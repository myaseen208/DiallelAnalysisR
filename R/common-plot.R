#-------------------------------------------------------------------------------------------------------------------
# Plot style (common layer; synced from SKILL.qmd): a TikZ/pgfplots-like look built on theme_classic().
#-------------------------------------------------------------------------------------------------------------------

# print-safe colours close to the pgfplots cycle (blue, red, green, violet, orange, teal, grey)
.da_palette <- c("#1f4e9e", "#b2182b", "#2d7d46", "#6a3d9a", "#c66b00", "#00777a", "#4d4d4d")

# continuous axes with about ten pretty breaks; y starts at the data (no padding below 0 for bars)
.da_breaks <- function(integer = FALSE) {
  if (!integer) return(scales::pretty_breaks(n = 10))
  function(x) { b <- scales::pretty_breaks(n = 10)(x); b <- b[abs(b - round(b)) < 1e-9]; if (length(b) < 2L) unique(round(x)) else b }
}
.da_x_cont <- function(..., integer = FALSE) ggplot2::scale_x_continuous(breaks = .da_breaks(integer), ...)
.da_y_cont <- function(..., bars = FALSE) {
  if (bars) ggplot2::scale_y_continuous(breaks = .da_breaks(),
                                        expand = ggplot2::expansion(mult = c(0, 0.05)), ...)
  else ggplot2::scale_y_continuous(breaks = .da_breaks(), ...)
}

#' ggplot2 theme of DiallelAnalysisR
#'
#' @description The theme used by every \code{plot()} method of \pkg{DiallelAnalysisR} (identical in all packages of the
#' author): \code{\link[ggplot2]{theme_classic}} with a serif font, black axis lines, ticks pointing inwards and no
#' grid, close to the look of TikZ/pgfplots figures in LaTeX documents. The \code{plot()} methods also use
#' \code{scales::pretty_breaks(n = 10)} on every continuous axis. Save figures with \code{\link{da_save}}.
#' @param base_size base font size in points (default 11).
#' @param base_family font family (default \code{"serif"}; for example \code{"Latin Modern Roman"} when installed,
#'   to match LaTeX documents).
#' @param ticks_inward logical; ticks point into the panel, as in pgfplots (default \code{TRUE}).
#' @param legend_position position of the legend (default \code{"bottom"}).
#' @return A \code{ggplot2} theme.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @family DiallelAnalysisR utilities
#' @examples
#' library(ggplot2)
#' p <-
#'   ggplot(data = data.frame(x = 1:20, y = cumsum(sin(1:20))), mapping = aes(x = x, y = y)) +
#'   geom_line()
#' p +
#'   da_theme(
#'       base_size       = 11
#'     , base_family     = "serif"
#'     , ticks_inward    = TRUE
#'     , legend_position = "bottom"
#'     )
#' p +
#'   da_theme(
#'       base_size       = 12
#'     , base_family     = "serif"
#'     , ticks_inward    = FALSE
#'     , legend_position = "right"
#'     ) +
#'   scale_x_continuous(breaks = scales::pretty_breaks(n = 10))
#' @export
da_theme <- function(base_size = 11, base_family = "serif", ticks_inward = TRUE, legend_position = "bottom") {
  tick <- 0.12 * base_size / 11
  ggplot2::theme_classic(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      axis.line = ggplot2::element_line(colour = "black", linewidth = 0.4),
      axis.ticks = ggplot2::element_line(colour = "black", linewidth = 0.4),
      axis.ticks.length = ggplot2::unit(if (ticks_inward) -tick else tick, "cm"),
      axis.text = ggplot2::element_text(colour = "black", size = ggplot2::rel(0.9)),
      axis.text.x = ggplot2::element_text(margin = ggplot2::margin(t = 0.5 * base_size)),
      axis.text.y = ggplot2::element_text(margin = ggplot2::margin(r = 0.5 * base_size)),
      axis.title = ggplot2::element_text(colour = "black"),
      plot.title = ggplot2::element_text(size = ggplot2::rel(1), face = "plain", hjust = 0),
      plot.title.position = "plot",
      panel.grid = ggplot2::element_blank(),
      legend.position = legend_position, legend.key = ggplot2::element_blank(),
      legend.background = ggplot2::element_blank(), legend.title = ggplot2::element_text(size = ggplot2::rel(0.9)),
      strip.background = ggplot2::element_blank(), strip.text = ggplot2::element_text(face = "plain"),
      plot.margin = ggplot2::margin(8, 14, 8, 8))
}

