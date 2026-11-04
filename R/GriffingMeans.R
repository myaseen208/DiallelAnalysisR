#' Griffing's analysis from a table of cross means
#'
#' @description
#' \code{GriffingMeans()} performs Griffing's (1956) combining-ability analysis when only the cross means and the
#' error mean square are available, as in published examples: the cross means come from \code{data} (one row per
#' cross) and the error from the experiment's analysis of variance. The analysis is that of \code{\link{Griffing}}.
#'
#' @details
#' \strong{Error.} \code{ErrorMS} is the error mean square on the basis of a cross mean, Griffing's
#' \eqn{M'_e = M_e/(bc)}{M_e' = M_e/(b c)} for \eqn{b}{b} blocks and \eqn{c}{c} plants per plot: for Model 1 the
#' within-plot (or plot) error divided by the number of observations per mean, for Model 2 the variety by block mean
#' square divided by the same number (Griffing 1956, Tables 8 and 12). \code{ErrorDf} is its degrees of freedom.
#' All other quantities, formulas and components are as documented in \code{\link{Griffing}}.
#'
#' @param y column of \code{data} with the cross means (bare name, string or vector).
#' @param Cross1,Cross2 columns of \code{data} with the two parents of each cross.
#' @param data a data frame with one row per cross (and per parent in Methods 1 and 2).
#' @param Method,Model as in \code{\link{Griffing}}.
#' @param ErrorMS error mean square on the basis of a cross mean (see Details).
#' @param ErrorDf degrees of freedom of \code{ErrorMS}.
#' @return An object of class \code{c("da_griffing", "da_result", "list")} with the components of
#'   \code{\link{Griffing}} except \code{RCBD} (there are no plot data).
#' @references
#' Griffing, B. (1956). Concept of general and specific combining ability in relation to diallel crossing systems.
#' \emph{Australian Journal of Biological Sciences}, \strong{9}(4), 463--493. \doi{10.1071/BI9560463}
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{Griffing}}, \code{\link{Griffing56}}
#' @family DiallelAnalysisR analyses
#' @examples
#' #-------------------------------------------------------------
#' ## Griffing's (1956) example: Method 4, Model 1, total yield
#' #-------------------------------------------------------------
#' g56 <-
#'   GriffingMeans(
#'       y       = TotalYield
#'     , Cross1  = Cross1
#'     , Cross2  = Cross2
#'     , data    = Griffing56
#'     , Method  = 4
#'     , Model   = 1
#'     , ErrorMS = 1642.48 / 78
#'     , ErrorDf = 2558
#'     )
#' g56$ANOVA
#' round(x = g56$GCA, digits = 2)
#'
#' #-------------------------------------------------------------
#' ## The same data with Model 2 (variety x block error)
#' #-------------------------------------------------------------
#' g56r <-
#'   GriffingMeans(
#'       y       = TotalYield
#'     , Cross1  = Cross1
#'     , Cross2  = Cross2
#'     , data    = Griffing56
#'     , Method  = 4
#'     , Model   = 2
#'     , ErrorMS = 11803.61 / 78
#'     , ErrorDf = 175
#'     )
#' g56r$Genetic.Components
#' @export
GriffingMeans <- function(y, Cross1, Cross2, data, Method, Model, ErrorMS, ErrorDf) {
  fn      <- "GriffingMeans"
  data    <- .da_check_data(data, fn)
  y       <- .da_column(data, substitute(y), "y", fn, parent.frame())
  Cross1  <- .da_column(data, substitute(Cross1), "Cross1", fn, parent.frame())
  Cross2  <- .da_column(data, substitute(Cross2), "Cross2", fn, parent.frame())
  Method  <- .da_check_number(Method, "Method", fn, min = 1, max = 4, integer = TRUE)
  Model   <- .da_check_number(Model, "Model", fn, min = 1, max = 2, integer = TRUE)
  ErrorMS <- .da_check_number(ErrorMS, "ErrorMS", fn, min = 0)
  ErrorDf <- .da_check_number(ErrorDf, "ErrorDf", fn, min = 1)
  # one "plot" per cross: the cell means are the data; the error comes from the arguments
  cd <-
    .da_cell_data(
        y      = y$value
      , p1     = Cross1$value
      , p2     = Cross2$value
      , rep    = rep(1L, nrow(data))
      , method = Method
      , fn     = fn
      )
  if (nrow(cd$M) < 4L) .da_stop(fn, "at least 4 parents are needed.")
  cd$R     <- 1
  cd$mse   <- ErrorMS
  cd$df_e  <- ErrorDf
  cd$ss_e  <- ErrorMS * ErrorDf
  cd$anova <- NULL
  out <- .da_griffing_core(cd, Method, Model)
  .da_result(
      out
    , cls   = "griffing"
    , label = sprintf("Griffing's Method %d, Model %d (%s effects) from cross means; %d parents", Method, Model,
                      c("fixed", "random")[Model], nrow(cd$M))
    , call  = match.call()
    , meta  = list(method = Method, model = Model, response = y$name, replicates = 1)
    )
}
