#-------------------------------------------------------------------------------------------------------------------
# Biplot of a two-way table of cross means (Yan and Hunt 2002)
#-------------------------------------------------------------------------------------------------------------------

# Y: table of means, entries (rows) by testers (columns). The table is centred on the tester means (the GGE model),
# missing cells (the selfs of a diallel without parents) are filled in by a rank-2 fit, and the singular values are
# split equally between rows and columns. The average-tester axis (through the origin and the mean tester) ranks the
# entries by their general combining ability as far as the two axes hold it; when specific combining ability is
# large the two axes mainly show it, so the best general combiner is marked from the row means (or from `best`).
.da_biplot_svd <- function(Y) {
  miss <- is.na(Y)
  if (any(miss)) {
    fill <- outer(rowMeans(Y, na.rm = TRUE), colMeans(Y, na.rm = TRUE), `+`) / 2
    Y[miss] <- fill[miss]
    for (it in seq_len(200L)) {
      Z <- sweep(Y, 2L, colMeans(Y))
      s <- svd(Z, nu = 2L, nv = 2L)
      fit <- s$u %*% diag(s$d[1:2]) %*% t(s$v) + rep(colMeans(Y), each = nrow(Y))
      delta <- max(abs(Y[miss] - fit[miss]))
      Y[miss] <- fit[miss]
      if (delta < 1e-8) break
    }
  }
  Z <- sweep(Y, 2L, colMeans(Y))
  s <- svd(Z)
  pv <- 100 * s$d^2 / sum(s$d^2)
  list(rows = s$u[, 1:2, drop = FALSE] %*% diag(sqrt(s$d[1:2])),
       cols = s$v[, 1:2, drop = FALSE] %*% diag(sqrt(s$d[1:2])), pv = pv[1:2])
}

.da_biplot <- function(Y, row_name = "Entries", col_name = "Testers", diag_missing = TRUE, title = NULL, best = NULL) {
  Y <- unclass(Y)
  if (diag_missing) diag(Y) <- NA
  bp <- .da_biplot_svd(Y)
  r <- data.table::data.table(x = bp$rows[, 1L], y = bp$rows[, 2L], label = rownames(Y), type = row_name)
  k <- data.table::data.table(x = bp$cols[, 1L], y = bp$cols[, 2L], label = colnames(Y), type = col_name)
  a <- colMeans(bp$cols)
  a <- a / sqrt(sum(a^2))
  if (is.null(best)) best <- rownames(Y)[which.max(rowMeans(Y, na.rm = TRUE))]
  ext <- max(abs(c(r$x, r$y, k$x, k$y))) * 1.15
  ggplot2::ggplot() +
    ggplot2::geom_hline(yintercept = 0, linewidth = 0.2, colour = "grey60") +
    ggplot2::geom_vline(xintercept = 0, linewidth = 0.2, colour = "grey60") +
    ggplot2::geom_abline(intercept = 0, slope = a[2L] / a[1L], linetype = "dashed", colour = .da_palette[3L]) +
    ggplot2::annotate("segment", x = 0, y = 0, xend = a[1L] * ext * 0.9, yend = a[2L] * ext * 0.9,
                      arrow = ggplot2::arrow(length = ggplot2::unit(0.18, "cm")), colour = .da_palette[3L]) +
    ggplot2::geom_segment(data = k, mapping = ggplot2::aes(x = 0, y = 0, xend = x, yend = y), colour = .da_palette[2L],
                          linewidth = 0.3) +
    ggplot2::geom_text(data = k, mapping = ggplot2::aes(x = x, y = y, label = label), colour = .da_palette[2L],
                       fontface = "italic", size = 3.4, vjust = -0.5) +
    ggplot2::geom_point(data = r, mapping = ggplot2::aes(x = x, y = y), colour = .da_palette[1L], size = 1.8) +
    ggplot2::geom_text(data = r, mapping = ggplot2::aes(x = x, y = y, label = label,
                                                        fontface = ifelse(label == best, "bold", "plain")),
                       colour = .da_palette[1L], size = 3.4, vjust = 1.5) +
    ggplot2::coord_equal(xlim = c(-ext, ext), ylim = c(-ext, ext)) +
    ggplot2::labs(x = sprintf("PC1 (%.1f%%)", bp$pv[1L]), y = sprintf("PC2 (%.1f%%)", bp$pv[2L]),
                  title = if (is.null(title)) "Biplot of the cross means (tester-centred)" else title,
                  subtitle = sprintf("Dashed: average-%s axis; bold: best general combiner (%s); the two axes hold %.1f%%",
                                     tolower(sub("s$", "", col_name)), best, sum(bp$pv))) +
    da_theme()
}

utils::globalVariables(c("x", "y", "label", "type"))
