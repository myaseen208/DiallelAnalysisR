#-------------------------------------------------------------------------------------------------------------------
# Methods of the analysis results: print, summary, anova, coef, vcov, confint, fitted, residuals, nobs, df.residual,
# predict, autoplot (plot is in common-objects.R and plots-diallel.R)
#-------------------------------------------------------------------------------------------------------------------

#' Methods for the diallel analyses
#'
#' @description
#' The results of \code{\link{Griffing}}, \code{\link{Hayman}} and \code{\link{PartialDiallel}} are lists with a
#' class, so the usual model functions of R work on them: \code{print()} shows the main tables, \code{summary()} adds
#' the tests of every effect, \code{anova()} returns the analysis of variance, \code{coef()} the estimates,
#' \code{vcov()} and \code{confint()} their covariance matrix and confidence intervals, \code{fitted()} and
#' \code{residuals()} the plot-level fitted values and residuals of the block analysis, \code{predict()} the
#' predicted means of crosses (Griffing's fixed model), and \code{plot()} or \code{autoplot()} the figures.
#'
#' @details
#' \strong{Standard errors and tests} use the error variance of a cell mean \eqn{\sigma^2_m = MS_E/B}{sigma^2_m =
#' MS_E/B} on the error degrees of freedom \eqn{f_E}{f_E}: \eqn{t = \hat{\theta}/\mathrm{SE}(\hat{\theta})}{t =
#' estimate/SE}, two-sided p-values from the \eqn{t}{t} distribution on \eqn{f_E}{f_E} degrees of freedom, and
#' confidence intervals \eqn{\hat{\theta} \pm t_{1-\alpha/2, f_E}\,\mathrm{SE}(\hat{\theta})}{estimate +/-
#' t(1 - alpha/2, f_E) SE}. In Griffing's fixed model the gca effects have \eqn{\mathrm{Var}(\hat{g}_i) =
#' v_1\sigma^2_m}{Var(g_i) = v1 sigma^2_m} and \eqn{\mathrm{Cov}(\hat{g}_i, \hat{g}_j) = (v_1 - v_{12}/2)
#' \sigma^2_m}{Cov(g_i, g_j) = (v1 - v12/2) sigma^2_m}, where \eqn{v_1}{v1} and \eqn{v_{12}}{v12} are the variance
#' coefficients of \eqn{\hat{g}_i}{g_i} and of \eqn{\hat{g}_i - \hat{g}_j}{g_i - g_j} (see \code{\link{Griffing}}). In
#' the partial diallel \eqn{\mathrm{Var}(\hat{g}^I_i) = (1 - 1/L)\sigma^2/(BM)}{Var(gI_i) = (1 - 1/L) sigma^2/(B M)},
#' \eqn{\mathrm{Var}(\hat{g}^{II}_j) = (1 - 1/M)\sigma^2/(BL)}{Var(gII_j) = (1 - 1/M) sigma^2/(B L)} and
#' \eqn{\mathrm{Var}(\hat{S}_{ij}) = (L-1)(M-1)\sigma^2/(BLM)}{Var(S_ij) = (L - 1)(M - 1) sigma^2/(B L M)}. Hayman's
#' components are tested on \eqn{P-2}{P-2} degrees of freedom.
#'
#' \strong{Summary.} \code{summary(object, top = 5)} lists the \code{top} crosses with the largest sca effects
#' (Griffing's Model 1 and the partial diallel); \code{top} is passed through \code{...}.
#'
#' \strong{Prediction} (Griffing, Model 1): the mean of cross \eqn{i \times j}{i x j} is predicted by \eqn{\hat{\mu} +
#' \hat{g}_i + \hat{g}_j}{mu + g_i + g_j} from general combining ability alone (\code{type = "gca"}, the prediction
#' for crosses not grown or not yet tested) or by \eqn{\hat{\mu} + \hat{g}_i + \hat{g}_j + \hat{S}_{ij} +
#' \hat{R}_{ij}}{mu + g_i + g_j + S_ij + R_ij} (\code{type = "full"}, which reproduces the observed means).
#'
#' @param x,object a result of \code{Griffing()}, \code{Hayman()} or \code{PartialDiallel()}.
#' @param digits significant digits of printed numbers (default 4).
#' @param parm effects to include (names; default all).
#' @param level confidence level (default 0.95).
#' @param newdata data frame with columns \code{Cross1} and \code{Cross2} (parent labels); default every pair of
#'   parents.
#' @param type \code{"gca"} (default) or \code{"full"}; see Details.
#' @param ... passed on (to \code{plot()} for \code{autoplot()}; otherwise not used).
#' @return \code{print()} returns \code{x} invisibly. \code{summary()}: an object of class
#'   \code{summary.da_griffing}, \code{summary.da_hayman} or \code{summary.da_partial} (a list of tables, each a
#'   \code{data.table} or \code{data.frame}) with a print method. \code{anova()}: the analysis of variance (class
#'   \code{anova}). \code{coef()}: a named numeric vector (Griffing Model 1: gca effects \code{g_<parent>}, sca effects
#'   \code{s_<i>:<j>}, reciprocal effects \code{r_<i>:<j>}; Griffing Model 2: variance components; Hayman: the
#'   components of variation; partial diallel: gca effects \code{gI_<parent>}, \code{gII_<parent>}).
#'   \code{vcov()}: covariance matrix of the gca effects. \code{confint()}: a matrix with columns for the lower and
#'   upper limits. \code{fitted()}, \code{residuals()}: numeric vectors, one value per plot. \code{nobs()}: number of
#'   plots; \code{df.residual()}: error degrees of freedom. \code{predict()}: a \code{data.table} with
#'   \code{Cross1}, \code{Cross2} and \code{predicted}. \code{autoplot()}: a \code{ggplot} object.
#' @references
#' Griffing, B. (1956). Concept of general and specific combining ability in relation to diallel crossing systems.
#' \emph{Australian Journal of Biological Sciences}, \strong{9}(4), 463--493. \doi{10.1071/BI9560463}
#'
#' Hayman, B. I. (1954). The theory and analysis of diallel crosses. \emph{Genetics}, \strong{39}(6), 789--809.
#' \doi{10.1093/genetics/39.6.789}
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{Griffing}}, \code{\link{Hayman}}, \code{\link{PartialDiallel}}, \code{\link{da-methods}}
#' @name diallel-methods
#' @examples
#' #-------------------------------------------------------------
#' ## The model functions on Griffing's fixed model
#' #-------------------------------------------------------------
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
#' fit
#' summary(object = fit, top = 5)
#' anova(fit)
#' coef(fit)[1:8]
#' vcov(fit)
#' confint(object = fit, parm = NULL, level = 0.95)
#' head(fitted(fit))
#' head(residuals(fit))
#' nobs(fit)
#' df.residual(fit)
#' predict(
#'     object  = fit
#'   , newdata = data.frame(Cross1 = c(3, 7), Cross2 = c(7, 8))
#'   , type    = c("gca", "full")[1]
#'   )
#' plot(x = fit, which = c("gca", "sca", "biplot", "residuals", "qq")[4])
#'
#' #-------------------------------------------------------------
#' ## Hayman and the partial diallel
#' #-------------------------------------------------------------
#' h <-
#'   Hayman(
#'       y      = Yield
#'     , Rep    = Rep
#'     , Cross1 = Cross1
#'     , Cross2 = Cross2
#'     , data   = HaymanData
#'     )
#' summary(object = h, top = 5)
#' coef(h)
#' p <-
#'   PartialDiallel(
#'       y      = y
#'     , Rep    = Rep
#'     , Cross1 = Cross1
#'     , Cross2 = Cross2
#'     , data   = PartialDiallelData
#'     )
#' summary(object = p, top = 5)
#' confint(object = p, parm = NULL, level = 0.95)
NULL

