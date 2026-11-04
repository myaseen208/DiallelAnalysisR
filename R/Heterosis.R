#' Heterosis over the mid-parent, the better parent and a standard variety
#'
#' @description
#' \code{Heterosis()} estimates, for every cross of a diallel or a set of crosses grown with their parents in a
#' randomized complete block experiment, the heterosis over the mid-parent, over the better parent and over a standard
#' (check) variety, in percent, with \eqn{t}{t} tests of the underlying differences.
#'
#' @details
#' \strong{Means.} \eqn{F_{ij}}{F_ij} is the mean of cross \eqn{i \times j}{i x j} (crosses recorded both ways round
#' are kept apart, so reciprocal crosses have their own heterosis), \eqn{P_i}{P_i} the mean of parent \eqn{i}{i} and
#' \eqn{C}{C} the mean of the check; the means are least-squares means of the block analysis when plots are missing.
#' With \eqn{B}{B} replicates and error mean square \eqn{MS_E}{MS_E} on \eqn{f_E}{f_E} degrees of freedom
#' (Singh and Chaudhary 2004):
#' \deqn{MP = \frac{P_i + P_j}{2}, \quad H_{MP} = 100\,\frac{F_{ij} - MP}{MP}, \quad t = \frac{F_{ij} - MP}{
#'   \sqrt{3MS_E/(2B)}},}{MP = (P_i + P_j)/2; H_MP = 100 (F_ij - MP)/MP; t = (F_ij - MP)/sqrt(3 MS_E/(2B)),}
#' \deqn{BP = \max(P_i, P_j), \quad H_{BP} = 100\,\frac{F_{ij} - BP}{BP}, \quad t = \frac{F_{ij} - BP}{
#'   \sqrt{2MS_E/B}},}{BP = max(P_i, P_j); H_BP = 100 (F_ij - BP)/BP; t = (F_ij - BP)/sqrt(2 MS_E/B),}
#' and the standard heterosis \eqn{H_{C} = 100(F_{ij} - C)/C}{H_C = 100 (F_ij - C)/C} with \eqn{t = (F_{ij} -
#' C)/\sqrt{2MS_E/B}}{t = (F_ij - C)/sqrt(2 MS_E/B)}. For a trait where lower values are better (days to flowering,
#' disease score) set \code{Better = "lower"}: the better parent is then the lower one. The p-values are two-sided
#' on \eqn{f_E}{f_E} degrees of freedom.
#'
#' @inheritParams Griffing
#' @param Check label of the standard (check) variety: a parent of the diallel or another entry of \code{data} grown
#'   as a self (\code{Cross1 == Cross2}); \code{NULL} (default) for no standard heterosis.
#' @param Better \code{"higher"} (default) or \code{"lower"}: which parent is the better one.
#' @return An object of class \code{c("da_heterosis", "da_result", "list")}:
#' \describe{
#'   \item{\code{Means}}{matrix of cross means (parents on the diagonal).}
#'   \item{\code{Heterosis}}{\code{data.table}, one row per cross: \code{Cross1}, \code{Cross2}, \code{F1},
#'     \code{MidParent}, \code{BetterParent}, \code{MP} (percent), \code{t_MP}, \code{p_MP}, \code{BP},
#'     \code{t_BP}, \code{p_BP} and, with a check, \code{Check}, \code{SH}, \code{t_SH}, \code{p_SH}.}
#'   \item{\code{StdErr}}{standard errors of the differences \eqn{F_{ij} - MP}{F_ij - MP} and \eqn{F_{ij} - BP}{F_ij
#'     - BP} (also used for the check).}
#'   \item{\code{RCBD}}{analysis of variance of the plot data.}
#' }
#'   Methods: \code{print()}, \code{summary()}, \code{plot()} (heterosis of every cross, significant ones marked;
#'   \code{which = c("MP", "BP", "SH", "residuals", "qq")}), \code{data.table::as.data.table(x, component =)},
#'   \code{\link{da_export}}.
#' @references
#' Fonseca, S. and Patterson, F. L. (1968). Hybrid vigor in a seven-parent diallel cross in common winter wheat
#' (\emph{Triticum aestivum} L.). \emph{Crop Science}, \strong{8}(1), 85--88. \doi{10.2135/cropsci1968.0011183X000800010025x}
#'
#' Singh, R. K. and Chaudhary, B. D. (2004). \emph{Biometrical Methods in Quantitative Genetic Analysis}. Kalyani
#' Publishers, New Delhi.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{Griffing}}, \code{\link{GardnerEberhart}}
#' @family DiallelAnalysisR analyses
#' @examples
#' #-------------------------------------------------------------
#' ## Parents and one set of crosses; parent 3 as the check
#' #-------------------------------------------------------------
#' het <-
#'   Heterosis(
#'       y      = Yield
#'     , Rep    = Rep
#'     , Cross1 = Cross1
#'     , Cross2 = Cross2
#'     , data   = GriffingData2
#'     , Check  = 3
#'     , Better = c("higher", "lower")[1]
#'     )
#' het
#' head(het$Heterosis)
#' plot(x = het, which = c("MP", "BP", "SH", "residuals", "qq")[1])
#' @export
Heterosis <- function(y, Rep, Cross1, Cross2, data, Check = NULL, Better = c("higher", "lower")) {
  fn     <- "Heterosis"
  Better <- match.arg(Better)
  data   <- .da_check_data(data, fn)
  y      <- .da_column(data, substitute(y), "y", fn, parent.frame())
  Rep    <- .da_column(data, substitute(Rep), "Rep", fn, parent.frame())
  Cross1 <- .da_column(data, substitute(Cross1), "Cross1", fn, parent.frame())
  Cross2 <- .da_column(data, substitute(Cross2), "Cross2", fn, parent.frame())
  out <- .da_heterosis_core(y$value, Cross1$value, Cross2$value, Rep$value, Check, Better, fn)
  .da_result(
      out
    , cls   = "heterosis"
    , label = sprintf("Heterosis of %d crosses%s", nrow(out$Heterosis),
                      if (is.null(Check)) "" else paste0("; check ", Check))
    , call  = match.call()
    , meta  = list(response = y$name, replicates = attr(out, "B"), check = Check, better = Better)
    )
}

