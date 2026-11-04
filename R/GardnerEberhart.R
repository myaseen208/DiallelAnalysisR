#' Gardner and Eberhart's Analyses II and III of a diallel with parents
#'
#' @description
#' \code{GardnerEberhart()} analyses parents and one set of \eqn{F_1}{F1} crosses (Griffing's Method 2 design) with
#' the genetic models of Gardner and Eberhart (1966): Analysis II splits the entries into variety effects and
#' heterosis (average, variety and specific heterosis); Analysis III into variety effects, average heterosis and the
#' general and specific combining ability of the crosses.
#'
#' @details
#' Let \eqn{\bar{y}_{jj}}{y_jj} be the mean of parent (variety) \eqn{j}{j} and \eqn{\bar{y}_{jj'}}{y_jj'} that of the
#' cross \eqn{j \times j'}{j x j'}, \eqn{j < j'}{j < j'}, with \eqn{P}{P} parents.
#'
#' \strong{Analysis II.}
#' \deqn{\bar{y}_{jj} = \mu_v + v_j, \qquad \bar{y}_{jj'} = \mu_v + \frac{v_j + v_{j'}}{2} + \bar{h} + h_j + h_{j'} +
#'   s_{jj'},}{y_jj = mu_v + v_j; y_jj' = mu_v + (v_j + v_j')/2 + hbar + h_j + h_j' + s_jj',}
#' with \eqn{\sum_j v_j = \sum_j h_j = 0}{sum v_j = sum h_j = 0} and \eqn{\sum_{j' \neq j} s_{jj'} = 0}{sum_j' s_jj' =
#' 0}. The entries' sum of squares (\eqn{P(P + 1)/2 - 1}{P(P + 1)/2 - 1} degrees of freedom) is split sequentially
#' into varieties (\eqn{P - 1}{P - 1}) and heterosis, the latter into average heterosis (1), variety heterosis
#' (\eqn{P - 1}{P - 1}) and specific heterosis (\eqn{P(P - 3)/2}{P(P - 3)/2}).
#'
#' \strong{Analysis III.}
#' \deqn{\bar{y}_{jj} = \mu_v + v_j, \qquad \bar{y}_{jj'} = \mu_v + \bar{h} + g_j + g_{j'} + s_{jj'},}{y_jj = mu_v +
#'   v_j; y_jj' = mu_v + hbar + g_j + g_j' + s_jj',}
#' with \eqn{\sum_j g_j = 0}{sum g_j = 0}: varieties (\eqn{P - 1}{P - 1}), varieties against crosses (average
#' heterosis, 1), general combining ability of the crosses (\eqn{P - 1}{P - 1}) and specific combining ability
#' (\eqn{P(P - 3)/2}{P(P - 3)/2}); the last two are Griffing's Method 4 analysis of the crosses.
#'
#' The sums of squares are on the scale of entry means; the error is \eqn{MS_E/B}{MS_E/B} on the error degrees of
#' freedom of the block analysis (least-squares entry means and the harmonic mean of the plot numbers when plots are
#' missing). With \code{Model = 1} every line is tested against the error; with \code{Model = 2} the variety and
#' heterosis lines (Analysis II) or the gca line (Analysis III) are tested against the specific line. Standard errors
#' of the effects come from the least-squares fit, \eqn{\mathrm{Var}(\hat{\boldsymbol{\beta}}) =
#' (\mathbf{X}^{\top}\mathbf{X})^{-1}MS_E/B}{Var(b) = (X'X)^-1 MS_E/B}.
#'
#' @inheritParams Griffing
#' @param Analysis \code{2} (Analysis II, default) or \code{3} (Analysis III).
#' @param Model \code{1} (fixed effects, default) or \code{2} (random effects; changes only the tests).
#' @return An object of class \code{c("da_gardner", "da_result", "list")}:
#' \describe{
#'   \item{\code{Means}}{matrix of entry means (parents on the diagonal, crosses above it).}
#'   \item{\code{ANOVA}}{analysis of variance of the entries (class \code{anova}).}
#'   \item{\code{Effects}}{\code{data.table} of the effects of each parent with standard errors: Analysis II
#'     \code{v} and \code{h}; Analysis III \code{v} and \code{g}.}
#'   \item{\code{Average}}{data frame: \eqn{\hat{\mu}_v}{mu_v} and \eqn{\hat{\bar{h}}}{hbar} with standard errors.}
#'   \item{\code{Specific}}{symmetric matrix of the specific effects \eqn{\hat{s}_{jj'}}{s_jj'}.}
#'   \item{\code{RCBD}}{analysis of variance of the plot data.}
#' }
#'   Methods: \code{print()}, \code{summary()}, \code{plot()} (\code{which = c("effects", "specific", "residuals",
#'   "qq")}), \code{data.table::as.data.table(x, component =)}, \code{\link{da_export}}.
#' @references
#' Gardner, C. O. and Eberhart, S. A. (1966). Analysis and interpretation of the variety cross diallel and related
#' populations. \emph{Biometrics}, \strong{22}(3), 439--452. \doi{10.2307/2528181}
#'
#' Murray, L. W., Ray, I. M., Dong, H. and Segovia-Lerma, A. (2003). Clarification and reevaluation of population-based
#' diallel analyses: Gardner and Eberhart Analyses II and III revisited. \emph{Crop Science}, \strong{43}(6),
#' 1930--1937. \doi{10.2135/cropsci2003.1930}
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{Griffing}}, \code{\link{Heterosis}}
#' @family DiallelAnalysisR analyses
#' @examples
#' #-------------------------------------------------------------
#' ## Analysis II: varieties and heterosis
#' #-------------------------------------------------------------
#' ge2 <-
#'   GardnerEberhart(
#'       y        = Yield
#'     , Rep      = Rep
#'     , Cross1   = Cross1
#'     , Cross2   = Cross2
#'     , data     = GriffingData2
#'     , Analysis = 2
#'     , Model    = 1
#'     )
#' ge2
#' ge2$Effects
#' plot(x = ge2, which = c("effects", "specific", "residuals", "qq")[1])
#'
#' #-------------------------------------------------------------
#' ## Analysis III: varieties, average heterosis, gca and sca
#' #-------------------------------------------------------------
#' ge3 <-
#'   GardnerEberhart(
#'       y        = Yield
#'     , Rep      = Rep
#'     , Cross1   = Cross1
#'     , Cross2   = Cross2
#'     , data     = GriffingData2
#'     , Analysis = 3
#'     , Model    = 1
#'     )
#' ge3$ANOVA
#' @export
GardnerEberhart <- function(y, Rep, Cross1, Cross2, data, Analysis = 2, Model = 1) {
  fn       <- "GardnerEberhart"
  data     <- .da_check_data(data, fn)
  y        <- .da_column(data, substitute(y), "y", fn, parent.frame())
  Rep      <- .da_column(data, substitute(Rep), "Rep", fn, parent.frame())
  Cross1   <- .da_column(data, substitute(Cross1), "Cross1", fn, parent.frame())
  Cross2   <- .da_column(data, substitute(Cross2), "Cross2", fn, parent.frame())
  Analysis <- .da_check_number(Analysis, "Analysis", fn, min = 2, max = 3, integer = TRUE)
  Model    <- .da_check_number(Model, "Model", fn, min = 1, max = 2, integer = TRUE)
  cd <- .da_cell_data(y = y$value, p1 = Cross1$value, p2 = Cross2$value, rep = Rep$value, method = 2L, fn = fn)
  if (nrow(cd$M) < 4L) .da_stop(fn, "at least 4 parents are needed.")
  out <- .da_gardner_core(cd, Analysis, Model)
  attr(out, "plots") <- cd$plots
  .da_result(
      out
    , cls   = "gardner"
    , label = sprintf("Gardner and Eberhart's Analysis %s, Model %d; %d parents, %s replicates",
                      c("II", "III")[Analysis - 1L], Model, nrow(cd$M), format(round(cd$R, 2)))
    , call  = match.call()
    , meta  = list(analysis = Analysis, model = Model, response = y$name, replicates = cd$R)
    )
}

