#!/usr/bin/env Rscript
# One command for the author: every step runs even when an earlier one fails; a summary at the end.
# Usage: Rscript tools/check-all.R [--steps=style,terms,document,tests,pdf,build,check,vignettes,site]
# style and terms only report (tools/style.R --check, tools/check-terms.R --git); they never change a file.
args <- commandArgs(trailingOnly = TRUE)
steps_arg <- grep("^--steps=", args, value = TRUE)
steps <- if (length(steps_arg)) strsplit(sub("^--steps=", "", steps_arg), ",")[[1L]] else
  c("style", "terms", "document", "tests", "pdf", "build", "check", "vignettes", "site")
dir.create("tests/results", showWarnings = FALSE, recursive = TRUE)
pkg <- read.dcf("DESCRIPTION", fields = c("Package", "Version"))
tarball <- sprintf("%s_%s.tar.gz", pkg[1L, "Package"], pkg[1L, "Version"])
run <- function(name, expr) {
  t0 <- Sys.time()
  r <- tryCatch({ force(expr); "ok" }, error = function(e) paste("ERROR:", conditionMessage(e)))
  data.frame(step = name, result = r, seconds = round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1))
}
sh <- function(cmd, args, log) {
  st <- system2(cmd, args, stdout = log, stderr = log)
  if (!identical(st, 0L)) stop(sprintf("exit status %s, see %s", st, log))
}
res <- list()
if ("style" %in% steps) res$style <- run("style", {
  out <- system2(file.path(R.home("bin"), "Rscript"), c("tools/style.R", "--check"), stdout = TRUE, stderr = TRUE)
  writeLines(out, "tests/results/style.log")
  n <- suppressWarnings(as.integer(sub("^.*: ([0-9]+) file.*$", "\\1", grep("would change", out, value = TRUE))))
  if (length(n) && !is.na(n) && n > 0L) stop(n, " file(s) not in the code style: run Rscript tools/style.R")
})
if ("terms" %in% steps) res$terms <- run("terms", sh(file.path(R.home("bin"), "Rscript"),
                                                     c("tools/check-terms.R", "--git"), "tests/results/terms.log"))
if ("document" %in% steps) res$document <- run("document", {
  if (file.exists("src")) Rcpp::compileAttributes(".")
  roxygen2::roxygenise(".")
  # README.md and NEWS.md from their .qmd sources (README runs code: the package is installed first)
  if (nzchar(Sys.which("quarto"))) {
    sh(file.path(R.home("bin"), "R"), c("CMD", "INSTALL", "--no-test-load", "."), "tests/results/install.log")
    for (f in c("README.qmd", "NEWS.qmd")) if (file.exists(f)) sh("quarto", c("render", f), "tests/results/readme.log")
  } else warning("quarto not found: README.md and NEWS.md not rendered")
})
if ("tests" %in% steps) res$tests <- run("tests", sh(file.path(R.home("bin"), "Rscript"), "tools/run-tests.R",
                                                       "tests/results/run-tests.log"))
# PDFs before the build: the tarball ships them (vignettes/*-pdf.pdf)
if ("pdf" %in% steps) res$pdf <- run("pdf", sh(file.path(R.home("bin"), "Rscript"), "tools/render-pdf.R",
                                               "tests/results/pdf-all.log"))
if ("build" %in% steps) res$build <- run("build", sh(file.path(R.home("bin"), "R"), c("CMD", "build", "."),
                                                     "tests/results/build.log"))
if ("check" %in% steps) res$check <- run("check", {
  Sys.setenv(`_R_CHECK_CRAN_INCOMING_REMOTE_` = "false", NOT_CRAN = "true")
  if (!file.exists(tarball)) stop("no ", tarball, " (the build step failed)")
  system2(file.path(R.home("bin"), "R"), c("CMD", "check", "--as-cran", "--no-manual", tarball),
          stdout = "tests/results/check.log", stderr = "tests/results/check.log")
  st <- grep("^Status:", readLines("tests/results/check.log"), value = TRUE)
  if (!length(st) || grepl("ERROR|WARNING", st)) stop(if (length(st)) st else "no Status line", "; see check.log")
  message(st)
})
if ("vignettes" %in% steps) res$vignettes <- run("vignettes", {
  qmd <- list.files("vignettes", pattern = "^[^_].*\\.qmd$", full.names = TRUE)
  bad <- character(0)
  for (v in qmd) {
    ok <- tryCatch({ quarto::quarto_render(v, quiet = TRUE); TRUE }, error = function(e) FALSE)
    html <- sub("\\.qmd$", ".html", v)
    if (!ok || !file.exists(html)) bad <- c(bad, basename(v))
  }
  if (length(bad)) stop("vignettes with errors: ", paste(bad, collapse = ", "))
})
if ("site" %in% steps) res$site <- run("site", {
  # every help page and vignette is in the index (pkgdown stops on a missing topic): checked first, in seconds
  sh(file.path(R.home("bin"), "Rscript"), "tools/check-pkgdown-index.R", "tests/results/site-index.log")
  pkgdown::build_site(".", preview = FALSE, new_process = TRUE)
  # the site is served from docs/ on the main branch (GitHub Pages): docs/ is in git, and .nojekyll stops GitHub
  # from running Jekyll, which would drop the folders and files whose names start with an underscore
  file.create("docs/.nojekyll")
  sh(file.path(R.home("bin"), "Rscript"), c("tools/fix-pkgdown-mathjax.R", "docs"), "tests/results/site.log")
  # the PDF vignettes reach the site through pkgdown/assets/pdf/ (written by tools/render-pdf.R)
  if (!file.exists("pkgdown/assets/pdf/index.html")) warning("no PDF index: run tools/render-pdf.R first")
})
if ("math" %in% steps || "site" %in% steps) res$math <- run("math", {
  if (!nzchar(Sys.which("node"))) stop("node not found: skipped (open the pages once in a browser instead)")
  sh("node", c("tools/check-math.js", "docs", "vignettes"), "tests/results/math.log")
})
s <- do.call(rbind, res)
utils::write.csv(s, "tests/results/check-all.csv", row.names = FALSE)
print(s, row.names = FALSE)
