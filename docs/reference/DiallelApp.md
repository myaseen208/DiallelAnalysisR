# Interactive analysis in a web browser

`DiallelApp()` starts a Shiny application for the analyses of the
package: choose an example data set or upload a CSV file (one row per
plot), pick the analysis and its columns, and get the printed results,
the main tables, the plots, the tables for a paper (Word, LaTeX, HTML or
Markdown, through
[`da_export`](https://myaseen208.com/DiallelAnalysisR/reference/da_export.md))
and the R code that repeats the analysis.

## Usage

``` r
DiallelApp(launch.browser = interactive(), ...)
```

## Arguments

- launch.browser:

  passed to
  [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html): `TRUE`
  (default in an interactive session) opens the application in the web
  browser.

- ...:

  further arguments to
  [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html), such
  as `port`.

## Value

Called for its side effect; returns the value of
[`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html) when the
application is closed.

## Details

The application needs the packages shiny and bslib (and officer and
flextable for Word tables). It covers
[`Griffing`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md),
[`GriffingEnv`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingEnv.md),
[`Heterosis`](https://myaseen208.com/DiallelAnalysisR/reference/Heterosis.md),
[`Hayman`](https://myaseen208.com/DiallelAnalysisR/reference/Hayman.md),
[`GardnerEberhart`](https://myaseen208.com/DiallelAnalysisR/reference/GardnerEberhart.md),
[`PartialDiallel`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallel.md),
[`LineTester`](https://myaseen208.com/DiallelAnalysisR/reference/LineTester.md)
and
[`NCDesign`](https://myaseen208.com/DiallelAnalysisR/reference/NCDesign.md).

## See also

[`da_export`](https://myaseen208.com/DiallelAnalysisR/reference/da_export.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
if (interactive()) {
  DiallelApp(
      launch.browser = TRUE
    )
}
```