.da_gardner_core <- function(cd, analysis, model) {
  M   <- cd$M
  P   <- nrow(M)
  lab <- rownames(M)
  ij  <- which(upper.tri(M, diag = TRUE), arr.ind = TRUE)
  ij  <- ij[order(ij[, 1L] != ij[, 2L], ij[, 1L], ij[, 2L]), , drop = FALSE]
  i   <- ij[, 1L]
  j   <- ij[, 2L]
  v   <- M[ij]
  cr  <- as.numeric(i != j)
  n   <- length(v)
  var_m <- cd$mse / cd$R
  Si <- .da_sum0(i, P)
  Sj <- .da_sum0(j, P)
  if (analysis == 2L) {
    V  <- Si * (1 - cr) + (Si + Sj) / 2 * cr                   # variety effects: v_j for parents, mean for crosses
    H  <- (Si + Sj) * cr                                         # variety heterosis h_j + h_j'
    X  <- cbind(1, V, cr, H)
    bl <- list(Varieties = 1L + seq_len(P - 1L), `Average heterosis` = P + 1L, `Variety heterosis` = P + 1L + seq_len(P - 1L))
  } else {
    V  <- Si * (1 - cr)                                          # variety effects among the parents
    G  <- (Si + Sj) * cr                                         # gca among the crosses
    X  <- cbind(1, V, cr, G)
    bl <- list(Varieties = 1L + seq_len(P - 1L), `Average heterosis` = P + 1L, gca = P + 1L + seq_len(P - 1L))
  }
  ss  <- .da_seq_ss(X, c(list(Mean = 1L), bl), v)[-1L]
  ls  <- .da_ls(X, v)
  res <- v - ls$fitted
  spec <- if (analysis == 2L) "Specific heterosis" else "sca"
  ss  <- c(ss, stats::setNames(sum(res^2), spec))
  if (analysis == 2L) ss <- c(ss[1L], Heterosis = sum(ss[2:4]), ss[2:4])
  ss  <- c(ss, Error = cd$ss_e / cd$R)
  df  <- c(Varieties = P - 1, if (analysis == 2L) c(Heterosis = P * (P - 1) / 2), `Average heterosis` = 1, P - 1,
           P * (P - 3) / 2, Error = cd$df_e)
  names(df) <- names(ss)
  ag  <- stats::setNames(rep("Error", length(ss)), names(ss))
  ag[["Error"]] <- NA
  if (model == 2L) {
    if (analysis == 2L) ag[c("Varieties", "Heterosis", "Average heterosis", "Variety heterosis")] <- spec
    else ag[["gca"]] <- spec
  }
  ANOVA <- .da_aov(ss, df, ag)
  ANOVA[["F value"]][is.na(ag)] <- NA
  ANOVA[["Pr(>F)"]][is.na(ag)] <- NA
  Vb  <- ls$unscaled * var_m
  b   <- ls$coef
  e1  <- .da_full_effects(b[1L + seq_len(P - 1L)], Vb[1L + seq_len(P - 1L), 1L + seq_len(P - 1L), drop = FALSE])
  k2  <- P + 1L + seq_len(P - 1L)
  e2  <- .da_full_effects(b[k2], Vb[k2, k2, drop = FALSE])
  nm2 <- if (analysis == 2L) "h" else "g"
  Effects <- data.table::data.table(Parent = lab, v = e1$est, SE_v = sqrt(diag(e1$var)), x = e2$est,
                                    SE_x = sqrt(diag(e2$var)))
  data.table::setnames(Effects, c("x", "SE_x"), c(nm2, paste0("SE_", nm2)))
  Average <- data.frame(Estimate = b[c(1L, P + 1L)], `Std. Error` = sqrt(diag(Vb)[c(1L, P + 1L)]), check.names = FALSE,
                        row.names = c("mu_v", "hbar"))
  Average$`t value` <- Average$Estimate / Average$`Std. Error`
  Average$`Pr(>|t|)` <- 2 * stats::pt(-abs(Average$`t value`), cd$df_e)
  S <- matrix(NA_real_, P, P, dimnames = dimnames(M))
  S[ij[cr == 1, , drop = FALSE]] <- res[cr == 1]
  S[ij[cr == 1, 2:1, drop = FALSE]] <- res[cr == 1]
  list(Means = M, ANOVA = ANOVA, Effects = Effects, Average = Average, Specific = S, RCBD = cd$anova)
}