.da_heterosis_core <- function(y, p1, p2, rep, check, better, fn) {
  ok   <- !is.na(y) & !is.na(p1) & !is.na(p2) & !is.na(rep)
  y    <- y[ok]
  rep  <- factor(rep[ok])
  a    <- as.character(p1[ok])
  b    <- as.character(p2[ok])
  lab  <- .da_parent_levels(a, b)
  cell <- factor(paste(a, b, sep = "\r"))
  cnt  <- tabulate(cell, nbins = nlevels(cell))
  # least-squares cell means adjusted for blocks (equal to the plain means when no plot is missing)
  X    <- stats::model.matrix(~ 0 + cell + rep, contrasts.arg = list(rep = "contr.sum"))
  f    <- stats::lm.fit(X, y)
  df_e <- length(y) - f$rank
  if (df_e < 1L) .da_stop(fn, "no degrees of freedom left for the error.")
  mse  <- sum(f$residuals^2) / df_e
  B    <- 1 / mean(1 / cnt)
  key  <- do.call(rbind, strsplit(levels(cell), "\r", fixed = TRUE))
  mn   <- f$coefficients[seq_len(nlevels(cell))]
  self <- key[, 1L] == key[, 2L]
  par  <- stats::setNames(mn[self], key[self, 1L])
  cr   <- !self
  if (!any(cr)) .da_stop(fn, "`data` has no crosses.")
  miss <- setdiff(unique(c(key[cr, 1L], key[cr, 2L])), names(par))
  if (length(miss)) .da_stop(fn, "the parents ", paste(miss, collapse = ", "), " are not grown alone (selfs).")
  Pi   <- par[key[cr, 1L]]
  Pj   <- par[key[cr, 2L]]
  F1   <- unname(mn[cr])
  MPv  <- unname((Pi + Pj) / 2)
  BPv  <- unname(if (better == "higher") pmax(Pi, Pj) else pmin(Pi, Pj))
  se_mp <- sqrt(3 * mse / (2 * B))
  se_bp <- sqrt(2 * mse / B)
  pt2   <- function(t) 2 * stats::pt(-abs(t), df_e)
  H <- data.table::data.table(Cross1 = key[cr, 1L], Cross2 = key[cr, 2L], F1 = F1, MidParent = MPv, BetterParent = BPv,
                              MP = 100 * (F1 - MPv) / MPv, t_MP = (F1 - MPv) / se_mp,
                              BP = 100 * (F1 - BPv) / BPv, t_BP = (F1 - BPv) / se_bp)
  H[, p_MP := pt2(t_MP)]
  H[, p_BP := pt2(t_BP)]
  if (better == "lower") H[, t_BP := -t_BP]
  data.table::setcolorder(H, c("Cross1", "Cross2", "F1", "MidParent", "BetterParent", "MP", "t_MP", "p_MP", "BP",
                               "t_BP", "p_BP"))
  if (!is.null(check)) {
    check <- as.character(check)
    if (!check %in% names(par)) .da_stop(fn, "`Check` = ", check, " is not grown alone in `data`.")
    C <- par[[check]]
    H[, Check := C]
    H[, SH := 100 * (F1 - C) / C]
    H[, t_SH := (F1 - C) / se_bp]
    H[, p_SH := pt2(t_SH)]
  }
  ord <- order(match(H$Cross1, lab), match(H$Cross2, lab))
  H <- H[ord]
  M <- matrix(NA_real_, length(lab), length(lab), dimnames = list(lab, lab))
  M[cbind(match(key[, 1L], lab), match(key[, 2L], lab))] <- mn
  fit <- f$fitted.values
  ss_rep <- sum(stats::lm.fit(stats::model.matrix(~ rep), y)$fitted.values^2) - length(y) * mean(y)^2
  ss_tot <- sum((y - mean(y))^2)
  RCBD <- data.frame(Df = c(nlevels(rep) - 1L, nlevels(cell) - 1L, df_e),
                     `Sum Sq` = c(ss_rep, ss_tot - ss_rep - sum(f$residuals^2), sum(f$residuals^2)), check.names = FALSE,
                     row.names = c("Rep", "Entries", "Residuals"))
  RCBD$`Mean Sq` <- RCBD$`Sum Sq` / RCBD$Df
  out <- list(Means = M, Heterosis = H, StdErr = c(F1_MP = se_mp, F1_BP = se_bp), RCBD = RCBD)
  attr(out, "plots") <- data.table::data.table(Cross1 = a, Cross2 = b, Rep = rep, y = y, fitted = unname(fit),
                                               residual = unname(y - fit))
  attr(out, "B") <- B
  out
}

