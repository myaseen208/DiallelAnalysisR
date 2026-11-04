# Code style of examples, vignettes and README (common layer; synced from SKILL.qmd).
# Usage: Rscript tools/style.R [--check] [file ...]
#   default files: R/*.R (roxygen @examples), vignettes/*.qmd, README.qmd
#   --check  report the files that would change; write nothing
# Rules (SKILL.qmd, section Style):
#   * one statement per line: no `;`
#   * every call of a function of the package writes out all of its arguments (defaults included), one per line,
#     names aligned, leading commas, `)` under the commas; an assigned call starts on the line after `<-`
#   * a choice argument (match.arg) is written c("a", "b", ...)[k], k the option chosen
#   * positional arguments of other functions are named (set.seed(seed = 1)); a single non-literal argument
#     (length(x)) and arguments going to `...` stay as they are
# Every rewritten block is parsed back and compared with the original call by call (argument matching with the
# defaults filled in); a block that does not compare equal is left unchanged and reported.

args_cli <- commandArgs(trailingOnly = TRUE)
check_only <- "--check" %in% args_cli
files <- setdiff(args_cli, "--check")
pkg <- read.dcf("DESCRIPTION", fields = "Package")[1, 1]
if (requireNamespace("pkgload", quietly = TRUE)) {
  suppressMessages(pkgload::load_all(".", quiet = TRUE, export_all = FALSE, helpers = FALSE))
} else {
  suppressMessages(library(pkg, character.only = TRUE))
}
for (p in c("ggplot2", "data.table")) if (requireNamespace(p, quietly = TRUE)) suppressMessages(library(p, character.only = TRUE))
if (!length(files)) {
  files <- c(Sys.glob("R/*.R"), Sys.glob("vignettes/*.qmd"), if (file.exists("README.qmd")) "README.qmd")
}
gt_style_skip <- c("library", "require", "requireNamespace", "suppressMessages", "suppressWarnings", "invisible",
                   "quote", "bquote", "stopifnot", "return", "on.exit", "Recall", "missing", "UseMethod", "NextMethod")
pkg_exports <- getNamespaceExports(pkg)

# ---- text helpers -------------------------------------------------------------------------------------------------
splitl <- function(s) {
  x <- strsplit(s, "\n", fixed = TRUE)[[1]]
  if (!length(x)) x <- ""
  if (endsWith(s, "\n")) x <- c(x, "")
  x
}
lead <- function(s) {
  ld <- sub("^([ ]*).*$", "\\1", s)
  if (startsWith(substring(s, nchar(ld) + 1L), ", ")) ld <- paste0(ld, "  ")   # leading-comma line: name column
  ld
}
pos2idx <- function(lines, l, c) sum(nchar(lines[seq_len(l - 1L)], type = "chars") + 1L) + c
# continuation lines: drop up to n leading spaces / add a prefix
dedent <- function(s, n) {
  if (n <= 0L) return(s)
  x <- splitl(s)
  if (length(x) > 1L) x[-1] <- sub(paste0("^ {0,", n, "}"), "", x[-1])
  paste(x, collapse = "\n")
}
indent <- function(s, pre) {
  x <- splitl(s)
  if (length(x) > 1L) x[-1] <- ifelse(nzchar(x[-1]), paste0(pre, x[-1]), x[-1])
  paste(x, collapse = "\n")
}

pdata <- function(txt) {
  ex <- tryCatch(parse(text = txt, keep.source = TRUE), error = function(e) NULL)
  if (is.null(ex)) return(NULL)
  pd <- utils::getParseData(ex, includeText = TRUE)
  if (is.null(pd)) pd <- data.frame(id = integer(), token = character())
  pd
}