#-------------------------------------------------------------------------------------------------------------------
# helpers
#-------------------------------------------------------------------------------------------------------------------
.da_ttable <- function(est, se, df, name = "term") {
  tv <- est / se
  out <- data.table::data.table(names(est), Estimate = unname(est), StdErr = unname(se), t.value = unname(tv),
                                p.value = unname(2 * stats::pt(-abs(tv), df)))
  data.table::setnames(out, 1L, name)
  out
}
.da_err <- function(x) {
  # Griffing: error line on the scale of a cell mean; partial diallel: plot scale
  A <- x$ANOVA
  list(mse = A["Error", "Mean Sq"], df = A["Error", "Df"], B = attr(x, "meta")$replicates)
}
.da_need_model1 <- function(x, fn) {
  if (attr(x, "meta")$model != 1L) .da_stop(fn, "effects are estimated in the fixed model (Model = 1) only.")
}
.da_gca_se <- function(x) {
  # standard error of a gca effect and of a difference of two (Griffing, Model 1)
  c(gi = x$StdErr[["gi"]], gi_gj = x$StdErr[["gi_gj"]])
}

#-------------------------------------------------------------------------------------------------------------------
# print
#-------------------------------------------------------------------------------------------------------------------
.da_print_griffing <- function(x, digits = 4L, ...) {
  cat(attr(x, "label"), "\n\nAnalysis of variance\n")
  print(x$ANOVA, digits = digits)
  cat("\nComponents\n")
  print(x$Genetic.Components, digits = digits)
  if (!is.null(x$GCA)) {
    cat("\nGeneral combining ability effects (standard error ", format(x$StdErr[["gi"]], digits = digits), ")\n",
        sep = "")
    print(signif(x$GCA, digits))
  }
  cat("\nAll components: names(x); tests of the effects: summary(x); figures: plot(x)\n")
  invisible(x)
}
.da_print_hayman <- function(x, digits = 4L, ...) {
  cat(attr(x, "label"), "\n\nAnalysis of variance\n")
  print(x$ANOVA, digits = digits)
  cat("\nComponents of variation\n")
  print(x$Components.of.Variation, digits = digits)
  cat("\nTests of the additive-dominance model\n")
  print(x$Tests, digits = digits)
  cat("\nAll components: names(x); genetic ratios: summary(x); Wr-Vr graph: plot(x)\n")
  invisible(x)
}
.da_print_partial <- function(x, digits = 4L, ...) {
  cat(attr(x, "label"), "\n\nAnalysis of variance\n")
  print(x$ANOVA, digits = digits)
  cat("\nVariance components\n")
  print(x$Genetic.Components, digits = digits)
  cat("\nGeneral combining ability effects\n")
  print(signif(x$General, digits))
  cat("\nAll components: names(x); tests of the effects: summary(x); figures: plot(x)\n")
  invisible(x)
}

