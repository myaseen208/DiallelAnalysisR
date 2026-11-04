#-------------------------------------------------------------------------------------------------------------------
# Export of the main tables of a result to Word, LaTeX, HTML, Markdown or CSV
#-------------------------------------------------------------------------------------------------------------------

#' Export the tables of an analysis for a report or a paper
#'
#' @description
#' \code{da_export()} writes the main tables of a result of this package (the analysis of variance, the components,
#' the effects with their standard errors and tests, and so on) to a Word document, a LaTeX file of \code{booktabs}
#' tables, an HTML page, a Markdown file or CSV files, with numbers rounded for print.
#'
#' @details
#' \code{da_tables()} returns the tables that \code{da_export()} writes, as a named list of data frames, so that they
#' can be edited first. Numbers are rounded to \code{digits} decimals; p-values are printed with three decimals and as
#' \code{<0.001} below 0.001. Word documents need the packages \pkg{officer} and \pkg{flextable}; the other formats
#' need nothing beyond base R. For LaTeX, the file holds one \code{table} environment per table and needs
#' \code{\\usepackage{booktabs}} in the preamble. For CSV, each table goes to its own file, named after \code{file}
#' with the table name appended.
#'
#' @param x a result of \code{\link{Griffing}}, \code{\link{GriffingMeans}}, \code{\link{Hayman}},
#'   \code{\link{PartialDiallel}} or another analysis of the package.
#' @param file path of the file to write (its extension does not choose the format; \code{format} does).
#' @param format \code{"docx"} (Word), \code{"latex"}, \code{"html"}, \code{"markdown"} or \code{"csv"}.
#' @param tables names of the tables to write (default all; see \code{names(da_tables(x))}).
#' @param digits decimals of the printed numbers (default 3).
#' @param title title written above the tables (default: the label of the analysis).
#' @return \code{da_export()}: the path(s) of the file(s) written, invisibly. \code{da_tables()}: a named list of data
#'   frames.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @family DiallelAnalysisR utilities
#' @examples
#' fit <-
#'   Griffing(
#'       y          = Yield
#'     , Rep        = Rep
#'     , Cross1     = Cross1
#'     , Cross2     = Cross2
#'     , data       = GriffingData1
#'     , Method     = 1
#'     , Model      = 1
#'     , Reciprocal = c("combined", "split")[1]
#'     )
#' names(da_tables(x = fit, digits = 3))
#' f <- tempfile(fileext = ".tex")
#' da_export(
#'     x      = fit
#'   , file   = f
#'   , format = c("docx", "latex", "html", "markdown", "csv")[2]
#'   , tables = NULL
#'   , digits = 3
#'   , title  = NULL
#'   )
#' cat(readLines(f)[1:12], sep = "\n")
#' @export
da_export <- function(x, file, format = c("docx", "latex", "html", "markdown", "csv"), tables = NULL, digits = 3,
                      title = NULL) {
  fn     <- "da_export"
  format <- match.arg(format)
  .da_check_class(x, "da_result", "x", fn)
  digits <- .da_check_number(digits, "digits", fn, min = 0, max = 10, integer = TRUE)
  tb <- da_tables(x, digits = digits)
  if (!is.null(tables)) {
    bad <- setdiff(tables, names(tb))
    if (length(bad)) .da_stop(fn, "no table ", paste0("\"", bad, "\"", collapse = ", "), "; tables: ",
                              paste0("\"", names(tb), "\"", collapse = ", "), ".")
    tb <- tb[tables]
  }
  if (is.null(title)) title <- attr(x, "label")
  switch(
      format
    , docx     = .da_write_docx(tb, file, title, fn)
    , latex    = .da_write_latex(tb, file, title)
    , html     = .da_write_html(tb, file, title)
    , markdown = .da_write_markdown(tb, file, title)
    , csv      = .da_write_csv(tb, file)
    )
}

#' @rdname da_export
#' @export
da_tables <- function(x, digits = 3) {
  .da_check_class(x, "da_result", "x", "da_tables")
  cls <- .da_cls(x)
  f <- paste0(".da_tables_", cls)
  ns <- asNamespace("DiallelAnalysisR")
  raw <- if (exists(f, envir = ns, inherits = FALSE)) get(f, envir = ns)(x) else .da_tables_default(x)
  lapply(raw, .da_format_table, digits = digits)
}