.da_plot_gardner <- function(x, which = c("effects", "specific", "residuals", "qq"), ...) {
  which <- match.arg(which)
  if (which %in% c("residuals", "qq")) return(.da_plot_resid(x, which))
  if (which == "specific") {
    S <- x$Specific
    d <- data.table::data.table(i = factor(rownames(S)[row(S)], levels = rownames(S)),
                                j = factor(colnames(S)[col(S)], levels = colnames(S)), s = as.vector(S))
    lim <- max(abs(d$s), na.rm = TRUE)
    return(
      ggplot2::ggplot(data = d, mapping = ggplot2::aes(x = j, y = i, fill = s)) +
        ggplot2::geom_tile(colour = "white") +
        ggplot2::scale_fill_gradient2(low = .da_palette[2L], mid = "white", high = .da_palette[1L],
                                      limits = c(-lim, lim), na.value = "grey95", name = NULL) +
        ggplot2::scale_y_discrete(limits = rev) +
        ggplot2::labs(x = NULL, y = NULL, title = "Specific effects") +
        da_theme(legend_position = "right")
    )
  }
  E <- x$Effects
  nm2 <- setdiff(names(E), c("Parent", "v", "SE_v"))[1L]
  d <- data.table::rbindlist(list(
    data.table::data.table(Parent = E$Parent, Effect = "variety (v)", est = E$v, se = E$SE_v),
    data.table::data.table(Parent = E$Parent, Effect = if (nm2 == "h") "variety heterosis (h)" else "gca (g)",
                           est = E[[nm2]], se = E[[paste0("SE_", nm2)]])))
  d[, Parent := factor(Parent, levels = E$Parent)]
  ggplot2::ggplot(data = d, mapping = ggplot2::aes(x = Parent, y = est)) +
    ggplot2::geom_hline(yintercept = 0, linewidth = 0.3) +
    ggplot2::geom_col(fill = .da_palette[1L], width = 0.7) +
    ggplot2::geom_errorbar(mapping = ggplot2::aes(ymin = est - se, ymax = est + se), width = 0.25) +
    ggplot2::facet_wrap(facets = ggplot2::vars(Effect), scales = "free_y") +
    ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(n = 8)) +
    ggplot2::labs(x = "Parent", y = "Effect (+/- one standard error)") +
    da_theme()
}

.da_print_gardner <- function(x, digits = 4L, ...) {
  cat(attr(x, "label"), "\n\nAnalysis of variance (entry means)\n")
  print(x$ANOVA, digits = digits)
  cat("\n")
  print(x$Average, digits = digits)
  cat("\nEffects of the parents\n")
  print(x$Effects, digits = digits)
  invisible(x)
}

.da_tables_gardner <- function(x) {
  list(`Analysis of variance` = .da_df(x$ANOVA), `Average effects` = .da_df(x$Average, "Effect"),
       `Effects of the parents` = as.data.frame(x$Effects), `Specific effects` = .da_df(x$Specific, "Parent"))
}

utils::globalVariables(c("Parent", "est", "se", "Effect", "i", "j", "s"))