#-------------------------------------------------------------------------------------------------------------------
# summary
#-------------------------------------------------------------------------------------------------------------------
.da_summary_griffing <- function(object, top = 5L, ...) {
  meta <- attr(object, "meta")
  out <- list(label = attr(object, "label"), anova = object$ANOVA, components = object$Genetic.Components)
  if (meta$model == 1L) {
    e <- .da_err(object)
    out$gca <- .da_ttable(object$GCA, rep(object$StdErr[["gi"]], length(object$GCA)), e$df, "parent")
    S <- object$SCA
    keep <- upper.tri(S) & !is.na(S)
    sca <- data.table::data.table(Cross1 = rownames(S)[row(S)[keep]], Cross2 = colnames(S)[col(S)[keep]],
                                  Estimate = S[keep])
    sca[, StdErr := object$StdErr[["sij"]]]
    sca[, t.value := Estimate / StdErr]
    sca[, p.value := 2 * stats::pt(-abs(t.value), e$df)]
    out$sca_top <- sca[order(-Estimate)][seq_len(min(top, .N))]
  }
  structure(out, class = "summary.da_griffing")
}

#' @rdname diallel-methods
#' @export
print.summary.da_griffing <- function(x, digits = 4L, ...) {
  cat(x$label, "\n\nAnalysis of variance\n")
  print(x$anova, digits = digits)
  cat("\nComponents\n")
  print(x$components, digits = digits)
  if (!is.null(x$gca)) {
    cat("\nGeneral combining ability effects\n")
    print(x$gca, digits = digits)
    cat("\nCrosses with the largest specific combining ability effects\n")
    print(x$sca_top, digits = digits)
  }
  invisible(x)
}

.da_summary_hayman <- function(object, ...) {
  P <- nrow(object$Means)
  cv <- data.table::as.data.table(object$Components.of.Variation, keep.rownames = "component")
  cv[, p.value := 2 * stats::pt(-abs(t.value), P - 2)]
  structure(list(label = attr(object, "label"), anova = object$ANOVA, components = cv,
                 ratios = object$Other.Parameters, tests = object$Tests, regression = c(a = object$a, b = object$b)),
            class = "summary.da_hayman")
}

#' @rdname diallel-methods
#' @export
print.summary.da_hayman <- function(x, digits = 4L, ...) {
  cat(x$label, "\n\nAnalysis of variance\n")
  print(x$anova, digits = digits)
  cat("\nComponents of variation (t tests on P - 2 degrees of freedom)\n")
  print(x$components, digits = digits)
  cat("\nGenetic ratios\n")
  print(x$ratios, digits = digits)
  cat("\nRegression of Wr on Vr: a = ", format(x$regression[["a"]], digits = digits), ", b = ",
      format(x$regression[["b"]], digits = digits), "\n", sep = "")
  print(x$tests, digits = digits)
  invisible(x)
}

