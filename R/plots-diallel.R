#-------------------------------------------------------------------------------------------------------------------
# plot() methods of the analyses (dispatched by plot.da_result through .da_plot_<analysis>)
#-------------------------------------------------------------------------------------------------------------------

# bar chart of effects with optional +/- standard-error bars
.da_effect_bars <- function(eff, se = NULL, group = NULL, title = "", ylab = "effect") {
  tb <- data.table::data.table(parent = factor(names(eff), levels = names(eff)), effect = unname(eff))
  if (!is.null(group)) tb[, group := group]
  p <-
    ggplot2::ggplot(data = tb, mapping = ggplot2::aes(x = parent, y = effect)) +
    ggplot2::geom_hline(yintercept = 0, linewidth = 0.3) +
    ggplot2::geom_col(fill = .da_palette[1L], width = 0.7)
  if (!is.null(se) && is.finite(se)) {
    p <- p + ggplot2::geom_errorbar(mapping = ggplot2::aes(ymin = effect - se, ymax = effect + se), width = 0.25)
  }
  if (!is.null(group)) p <- p + ggplot2::facet_wrap(facets = ggplot2::vars(group), scales = "free_x")
  p +
    ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
    ggplot2::labs(x = "parent", y = ylab, title = title) +
    da_theme()
}

# heat map of a matrix of effects
.da_effect_tiles <- function(S, title = "", xlab = "parent", ylab = "parent") {
  tb <- data.table::data.table(
      row   = factor(rep(rownames(S), times = ncol(S)), levels = rev(rownames(S)))
    , col   = factor(rep(colnames(S), each = nrow(S)), levels = colnames(S))
    , value = as.vector(S)
    )
  lim <- max(abs(tb$value), na.rm = TRUE)
  ggplot2::ggplot(data = tb, mapping = ggplot2::aes(x = col, y = row, fill = value)) +
    ggplot2::geom_tile(colour = "white") +
    ggplot2::geom_text(mapping = ggplot2::aes(label = ifelse(is.na(value), "", format(round(value, 1)))),
                       size = 3, family = "serif") +
    ggplot2::scale_fill_gradient2(low = .da_palette[2L], mid = "white", high = .da_palette[1L], limits = c(-lim, lim),
                                  na.value = "grey95", name = "effect") +
    ggplot2::coord_equal() +
    ggplot2::labs(x = xlab, y = ylab, title = title) +
    da_theme() +
    ggplot2::theme(axis.line = ggplot2::element_blank(), axis.ticks = ggplot2::element_blank())
}

# residuals of the block analysis against the fitted values, or their normal quantile plot
.da_plot_resid <- function(x, which) {
  pl <- attr(x, "plots")
  if (which == "residuals") {
    return(ggplot2::ggplot(data = pl, mapping = ggplot2::aes(x = fitted, y = residual)) +
             ggplot2::geom_hline(yintercept = 0, linewidth = 0.3) +
             ggplot2::geom_point(colour = .da_palette[1L], size = 1.4) +
             ggplot2::scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
             ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
             ggplot2::labs(x = "fitted value", y = "residual", title = "Residuals of the block analysis") +
             da_theme())
  }
  ggplot2::ggplot(data = pl, mapping = ggplot2::aes(sample = residual)) +
    ggplot2::stat_qq(colour = .da_palette[1L], size = 1.4) +
    ggplot2::stat_qq_line(colour = .da_palette[2L]) +
    ggplot2::scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
    ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
    ggplot2::labs(x = "normal quantile", y = "residual", title = "Normal quantile plot of the residuals") +
    da_theme()
}

