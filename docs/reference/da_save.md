# Save a figure (vector PDF by default)

A wrapper of
[`ggsave`](https://ggplot2.tidyverse.org/reference/ggsave.html) with the
defaults of the package: a vector PDF through
[`cairo_pdf`](https://rdrr.io/r/grDevices/cairo.html) (embedded fonts,
correct glyphs), A4 landscape (11.69 x 8.27 inches) and 600 dpi for
raster formats. The device follows the file extension for other formats
(`.png`, `.svg`, `.tiff`, ...).

## Usage

``` r
da_save(
  plot = ggplot2::last_plot(),
  filename,
  path = NULL,
  width = 11.69,
  height = 8.27,
  units = c("in", "cm", "mm"),
  dpi = 600,
  scale = 1,
  device = NULL,
  limitsize = TRUE,
  ...
)
```

## Arguments

- plot:

  a `ggplot` object, for example the result of
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html) on a
  DiallelAnalysisR result (default: the last plot).

- filename:

  file name; its extension chooses the format.

- path:

  directory to save in (default `NULL`: the working directory or the
  path in `filename`).

- width, height:

  size (default 11.69 x 8.27, A4 landscape, in `units`).

- units:

  `"in"` (default), `"cm"` or `"mm"`.

- dpi:

  resolution for raster formats (default 600).

- scale:

  multiplicative scaling factor (default 1).

- device:

  `NULL` (default: `cairo_pdf` for `.pdf`, otherwise chosen from the
  extension) or a device function or name, passed to
  [`ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html).

- limitsize:

  logical; refuse images larger than 50 x 50 inches (default `TRUE`).

- ...:

  passed to
  [`ggsave`](https://ggplot2.tidyverse.org/reference/ggsave.html).

## Value

The file name, invisibly.

## See also

Other DiallelAnalysisR utilities:
[`da_export()`](https://myaseen208.com/DiallelAnalysisR/reference/da_export.md),
[`da_notation()`](https://myaseen208.com/DiallelAnalysisR/reference/da_notation.md),
[`da_reference()`](https://myaseen208.com/DiallelAnalysisR/reference/da_reference.md),
[`da_theme()`](https://myaseen208.com/DiallelAnalysisR/reference/da_theme.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
library(ggplot2)
p <-
  ggplot(data = data.frame(x = 1:10, y = (1:10)^2), mapping = aes(x = x, y = y)) +
  geom_line() +
  da_theme(
      base_size       = 11
    , base_family     = "serif"
    , ticks_inward    = TRUE
    , legend_position = "bottom"
    )
f <- tempfile(fileext = ".pdf")
da_save(
    plot      = p
  , filename  = f
  , path      = NULL
  , width     = 11.69
  , height    = 8.27
  , units     = c("in", "cm", "mm")[1]
  , dpi       = 600
  , scale     = 1
  , device    = NULL
  , limitsize = TRUE
  )
da_save(
    plot      = p
  , filename  = basename(f)
  , path      = tempdir()
  , width     = 11.69
  , height    = 8.27
  , units     = c("in", "cm", "mm")[1]
  , dpi       = 600
  , scale     = 1
  , device    = grDevices::cairo_pdf
  , limitsize = TRUE
  )
da_save(
    plot      = p
  , filename  = tempfile(fileext = ".png")
  , path      = NULL
  , width     = 6
  , height    = 4
  , units     = c("in", "cm", "mm")[1]
  , dpi       = 300
  , scale     = 1
  , device    = NULL
  , limitsize = TRUE
  )
```
