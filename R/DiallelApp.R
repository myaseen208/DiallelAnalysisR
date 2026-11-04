#' Interactive analysis in a web browser
#'
#' @description
#' \code{DiallelApp()} starts a Shiny application for the analyses of the package: choose an example data set or
#' upload a CSV file (one row per plot), pick the analysis and its columns, and get the printed results, the main
#' tables, the plots, the tables for a paper (Word, LaTeX, HTML or Markdown, through \code{\link{da_export}}) and the
#' R code that repeats the analysis.
#'
#' @details
#' The application needs the packages \pkg{shiny} and \pkg{bslib} (and \pkg{officer} and \pkg{flextable} for Word
#' tables). It covers \code{\link{Griffing}}, \code{\link{GriffingEnv}}, \code{\link{Heterosis}}, \code{\link{Hayman}},
#' \code{\link{GardnerEberhart}}, \code{\link{PartialDiallel}}, \code{\link{LineTester}} and \code{\link{NCDesign}}.
#'
#' @param launch.browser passed to \code{shiny::runApp()}: \code{TRUE} (default in an interactive session) opens the
#'   application in the web browser.
#' @param ... further arguments to \code{shiny::runApp()}, such as \code{port}.
#' @return Called for its side effect; returns the value of \code{shiny::runApp()} when the application is closed.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{da_export}}
#' @examples
#' if (interactive()) {
#'   DiallelApp(
#'       launch.browser = TRUE
#'     )
#' }
#' @export
DiallelApp <- function(launch.browser = interactive(), ...) {
  fn <- "DiallelApp"
  for (p in c("shiny", "bslib")) {
    if (!requireNamespace(p, quietly = TRUE)) .da_stop(fn, "the package ", p, " is needed: install.packages(\"", p, "\").")
  }
  dir <- system.file("app", package = "DiallelAnalysisR")
  if (!nzchar(dir)) .da_stop(fn, "the application files are missing; reinstall DiallelAnalysisR.")
  shiny::runApp(appDir = dir, launch.browser = launch.browser, ...)
}