# ---- functions ----------------------------------------------------------------------------------------------------
local_funs <- character()   # functions defined in the file being styled (they mask the search path)
resolve_fun <- function(fname) {
  parts <- strsplit(fname, ":::?")[[1]]
  if (length(parts) == 1L && fname %in% local_funs) return(list(f = NULL, bare = fname, is_pkg = FALSE))
  f <- tryCatch(if (length(parts) == 2L) getExportedValue(parts[1], parts[2]) else get(fname, mode = "function"),
                error = function(e) NULL)
  bare <- parts[length(parts)]
  is_pkg <- bare %in% pkg_exports && (length(parts) == 1L || parts[1] == pkg)
  list(f = f, bare = bare, is_pkg = is_pkg && is.function(f))
}
fun_formals <- function(f) {
  fm <- formals(f)
  if (is.null(fm) && is.primitive(f)) fm <- suppressWarnings(formals(args(f)))
  fm
}
is_missing_el <- function(lst, a) identical(lst[[a]], quote(expr = ))
# a choice argument: default c("a", "b", ...) of strings and match.arg(<name>) in the body
choices_of <- function(f, a) {
  if (!is.function(f) || is.primitive(f) || !(a %in% names(formals(f))) || is_missing_el(formals(f), a)) return(NULL)
  d <- formals(f)[[a]]
  if (!is.call(d) || !identical(d[[1]], as.name("c")) || length(d) < 3L) return(NULL)
  v <- as.list(d)[-1]
  if (!all(vapply(v, is.character, logical(1)))) return(NULL)
  b <- paste(deparse(body(f)), collapse = " ")
  if (!grepl(paste0("match.arg\\(\\s*", a, "\\b"), b)) return(NULL)
  unlist(v)
}
dq <- function(x) paste0("\"", x, "\"")
choice_text <- function(ch, k) sprintf("c(%s)[%d]", paste(dq(ch), collapse = ", "), k)

# ---- the rewriter -------------------------------------------------------------------------------------------------
# process(): text in, text out; `fi` is the indentation of the line on which the text starts in its container.
process <- function(txt, fi = "") {
  pd <- pdata(txt)
  if (is.null(pd) || !nrow(pd)) return(txt)
  # 1. one statement per line
  sc <- pd[pd$token == "';'", ]
  if (nrow(sc)) {
    lines <- splitl(txt)
    sc <- sc[order(sc$line1, sc$col1, decreasing = TRUE), ]
    for (r in seq_len(nrow(sc))) {
      i <- pos2idx(lines, sc$line1[r], sc$col1[r])
      ld <- if (sc$line1[r] == 1L) fi else lead(lines[sc$line1[r]])
      rest <- sub("^[ \t]+", "", substring(txt, i + 1L))
      txt <- paste0(sub("[ \t]+$", "", substring(txt, 1L, i - 1L)), "\n", ld, rest)
    }
    return(process(txt, fi))
  }
  # 2. calls, outermost first (inner ones are handled through their arguments)
  fc <- pd[pd$token == "SYMBOL_FUNCTION_CALL", ]
  if (!nrow(fc)) return(txt)
  par <- setNames(pd$parent, pd$id)
  call_ids <- unname(par[as.character(par[as.character(fc$id)])])
  outer <- call_ids[vapply(call_ids, function(id) {
    a <- par[as.character(id)]
    while (!is.na(a) && a != 0) { if (a %in% call_ids) return(FALSE); a <- par[as.character(a)] }
    TRUE
  }, logical(1))]
  rows <- pd[match(outer, pd$id), ]
  rows <- rows[order(rows$line1, rows$col1, decreasing = TRUE), ]
  lines <- splitl(txt)
  for (r in seq_len(nrow(rows))) {
    l1 <- rows$line1[r]
    ld <- if (l1 == 1L) fi else lead(lines[l1])
    i1 <- pos2idx(lines, l1, rows$col1[r])
    i2 <- pos2idx(lines, rows$line2[r], rows$col2[r])
    ctext <- substring(txt, i1, i2)
    before <- substring(txt, 1L, i1 - 1L)
    res <- rewrite_call(ctext, ld, nchar(sub("^.*\n", "", before)) + if (l1 == 1L) nchar(fi) else 0L)
    after <- substring(txt, i2 + 1L)
    pre_line <- sub("^.*\n", "", before)
    cm <- ""
    if (grepl("\n", res$text) && grepl("^[ \t]*#", after)) {   # a trailing comment moves above the statement
      cm <- sub("^[ \t]*(#[^\n]*).*$", "\\1", after)
      after <- sub("^[ \t]*#[^\n]*", "", after)
      before <- paste0(substring(before, 1L, nchar(before) - nchar(pre_line)), ld, cm, "\n", pre_line)
    }
    if (res$pkg && grepl("\n", res$text) && grepl("\\S", pre_line) && grepl("(<-|=)\\s*$", pre_line) &&
        !grepl("\\(", pre_line)) {
      p2 <- paste0(ld, "  ")
      before <- paste0(sub("[ \t]+$", "", before), "\n", p2)
      new <- indent(res$text, p2)
    } else if (res$pkg && grepl("\n", res$text) && grepl("\\S", pre_line) && grepl("(\\+|\\|>|%[^%]*%)\\s*$", pre_line)) {
      k <- l1   # first line of the statement: walk back over continued lines
      while (k > 1L && grepl("(\\+|\\|>|%[^%]*%|\\(|,|<-|=)\\s*(#.*)?$", lines[k - 1L])) k <- k - 1L
      p2 <- paste0(if (k == 1L) fi else lead(lines[k]), "  ")
      before <- paste0(sub("[ \t]+$", "", before), "\n", p2)
      new <- indent(res$text, p2)
    } else {
      new <- indent(res$text, ld)
    }
    txt <- paste0(before, new, after)
    lines <- splitl(txt)
  }
  txt
}

