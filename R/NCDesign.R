#' North Carolina designs I, II and III
#'
#' @description
#' \code{NCDesign()} analyses the three mating designs of Comstock and Robinson (1948, 1952) grown in randomized
#' complete blocks: Design I (females nested within males), Design II (every male crossed with every female) and
#' Design III (males backcrossed to the two inbred parents of their population). It gives the analysis of variance,
#' the variance components and the additive and dominance variances with the average degree of dominance.
#'
#' @details
#' \eqn{B}{B} is the number of replicates, \eqn{M}{M} the number of males and \eqn{F_m}{F_m} the number of females
#' per male; \eqn{F}{F} (\code{Inbreeding}) is the inbreeding coefficient of the parents, so that the covariance of
#' half sibs is \eqn{(1 + F)\sigma^2_A/4}{(1 + F) sigma^2_A/4} and that of full sibs adds \eqn{(1 + F)^2\sigma^2_D/4}{(1
#' + F)^2 sigma^2_D/4}.
#'
#' \strong{Design I.} Lines males, females within males and error, with \eqn{E(MS_m) = \sigma^2 + B\sigma^2_{f(m)} +
#' BF_m\sigma^2_m}{E(MS_m) = sigma^2 + B sigma^2_f(m) + B F_m sigma^2_m} and \eqn{E(MS_{f(m)}) = \sigma^2 +
#' B\sigma^2_{f(m)}}{E(MS_f(m)) = sigma^2 + B sigma^2_f(m)}: males are tested against females within males, and
#' \eqn{\sigma^2_A = 4\sigma^2_m/(1 + F)}{sigma^2_A = 4 sigma^2_m/(1 + F)}, \eqn{\sigma^2_D = 4(\sigma^2_{f(m)} -
#' \sigma^2_m)/(1 + F)^2}{sigma^2_D = 4 (sigma^2_f(m) - sigma^2_m)/(1 + F)^2}.
#'
#' \strong{Design II.} Lines males, females, males \eqn{\times}{x} females and error; males and females are tested
#' against the interaction, the interaction against the error. \eqn{\sigma^2_A = 2(\sigma^2_m + \sigma^2_f)/(1 +
#' F)}{sigma^2_A = 2 (sigma^2_m + sigma^2_f)/(1 + F)} (four times their mean) and \eqn{\sigma^2_D = 4\sigma^2_{mf}/(1 +
#' F)^2}{sigma^2_D = 4 sigma^2_mf/(1 + F)^2}.
#'
#' \strong{Design III.} \code{Female} has exactly two levels, the two inbred parents; the males are \eqn{F_2}{F2}
#' plants. Lines males, testers (parents), males \eqn{\times}{x} testers and error, all tested against the error, with
#' \eqn{E(MS_m) = \sigma^2 + 2B\sigma^2_m}{E(MS_m) = sigma^2 + 2B sigma^2_m} and \eqn{E(MS_{mt}) = \sigma^2 +
#' B\sigma^2_{mt}}{E(MS_mt) = sigma^2 + B sigma^2_mt}; with gene frequencies of one half \eqn{\sigma^2_A =
#' 4\sigma^2_m}{sigma^2_A = 4 sigma^2_m} and \eqn{\sigma^2_D = 2\sigma^2_{mt}}{sigma^2_D = 2 sigma^2_mt}
#' (\code{Inbreeding} is not used).
#'
#' In every design the average degree of dominance is \eqn{\sqrt{2\sigma^2_D/\sigma^2_A}}{sqrt(2 sigma^2_D/sigma^2_A)}.
#' Every male-female combination must have at least one plot; missing plots are handled with least-squares means as
#' in \code{\link{LineTester}}.
#'
#' @inheritParams Griffing
#' @param Male male parent of each plot: a column of \code{data} or a vector, as for \code{y}.
#' @param Female female parent of each plot (Design I: labels may repeat across males, as females are nested; Design
#'   III: the two inbred parents): a column of \code{data} or a vector, as for \code{y}.
#' @param Design \code{1}, \code{2} or \code{3}. No default.
#' @param Inbreeding inbreeding coefficient \eqn{F}{F} of the parents, in \eqn{[0, 1]}{[0, 1]} (default \code{0}).
#' @return An object of class \code{c("da_ncdesign", "da_result", "list")}:
#' \describe{
#'   \item{\code{Means}}{matrix of the cross means (males in rows).}
#'   \item{\code{ANOVA}}{analysis of variance (class \code{anova}).}
#'   \item{\code{Genetic.Components}}{data frame: the variance components of the design, \eqn{\sigma^2_A}{sigma^2_A},
#'     \eqn{\sigma^2_D}{sigma^2_D} and the average degree of dominance.}
#' }
#'   Methods: \code{print()}, \code{summary()}, \code{plot()} (\code{which = c("components", "residuals", "qq")}),
#'   \code{data.table::as.data.table(x, component =)}, \code{\link{da_export}}.
#' @references
#' Comstock, R. E. and Robinson, H. F. (1948). The components of genetic variance in populations of biparental
#' progenies and their use in estimating the average degree of dominance. \emph{Biometrics}, \strong{4}(4),
#' 254--266. \doi{10.2307/3001412}
#'
#' Comstock, R. E. and Robinson, H. F. (1952). Estimation of average dominance of genes. In J. W. Gowen (ed.),
#' \emph{Heterosis}, 494--516. Iowa State College Press, Ames.
#'
#' Hallauer, A. R., Carena, M. J. and Miranda Filho, J. B. (2010). \emph{Quantitative Genetics in Maize Breeding}.
#' Springer, New York. \doi{10.1007/978-1-4419-0766-0}
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{LineTester}}, \code{\link{NCData}}
#' @family DiallelAnalysisR analyses
#' @examples
#' #-------------------------------------------------------------
#' ## Design II: every male crossed with every female
#' #-------------------------------------------------------------
#' nc2 <-
#'   NCDesign(
#'       y          = Yield
#'     , Rep        = Rep
#'     , Male       = Male
#'     , Female     = Female
#'     , data       = NCData[NCData$Design == 2, ]
#'     , Design     = 2
#'     , Inbreeding = 0
#'     )
#' nc2
#'
#' #-------------------------------------------------------------
#' ## Designs I and III
#' #-------------------------------------------------------------
#' nc1 <-
#'   NCDesign(
#'       y          = Yield
#'     , Rep        = Rep
#'     , Male       = Male
#'     , Female     = Female
#'     , data       = NCData[NCData$Design == 1, ]
#'     , Design     = 1
#'     , Inbreeding = 0
#'     )
#' nc1$Genetic.Components
#' nc3 <-
#'   NCDesign(
#'       y          = Yield
#'     , Rep        = Rep
#'     , Male       = Male
#'     , Female     = Female
#'     , data       = NCData[NCData$Design == 3, ]
#'     , Design     = 3
#'     , Inbreeding = 0
#'     )
#' plot(x = nc3, which = c("components", "residuals", "qq")[1])
#' @export
NCDesign <- function(y, Rep, Male, Female, data, Design, Inbreeding = 0) {
  fn     <- "NCDesign"
  data   <- .da_check_data(data, fn)
  y      <- .da_column(data, substitute(y), "y", fn, parent.frame())
  Rep    <- .da_column(data, substitute(Rep), "Rep", fn, parent.frame())
  Male   <- .da_column(data, substitute(Male), "Male", fn, parent.frame())
  Female <- .da_column(data, substitute(Female), "Female", fn, parent.frame())
  Design <- .da_check_number(Design, "Design", fn, min = 1, max = 3, integer = TRUE)
  Inbreeding <- .da_check_number(Inbreeding, "Inbreeding", fn, min = 0, max = 1)
  fem <- Female$value
  if (Design == 1L) fem <- paste(Male$value, fem, sep = ":")
  if (Design == 3L && length(unique(stats::na.omit(fem))) != 2L) {
    .da_stop(fn, "Design 3 needs exactly two levels of `Female` (the two inbred parents).")
  }
  if (Design == 1L) {
    out <- .da_nc1_core(y$value, Male$value, fem, Rep$value, Inbreeding, fn)
  } else {
    tw  <- .da_two_way(y$value, Male$value, fem, Rep$value, fn, c("males", "females"))
    out <- .da_nc23_core(tw, Design, Inbreeding)
    attr(out, "plots") <- tw$plots
  }
  .da_result(
      out
    , cls   = "ncdesign"
    , label = sprintf("North Carolina Design %s: %d males, %s replicates", c("I", "II", "III")[Design], nrow(out$Means),
                      format(round(attr(out, "B"), 2)))
    , call  = match.call()
    , meta  = list(design = Design, response = y$name, replicates = attr(out, "B"), inbreeding = Inbreeding)
    )
}