#' Save a figure (vector PDF by default)
#'
#' @description A wrapper of \code{\link[ggplot2]{ggsave}} with the defaults of the package: a vector PDF through
#' \code{\link[grDevices]{cairo_pdf}} (embedded fonts, correct glyphs), A4 landscape (11.69 x 8.27 inches) and 600
#' dpi for raster formats. The device follows the file extension for other formats (\code{.png}, \code{.svg},
#' \code{.tiff}, ...).
#' @param plot a \code{ggplot} object, for example the result of \code{plot()} on a DiallelAnalysisR result (default: the last
#'   plot).
#' @param filename file name; its extension chooses the format.
#' @param path directory to save in (default \code{NULL}: the working directory or the path in \code{filename}).
#' @param width,height size (default 11.69 x 8.27, A4 landscape, in \code{units}).
#' @param units \code{"in"} (default), \code{"cm"} or \code{"mm"}.
#' @param dpi resolution for raster formats (default 600).
#' @param scale multiplicative scaling factor (default 1).
#' @param device \code{NULL} (default: \code{cairo_pdf} for \code{.pdf}, otherwise chosen from the extension) or a
#'   device function or name, passed to \code{ggsave()}.
#' @param limitsize logical; refuse images larger than 50 x 50 inches (default \code{TRUE}).
#' @param ... passed to \code{\link[ggplot2]{ggsave}}.
#' @return The file name, invisibly.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @family DiallelAnalysisR utilities
#' @examples
#' library(ggplot2)
#' p <-
#'   ggplot(data = data.frame(x = 1:10, y = (1:10)^2), mapping = aes(x = x, y = y)) +
#'   geom_line() +
#'   da_theme(
#'       base_size       = 11
#'     , base_family     = "serif"
#'     , ticks_inward    = TRUE
#'     , legend_position = "bottom"
#'     )
#' f <- tempfile(fileext = ".pdf")
#' da_save(
#'     plot      = p
#'   , filename  = f
#'   , path      = NULL
#'   , width     = 11.69
#'   , height    = 8.27
#'   , units     = c("in", "cm", "mm")[1]
#'   , dpi       = 600
#'   , scale     = 1
#'   , device    = NULL
#'   , limitsize = TRUE
#'   )
#' da_save(
#'     plot      = p
#'   , filename  = basename(f)
#'   , path      = tempdir()
#'   , width     = 11.69
#'   , height    = 8.27
#'   , units     = c("in", "cm", "mm")[1]
#'   , dpi       = 600
#'   , scale     = 1
#'   , device    = grDevices::cairo_pdf
#'   , limitsize = TRUE
#'   )
#' da_save(
#'     plot      = p
#'   , filename  = tempfile(fileext = ".png")
#'   , path      = NULL
#'   , width     = 6
#'   , height    = 4
#'   , units     = c("in", "cm", "mm")[1]
#'   , dpi       = 300
#'   , scale     = 1
#'   , device    = NULL
#'   , limitsize = TRUE
#'   )
#' @export
da_save <- function(plot = ggplot2::last_plot(), filename, path = NULL, width = 11.69, height = 8.27,
                         units = c("in", "cm", "mm"), dpi = 600, scale = 1, device = NULL, limitsize = TRUE, ...) {
  units <- match.arg(units)
  if (is.null(device) && grepl("\\.pdf$", filename, ignore.case = TRUE)) device <- grDevices::cairo_pdf
  ggplot2::ggsave(filename = filename, plot = plot, device = device, path = path, scale = scale, width = width,
                  height = height, units = units, dpi = dpi, limitsize = limitsize, ...)
  invisible(filename)
}
