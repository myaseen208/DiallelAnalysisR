#!/usr/bin/env Rscript
# Extract the file templates of SKILL.qmd into a package directory.
# Usage: Rscript tools/scaffold.R SKILL.qmd <pkg_dir> [--prefix=<pfx>] [--title="<title>"] [--sync] [--force]
#   <pkg_dir>  the package folder (its DESCRIPTION gives Package, Title and Config/skill/prefix when present)
#   --prefix   short lower-case prefix of the internal helpers and the new utility functions (default: the
#              Config/skill/prefix field, else the package name in lower case)
#   --sync     overwrite only the common layer (R/common-*, common tests, vignette assets, notation macros, tools,
#              pkgdown templates); files written once (DESCRIPTION, README.qmd, ...) are kept
#   --force    overwrite every file
# Placeholders: {{pkg}} package name, {{pfx}} prefix, {{PKGUP}} package name in capitals, {{pkg_title}} title,
# {{year}} current year. This file is itself a template: its placeholder patterns are assembled at run time (ph())
# so that scaffolding never substitutes them, and it is copied verbatim.
args <- commandArgs(trailingOnly = TRUE)
flag <- function(name) {
  a <- grep(paste0("^--", name, "="), args, value = TRUE)
  if (length(a)) sub(paste0("^--", name, "="), "", a[1L]) else NA_character_
}
pos <- args[!startsWith(args, "--")]
if (length(pos) < 2L) stop("usage: scaffold.R SKILL.qmd <pkg_dir> [--prefix=] [--title=] [--sync] [--force]")
skill <- pos[1L]
dir <- pos[2L]
sync <- "--sync" %in% args
force <- "--force" %in% args
desc <- file.path(dir, "DESCRIPTION")
dcf <- if (file.exists(desc)) read.dcf(desc, keep.white = "Description") else NULL
field <- function(f) if (!is.null(dcf) && f %in% colnames(dcf)) gsub("\\s+", " ", dcf[1L, f]) else NA_character_
pkg <- if (!is.na(field("Package"))) field("Package") else basename(normalizePath(dir, mustWork = FALSE))
pfx <- flag("prefix")
if (is.na(pfx)) pfx <- field("Config/skill/prefix")
if (is.na(pfx)) pfx <- tolower(pkg)
if (!grepl("^[a-z][a-z0-9]*$", pfx)) stop("the prefix must be lower-case letters and digits: ", pfx)
title <- flag("title")
if (is.na(title)) title <- field("Title")
if (is.na(title)) title <- "TITLE"
x <- readLines(skill, warn = FALSE)
open_re <- "^(`{3,})\\{\\.[A-Za-z0-9]+ filename=\"([^\"]+)\"\\}\\s*$"
common_re <- paste0("^(R/common-|tests/testthat/(helper-common|test-common-|test-reference|test-legacy)|",
                    "vignettes/(_quarto\\.yaml|.*\\.css|_.*-pdf\\.tex)$|tools/|pkgdown/)")
ph <- function(name) paste0("{", "{", name, "}", "}")
sub_all <- function(s) {
  s <- gsub(ph("pkg_title"), title, s, fixed = TRUE)
  s <- gsub(ph("PKGUP"), toupper(pkg), s, fixed = TRUE)
  s <- gsub(ph("pkg"), pkg, s, fixed = TRUE)
  s <- gsub(ph("pfx"), pfx, s, fixed = TRUE)
  s <- gsub(ph("year"), format(Sys.Date(), "%Y"), s, fixed = TRUE)
  s <- gsub(paste0("{", "{</", "*"), paste0("{", "{<"), s, fixed = TRUE)
  gsub(paste0("*", "/>}", "}"), paste0(">}", "}"), s, fixed = TRUE)
}
i <- 1L
written <- character(0)
skipped <- character(0)
while (i <= length(x)) {
  m <- regmatches(x[i], regexec(open_re, x[i]))[[1L]]
  if (length(m) == 3L) {
    fence <- m[2L]
    path <- sub_all(m[3L])
    j <- i + 1L
    while (j <= length(x) && !identical(trimws(x[j]), fence)) j <- j + 1L
    body <- x[seq.int(i + 1L, length.out = max(0L, j - i - 1L))]
    if (path != "tools/scaffold.R") body <- sub_all(body)   # the scaffold script is copied verbatim
    target <- file.path(dir, path)
    if (force || (sync && grepl(common_re, path)) || (!sync && !file.exists(target))) {
      dir.create(dirname(target), recursive = TRUE, showWarnings = FALSE)
      writeLines(body, target)
      written <- c(written, path)
    } else {
      skipped <- c(skipped, path)
    }
    i <- j + 1L
  } else {
    i <- i + 1L
  }
}
left <- grep(paste0("\\{", "\\{(pkg|pfx|PKGUP|pkg_title|year)\\}", "\\}"),
             unlist(lapply(file.path(dir, setdiff(written, "tools/scaffold.R")), readLines, warn = FALSE)), value = TRUE)
if (length(left)) warning(length(left), " unsubstituted placeholder line(s) remain")
cat(sprintf("%s (prefix %s): written %d file(s), kept %d existing\n", pkg, pfx, length(written), length(skipped)))
cat(paste0("  + ", written), sep = "\n")
