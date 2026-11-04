#' Partial diallel analysis (crosses between two groups of parents)
#'
#' @description
#' \code{PartialDiallel()} analyses a partial diallel in which each of \eqn{L}{L} parents of a first group is crossed
#' with each of \eqn{M}{M} parents of a second group (a factorial mating design, also known as line by tester or North
#' Carolina design II), from the plot data of a randomized complete block experiment: the analysis of variance of the
#' general combining ability of each group and of the specific combining ability, the variance components, and the
#' gca and sca effects.
#'
#' @details
#' \strong{Data and model.} \eqn{\mathbf{Y}}{Y} is the \eqn{L \times M}{L x M} matrix of cross means (group I in rows,
#' group II in columns) over \eqn{B}{B} replicates, with row means \eqn{\bar{Y}_{i\cdot}}{Ybar_i.}, column means
#' \eqn{\bar{Y}_{\cdot j}}{Ybar_.j} and grand mean \eqn{\bar{Y}_{\cdot\cdot}}{Ybar_..}. The mean of cross
#' \eqn{i \times j}{i x j} is \eqn{Y_{ij} = \mu + g^{I}_i + g^{II}_j + S_{ij} + \bar{e}_{ij}}{Y_ij = mu + gI_i + gII_j
#' + S_ij + e_ij}.
#'
#' \strong{Analysis of variance} (plot scale):
#' \deqn{SS_{g^I} = BM\sum_i (\bar{Y}_{i\cdot} - \bar{Y}_{\cdot\cdot})^2, \quad SS_{g^{II}} = BL\sum_j
#'   (\bar{Y}_{\cdot j} - \bar{Y}_{\cdot\cdot})^2, \quad SS_s = B\sum_{i,j}(Y_{ij} - \bar{Y}_{i\cdot} -
#'   \bar{Y}_{\cdot j} + \bar{Y}_{\cdot\cdot})^2,}{SS_gI = B M sum_i (Ybar_i. - Ybar..)^2; SS_gII = B L sum_j (Ybar_.j
#'   - Ybar..)^2; SS_s = B sum_ij (Y_ij - Ybar_i. - Ybar_.j + Ybar..)^2,}
#' on \eqn{L-1}{L-1}, \eqn{M-1}{M-1} and \eqn{(L-1)(M-1)}{(L-1)(M-1)} degrees of freedom; their sum is the treatment
#' sum of squares on \eqn{LM-1}{LM-1} degrees of freedom; the error is the residual of the block analysis of the plot
#' data. Every line is tested against the error.
#'
#' \strong{Effects.} \eqn{\hat{g}^I_i = \bar{Y}_{i\cdot} - \bar{Y}_{\cdot\cdot}}{gI_i = Ybar_i. - Ybar..},
#' \eqn{\hat{g}^{II}_j = \bar{Y}_{\cdot j} - \bar{Y}_{\cdot\cdot}}{gII_j = Ybar_.j - Ybar..},
#' \eqn{\hat{S}_{ij} = Y_{ij} - \bar{Y}_{i\cdot} - \bar{Y}_{\cdot j} + \bar{Y}_{\cdot\cdot}}{S_ij = Y_ij - Ybar_i. -
#' Ybar_.j + Ybar..}.
#'
#' \strong{Variance components} (random model; Kempthorne 1957, Comstock and Robinson 1952):
#' \eqn{\sigma^2_{g^I} = (MS_{g^I} - MS_s)/(BM)}{sigma^2_gI = (MS_gI - MS_s)/(B M)}, \eqn{\sigma^2_{g^{II}} =
#' (MS_{g^{II}} - MS_s)/(BL)}{sigma^2_gII = (MS_gII - MS_s)/(B L)}, \eqn{\sigma^2_s = (MS_s - MS_E)/B}{sigma^2_s =
#' (MS_s - MS_E)/B}. The column \code{Percent} gives the proportional contribution of each source to the treatment sum
#' of squares.
#'
#' \strong{Changes from version 0.6.0.} The column arguments are used (version 0.6.0 read the columns \code{y},
#' \code{Rep}, \code{Cross1} and \code{Cross2} by name); the error line is on the plot scale like the other lines
#' (version 0.6.0 divided it by the number of replicates, so its \eqn{F}{F} values were too large by that factor
#' squared); the components are the variance components above (version 0.6.0 gave differences of mean squares and
#' their shares); the tables keep the parents' labels.
#'
#' @inheritParams Griffing
#' @param Cross1 parent of group I (rows) of each plot: a column of \code{data} or a vector, as for \code{y}.
#' @param Cross2 parent of group II (columns) of each plot: a column of \code{data} or a vector, as for \code{y}.
#' @return An object of class \code{c("da_partial", "da_result", "list")}:
#' \describe{
#'   \item{\code{Means}}{\eqn{L \times M}{L x M} matrix of cross means.}
#'   \item{\code{ANOVA}}{analysis of variance (class \code{anova}): \code{Treat}, \code{GCA I}, \code{GCA II},
#'     \code{SCA}, \code{Error}.}
#'   \item{\code{Genetic.Components}}{\code{Components} (variance components of \code{GCA I}, \code{GCA II},
#'     \code{SCA}) and \code{Percent} (share of the treatment sum of squares, as a proportion).}
#'   \item{\code{General}}{gca effects, group I followed by group II, named by parent.}
#'   \item{\code{Specific}}{\eqn{L \times M}{L x M} matrix of sca effects.}
#'   \item{\code{RCBD}}{(new) analysis of variance of the plot data as a randomized complete block design.}
#' }
#'   Methods: \code{print()}, \code{summary()}, \code{plot()} (gca effects of both groups and the sca effects as a heat
#'   map, residual plots; \code{which = c("gca", "sca", "residuals", "qq")}), \code{anova()}, \code{coef()},
#'   \code{vcov()}, \code{confint()}, \code{fitted()}, \code{residuals()}, \code{data.table::as.data.table(x,
#'   component =)}; see \code{\link{diallel-methods}}.
#'
#' @references
#' Comstock, R. E. and Robinson, H. F. (1952). Estimation of average dominance of genes. In J. W. Gowen (ed.),
#' \emph{Heterosis}, 494--516. Iowa State College Press, Ames.
#'
#' Kempthorne, O. (1957). \emph{An Introduction to Genetic Statistics}. John Wiley and Sons, New York.
#'
#' Kempthorne, O. and Curnow, R. N. (1961). The partial diallel cross. \emph{Biometrics}, \strong{17}(2), 229--250.
#' \doi{10.2307/2527989}
#'
#' Singh, R. K. and Chaudhary, B. D. (2004). \emph{Biometrical Methods in Quantitative Genetic Analysis}. Kalyani
#' Publishers, New Delhi.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com}), Pedro A. M. Barbosa (\email{pedro.barbosa@@usp.br})
#' @seealso \code{\link{Griffing}}, \code{\link{PartialDiallelData}}, \code{\link{da-methods}}
#' @family DiallelAnalysisR analyses
#' @examples
#' #-------------------------------------------------------------
#' ## Ten parents of group I crossed with four parents of group II
#' #-------------------------------------------------------------
#' Partial1 <-
#'   PartialDiallel(
#'       y      = y
#'     , Rep    = Rep
#'     , Cross1 = Cross1
#'     , Cross2 = Cross2
#'     , data   = PartialDiallelData
#'     )
#' Partial1
#' Partial1$ANOVA
#' Partial1$Genetic.Components
#' plot(Partial1)
#' @export
PartialDiallel <- function(y, Rep, Cross1, Cross2, data) {
  fn     <- "PartialDiallel"
  data   <- .da_check_data(data, fn)
  y      <- .da_column(data, substitute(y), "y", fn, parent.frame())
  Rep    <- .da_column(data, substitute(Rep), "Rep", fn, parent.frame())
  Cross1 <- .da_column(data, substitute(Cross1), "Cross1", fn, parent.frame())
  Cross2 <- .da_column(data, substitute(Cross2), "Cross2", fn, parent.frame())
  if (!is.numeric(y$value)) .da_stop(fn, "`y` must be numeric.")
  g1 <- .da_parent_levels(Cross1$value)
  g2 <- .da_parent_levels(Cross2$value)
  if (length(intersect(g1, g2))) .da_stop(fn, "a parent appears in both groups (Cross1 and Cross2).")
  if (length(g1) < 2L || length(g2) < 2L) .da_stop(fn, "each group needs at least 2 parents.")
  out <- .da_partial_core(y$value, factor(as.character(Cross1$value), g1), factor(as.character(Cross2$value), g2),
                          factor(Rep$value), fn)
  .da_result(
      out
    , cls   = "partial"
    , label = sprintf("Partial diallel; %d x %d parents", length(g1), length(g2))
    , call  = match.call()
    , meta  = list(response = y$name, replicates = nlevels(factor(Rep$value)))
    )
}

