#!/usr/bin/env Rscript
# Timings: the released version against this one, on the cases of dev/bench-cases.R (a list of named calls,
# e.g. list(griffing_m1 = quote(Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2,
# data = GriffingData1, Method = 1, Model = 1)))). Results go to tools/bench-results.csv and feed the speed vignette.
# Usage: Rscript tools/bench.R <old.tar.gz> [--iterations=50]
args <- commandArgs(trailingOnly = TRUE)
it <- sub("^--iterations=", "", grep("^--iterations=", args, value = TRUE)[1L])
it <- if (is.na(it)) 50L else as.integer(it)
tarball <- args[!startsWith(args, "--")][1L]
pkg <- read.dcf("DESCRIPTION", fields = "Package")[1L]
cases <- source("dev/bench-cases.R")$value
time_cases <- function(lib) {
  code <- sprintf(paste(
    "%s suppressPackageStartupMessages(library('%s', character.only = TRUE));",
    "cases <- source('dev/bench-cases.R')$value;",
    "r <- lapply(names(cases), function(n) { cl <- cases[[n]]; eval(cl); b <- bench::mark(eval(cl), iterations = %d,",
    "check = FALSE); data.frame(case = n, median_ms = as.numeric(b$median) * 1000, mem_kb = as.numeric(b$mem_alloc) / 1024) });",
    "write.csv(do.call(rbind, r), stdout(), row.names = FALSE)"),
    if (is.null(lib)) "" else sprintf(".libPaths(c('%s', .libPaths()));", lib), pkg, it)
  utils::read.csv(text = system2(file.path(R.home("bin"), "Rscript"), c("-e", shQuote(code)), stdout = TRUE))
}
new_lib <- tempfile("new-lib")
dir.create(new_lib)
system2(file.path(R.home("bin"), "R"), c("CMD", "INSTALL", "--no-test-load", "-l", shQuote(new_lib), "."),
        stdout = FALSE, stderr = FALSE)
res <- time_cases(new_lib)
res$version <- read.dcf("DESCRIPTION", fields = "Version")[1L]
if (!is.na(tarball)) {
  old_lib <- tempfile("old-lib")
  dir.create(old_lib)
  system2(file.path(R.home("bin"), "R"), c("CMD", "INSTALL", "--no-test-load", "-l", shQuote(old_lib),
                                          shQuote(tarball)), stdout = FALSE, stderr = FALSE)
  old <- time_cases(old_lib)
  old$version <- read.dcf(file.path(old_lib, pkg, "DESCRIPTION"), fields = "Version")[1L]
  res <- rbind(old, res)
}
res$date <- format(Sys.Date())
f <- "tools/bench-results.csv"
utils::write.csv(if (file.exists(f)) rbind(utils::read.csv(f), res) else res, f, row.names = FALSE)
print(res, row.names = FALSE)
