#-------------------------------------------------------------------------------------------------------------------
# Published values (common layer; synced from SKILL.qmd): inst/extdata/reference.csv drives the tests and the
# validation vignette.
#-------------------------------------------------------------------------------------------------------------------

#' Published values used by the tests and vignettes
#'
#' @description Reads \code{inst/extdata/reference.csv}: one row per published number, with its source, the R call
#' that recomputes it with this package (\code{call}), the expression that extracts the number from the result
#' (\code{extract}, in terms of \code{x}), the printed value and the digits to compare. The same file drives the test
#' of published values and the vignette that reproduces the published examples. Each distinct \code{call} is evaluated once.
#' @param source optional regular expression; keep rows whose \code{source} matches.
#' @param evaluate logical; evaluate the rows and add columns \code{computed} and \code{agrees} (default
#'   \code{FALSE}).
#' @param level largest \code{level} evaluated (1 = fast rows, 2 = slow rows; default 1); rows above it get
#'   \code{NA}.
#' @return A \code{data.table} with columns \code{id}, \code{source}, \code{quantity}, \code{call}, \code{extract},
#'   \code{value}, \code{digits}, \code{level}, \code{note} (and \code{computed}, \code{agrees}).
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @family DiallelAnalysisR utilities
#' @examples
#' ref <-
#'   da_reference(
#'       source   = NULL
#'     , evaluate = FALSE
#'     , level    = 1
#'     )
#' ref
#' \donttest{
#' da_reference(
#'     source   = "."
#'   , evaluate = TRUE
#'   , level    = 1
#'   )
#' }
#' @export
da_reference <- function(source = NULL, evaluate = FALSE, level = 1) {
  f <- system.file("extdata", "reference.csv", package = "DiallelAnalysisR")
  if (!nzchar(f)) return(data.table::data.table())
  ref <- data.table::fread(f, encoding = "UTF-8", colClasses = list(character = c("note")))
  if (!is.null(source)) { src <- source; ref <- ref[grepl(src, ref$source)] }
  if (evaluate && nrow(ref)) {
    ns <- asNamespace("DiallelAnalysisR")
    # the calls see the package's functions (exported and internal) and its data sets (lazy data is not part of the
    # namespace, so it is copied into the evaluation environment)
    env <- new.env(parent = ns)
    lazy <- getNamespaceInfo(ns, "lazydata")
    for (nm in ls(lazy)) assign(nm, get(nm, envir = lazy), envir = env)
    cache <- new.env(parent = emptyenv())
    comp <- vapply(seq_len(nrow(ref)), function(i) {
      if (ref$level[i] > level) return(NA_real_)
      cl <- ref$call[i]
      if (is.null(cache[[cl]])) cache[[cl]] <- tryCatch(eval(parse(text = cl), envir = new.env(parent = env)),
                                                        error = function(e) structure(list(), error = conditionMessage(e)))
      x <- cache[[cl]]
      v <- tryCatch(as.numeric(eval(parse(text = ref$extract[i]), envir = list(x = x), enclos = env)),
                    error = function(e) NA_real_)
      if (length(v) != 1L) NA_real_ else v
    }, numeric(1))
    ref[, computed := comp]
    ref[, agrees := !is.na(computed) & round(computed, digits) == round(value, digits)]
  }
  ref[]
}