.da_partial_se <- function(x) {
  e <- .da_err(x)
  L <- nrow(x$Means)
  M <- ncol(x$Means)
  c(gI = sqrt((1 - 1 / L) * e$mse / (e$B * M)), gII = sqrt((1 - 1 / M) * e$mse / (e$B * L)),
    s = sqrt((L - 1) * (M - 1) * e$mse / (e$B * L * M)))
}

.da_summary_partial <- function(object, top = 5L, ...) {
  e  <- .da_err(object)
  L  <- nrow(object$Means)
  se <- .da_partial_se(object)
  g  <- object$General
  gt <- .da_ttable(g, c(rep(se[["gI"]], L), rep(se[["gII"]], length(g) - L)), e$df, "parent")
  gt[, group := rep(c("I", "II"), c(L, length(g) - L))]
  S  <- object$Specific
  sca <- data.table::data.table(Cross1 = rownames(S)[row(S)], Cross2 = colnames(S)[col(S)], Estimate = as.vector(S))
  sca[, StdErr := se[["s"]]]
  sca[, t.value := Estimate / StdErr]
  sca[, p.value := 2 * stats::pt(-abs(t.value), e$df)]
  structure(list(label = attr(object, "label"), anova = object$ANOVA, components = object$Genetic.Components,
                 gca = gt, sca_top = sca[order(-Estimate)][seq_len(min(top, .N))]), class = "summary.da_partial")
}

#' @rdname diallel-methods
#' @export
print.summary.da_partial <- function(x, digits = 4L, ...) {
  cat(x$label, "\n\nAnalysis of variance\n")
  print(x$anova, digits = digits)
  cat("\nVariance components\n")
  print(x$components, digits = digits)
  cat("\nGeneral combining ability effects\n")
  print(x$gca, digits = digits)
  cat("\nCrosses with the largest specific combining ability effects\n")
  print(x$sca_top, digits = digits)
  invisible(x)
}

#-------------------------------------------------------------------------------------------------------------------
# model functions
#-------------------------------------------------------------------------------------------------------------------

#' @rdname diallel-methods
#' @export
anova.da_result <- function(object, ...) object$ANOVA

#' @rdname diallel-methods
#' @export
coef.da_griffing <- function(object, ...) {
  if (attr(object, "meta")$model == 2L) {
    gc <- object$Genetic.Components
    return(stats::setNames(gc$Components, rownames(gc)))
  }
  S <- object$SCA
  up <- upper.tri(S, diag = TRUE) & !is.na(S)
  out <- c(stats::setNames(object$GCA, paste0("g_", names(object$GCA))),
           stats::setNames(S[up], paste0("s_", rownames(S)[row(S)[up]], ":", colnames(S)[col(S)[up]])))
  if (!is.null(object$Reciprocal)) {
    Rm <- object$Reciprocal
    ur <- upper.tri(Rm)
    out <- c(out, stats::setNames(Rm[ur], paste0("r_", rownames(Rm)[row(Rm)[ur]], ":", colnames(Rm)[col(Rm)[ur]])))
  }
  out
}

#' @rdname diallel-methods
#' @export
coef.da_hayman <- function(object, ...) {
  cv <- object$Components.of.Variation
  stats::setNames(cv$Estimate, rownames(cv))
}

#' @rdname diallel-methods
#' @export
coef.da_partial <- function(object, ...) {
  L <- nrow(object$Means)
  g <- object$General
  stats::setNames(g, paste0(rep(c("gI_", "gII_"), c(L, length(g) - L)), names(g)))
}

#' @rdname diallel-methods
#' @export
vcov.da_griffing <- function(object, ...) {
  .da_need_model1(object, "vcov")
  se <- .da_gca_se(object)
  v1 <- se[["gi"]]^2
  P  <- length(object$GCA)
  V  <- matrix(v1 - se[["gi_gj"]]^2 / 2, P, P, dimnames = list(names(object$GCA), names(object$GCA)))
  diag(V) <- v1
  V
}

#' @rdname diallel-methods
#' @export
vcov.da_partial <- function(object, ...) {
  e  <- .da_err(object)
  L  <- nrow(object$Means)
  M  <- ncol(object$Means)
  vI  <- e$mse / (e$B * M)
  vII <- e$mse / (e$B * L)
  VI  <- (diag(L) - 1 / L) * vI
  VII <- (diag(M) - 1 / M) * vII
  V   <- matrix(0, L + M, L + M)
  V[seq_len(L), seq_len(L)] <- VI
  V[L + seq_len(M), L + seq_len(M)] <- VII
  nm <- names(coef.da_partial(object))
  dimnames(V) <- list(nm, nm)
  V
}

