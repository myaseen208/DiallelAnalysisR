#!/usr/bin/env Rscript
# Results of the released (legacy) version, saved for the regression tests (phase P0).
# Usage: Rscript tools/legacy-snapshot.R <old.tar.gz> [--out=dev/legacy]
# Installs the old version into a temporary library (your installed packages are not touched), runs every file
# <out>/examples/<topic>.R (written by tools/audit-legacy.R) in a fresh R process, and saves every object the
# example creates to <out>/<topic>.rds. tests/testthat/test-legacy.R compares the new results with these; a result
# that the old version got wrong is listed in <out>/exceptions.csv (topic, object, reason) and is not compared.
args <- commandArgs(trailingOnly = TRUE)
out <- sub("^--out=", "", grep("^--out=", args, value = TRUE)[1L])
if (is.na(out)) out <- "dev/legacy"
tarball <- args[!startsWith(args, "--")][1L]
if (is.na(tarball) || !file.exists(tarball)) stop("usage: legacy-snapshot.R <old.tar.gz> [--out=dev/legacy]")
lib <- tempfile("legacy-lib")
dir.create(lib)
st <- system2(file.path(R.home("bin"), "R"), c("CMD", "INSTALL", "--no-test-load", "-l", shQuote(lib),
                                                shQuote(tarball)), stdout = FALSE, stderr = FALSE)
if (!identical(st, 0L)) stop("could not install ", tarball)
pkg <- basename(list.dirs(lib, recursive = FALSE)[1L])   # the installed package (the file may be renamed)
exs <- list.files(file.path(out, "examples"), pattern = "\\.R$", full.names = TRUE)
for (f in exs) {
  topic <- sub("\\.R$", "", basename(f))
  rds <- file.path(out, paste0(topic, ".rds"))
  code <- sprintf(paste(
    ".libPaths(c('%s', .libPaths()));",
    "suppressPackageStartupMessages(library('%s', character.only = TRUE));",
    "e <- new.env();",
    "r <- tryCatch({ sys.source('%s', envir = e, keep.source = FALSE); 'ok' }, error = function(err) conditionMessage(err));",
    "o <- mget(ls(e), envir = e);",
    "o <- o[!vapply(o, function(v) inherits(v, c('gg', 'ggplot', 'function')), logical(1))];",
    "saveRDS(list(status = r, objects = o), '%s');",
    "cat(r, length(o), '\\n')"), lib, pkg, f, rds)
  res <- system2(file.path(R.home("bin"), "Rscript"), c("-e", shQuote(code)), stdout = TRUE, stderr = TRUE)
  cat(sprintf("%-30s %s\n", topic, utils::tail(res, 1L)))
}
if (!file.exists(file.path(out, "exceptions.csv"))) {
  writeLines("topic,object,reason", file.path(out, "exceptions.csv"))
}
cat("snapshots in", out, "\n")
