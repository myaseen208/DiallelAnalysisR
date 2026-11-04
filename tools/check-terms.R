#!/usr/bin/env Rscript
# Wording check: the package (code, comments, documentation, vignettes, README, NEWS, DESCRIPTION, data
# documentation, tools, tests) and, with --git, the commit messages must not name automated writing tools or their
# makers. The banned words are stored encoded (rot13) so that this file passes its own check.
# Usage: Rscript tools/check-terms.R [--git] [path ...]
#   default paths: the whole package folder except .git, docs, *.Rcheck, tarballs, pdf/, tests/results
#   --git   also scan every commit message (git log)
# Words allowed in one package (a proper name that happens to match, say) go in dev/terms-allow.txt, one regular
# expression per line. Exit status 1 when anything is found.
args <- commandArgs(trailingOnly = TRUE)
use_git <- "--git" %in% args
paths <- args[!startsWith(args, "--")]
rot13 <- function(s) chartr("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                            "nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM", s)
# case-sensitive whole words, then case-insensitive phrases
exact <- rot13(c("NV", "N\\.V\\.", "YYZ", "YYZf", "TCG", "TCG-[0-9]", "Pbcvybg"))
phrase <- rot13(c("negvsvpvny vagryyvtrapr", "ynetr ynathntr zbqry", "ynathntr zbqry", "pynhqr", "naguebcvp",
                  "pungtcg", "bcranv", "pbcvybg", "trzvav", "pungobg", "trarengvir zbqry", "ZY zbqry"))
phrase <- tolower(phrase)
allow <- if (file.exists("dev/terms-allow.txt")) readLines("dev/terms-allow.txt", warn = FALSE) else character()
allow <- allow[nzchar(trimws(allow)) & !startsWith(allow, "#")]
if (!length(paths)) {
  paths <- list.files(".", recursive = TRUE, all.files = TRUE, full.names = TRUE)
  paths <- paths[!grepl("(^|/)(\\.git|docs|pdf|tests/results|[^/]*\\.Rcheck|\\.quarto|node_modules)/", paths)]
  paths <- paths[!grepl("\\.(tar\\.gz|zip|rds|RData|rda|pdf|png|jpg|jpeg|gif|svg|ico|o|so|dll|fst)$", paths,
                        ignore.case = TRUE)]
  paths <- setdiff(paths, "./tools/check-terms.R")
}
scan_lines <- function(lines, where) {
  hits <- character()
  for (k in seq_along(lines)) {
    s <- lines[k]
    if (length(allow) && any(vapply(allow, grepl, logical(1), x = s, perl = TRUE))) next
    bad <- c(exact[vapply(exact, function(w) grepl(paste0("(?<![A-Za-z0-9_])", w, "(?![A-Za-z0-9_])"), s,
                                                       perl = TRUE), logical(1))],
             phrase[vapply(phrase, function(w) grepl(paste0("(?i)(?<![a-z])", w, "(?![a-z])"), s, perl = TRUE),
                           logical(1))])
    if (length(bad)) hits <- c(hits, sprintf("%s:%d: %s", where, k, trimws(substr(s, 1L, 110L))))
  }
  hits
}
found <- character()
for (p in paths) {
  if (dir.exists(p)) next
  lines <- tryCatch(readLines(p, warn = FALSE, encoding = "UTF-8"), error = function(e) character())
  found <- c(found, scan_lines(lines, sub("^\\./", "", p)))
}
if (use_git && dir.exists(".git")) {
  msg <- tryCatch(system2("git", c("log", "--format=%h %B"), stdout = TRUE), error = function(e) character())
  found <- c(found, scan_lines(msg, "git log"))
}
if (length(found)) {
  cat(length(found), "line(s) to reword:\n", paste0("  ", found, "\n"), sep = "")
  quit(status = 1L)
}
cat("wording check: clean (", length(paths), " files", if (use_git) " and the commit messages", ")\n", sep = "")