.da_nc1_core <- function(y, male, fem, rep, Fi, fn) {
  if (!is.numeric(y)) .da_stop(fn, "`y` must be numeric.")
  ok   <- !is.na(y) & !is.na(male) & !is.na(fem) & !is.na(rep)
  y    <- y[ok]
  male <- factor(male[ok])
  fem  <- factor(fem[ok])
  rep  <- factor(rep[ok])
  nf   <- tapply(as.character(fem), male, function(v) length(unique(v)))
  if (length(unique(nf)) != 1L) .da_stop(fn, "Design 1 needs the same number of females for every male.")
  if (nf[[1L]] < 2L) .da_stop(fn, "Design 1 needs at least two females per male.")
  X    <- stats::model.matrix(~ 0 + fem + rep, contrasts.arg = list(rep = "contr.sum"))
  f    <- stats::lm.fit(X, y)
  df_e <- length(y) - f$rank
  if (df_e < 1L) .da_stop(fn, "no degrees of freedom left for the error.")
  ss_e <- sum(f$residuals^2)
  mn   <- f$coefficients[seq_len(nlevels(fem))]
  fm   <- male[match(levels(fem), as.character(fem))]
  B    <- 1 / mean(1 / as.vector(table(fem)))
  Fm   <- nf[[1L]]
  Mn   <- nlevels(male)
  mm   <- tapply(mn, fm, mean)
  gm   <- mean(mn)
  ss_r <- sum(stats::lm.fit(stats::model.matrix(~ rep), y)$fitted.values^2) - length(y) * mean(y)^2
  ss   <- c(Rep = ss_r, Males = B * Fm * sum((mm - gm)^2), `Females(Males)` = B * sum((mn - mm[as.character(fm)])^2),
            Error = ss_e)
  df   <- c(Rep = nlevels(rep) - 1L, Males = Mn - 1, `Females(Males)` = Mn * (Fm - 1), Error = df_e)
  ANOVA <- .da_aov(ss, df, c("Error", "Females(Males)", "Error", NA))
  ms   <- stats::setNames(ANOVA$`Mean Sq`, rownames(ANOVA))
  v_m  <- (ms[["Males"]] - ms[["Females(Males)"]]) / (B * Fm)
  v_f  <- (ms[["Females(Males)"]] - ms[["Error"]]) / B
  sA   <- 4 * v_m / (1 + Fi)
  sD   <- 4 * (v_f - v_m) / (1 + Fi)^2
  comp <- c(Males = v_m, `Females(Males)` = v_f, Error = ms[["Error"]], Additive = sA, Dominance = sD,
            `Degree of dominance` = sqrt(2 * sD / sA))
  Means <- t(vapply(levels(male), function(m) unname(mn[fm == m]), numeric(Fm)))
  colnames(Means) <- paste0("F", seq_len(Fm))
  out  <- list(Means = Means, ANOVA = ANOVA,
               Genetic.Components = data.frame(Components = suppressWarnings(unname(comp)), row.names = names(comp)))
  attr(out, "plots") <- data.table::data.table(Row = male, Column = fem, Rep = rep, y = y,
                                               fitted = unname(f$fitted.values), residual = unname(f$residuals))
  attr(out, "B") <- B
  out
}