.da_plot_heterosis <- function(x, which = c("MP", "BP", "SH", "residuals", "qq"), ...) {
  which <- match.arg(which)
  if (which %in% c("residuals", "qq")) return(.da_plot_resid(x, which))
  H <- data.table::copy(x$Heterosis)
  if (which == "SH" && !"SH" %in% names(H)) .da_stop("plot", "no check variety: call Heterosis() with `Check`.")
  H[, cross := paste(Cross1, "x", Cross2)]
  H[, value := get(which)]
  H[, signif := get(paste0("p_", which)) < 0.05]
  H[, cross := factor(cross, levels = cross[order(value)])]
  lab <- c(MP = "mid-parent", BP = "better-parent", SH = "standard")[[which]]
  ggplot2::ggplot(data = H, mapping = ggplot2::aes(x = value, y = cross, colour = signif)) +
    ggplot2::geom_vline(xintercept = 0, linewidth = 0.3) +
    ggplot2::geom_segment(mapping = ggplot2::aes(x = 0, xend = value, yend = cross)) +
    ggplot2::geom_point(size = 2) +
    ggplot2::scale_colour_manual(values = c(`FALSE` = .da_palette[7L], `TRUE` = .da_palette[1L]),
                                 labels = c(`FALSE` = "not significant", `TRUE` = "p < 0.05"), name = NULL) +
    ggplot2::scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
    ggplot2::labs(x = paste0(lab, " heterosis (%)"), y = NULL, title = paste0("Heterosis over the ", lab)) +
    da_theme()
}

.da_print_heterosis <- function(x, digits = 4L, ...) {
  cat(attr(x, "label"), "\n\n")
  print(x$Heterosis, digits = digits)
  cat("\nStandard errors of the differences: F1 - MP ", format(x$StdErr[["F1_MP"]], digits = digits), ", F1 - BP ",
      format(x$StdErr[["F1_BP"]], digits = digits), "\n", sep = "")
  invisible(x)
}

.da_tables_heterosis <- function(x) list(Heterosis = as.data.frame(x$Heterosis), `Analysis of variance` = .da_df(x$RCBD))

utils::globalVariables(c("Cross1", "Cross2", "t_MP", "t_BP", "t_SH", "p_MP", "p_BP", "p_SH", "Check", "SH", "cross", "signif"))