.da_partial_core <- function(y, f1, f2, rep, fn) {
  L    <- nlevels(f1)
  M    <- nlevels(f2)
  cell <- interaction(f1, f2, drop = FALSE, lex.order = TRUE)
  cnt  <- tabulate(cell, nbins = L * M)
  if (any(cnt == 0L)) .da_stop(fn, sum(cnt == 0L), " cross(es) between the groups are missing.")
  B    <- nlevels(rep)
  if (!all(cnt == B) || !all(table(cell, rep) == 1L)) .da_stop(fn, "every cross needs one plot in every replicate.")
  #-----------------------------------------------------------------------------------------------------------------
  # cross means and the block analysis of the plot data
  #-----------------------------------------------------------------------------------------------------------------
  s     <- rowsum(y, cell, reorder = TRUE)[, 1L]
  Ym    <- matrix(s / B, L, M, byrow = TRUE, dimnames = list(levels(f1), levels(f2)))
  N     <- length(y)
  G     <- sum(y)
  ss_tot <- sum(y^2) - G^2 / N
  ss_rep <- sum(rowsum(y, rep)[, 1L]^2) / (L * M) - G^2 / N
  ss_trt <- sum(s^2) / B - G^2 / N
  ss_e   <- ss_tot - ss_rep - ss_trt
  df_e   <- (B - 1L) * (L * M - 1L)
  RCBD <- data.frame(Df = c(B - 1L, L * M - 1L, df_e), `Sum Sq` = c(ss_rep, ss_trt, ss_e),
                     `Mean Sq` = c(ss_rep / (B - 1L), ss_trt / (L * M - 1L), ss_e / df_e), check.names = FALSE,
                     row.names = c("Rep", "Crosses", "Residuals"))
  #-----------------------------------------------------------------------------------------------------------------
  # gca of both groups, sca (plot scale)
  #-----------------------------------------------------------------------------------------------------------------
  m   <- mean(Ym)
  gI  <- rowMeans(Ym) - m
  gII <- colMeans(Ym) - m
  Sij <- Ym - outer(rowMeans(Ym), colMeans(Ym), `+`) + m
  df  <- c(L * M - 1L, L - 1L, M - 1L, (L - 1L) * (M - 1L), df_e)
  SS  <- c(ss_trt, B * M * sum(gI^2), B * L * sum(gII^2), B * sum(Sij^2), ss_e)
  MS  <- SS / df
  Fv  <- c(MS[1:4] / MS[5L], NA)
  pv  <- c(stats::pf(Fv[1:4], df[1:4], df[5L], lower.tail = FALSE), NA)
  ANOVA <-
    data.frame(
        Df          = df
      , `Sum Sq`    = SS
      , `Mean Sq`   = MS
      , `F value`   = Fv
      , `Pr(>F)`    = pv
      , check.names = FALSE
      , row.names   = c("Treat", "GCA I", "GCA II", "SCA", "Error")
      )
  class(ANOVA) <- c("anova", "data.frame")
  comp <- c((MS[2L] - MS[4L]) / (B * M), (MS[3L] - MS[4L]) / (B * L), (MS[4L] - MS[5L]) / B)
  Genetic.Components <-
    data.frame(
        Components = comp
      , Percent    = SS[2:4] / SS[1L]
      , row.names  = c("GCA I", "GCA II", "SCA")
      )
  fit <- (s / B)[as.integer(cell)] + (rowsum(y, rep)[, 1L] / (L * M))[as.integer(rep)] - G / N
  out <- list(
      Means              = Ym
    , ANOVA              = ANOVA
    , Genetic.Components = Genetic.Components
    , General            = c(gI, gII)
    , Specific           = Sij
    , RCBD               = RCBD
    )
  attr(out, "plots") <- data.table::data.table(Cross1 = as.character(f1), Cross2 = as.character(f2), Rep = rep, y = y,
                                               fitted = unname(fit), residual = unname(y - fit))
  out
}
