#' Analysis of ... (sentence case, no full stop)
#'
#' @description
#' One paragraph: what the function computes, from which data, by whose method (author, year).
#'
#' @details
#' The model, with every symbol defined (scalars upper case, vectors lower-case bold, matrices upper-case bold):
#' \deqn{y_{ijk} = \mu + g_i + g_j + s_{ij} + r_{ij} + e_{ijk}}{y_ijk = mu + g_i + g_j + s_ij + r_ij + e_ijk}
#' where \eqn{P}{P} is the number of parents and \eqn{R}{R} the number of replicates. Then the formulas the function
#' evaluates, in order, each as \code{\\deqn{LaTeX}{ASCII}}: sums of squares, mean squares, test statistics, effects,
#' standard errors. State the assumptions, the methods or models offered and how they differ, and how missing values
#' are handled.
#'
#' @param y response: a column of \code{data} given by name (\code{y = Yield} or \code{y = "Yield"}) or a numeric
#'   vector of length \code{nrow(data)}.
#' @param Rep replicate (block) column, as for \code{y}; converted to a factor.
#' @param Method method: \code{1} (parents, F1 and reciprocals), \code{2} (parents and F1), \code{3} (F1 and
#'   reciprocals) or \code{4} (F1 only). No default.
#' @param Model \code{1} (fixed effects) or \code{2} (random effects). No default.
#' @param data a data frame (or \code{data.table}) holding the columns.
#'
#' @return An object of class \code{c("da_<analysis>", "da_result", "list")}: the list returned by
#'   earlier versions, with the same component names.
#' \describe{
#'   \item{\code{Means}}{matrix of cross means, parents in rows and columns (\eqn{P \times P}{P x P}).}
#'   \item{\code{ANOVA}}{analysis-of-variance table: \code{Df}, \code{Sum Sq}, \code{Mean Sq}, \code{F value},
#'     \code{Pr(>F)}; one row per source.}
#'   \item{...}{one item per component, with its class, dimension and meaning.}
#' }
#' Methods: \code{print()}, \code{summary()}, \code{plot()} (describe the plot), \code{as.data.table(x, component)};
#' see \code{\link{da-methods}}.
#'
#' @references
#' Author, A. (year). Title. \emph{Journal}, \strong{volume}(issue), pages. \doi{...}
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{OtherFunction}}, \code{\link{DataSet}}
#' @family DiallelAnalysisR analyses
#' @examples
#' #-------------------------------------------------------------
#' ## Method 1, Model 1: parents, F1 and reciprocals; fixed effects
#' #-------------------------------------------------------------
#' fit <-
#'   FunctionName(
#'       y      = Yield
#'     , Rep    = Rep
#'     , Method = 1
#'     , Model  = 1
#'     , data   = DataSet
#'     )
#' fit
#' summary(fit)
#' fit$ANOVA
#' data.table::as.data.table(fit, component = "ANOVA")
#' plot(fit)
#' @export
FunctionName <- function(y, Rep, Method, Model, data) {
  fn     <- "FunctionName"
  data   <- .da_check_data(data, fn)
  y      <- .da_column(data, substitute(y), "y", fn, parent.frame())
  Rep    <- .da_column(data, substitute(Rep), "Rep", fn, parent.frame())
  Method <- .da_check_number(Method, "Method", fn, min = 1, max = 4, integer = TRUE)
  Model  <- .da_check_number(Model, "Model", fn, min = 1, max = 2, integer = TRUE)
  #-----------------------------------------------------------------------------------------------------------------
  # computation: one core for every method and model (plain vectors and matrices in, named list out)
  #-----------------------------------------------------------------------------------------------------------------
  out <-
    .da_thing_core(
        y      = as.numeric(y$value)
      , rep    = as.factor(Rep$value)
      , method = Method
      , model  = Model
      )
  .da_result(
      out
    , cls   = "thing"
    , label = sprintf("Method %d, Model %d", Method, Model)
    , call  = match.call()
    )
}
