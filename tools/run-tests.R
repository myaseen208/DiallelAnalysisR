#!/usr/bin/env Rscript
# Resilient test runner: every test file in its own R process, with a time limit; never stops at a failure.
# Usage: Rscript tools/run-tests.R [name ...] [--timeout=900] [--level=1]
# Writes tests/results/summary.csv and tests/results/<file>.log; exit status 0 even when tests fail.
args <- commandArgs(trailingOnly = TRUE)
opt <- function(name, default) {
  a <- grep(paste0("^--", name, "="), args, value = TRUE)
  if (length(a)) sub(paste0("^--", name, "="), "", a[1L]) else default
}
timeout <- as.numeric(opt("timeout", "900")); level <- opt("level", "1")
names_wanted <- args[!startsWith(args, "--")]
files <- sort(list.files("tests/testthat", pattern = "^test-.*\\.R$", full.names = TRUE))
if (length(names_wanted)) files <- files[gsub("^test-|\\.R$", "", basename(files)) %in% names_wanted]
out_dir <- "tests/results"; dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
pkg <- read.dcf("DESCRIPTION", fields = "Package")[1L]
rows <- list()
for (f in files) {
  log <- file.path(out_dir, sub("\\.R$", ".log", basename(f)))
  code <- sprintf(paste(
    "suppressPackageStartupMessages(pkgload::load_all('.', quiet = TRUE));",
    "r <- as.data.frame(testthat::test_file('%s', reporter = testthat::ProgressReporter$new(show_praise = FALSE),",
    "stop_on_failure = FALSE));",
    "cat(sprintf('\\n@@RESULT %%d %%d %%d %%d\\n', sum(r$passed), sum(r$failed), sum(r$skipped), sum(r$error)))"), f)
  t0 <- Sys.time()
  env <- c(paste0(toupper(pkg), "_TEST_LEVEL=", level), "NOT_CRAN=true")
  status <- tryCatch(suppressWarnings(system2(file.path(R.home("bin"), "Rscript"), c("-e", shQuote(code)), stdout = log, stderr = log,
                             env = env, timeout = timeout)), error = function(e) -1L)
  secs <- round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1)
  res <- grep("^@@RESULT", readLines(log, warn = FALSE), value = TRUE)
  v <- if (length(res)) as.integer(strsplit(sub("^@@RESULT ", "", res[length(res)]), " ")[[1L]]) else c(NA, NA, NA, NA)
  rows[[f]] <- data.frame(file = basename(f), passed = v[1L], failed = v[2L], skipped = v[3L], errors = v[4L],
                          seconds = secs, status = if (identical(status, 124L)) "timeout" else
                            if (!length(res)) "crashed" else if (v[2L] + v[4L] > 0) "FAIL" else "ok")
  cat(sprintf("%-40s %-8s %6s s  pass %s fail %s skip %s\n", basename(f), rows[[f]]$status, secs, v[1L], v[2L], v[3L]))
}
s <- do.call(rbind, rows)
utils::write.csv(s, file.path(out_dir, "summary.csv"), row.names = FALSE)
cat(sprintf("\nTOTAL: %d files, %d passed, %d failed, %d skipped, %d not ok -> %s\n", nrow(s), sum(s$passed, na.rm = TRUE),
            sum(s$failed, na.rm = TRUE), sum(s$skipped, na.rm = TRUE), sum(s$status != "ok"), file.path(out_dir, "summary.csv")))
