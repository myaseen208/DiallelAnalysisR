#' Line by tester analysis
#'
#' @description
#' \code{LineTester()} carries out Kempthorne's (1957) line \eqn{\times}{x} tester analysis of the crosses of
#' \eqn{L}{L} lines with \eqn{T}{T} testers in a randomized complete block experiment: the analysis of variance with
#' the split of the crosses into lines, testers and lines \eqn{\times}{x} testers, the proportional contributions of
#' the three to the crosses' sum of squares, the general and specific combining ability effects with standard errors,
#' and the genetic variances.
#'
#' @details
#' With \eqn{B}{B} replicates, cross means \eqn{\bar{y}_{ij}}{y_ij}, line means \eqn{\bar{y}_{i\cdot}}{y_i.}, tester
#' means \eqn{\bar{y}_{\cdot j}}{y_.j} and grand mean \eqn{\bar{y}_{\cdot\cdot}}{y_..}:
#' \deqn{\hat{g}_i = \bar{y}_{i\cdot} - \bar{y}_{\cdot\cdot}, \quad \hat{g}_j = \bar{y}_{\cdot j} - \bar{y}_{\cdot\cdot},
#'   \quad \hat{s}_{ij} = \bar{y}_{ij} - \bar{y}_{i\cdot} - \bar{y}_{\cdot j} + \bar{y}_{\cdot\cdot},}{g_i = y_i. - y..;
#'   g_j = y_.j - y..; s_ij = y_ij - y_i. - y_.j + y..,}
#' with standard errors \eqn{\sqrt{MS_E/(BT)}}{sqrt(MS_E/(BT))} (lines), \eqn{\sqrt{MS_E/(BL)}}{sqrt(MS_E/(BL))}
#' (testers) and \eqn{\sqrt{MS_E/B}}{sqrt(MS_E/B)} (crosses); a difference of two effects has \eqn{\sqrt{2}}{sqrt(2)}
#' times these. The sums of squares are on the plot scale; the proportional contribution of lines is \eqn{100
#' SS_L/SS_C}{100 SS_L/SS_C}, and likewise for testers and lines \eqn{\times}{x} testers.
#'
#' \strong{Genetic variances.} From the expected mean squares \eqn{E(MS_L) = \sigma^2 + B\sigma^2_s +
#' BT\sigma^2_{gL}}{E(MS_L) = sigma^2 + B sigma^2_s + BT sigma^2_gL}, \eqn{E(MS_T) = \sigma^2 + B\sigma^2_s +
#' BL\sigma^2_{gT}}{E(MS_T) = sigma^2 + B sigma^2_s + BL sigma^2_gT} and \eqn{E(MS_{LT}) = \sigma^2 +
#' B\sigma^2_s}{E(MS_LT) = sigma^2 + B sigma^2_s}:
#' \deqn{\hat{\sigma}^2_{gca} = \frac{L + T - 2}{B(2LT - L - T)}\left[\frac{(L - 1)MS_L + (T - 1)MS_T}{L + T - 2} -
#'   MS_{LT}\right], \qquad \hat{\sigma}^2_{sca} = \frac{MS_{LT} - MS_E}{B},}{sigma^2_gca = (L + T - 2)/(B(2LT - L -
#'   T)) [((L - 1) MS_L + (T - 1) MS_T)/(L + T - 2) - MS_LT]; sigma^2_sca = (MS_LT - MS_E)/B,}
#' and with inbreeding coefficient \eqn{F}{F} of the parents \eqn{\sigma^2_A = 4\sigma^2_{gca}/(1 + F)}{sigma^2_A = 4
#' sigma^2_gca/(1 + F)} and \eqn{\sigma^2_D = 4\sigma^2_{sca}/(1 + F)^2}{sigma^2_D = 4 sigma^2_sca/(1 + F)^2}
#' (Singh and Chaudhary 2004). The degree of dominance is \eqn{\sqrt{2\sigma^2_D/\sigma^2_A}}{sqrt(2 sigma^2_D/sigma^2_A)}.
#'
#' Missing plots are handled as in \code{\link{Griffing}}: least-squares cross means adjusted for blocks and the
#' harmonic mean of the plot numbers as \eqn{B}{B}; every cross must have at least one plot.
#'
#' @inheritParams Griffing
#' @param Line line (female) of each plot: a column of \code{data} or a vector, as for \code{y}.
#' @param Tester tester (male) of each plot: a column of \code{data} or a vector, as for \code{y}.
#' @param Inbreeding inbreeding coefficient \eqn{F}{F} of the lines and testers, in \eqn{[0, 1]}{[0, 1]} (default
#'   \code{0}; \code{1} for inbred lines).
#' @return An object of class \code{c("da_linetester", "da_result", "list")}:
#' \describe{
#'   \item{\code{Means}}{\eqn{L \times T}{L x T} matrix of cross means.}
#'   \item{\code{ANOVA}}{analysis of variance (class \code{anova}): \code{Rep}, \code{Crosses}, \code{Lines},
#'     \code{Testers}, \code{Lines:Testers}, \code{Error}.}
#'   \item{\code{Contribution}}{proportional contributions (percent) of lines, testers and lines \eqn{\times}{x}
#'     testers.}
#'   \item{\code{GCA.Lines}, \code{GCA.Testers}}{gca effects (named vectors).}
#'   \item{\code{SCA}}{\eqn{L \times T}{L x T} matrix of sca effects.}
#'   \item{\code{StdErr}}{standard errors: \code{gca_line}, \code{gca_tester}, \code{sca}, \code{gi_gj_line},
#'     \code{gi_gj_tester}, \code{sij_skl}.}
#'   \item{\code{Genetic.Components}}{data frame: \eqn{\sigma^2_{gca}}{sigma^2_gca} of lines, of testers and pooled,
#'     \eqn{\sigma^2_{sca}}{sigma^2_sca}, \eqn{\sigma^2_A}{sigma^2_A}, \eqn{\sigma^2_D}{sigma^2_D}, their ratio and
#'     the degree of dominance.}
#' }
#'   Methods: \code{print()}, \code{summary()}, \code{plot()} (\code{which = c("gca", "sca", "contribution", "biplot",
#'   "residuals", "qq")}), \code{data.table::as.data.table(x, component =)}, \code{\link{da_export}}.
#' @references
#' Kempthorne, O. (1957). \emph{An Introduction to Genetic Statistics}. John Wiley and Sons, New York.
#'
#' Singh, R. K. and Chaudhary, B. D. (2004). \emph{Biometrical Methods in Quantitative Genetic Analysis}. Kalyani
#' Publishers, New Delhi.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{NCDesign}}, \code{\link{PartialDiallel}}, \code{\link{LineTesterData}}
#' @family DiallelAnalysisR analyses
#' @examples
#' lt <-
#'   LineTester(
#'       y          = Yield
#'     , Rep        = Rep
#'     , Line       = Line
#'     , Tester     = Tester
#'     , data       = LineTesterData
#'     , Inbreeding = 1
#'     )
#' lt
#' lt$Contribution
#' plot(x = lt, which = c("gca", "sca", "contribution", "biplot", "residuals", "qq")[1])
#' @export
LineTester <- function(y, Rep, Line, Tester, data, Inbreeding = 0) {
  fn     <- "LineTester"
  data   <- .da_check_data(data, fn)
  y      <- .da_column(data, substitute(y), "y", fn, parent.frame())
  Rep    <- .da_column(data, substitute(Rep), "Rep", fn, parent.frame())
  Line   <- .da_column(data, substitute(Line), "Line", fn, parent.frame())
  Tester <- .da_column(data, substitute(Tester), "Tester", fn, parent.frame())
  Inbreeding <- .da_check_number(Inbreeding, "Inbreeding", fn, min = 0, max = 1)
  tw  <- .da_two_way(y$value, Line$value, Tester$value, Rep$value, fn, c("lines", "testers"))
  out <- .da_linetester_core(tw, Inbreeding)
  attr(out, "plots") <- tw$plots
  .da_result(
      out
    , cls   = "linetester"
    , label = sprintf("Line x tester analysis: %d lines, %d testers, %s replicates%s", nrow(tw$M), ncol(tw$M),
                      format(round(tw$R, 2)), if (tw$balanced) "" else " (missing plots: least-squares cross means)")
    , call  = match.call()
    , meta  = list(response = y$name, replicates = tw$R, inbreeding = Inbreeding)
    )
}