layout_call <- function(fname, nms, vals, cmts = rep("", length(vals))) {
  w <- max(c(0L, nchar(nms)))
  lab <- ifelse(nzchar(nms), paste0(formatC(nms, width = -w), " = "), "")
  body <- vapply(seq_along(vals), function(i) {
    s <- paste0(if (i == 1L) "    " else "  , ", lab[i], indent(vals[i], "    "))
    if (nzchar(cmts[i])) s <- paste(s, cmts[i])
    s
  }, "")
  paste(c(paste0(fname, "("), body, "  )"), collapse = "\n")
}

# rewrite_call(): one call; returns list(text, pkg) with continuation lines relative to the line indentation `fi`
rewrite_call <- function(ctext, fi, off = nchar(fi)) {
  pd <- pdata(ctext)
  keep <- list(text = dedent(ctext, nchar(fi)), pkg = FALSE)
  if (is.null(pd)) return(keep)
  top <- pd[pd$parent == 0 & pd$token == "expr", ]
  if (nrow(top) != 1L) return(keep)
  kids <- pd[pd$parent == top$id, ]
  kids <- kids[order(kids$line1, kids$col1), ]
  if (nrow(kids) < 3L || kids$token[2] != "'('") return(keep)
  fname <- kids$text[1]
  if (!nzchar(fname)) fname <- paste(pd$text[pd$parent == kids$id[1] & pd$terminal], collapse = "")
  lines <- splitl(ctext)
  span <- function(k) substring(ctext, pos2idx(lines, k$line1, k$col1), pos2idx(lines, k$line2, k$col2))
  line_lead <- function(l) if (l == 1L) fi else lead(lines[l])
  # arguments
  args <- list(); cur <- list(name = NULL, val = NULL, row = NULL, nrow = NULL)
  comments <- list()
  inner <- kids[3:(nrow(kids) - 1L), , drop = FALSE]
  if (nrow(kids) == 3L) inner <- inner[0, ]
  for (k in seq_len(nrow(inner))) {
    t <- inner$token[k]
    if (t %in% c("SYMBOL_SUB", "STR_CONST", "NULL_CONST") && k < nrow(inner) && inner$token[k + 1L] == "EQ_SUB") {
      cur$name <- inner$text[k]; cur$nrow <- inner[k, ]
    } else if (t == "EQ_SUB") {
      next
    } else if (t == "expr") {
      cur$val <- span(inner[k, ]); cur$row <- inner[k, ]
    } else if (t == "','") {
      args[[length(args) + 1L]] <- cur; cur <- list(name = NULL, val = NULL, row = NULL, nrow = NULL)
    } else if (t == "COMMENT") {
      comments[[length(comments) + 1L]] <- list(after = length(args) + !is.null(cur$val), text = inner$text[k])
    }
  }
  if (!is.null(cur$val) || !is.null(cur$name)) args[[length(args) + 1L]] <- cur
  if (any(vapply(args, function(a) is.null(a$val), logical(1)))) return(keep)   # empty argument: leave alone
  # process the argument values (nested calls)
  vals_abs <- lapply(args, function(a) process(a$val, line_lead(a$row$line1)))
  rf <- resolve_fun(fname)
  fm <- if (is.function(rf$f)) fun_formals(rf$f) else NULL
  if (rf$bare %in% gt_style_skip) fm <- NULL
  if (is.null(fm)) rf$is_pkg <- FALSE
  # argument matching
  mapped <- rep(NA_character_, length(args))
  if (!is.null(fm) && length(args)) {
    def <- function() NULL
    formals(def) <- fm
    ph <- lapply(seq_along(args), function(i) as.name(paste0(".a", i, ".")))
    names(ph) <- vapply(args, function(a) if (is.null(a$name)) "" else gsub("^[\"'`]|[\"'`]$", "", a$name), "")
    m <- tryCatch(match.call(def, as.call(c(as.name("f"), ph)), expand.dots = FALSE), error = function(e) NULL)
    if (is.null(m)) { rf$is_pkg <- FALSE; fm <- NULL } else {
      for (nm in setdiff(names(m)[-1], "...")) mapped[as.integer(gsub("\\D", "", as.character(m[[nm]])))] <- nm
    }
  }
  if (rf$is_pkg) {
    f <- rf$f
    out_names <- character(); out_vals <- character(); out_cmt <- character()
    given <- setNames(vals_abs, mapped)
    rel <- function(i) dedent(vals_abs[[i]], nchar(line_lead(args[[i]]$row$line1)))
    cmt_for <- function(i) {
      cc <- Filter(function(z) z$after == i, comments)
      if (length(cc)) paste(vapply(cc, `[[`, "", "text"), collapse = " ") else ""
    }
    final <- list()
    for (a in names(fm)) {
      if (a == "...") {
        for (i in which(is.na(mapped))) {
          out_names <- c(out_names, if (is.null(args[[i]]$name)) "" else args[[i]]$name)
          out_vals <- c(out_vals, rel(i)); out_cmt <- c(out_cmt, cmt_for(i))
        }
        next
      }
      i <- match(a, mapped)
      ch <- choices_of(f, a)
      if (!is.na(i)) {
        v <- rel(i)
        if (!is.null(ch)) {
          lit <- tryCatch(eval(parse(text = v)[[1]], baseenv()), error = function(e) NULL)
          if (is.character(lit) && length(lit) == 1L && lit %in% ch) v <- choice_text(ch, match(lit, ch))
        }
        cm <- cmt_for(i)
      } else {
        if (is_missing_el(fm, a)) next
        d <- fm[[a]]
        if (!is.null(ch)) {
          v <- choice_text(ch, 1L)
        } else {
          refs <- intersect(all.names(d), names(fm))
          if (length(refs)) {
            env <- lapply(refs, function(z) if (!is.null(final[[z]])) str2lang(final[[z]]) else fm[[z]])
            names(env) <- refs
            d <- do.call(substitute, list(d, env))
          }
          v <- gsub("([0-9])e([-+])0([0-9])", "\\1e\\2\\3", paste(deparse(d, width.cutoff = 500L), collapse = " "))
          v <- process(v)
        }
        cm <- ""
      }
      final[[a]] <- v
      out_names <- c(out_names, a); out_vals <- c(out_vals, v); out_cmt <- c(out_cmt, cm)
    }
    if (!length(out_names)) return(list(text = paste0(fname, "()"), pkg = TRUE))
    return(list(text = layout_call(fname, out_names, out_vals, out_cmt), pkg = TRUE))
  }
  # other functions: keep the layout; name positional arguments; replace processed values
  name_them <- !is.null(fm) && !any(is.na(mapped)) && length(args) > 0L
  if (name_them && length(args) == 1L && is.null(args[[1]]$name)) {
    lit <- pd$token[pd$parent == args[[1]]$row$id]
    name_them <- length(lit) == 1L && lit %in% c("NUM_CONST", "STR_CONST", "NULL_CONST")
  }
  wide <- function(t) { x <- splitl(t); any(c(off + nchar(x[1]), nchar(x[-1])) > 100L) }
  spliced <- ctext
  for (i in rev(seq_along(args))) {
    a <- args[[i]]
    j1 <- pos2idx(lines, a$row$line1, a$row$col1); j2 <- pos2idx(lines, a$row$line2, a$row$col2)
    nm <- if (name_them && is.null(a$name)) paste0(mapped[i], " = ") else ""
    spliced <- paste0(substring(spliced, 1L, j1 - 1L), nm, vals_abs[[i]], substring(spliced, j2 + 1L))
  }
  grown <- vapply(seq_along(args), function(i) grepl("\n", vals_abs[[i]]) && !identical(vals_abs[[i]], args[[i]]$val),
                  logical(1))
  lay <- any(grown) ||   # holds a value rewritten over several lines
    (length(args) > 1L && wide(spliced) && !(rf$bare %in% c("c", "paste", "paste0", "sprintf", "cat")))
  if (lay && !length(comments)) {   # same layout as a call of the package
    nms <- vapply(seq_along(args), function(i) {
      if (!is.null(args[[i]]$name)) args[[i]]$name else if (name_them) mapped[i] else ""
    }, "")
    vals <- vapply(seq_along(args), function(i) dedent(vals_abs[[i]], nchar(line_lead(args[[i]]$row$line1))), "")
    return(list(text = layout_call(fname, nms, vals), pkg = TRUE))
  }
  list(text = dedent(spliced, nchar(fi)), pkg = FALSE)
}