.da_plot_griffing <- function(x, which = c("gca", "sca", "biplot", "residuals", "qq"), ...) {
  which <- match.arg(which)
  if (which %in% c("residuals", "qq")) return(.da_plot_resid(x, which))
  if (which == "biplot") {
    best <- if (!is.null(x$GCA)) names(x$GCA)[which.max(x$GCA)]
    return(.da_biplot(.da_symmetric_means(x$Means), row_name = "Parents", col_name = "Testers", best = best))
  }
  meta  <- attr(x, "meta")
  if (meta$model == 2L) {
    gc <- x$Genetic.Components
    v  <- gc$Components[rownames(gc) %in% c("gca", "sca", "Reciprocal", "Maternal", "NonMaternal", "Error")]
    names(v) <- rownames(gc)[rownames(gc) %in% c("gca", "sca", "Reciprocal", "Maternal", "NonMaternal", "Error")]
    return(.da_effect_bars(v, title = paste0(attr(x, "label"), ": variance components"), ylab = "variance") +
             ggplot2::labs(x = "component"))
  }
  if (which == "gca") {
    return(.da_effect_bars(x$GCA, se = x$StdErr[["gi"]],
                           title = "General combining ability effects (bars: +/- one standard error)",
                           ylab = "gca effect"))
  }
  S <- x$SCA
  S[lower.tri(S)] <- NA
  .da_effect_tiles(S, title = "Specific combining ability effects", xlab = "male parent", ylab = "female parent")
}

.da_plot_hayman <- function(x, which = c("WrVr", "residuals", "qq"), ...) {
  which <- match.arg(which)
  if (which %in% c("residuals", "qq")) return(.da_plot_resid(x, which))
  w   <- x$Wr.Vr.Table
  v0  <- x$VOLO
  xmx <- max(c(w$Vr, x$In.Value, w$Wr, 0)) * 1.05
  cur <- data.table::data.table(Vr = seq(0, xmx, length.out = 200L))
  cur[, Wr := sqrt(Vr * v0)]
  pts <- data.table::data.table(Vr = w$Vr, Wr = w$Wr, parent = rownames(w))
  ggplot2::ggplot() +
    ggplot2::geom_hline(yintercept = 0, linewidth = 0.3) +
    ggplot2::geom_vline(xintercept = 0, linewidth = 0.3) +
    ggplot2::geom_line(data = cur, mapping = ggplot2::aes(x = Vr, y = Wr), colour = .da_palette[1L]) +
    ggplot2::geom_abline(intercept = x$a, slope = x$b, colour = .da_palette[2L]) +
    ggplot2::geom_abline(intercept = mean(w$Wr) - mean(w$Vr), slope = 1, linetype = 2, colour = .da_palette[7L]) +
    ggplot2::geom_point(data = pts, mapping = ggplot2::aes(x = Vr, y = Wr), size = 2) +
    ggplot2::geom_text(data = pts, mapping = ggplot2::aes(x = Vr, y = Wr, label = parent), vjust = -0.8,
                       family = "serif", size = 3.5) +
    ggplot2::scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
    ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
    ggplot2::labs(x = expression(V[r]), y = expression(W[r]),
                  title = sprintf("Wr-Vr graph: limiting parabola, regression (b = %.2f), unit slope (dashed)", x$b)) +
    da_theme()
}

.da_plot_partial <- function(x, which = c("gca", "sca", "residuals", "qq"), ...) {
  which <- match.arg(which)
  if (which %in% c("residuals", "qq")) return(.da_plot_resid(x, which))
  if (which == "gca") {
    nI <- nrow(x$Means)
    grp <- rep(c("group I", "group II"), c(nI, length(x$General) - nI))
    return(.da_effect_bars(x$General, group = grp, title = "General combining ability effects", ylab = "gca effect"))
  }
  .da_effect_tiles(x$Specific, title = "Specific combining ability effects", xlab = "group II", ylab = "group I")
}

utils::globalVariables(c("parent", "effect", "group", "row", "col", "Vr", "Wr", "fitted", "residual"))

# symmetric table of cross means: the mean of a cross and its reciprocal, a one-way cross in both cells
.da_symmetric_means <- function(M) {
  U <- unclass(M)
  L <- t(U)
  out <- ifelse(is.na(U), L, ifelse(is.na(L), U, (U + L) / 2))
  dimnames(out) <- dimnames(M)
  out
}