.da_nc23_core <- function(tw, design, Fi) {
  M  <- tw$M
  B  <- tw$R
  Mn <- nrow(M)
  Fn <- ncol(M)
  gm <- mean(M)
  rm <- rowMeans(M) - gm
  cm <- colMeans(M) - gm
  S  <- M - outer(rowMeans(M), colMeans(M), `+`) + gm
  nm <- if (design == 2L) c("Males", "Females", "Males:Females") else c("Males", "Testers", "Males:Testers")
  ss <- stats::setNames(c(tw$ss_rep, B * Fn * sum(rm^2), B * Mn * sum(cm^2), B * sum(S^2), tw$ss_e),
                        c("Rep", nm, "Error"))
  df <- stats::setNames(c(tw$df_rep, Mn - 1, Fn - 1, (Mn - 1) * (Fn - 1), tw$df_e), names(ss))
  ag <- if (design == 2L) c("Error", nm[3L], nm[3L], "Error", NA) else c("Error", "Error", "Error", "Error", NA)
  ANOVA <- .da_aov(ss, df, ag)
  ms <- stats::setNames(ANOVA$`Mean Sq`, rownames(ANOVA))
  if (design == 2L) {
    v_m  <- (ms[["Males"]] - ms[["Males:Females"]]) / (B * Fn)
    v_f  <- (ms[["Females"]] - ms[["Males:Females"]]) / (B * Mn)
    v_mf <- (ms[["Males:Females"]] - ms[["Error"]]) / B
    sA   <- 2 * (v_m + v_f) / (1 + Fi)
    sD   <- 4 * v_mf / (1 + Fi)^2
    comp <- c(Males = v_m, Females = v_f, `Males:Females` = v_mf, Error = ms[["Error"]], Additive = sA, Dominance = sD,
              `Degree of dominance` = sqrt(2 * sD / sA))
  } else {
    v_m  <- (ms[["Males"]] - ms[["Error"]]) / (2 * B)
    v_mt <- (ms[["Males:Testers"]] - ms[["Error"]]) / B
    sA   <- 4 * v_m
    sD   <- 2 * v_mt
    comp <- c(Males = v_m, `Males:Testers` = v_mt, Error = ms[["Error"]], Additive = sA, Dominance = sD,
              `Degree of dominance` = sqrt(2 * sD / sA))
  }
  out <- list(Means = M, ANOVA = ANOVA,
              Genetic.Components = data.frame(Components = suppressWarnings(unname(comp)), row.names = names(comp)))
  attr(out, "B") <- B
  out
}

.da_plot_ncdesign <- function(x, which = c("components", "residuals", "qq"), ...) {
  which <- match.arg(which)
  if (which %in% c("residuals", "qq")) return(.da_plot_resid(x, which))
  gc <- x$Genetic.Components
  keep <- rownames(gc) != "Degree of dominance"
  .da_effect_bars(stats::setNames(gc$Components[keep], rownames(gc)[keep]),
                  title = paste0(attr(x, "label"), ": variance components"), ylab = "variance") +
    ggplot2::labs(x = "component")
}

.da_print_ncdesign <- function(x, digits = 4L, ...) {
  cat(attr(x, "label"), "\n\n")
  print(x$ANOVA, digits = digits)
  cat("\nGenetic components\n")
  print(x$Genetic.Components, digits = digits)
  invisible(x)
}

.da_tables_ncdesign <- function(x) {
  list(`Analysis of variance` = .da_df(x$ANOVA), Components = .da_df(x$Genetic.Components, "Component"),
       Means = .da_df(x$Means, "Male"))
}
