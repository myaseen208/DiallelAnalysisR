#!/usr/bin/env Rscript
# pkgdown 2.2.x writes the MathJax script and then `window.MathJax = {...}`; reassigning the global after MathJax has
# loaded breaks on-demand extensions such as \boldsymbol (rendered in red). This script moves the configuration in
# front of the script and preloads boldsymbol, in every HTML file of the site.
# Usage: Rscript tools/fix-pkgdown-mathjax.R [docs]
args <- commandArgs(trailingOnly = TRUE)
site <- if (length(args)) args[1L] else "docs"
files <- list.files(site, pattern = "\\.html$", recursive = TRUE, full.names = TRUE)
re <- "(?s)(<script src=\"[^\"]*mathjax@[^\"]*\"[^>]*></script>)(\\s*<script>\\s*window\\.MathJax\\s*=\\s*\\{)(.*?)(\\};\\s*</script>)"
cfg <- "loader: {load: ['[tex]/boldsymbol']}, tex: {packages: {'[+]': ['boldsymbol']}},"
n <- 0L
for (f in files) {
  s <- paste(readLines(f, warn = FALSE), collapse = "\n")
  m <- regexpr(re, s, perl = TRUE)
  if (m < 0) next
  hit <- regmatches(s, m)
  parts <- regmatches(hit, regexec(re, hit, perl = TRUE))[[1L]]
  fixed <- paste0(parts[3L], " ", cfg, parts[4L], parts[5L], parts[2L])
  regmatches(s, m) <- fixed
  writeLines(s, f); n <- n + 1L
}
cat(sprintf("fixed MathJax order in %d of %d HTML files\n", n, length(files)))