# cross means of a two-way (row factor by column factor) layout in blocks, with the error of the block analysis;
# least-squares means when plots are missing
.da_two_way <- function(y, a, b, rep, fn, what = c("rows", "columns")) {
  if (!is.numeric(y)) .da_stop(fn, "`y` must be numeric.")
  ok  <- !is.na(y) & !is.na(a) & !is.na(b) & !is.na(rep)
  y   <- y[ok]
  a   <- factor(a[ok])
  b   <- factor(b[ok])
  rep <- factor(rep[ok])
  if (nlevels(a) < 2L || nlevels(b) < 2L) .da_stop(fn, "at least two ", what[1L], " and two ", what[2L], " are needed.")
  if (nlevels(rep) < 2L) .da_stop(fn, "at least two replicates are needed.")
  cnt <- table(a, b)
  if (any(cnt == 0L)) .da_stop(fn, sum(cnt == 0L), " combination(s) of ", what[1L], " and ", what[2L],
                               " have no plot; the design must be complete.")
  cell <- interaction(a, b, drop = TRUE, lex.order = TRUE)
  X    <- stats::model.matrix(~ 0 + cell + rep, contrasts.arg = list(rep = "contr.sum"))
  f    <- stats::lm.fit(X, y)
  df_e <- length(y) - f$rank
  if (df_e < 1L) .da_stop(fn, "no degrees of freedom left for the error.")
  ss_e <- sum(f$residuals^2)
  mn   <- f$coefficients[seq_len(nlevels(cell))]
  M    <- matrix(mn, nlevels(a), nlevels(b), byrow = TRUE, dimnames = list(levels(a), levels(b)))
  balanced <- length(unique(as.vector(cnt))) == 1L && all(table(cell, rep) == cnt[1L] / nlevels(rep))
  R    <- 1 / mean(1 / as.vector(cnt))
  ss_r <- if (balanced) sum(tapply(y, rep, length) * (tapply(y, rep, mean) - mean(y))^2) else
    sum(stats::lm.fit(stats::model.matrix(~ rep), y)$fitted.values^2) - length(y) * mean(y)^2
  list(M = M, R = R, mse = ss_e / df_e, df_e = df_e, ss_e = ss_e, ss_rep = ss_r, df_rep = nlevels(rep) - 1L,
       balanced = balanced,
       plots = data.table::data.table(Row = a, Column = b, Rep = rep, y = y, fitted = unname(f$fitted.values),
                                      residual = unname(f$residuals)))
}

