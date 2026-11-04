#!/usr/bin/env Rscript
# PDF versions of the vignettes (common layer; synced). The HTML vignettes are built by R CMD build and pkgdown; this
# script renders the same .qmd files to PDF with Quarto and XeLaTeX and writes them to pdf/ (not built, not in git).
# Usage: Rscript tools/render-pdf.R [name ...] [--out=pdf] [--keep-tex] [--no-ship]
#   ship (default): each PDF is also copied to vignettes/<name>-pdf.pdf with an R.rsp "asis" index file, so the
#               installed package lists every vignette twice, as HTML and as PDF (browseVignettes()); needs
#               Suggests: R.rsp and VignetteBuilder: quarto, R.rsp in DESCRIPTION
#   name        part of a vignette file name (e.g. 05 or distributions); default: every vignette
# Site: the PDFs are also copied to pkgdown/assets/pdf/ with an index page (pkgdown copies pkgdown/assets/ into the
# site), so the navbar link "PDF" works with a plain pkgdown::build_site(). Shipped PDFs and site copies of vignettes
# that no longer exist (renamed or removed) are deleted.
# Layout: vignettes/_<pkg>-pdf.tex loads gtm.sty when LaTeX can find it (the author's manuscript layout: footer,
# running head, captions), else the plain article class. To use your gtm.sty, either install it in your TEXMFHOME or
# point the environment variable GTM_STY at the file or its folder. The file is never copied into the package.
# The maths macros of vignettes/_<pkg>-macros.txt are written to vignettes/_<pkg>-macros.tex first (one source).
# Every vignette is rendered even when an earlier one fails; a summary is printed and written to
# tests/results/pdf.csv, LaTeX logs of failures to tests/results/pdf-<name>.log.
args <- commandArgs(trailingOnly = TRUE)
out <- sub("^--out=", "", grep("^--out=", args, value = TRUE)[1])
if (is.na(out)) out <- "pdf"
keep_tex <- "--keep-tex" %in% args
ship <- !("--no-ship" %in% args)
pick <- grep("^--", args, value = TRUE, invert = TRUE)
pkg <- read.dcf("DESCRIPTION", fields = "Package")[1, 1]
quarto <- Sys.which("quarto")
if (!nzchar(quarto)) stop("quarto not found on PATH")
dir.create(out, showWarnings = FALSE)
dir.create("tests/results", showWarnings = FALSE, recursive = TRUE)

# 1. macros: vignettes/_<pkg>-macros.txt -> vignettes/_<pkg>-macros.tex
md <- readLines(file.path("vignettes", sprintf("_%s-macros.txt", pkg)), warn = FALSE)
d <- which(md == "$$")
if (length(d) < 2L) stop("no $$ ... $$ block in the macros file")
mac <- md[(d[1] + 1L):(d[2] - 1L)]
mac <- sub("^\\\\newcommand\\{", "\\\\vmacro{", mac)
writeLines(c(sprintf("%% generated from _%s-macros.txt by tools/render-pdf.R: do not edit", pkg), mac),
           file.path("vignettes", sprintf("_%s-macros.tex", pkg)))

# 2. gtm.sty: GTM_STY (file or folder), else whatever LaTeX finds (kpsewhich)
sep <- .Platform$path.sep
texinputs <- Sys.getenv("TEXINPUTS")
gtm <- Sys.getenv("GTM_STY")
if (nzchar(gtm)) {
  dir <- if (dir.exists(gtm)) gtm else dirname(gtm)
  if (!file.exists(file.path(dir, "gtm.sty"))) stop("GTM_STY: no gtm.sty in ", dir)
  Sys.setenv(TEXINPUTS = paste0(normalizePath(dir), "//", sep, texinputs))
  message("gtm.sty: ", file.path(normalizePath(dir), "gtm.sty"))
} else {
  k <- suppressWarnings(tryCatch(system2("kpsewhich", "gtm.sty", stdout = TRUE, stderr = FALSE),
                                 error = function(e) character()))
  message("gtm.sty: ", if (length(k) && nzchar(k[1])) k[1] else "not found (plain article layout; see the header)")
}

# 3. render
qmd <- list.files("vignettes", pattern = "^[^_].*\\.qmd$", full.names = TRUE)
if (length(pick)) qmd <- qmd[vapply(basename(qmd), function(f) any(vapply(pick, grepl, logical(1), x = f,
                                                                          fixed = TRUE)), logical(1))]