# ---- equivalence check --------------------------------------------------------------------------------------------
norm <- function(e) {
  if (!is.call(e)) return(e)
  # c("a", "b")[k] -> "x"
  if (identical(e[[1]], as.name("[")) && length(e) == 3L && is.call(e[[2]]) && identical(e[[2]][[1]], as.name("c")) &&
      is.numeric(e[[3]])) {
    v <- tryCatch(eval(e, baseenv()), error = function(err) NULL)
    if (is.character(v) && length(v) == 1L) return(v)
  }
  fn <- e[[1]]
  fname <- if (is.symbol(fn)) as.character(fn) else if (is.call(fn) && as.character(fn[[1]]) %in% c("::", ":::"))
    paste0(as.character(fn[[2]]), "::", as.character(fn[[3]])) else NULL
  if (!is.null(fname) && !(sub(".*::", "", fname) %in% gt_style_skip)) {
    rf <- resolve_fun(fname)
    fm <- if (is.function(rf$f)) fun_formals(rf$f) else NULL
    if (!is.null(fm)) {
      def <- function() NULL; formals(def) <- fm
      m <- tryCatch(match.call(def, e), error = function(err) NULL)
      if (!is.null(m)) {
        m[[1]] <- fn
        if (rf$is_pkg) {
          L <- as.list(m)
          for (a in setdiff(names(fm), c("...", names(L)))) {
            if (is_missing_el(fm, a)) next
            ch <- choices_of(rf$f, a)
            L[a] <- list(if (!is.null(ch)) ch[1] else fm[[a]])
          }
          for (a in intersect(names(fm), names(L))) {
            if (!is.null(choices_of(rf$f, a)) && is.call(L[[a]])) L[a] <- list(norm(L[[a]]))
            d <- if (is_missing_el(fm, a)) NULL else fm[[a]]
            if ((is.call(d) || is.symbol(d)) && identical(L[[a]], d) && length(intersect(all.names(d), names(fm)))) {
              L[a] <- list(do.call(substitute, list(d, L[setdiff(intersect(names(fm), names(L)), c("...", a))])))
            }
          }
          nn <- names(L)[-1]
          ord <- order(match(nn, names(fm)), seq_along(nn))
          m <- as.call(c(L[1], L[-1][ord]))
        }
        e <- m
      }
    }
  }
  for (i in seq_along(e)[-1]) if (!is_missing_el(e, i) && !is.null(e[[i]])) e[[i]] <- norm(e[[i]])
  e
}
same_code <- function(a, b) {
  ea <- tryCatch(parse(text = a, keep.source = FALSE), error = function(e) NULL)
  eb <- tryCatch(parse(text = b, keep.source = FALSE), error = function(e) NULL)
  if (is.null(ea) || is.null(eb) || length(ea) != length(eb)) return(FALSE)
  for (i in seq_along(ea)) if (!identical(norm(ea[[i]]), norm(eb[[i]]))) {
    cat("  differs:\n   ", paste(deparse(norm(ea[[i]])), collapse = ""), "\n   ",
        paste(deparse(norm(eb[[i]])), collapse = ""), "\n")
    return(FALSE)
  }
  TRUE
}
style_block <- function(code, where) {
  new <- tryCatch(process(code), error = function(e) { cat("  error in", where, ":", conditionMessage(e), "\n"); code })
  if (identical(new, code)) return(code)
  if (!same_code(code, new)) { cat("  NOT changed (check failed):", where, "\n"); return(code) }
  new
}