.da_linetester_core <- function(tw, Fi) {
  M   <- tw$M
  B   <- tw$R
  L   <- nrow(M)
  Tn  <- ncol(M)
  gm  <- mean(M)
  gl  <- rowMeans(M) - gm
  gt  <- colMeans(M) - gm
  S   <- M - outer(rowMeans(M), colMeans(M), `+`) + gm
  ss  <- c(Rep = tw$ss_rep, Crosses = B * sum((M - gm)^2), Lines = B * Tn * sum(gl^2), Testers = B * L * sum(gt^2),
           `Lines:Testers` = B * sum(S^2), Error = tw$ss_e)
  df  <- c(Rep = tw$df_rep, Crosses = L * Tn - 1, Lines = L - 1, Testers = Tn - 1, `Lines:Testers` = (L - 1) * (Tn - 1),
           Error = tw$df_e)
  ag  <- c(Rep = "Error", Crosses = "Error", Lines = "Error", Testers = "Error", `Lines:Testers` = "Error", Error = NA)
  ANOVA <- .da_aov(ss, df, ag)
  ms  <- ANOVA$`Mean Sq`
  names(ms) <- rownames(ANOVA)
  Contribution <- 100 * ss[c("Lines", "Testers", "Lines:Testers")] / ss[["Crosses"]]
  mse <- tw$mse
  StdErr <- sqrt(c(gca_line = mse / (B * Tn), gca_tester = mse / (B * L), sca = mse / B, gi_gj_line = 2 * mse / (B * Tn),
                   gi_gj_tester = 2 * mse / (B * L), sij_skl = 2 * mse / B))
  v_l  <- (ms[["Lines"]] - ms[["Lines:Testers"]]) / (B * Tn)
  v_t  <- (ms[["Testers"]] - ms[["Lines:Testers"]]) / (B * L)
  v_g  <- (((L - 1) * ms[["Lines"]] + (Tn - 1) * ms[["Testers"]]) / (L + Tn - 2) - ms[["Lines:Testers"]]) *
    (L + Tn - 2) / (B * (2 * L * Tn - L - Tn))
  v_s  <- (ms[["Lines:Testers"]] - ms[["Error"]]) / B
  sA   <- 4 * v_g / (1 + Fi)
  sD   <- 4 * v_s / (1 + Fi)^2
  comp <- c(gca_lines = v_l, gca_testers = v_t, gca = v_g, sca = v_s, `gca/sca` = v_g / v_s, Additive = sA,
            Dominance = sD, `Dominance/Additive` = sD / sA, `Degree of dominance` = sqrt(2 * sD / sA))
  list(Means = M, ANOVA = ANOVA, Contribution = Contribution, GCA.Lines = gl, GCA.Testers = gt, SCA = S,
       StdErr = StdErr, Genetic.Components = data.frame(Components = unname(comp), row.names = names(comp)))
}