res <- data.frame(vignette = basename(qmd), result = "", seconds = NA_real_, pages = NA_integer_)
for (i in seq_along(qmd)) {
  v <- qmd[i]
  stem <- sub("\\.qmd$", "", basename(v))
  t0 <- Sys.time()
  log <- file.path("tests/results", sprintf("pdf-%s.log", stem))
  a <- c("render", basename(v), "--to", "pdf", if (keep_tex) c("-M", "keep-tex:true"))
  owd <- setwd("vignettes")
  st <- system2(quarto, a, stdout = file.path("..", log), stderr = file.path("..", log))
  setwd(owd)
  f <- file.path("vignettes", paste0(stem, ".pdf"))
  if (identical(st, 0L) && file.exists(f)) {
    file.rename(f, file.path(out, basename(f)))
    pg <- tryCatch(as.integer(sub("^Pages:\\s*", "", grep("^Pages:", system2("pdfinfo", file.path(out, basename(f)),
                                                                          stdout = TRUE), value = TRUE))),
                   error = function(e) NA_integer_)
    res$result[i] <- "ok"
    if (ship) {
      # the PDF as a vignette of its own (R.rsp::asis): same title with "(PDF)", a name distinct from the HTML one
      file.copy(file.path(out, basename(f)), file.path("vignettes", paste0(stem, "-pdf.pdf")), overwrite = TRUE)
      # compact as R CMD check --as-cran expects (needs qpdf or Ghostscript; skipped when neither is installed)
      if (nzchar(Sys.which("qpdf")) || nzchar(tools::find_gs_cmd())) {
        suppressWarnings(tools::compactPDF(file.path("vignettes", paste0(stem, "-pdf.pdf")), gs_quality = "ebook"))
      }
      ttl <- sub('^title:\\s*"?(.*?)"?\\s*$', "\\1", grep("^title:", readLines(v, n = 10L, warn = FALSE),
                                                              value = TRUE)[1L])
      writeLines(c(sprintf("%%\\VignetteIndexEntry{%s (PDF)}", ttl), "%\\VignetteEngine{R.rsp::asis}",
                   "%\\VignetteKeyword{PDF}"), file.path("vignettes", paste0(stem, "-pdf.pdf.asis")))
    }
    res$pages[i] <- if (length(pg)) pg else NA_integer_
    unlink(log)
  } else {
    res$result[i] <- sprintf("ERROR (exit %s), see %s", st, log)
  }
  unlink(file.path("vignettes", paste0(stem, "_files", "/figure-pdf")), recursive = TRUE)
  # LaTeX leftovers of a failed run (the error is in the log above); the .tex is kept only with --keep-tex
  unlink(file.path("vignettes", paste0(stem, c(".aux", ".toc", ".out", ".log", if (!keep_tex) ".tex"))))
  res$seconds[i] <- round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1)
  message(sprintf("%-40s %s", res$vignette[i], res$result[i]))
}
# PDFs of vignettes that no longer exist
stems <- sub("\\.qmd$", "", basename(list.files("vignettes", pattern = "^[^_].*\\.qmd$")))
old <- list.files("vignettes", pattern = "-pdf\\.pdf(\\.asis)?$")
unlink(file.path("vignettes", old[!sub("-pdf\\.pdf(\\.asis)?$", "", old) %in% stems]))
old <- list.files(out, pattern = "\\.pdf$")
unlink(file.path(out, old[!sub("\\.pdf$", "", old) %in% stems]))
# the site: pkgdown/assets/pdf/ with an index page, linked from the navbar ("PDF": pdf/index.html)
pdfs <- sort(list.files(out, pattern = "\\.pdf$"))
site <- file.path("pkgdown", "assets", "pdf")
unlink(site, recursive = TRUE)
dir.create(site, recursive = TRUE, showWarnings = FALSE)
file.copy(file.path(out, pdfs), site, overwrite = TRUE)
ttl <- vapply(pdfs, function(f) {
  y <- readLines(file.path("vignettes", sub("\\.pdf$", ".qmd", f)), n = 10L, warn = FALSE)
  t <- sub('^title:\\s*"?(.*?)"?\\s*$', "\\1", grep("^title:", y, value = TRUE)[1L])
  if (is.na(t)) f else t
}, "")
writeLines(c("<!DOCTYPE html>", "<html lang=\"en\"><head><meta charset=\"utf-8\">",
             "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">",
             sprintf("<title>%s: PDF vignettes</title>", pkg),
             "<style>body{font-family:Georgia,serif;max-width:46em;margin:2em auto;padding:0 1em;line-height:1.5}</style>",
             "</head><body>", sprintf("<h1>%s: PDF vignettes</h1>", pkg),
             "<ol>", sprintf("<li><a href=\"%s\">%s</a></li>", pdfs, ttl), "</ol>",
             "<p><a href=\"../index.html\">Back to the site</a></p>", "</body></html>"), file.path(site, "index.html"))
utils::write.csv(res, "tests/results/pdf.csv", row.names = FALSE)
print(res, row.names = FALSE)
cat(sprintf("%d of %d vignettes rendered to %s/\n", sum(res$result == "ok"), nrow(res), out))
if (any(res$result != "ok")) quit(status = 1L)