.da_confint <- function(est, se, df, level) {
  q <- stats::qt(1 - (1 - level) / 2, df)
  ci <- cbind(est - q * se, est + q * se)
  dimnames(ci) <- list(names(est), paste(format(100 * c((1 - level) / 2, 1 - (1 - level) / 2), trim = TRUE), "%"))
  ci
}

#' @rdname diallel-methods
#' @export
confint.da_griffing <- function(object, parm = NULL, level = 0.95, ...) {
  .da_need_model1(object, "confint")
  est <- coef(object)
  kind <- substr(names(est), 1L, 1L)
  pr <- sub("^s_", "", names(est))
  self <- kind == "s" & sub(":.*$", "", pr) == sub("^.*:", "", pr)
  se <- ifelse(kind == "g", object$StdErr[["gi"]],
               ifelse(kind == "r", if ("rij" %in% names(object$StdErr)) object$StdErr[["rij"]] else NA_real_,
                      ifelse(self & "sii" %in% names(object$StdErr), object$StdErr[["sii"]], object$StdErr[["sij"]])))
  if (!is.null(parm)) {
    keep <- names(est) %in% parm
    est <- est[keep]
    se <- se[keep]
  }
  .da_confint(est, se, .da_err(object)$df, level)
}

#' @rdname diallel-methods
#' @export
confint.da_partial <- function(object, parm = NULL, level = 0.95, ...) {
  est <- coef(object)
  L <- nrow(object$Means)
  s <- .da_partial_se(object)
  se <- c(rep(s[["gI"]], L), rep(s[["gII"]], length(est) - L))
  if (!is.null(parm)) {
    keep <- names(est) %in% parm
    est <- est[keep]
    se <- se[keep]
  }
  .da_confint(est, se, .da_err(object)$df, level)
}

#' @rdname diallel-methods
#' @export
fitted.da_result <- function(object, ...) attr(object, "plots")$fitted

#' @rdname diallel-methods
#' @export
residuals.da_result <- function(object, ...) attr(object, "plots")$residual

#' @rdname diallel-methods
#' @export
nobs.da_result <- function(object, ...) if (is.null(attr(object, "plots"))) NA_integer_ else nrow(attr(object, "plots"))

#' @rdname diallel-methods
#' @export
df.residual.da_result <- function(object, ...) {
  if (inherits(object, "da_hayman")) return(object$ANOVA["Error", "Df"])
  object$ANOVA["Error", "Df"]
}

#' @rdname diallel-methods
#' @export
predict.da_griffing <- function(object, newdata = NULL, type = c("gca", "full"), ...) {
  .da_need_model1(object, "predict")
  type <- match.arg(type)
  g <- object$GCA
  P <- names(g)
  M <- object$Means
  S <- object$SCA
  Rm <- if (is.null(object$Reciprocal)) matrix(0, length(P), length(P), dimnames = dimnames(M)) else object$Reciprocal
  # general mean from the observed cells: Y_ij = mu + g_i + g_j + S_ij + R_ij
  obs <- which(!is.na(M), arr.ind = TRUE)
  mu  <- mean(M[obs] - g[obs[, 1L]] - g[obs[, 2L]] - S[obs] - Rm[obs])
  if (is.null(newdata)) {
    newdata <- expand.grid(Cross1 = P, Cross2 = P, stringsAsFactors = FALSE)
  }
  i <- match(as.character(newdata$Cross1), P)
  j <- match(as.character(newdata$Cross2), P)
  if (anyNA(i) || anyNA(j)) .da_stop("predict", "`newdata` has parents that are not in the diallel.")
  pred <- mu + g[i] + g[j]
  if (type == "full") {
    s <- S[cbind(i, j)]
    s[is.na(s)] <- 0
    pred <- pred + s + Rm[cbind(i, j)]
  }
  data.table::data.table(Cross1 = P[i], Cross2 = P[j], predicted = unname(pred))
}

#' @rdname diallel-methods
#' @exportS3Method ggplot2::autoplot
autoplot.da_result <- function(object, ...) plot(object, ...)

utils::globalVariables(c("StdErr", "Estimate", "t.value", "p.value", "group"))