.da_plot_linetester <- function(x, which = c("gca", "sca", "contribution", "biplot", "residuals", "qq"), ...) {
  which <- match.arg(which)
  if (which %in% c("residuals", "qq")) return(.da_plot_resid(x, which))
  if (which == "biplot") return(.da_biplot(x$Means, row_name = "Lines", col_name = "Testers", diag_missing = FALSE,
                                                    best = names(x$GCA.Lines)[which.max(x$GCA.Lines)]))
  if (which == "contribution") {
    d <- data.table::data.table(Source = factor(names(x$Contribution), levels = names(x$Contribution)),
                                pc = unname(x$Contribution))
    return(
      ggplot2::ggplot(data = d, mapping = ggplot2::aes(x = Source, y = pc)) +
        ggplot2::geom_col(fill = .da_palette[1L], width = 0.6) +
        ggplot2::geom_text(mapping = ggplot2::aes(label = sprintf("%.1f%%", pc)), vjust = -0.4, size = 3.4) +
        ggplot2::scale_y_continuous(limits = c(0, 100), breaks = scales::pretty_breaks(n = 6)) +
        ggplot2::labs(x = NULL, y = "Contribution to the crosses' sum of squares (%)") +
        da_theme()
    )
  }
  if (which == "sca") {
    S <- x$SCA
    d <- data.table::data.table(Line = factor(rownames(S)[row(S)], levels = rownames(S)),
                                Tester = factor(colnames(S)[col(S)], levels = colnames(S)), s = as.vector(S))
    lim <- max(abs(d$s))
    return(
      ggplot2::ggplot(data = d, mapping = ggplot2::aes(x = Tester, y = Line, fill = s)) +
        ggplot2::geom_tile(colour = "white") +
        ggplot2::geom_text(mapping = ggplot2::aes(label = format(round(s, 1))), size = 3) +
        ggplot2::scale_fill_gradient2(low = .da_palette[2L], mid = "white", high = .da_palette[1L],
                                      limits = c(-lim, lim), name = NULL) +
        ggplot2::scale_y_discrete(limits = rev) +
        ggplot2::labs(title = "Specific combining ability") +
        da_theme(legend_position = "right")
    )
  }
  se <- x$StdErr
  d <- data.table::rbindlist(list(
    data.table::data.table(Group = "Lines", Parent = names(x$GCA.Lines), g = unname(x$GCA.Lines), se = se[["gca_line"]]),
    data.table::data.table(Group = "Testers", Parent = names(x$GCA.Testers), g = unname(x$GCA.Testers),
                           se = se[["gca_tester"]])))
  d[, Parent := factor(Parent, levels = unique(Parent))]
  ggplot2::ggplot(data = d, mapping = ggplot2::aes(x = Parent, y = g)) +
    ggplot2::geom_hline(yintercept = 0, linewidth = 0.3) +
    ggplot2::geom_col(fill = .da_palette[1L], width = 0.7) +
    ggplot2::geom_errorbar(mapping = ggplot2::aes(ymin = g - se, ymax = g + se), width = 0.25) +
    ggplot2::facet_wrap(facets = ggplot2::vars(Group), scales = "free_x") +
    ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(n = 8)) +
    ggplot2::labs(x = NULL, y = "gca effect (+/- one standard error)") +
    da_theme()
}

.da_print_linetester <- function(x, digits = 4L, ...) {
  cat(attr(x, "label"), "\n\n")
  print(x$ANOVA, digits = digits)
  cat("\nProportional contributions (%)\n")
  print(round(x$Contribution, 2))
  cat("\nGenetic components\n")
  print(x$Genetic.Components, digits = digits)
  invisible(x)
}

.da_tables_linetester <- function(x) {
  list(`Analysis of variance` = .da_df(x$ANOVA),
       `Proportional contributions` = data.frame(Source = names(x$Contribution), Percent = unname(x$Contribution)),
       `gca of the lines` = data.frame(Line = names(x$GCA.Lines), gca = unname(x$GCA.Lines)),
       `gca of the testers` = data.frame(Tester = names(x$GCA.Testers), gca = unname(x$GCA.Testers)),
       `sca effects` = .da_df(x$SCA, "Line"), `Standard errors` = .da_df(x$StdErr, "Effect"),
       Components = .da_df(x$Genetic.Components, "Component"))
}

utils::globalVariables(c("Source", "pc", "Line", "Tester", "Group", "g"))