# ---- files --------------------------------------------------------------------------------------------------------
style_qmd <- function(x, file) {
  open <- grep("^```\\{r[ ,}]", x); out <- x
  for (s in rev(open)) {
    e <- s + which(grepl("^```\\s*$", x[(s + 1L):length(x)]))[1]
    if (is.na(e) || e <= s + 1L) next
    body <- x[(s + 1L):(e - 1L)]
    nopt <- sum(cumprod(grepl("^#\\|", body)))
    code <- body[seq_along(body) > nopt]
    if (!length(code)) next
    new <- splitl(style_block(paste(code, collapse = "\n"), sprintf("%s:%d", file, s)))
    out <- c(out[seq_len(s + nopt)], new, out[e:length(out)])
  }
  out
}
style_r <- function(x, file) {
  ex <- grep("^#' @examples\\s*$", x); out <- x
  for (s in rev(ex)) {
    e <- s
    while (e < length(x) && grepl("^#'( |$)", x[e + 1L]) && !grepl("^#' @", x[e + 1L])) e <- e + 1L
    if (e == s) next
    code <- sub("^#' ?", "", x[(s + 1L):e])
    esc <- any(grepl("\\%", code, fixed = TRUE))
    if (esc) code <- gsub("\\%", "%", code, fixed = TRUE)
    code <- sub("\\\\dontrun\\{", "if (.DONTRUN.) {", code)
    code <- sub("\\\\donttest\\{", "if (.DONTTEST.) {", code)
    new <- splitl(style_block(paste(code, collapse = "\n"), sprintf("%s:%d", file, s)))
    new <- sub("if (.DONTRUN.) {", "\\dontrun{", new, fixed = TRUE)
    new <- sub("if (.DONTTEST.) {", "\\donttest{", new, fixed = TRUE)
    if (esc) new <- gsub("%", "\\%", new, fixed = TRUE)
    new <- ifelse(nzchar(new), paste0("#' ", new), "#'")
    out <- c(out[seq_len(s)], new, out[(e + 1L):length(out)][e < length(out)])
    if (e == length(x)) out <- c(out[seq_len(s)], new)
  }
  out
}
changed <- character()
for (f in files) {
  x <- readLines(f, warn = FALSE)
  local_funs <- unique(sub("^\\s*([A-Za-z.][A-Za-z0-9._]*)\\s*(<-|=)\\s*function.*$", "\\1",
                           grep("^\\s*(#' )?\\s*[A-Za-z.][A-Za-z0-9._]*\\s*(<-|=)\\s*function", sub("^#' ", "", x),
                                value = TRUE)))
  y <- if (grepl("\\.R$", f)) style_r(x, f) else style_qmd(x, f)
  if (!identical(x, y)) {
    changed <- c(changed, f)
    if (!check_only) writeLines(y, f)
  }
}
cat(sprintf("%s: %d file(s) %s\n", pkg, length(changed), if (check_only) "would change" else "restyled"))
if (length(changed)) cat(paste0("  ", changed, collapse = "\n"), "\n")
