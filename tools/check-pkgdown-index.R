#!/usr/bin/env Rscript
# Is every help page and every vignette in the index of _pkgdown.yml? (common layer; synced)
# Usage: Rscript tools/check-pkgdown-index.R
# pkgdown::build_site() stops on a help page missing from the reference index and on an unknown topic or article;
# this check finds both in a second, without building the site and with any pkgdown version. It reads the Rd files
# of man/ (names, aliases, concepts, the keyword internal) and the vignettes (.qmd, .Rmd), and resolves the
# entries of the reference index: names, has_concept(), starts_with(), ends_with(), contains(), matches(),
# has_keyword() and lacks_concepts(). Exit status 1 when something is missing or unknown.
cfg <- yaml::read_yaml("_pkgdown.yml")
rd <- list.files("man", pattern = "\\.Rd$", full.names = TRUE)
info <- lapply(rd, function(f) {
  x <- readLines(f, warn = FALSE)
  tag <- function(t) sub(sprintf("^\\\\%s\\{(.*)\\}\\s*$", t), "\\1", grep(sprintf("^\\\\%s\\{", t), x, value = TRUE))
  list(name = tag("name"), alias = tag("alias"), concept = tag("concept"), keyword = tag("keyword"))
})
names(info) <- vapply(info, function(i) i$name[1L], "")
internal <- vapply(info, function(i) "internal" %in% i$keyword, NA)
listed <- character(0)
unknown <- character(0)
for (sec in cfg$reference) {
  for (e in unlist(sec$contents)) {
    e <- trimws(e)
    hit <- if (grepl("^[a-z_]+\\(", e)) {
      fun <- sub("\\(.*$", "", e)
      arg <- eval(parse(text = sub("^[a-z_]+\\((.*)\\)$", "c(\\1)", e)))
      sel <- switch(
          fun
        , has_concept    = vapply(info, function(i) any(arg %in% i$concept), NA)
        , lacks_concepts = vapply(info, function(i) !any(arg %in% i$concept), NA)
        , has_keyword    = vapply(info, function(i) any(arg %in% i$keyword), NA)
        , starts_with    = startsWith(names(info), arg)
        , ends_with      = endsWith(names(info), arg)
        , contains       = grepl(arg, names(info), fixed = TRUE)
        , matches        = grepl(arg, names(info))
        , stop("unsupported selector in _pkgdown.yml: ", e)
        )
      names(info)[sel]
    } else {
      e <- gsub("^[\"'`]|[\"'`]$", "", e)
      names(info)[vapply(info, function(i) e %in% c(i$name, i$alias), NA)]
    }
    if (!length(hit)) unknown <- c(unknown, e)
    listed <- c(listed, hit)
  }
}
missing <- setdiff(names(info)[!internal], listed)
vig <- sub("\\.[qR]md$", "", list.files("vignettes", pattern = "^[^_].*\\.[qR]md$"))
arts <- unlist(lapply(cfg$articles, `[[`, "contents"))
art_unknown <- setdiff(arts, vig)
art_missing <- setdiff(vig, arts)
ok <- TRUE
report <- function(what, x) {
  if (length(x)) {
    cat(what, ":\n", paste0("  ", x, collapse = "\n"), "\n", sep = "")
    ok <<- FALSE
  }
}
report("help pages missing from the reference index (add them, or @keywords internal)", missing)
report("reference entries that match no help page", unknown)
report("vignettes missing from the articles index", if (is.null(cfg$articles)) character(0) else art_missing)
report("articles that are not vignettes", art_unknown)
if (ok) cat(sprintf("pkgdown index: complete (%d help pages, %d vignettes)\n", sum(!internal), length(vig)))
if (!ok) quit(status = 1L)