# a matrix or data frame with row names as a data frame with a first column
.da_df <- function(v, first = "Source") {
  if (data.table::is.data.table(v)) return(as.data.frame(v))
  d <- as.data.frame(v, check.names = FALSE, stringsAsFactors = FALSE)
  rn <- rownames(v)
  if (!is.null(rn) && !identical(rn, as.character(seq_len(nrow(d))))) {
    d <- cbind(stats::setNames(data.frame(trimws(rn), stringsAsFactors = FALSE), first), d)
  }
  rownames(d) <- NULL
  d
}

.da_format_table <- function(d, digits) {
  d <- as.data.frame(d, check.names = FALSE, stringsAsFactors = FALSE)
  for (k in seq_along(d)) {
    v <- d[[k]]
    nm <- names(d)[k]
    if (!is.numeric(v)) next
    if (grepl("^(Pr\\(.*\\)|p\\.value|P|p_.*)$", nm)) {
      d[[k]] <- ifelse(is.na(v), "", ifelse(v < 0.001, "<0.001", formatC(v, format = "f", digits = 3)))
    } else if (all(is.na(v) | abs(v - round(v)) < 1e-9) && nm %in% c("Df", "df", "Df1", "Df2")) {
      d[[k]] <- ifelse(is.na(v), "", formatC(round(v), format = "d"))
    } else {
      d[[k]] <- ifelse(is.na(v), "", formatC(v, format = "f", digits = digits, big.mark = ""))
    }
  }
  d
}

.da_tables_default <- function(x) {
  keep <- vapply(x, function(v) is.data.frame(v) || is.matrix(v), logical(1))
  lapply(unclass(x)[keep], .da_df)
}

.da_tables_griffing <- function(x) {
  out <- list(`Analysis of variance` = .da_df(x$ANOVA), Components = .da_df(x$Genetic.Components, "Component"))
  if (!is.null(x$GCA)) {
    s <- summary(x)
    out$`General combining ability effects` <- as.data.frame(s$gca)
    S <- x$SCA
    out$`Specific combining ability effects` <- .da_df(S, "Parent")
    if (!is.null(x$Reciprocal)) out$`Reciprocal effects` <- .da_df(x$Reciprocal, "Parent")
    if (!is.null(x$Maternal)) out$`Maternal effects` <- data.frame(Parent = names(x$Maternal), Maternal = unname(x$Maternal))
    out$`Standard errors` <- data.frame(Comparison = names(x$StdErr), StdErr = unname(x$StdErr))
  }
  out
}

.da_tables_hayman <- function(x) {
  s <- summary(x)
  list(
      `Analysis of variance`    = .da_df(x$ANOVA)
    , `Components of variation` = as.data.frame(s$components)
    , `Genetic ratios`          = .da_df(x$Other.Parameters, "Ratio")
    , `Wr and Vr`               = .da_df(x$Wr.Vr.Table[, c("Wr", "Vr", "Wr.Minus.Vr", "Wr.Plus.Vr", "Yr")], "Array")
    , `Tests of the model`      = .da_df(x$Tests, "Test")
    )
}

.da_tables_partial <- function(x) {
  s <- summary(x)
  list(
      `Analysis of variance`               = .da_df(x$ANOVA)
    , `Variance components`                = .da_df(x$Genetic.Components, "Component")
    , `General combining ability effects`  = as.data.frame(s$gca)
    , `Specific combining ability effects` = .da_df(x$Specific, "Parent")
    )
}

#-------------------------------------------------------------------------------------------------------------------
# writers
#-------------------------------------------------------------------------------------------------------------------
.da_tex_escape <- function(s) {
  s <- gsub("\\", "\\textbackslash{}", s, fixed = TRUE)
  s <- gsub("([&%$#_{}])", "\\\\\\1", s)
  s <- gsub("~", "\\textasciitilde{}", s, fixed = TRUE)
  s <- gsub("^", "\\textasciicircum{}", s, fixed = TRUE)
  gsub("<", "$<$", s, fixed = TRUE)
}

.da_write_latex <- function(tb, file, title) {
  out <- c(paste0("% ", title), "% tables written by DiallelAnalysisR::da_export(); needs \\usepackage{booktabs}", "")
  for (nm in names(tb)) {
    d <- tb[[nm]]
    num <- vapply(d, function(v) all(grepl("^-?[0-9.]*$|^<0\\.001$|^$", v)), logical(1))
    align <- paste(ifelse(num, "r", "l"), collapse = "")
    out <- c(out, "\\begin{table}[htbp]", "\\centering", sprintf("\\caption{%s}", .da_tex_escape(nm)),
             sprintf("\\begin{tabular}{%s}", align), "\\toprule",
             paste0(paste(.da_tex_escape(names(d)), collapse = " & "), " \\\\"), "\\midrule",
             apply(d, 1L, function(r) paste0(paste(.da_tex_escape(as.character(r)), collapse = " & "), " \\\\")),
             "\\bottomrule", "\\end{tabular}", "\\end{table}", "")
  }
  writeLines(out, file)
  invisible(file)
}

