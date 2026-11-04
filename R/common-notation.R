#-------------------------------------------------------------------------------------------------------------------
# Notation table (common layer; synced from SKILL.qmd). One source: inst/notation/notation.csv, read by this
# function, by the theory vignette and by the help page of the package.
#-------------------------------------------------------------------------------------------------------------------

#' Notation of DiallelAnalysisR
#'
#' @description
#' The symbols used in the help pages and vignettes of \pkg{DiallelAnalysisR}, with their meaning and the argument or result
#' component that holds them. The notation follows one rule throughout: scalars are upper-case letters in normal
#' face (\eqn{P}{P}, \eqn{R}{R}), indices lower-case italic (\eqn{i, j}{i, j}), vectors lower-case bold
#' (\eqn{\mathbf{y}}{y}, \eqn{\boldsymbol{\beta}}{beta}) and matrices upper-case bold (\eqn{\mathbf{X}}{X},
#' \eqn{\boldsymbol{\Sigma}}{Sigma}).
#' @param format \code{"table"} (default: a \code{data.table} with columns \code{symbol} (LaTeX), \code{text}
#'   (plain text), \code{kind} (scalar, index, vector, matrix, set, function, operator), \code{meaning} and
#'   \code{argument}), \code{"path"} (the path of \code{notation.csv}) or \code{"tex"} (the path of
#'   \code{Notations.tex}, the notation appendix used in the articles).
#' @return See \code{format}.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @family DiallelAnalysisR utilities
#' @examples
#' da_notation(
#'     format = c("table", "path", "tex")[1]
#'   )
#' @export
da_notation <- function(format = c("table", "path", "tex")) {
  format <- match.arg(format)
  csv <- system.file("notation", "notation.csv", package = "DiallelAnalysisR")
  if (format == "path") return(csv)
  if (format == "tex") return(system.file("notation", "Notations.tex", package = "DiallelAnalysisR"))
  if (!nzchar(csv)) return(data.table::data.table())
  data.table::fread(csv, encoding = "UTF-8", colClasses = "character")
}