.da_html_escape <- function(s) {
  s <- gsub("&", "&amp;", s, fixed = TRUE)
  s <- gsub("<", "&lt;", s, fixed = TRUE)
  gsub(">", "&gt;", s, fixed = TRUE)
}

.da_write_html <- function(tb, file, title) {
  css <- paste("body{font-family:Georgia,serif;max-width:60em;margin:2em auto;padding:0 1em}",
               "table{border-collapse:collapse;margin:0.5em 0 1.5em}",
               "caption{text-align:left;font-weight:bold;padding-bottom:0.3em}",
               "th,td{padding:0.2em 0.8em}thead th{border-top:2px solid #000;border-bottom:1px solid #000}",
               "tbody tr:last-child td{border-bottom:2px solid #000}td.n{text-align:right}")
  out <- c("<!DOCTYPE html>", "<html><head><meta charset=\"utf-8\">", sprintf("<title>%s</title>", .da_html_escape(title)),
           sprintf("<style>%s</style>", css), "</head><body>", sprintf("<h1>%s</h1>", .da_html_escape(title)))
  for (nm in names(tb)) {
    d <- tb[[nm]]
    num <- vapply(d, function(v) all(grepl("^-?[0-9.]*$|^<0\\.001$|^$", v)), logical(1))
    out <- c(out, "<table>", sprintf("<caption>%s</caption>", .da_html_escape(nm)), "<thead><tr>",
             paste0("<th>", .da_html_escape(names(d)), "</th>", collapse = ""), "</tr></thead><tbody>",
             apply(d, 1L, function(r) paste0("<tr>", paste0("<td", ifelse(num, " class=\"n\"", ""), ">",
                                                              .da_html_escape(as.character(r)), "</td>", collapse = ""),
                                              "</tr>")),
             "</tbody></table>")
  }
  writeLines(c(out, "</body></html>"), file)
  invisible(file)
}

.da_write_markdown <- function(tb, file, title) {
  out <- c(paste("#", title), "")
  for (nm in names(tb)) {
    d <- tb[[nm]]
    num <- vapply(d, function(v) all(grepl("^-?[0-9.]*$|^<0\\.001$|^$", v)), logical(1))
    out <- c(out, paste("##", nm), "", paste0("| ", paste(names(d), collapse = " | "), " |"),
             paste0("|", paste(ifelse(num, "---:", ":---"), collapse = "|"), "|"),
             apply(d, 1L, function(r) paste0("| ", paste(as.character(r), collapse = " | "), " |")), "")
  }
  writeLines(out, file)
  invisible(file)
}

.da_write_csv <- function(tb, file) {
  stem <- sub("\\.csv$", "", file)
  files <- vapply(names(tb), function(nm) {
    f <- paste0(stem, "_", gsub("[^A-Za-z0-9]+", "_", tolower(nm)), ".csv")
    data.table::fwrite(tb[[nm]], f)
    f
  }, "")
  invisible(unname(files))
}

.da_write_docx <- function(tb, file, title, fn) {
  if (!requireNamespace("officer", quietly = TRUE) || !requireNamespace("flextable", quietly = TRUE)) {
    .da_stop(fn, "Word export needs the packages officer and flextable: install.packages(c(\"officer\", ",
             "\"flextable\")); or use format = \"html\" and open the file in Word.")
  }
  doc <- officer::read_docx()
  doc <- officer::body_add_par(doc, title, style = "heading 1")
  for (nm in names(tb)) {
    ft <- flextable::flextable(tb[[nm]])
    ft <- flextable::theme_booktabs(ft)
    ft <- flextable::font(ft, fontname = "Times New Roman", part = "all")
    ft <- flextable::fontsize(ft, size = 10, part = "all")
    ft <- flextable::autofit(ft)
    ft <- flextable::set_caption(ft, caption = nm)
    doc <- flextable::body_add_flextable(doc, ft)
    doc <- officer::body_add_par(doc, "")
  }
  print(doc, target = file)
  invisible(file)
}
