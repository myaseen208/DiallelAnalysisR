# Export the tables of an analysis for a report or a paper

`da_export()` writes the main tables of a result of this package (the
analysis of variance, the components, the effects with their standard
errors and tests, and so on) to a Word document, a LaTeX file of
`booktabs` tables, an HTML page, a Markdown file or CSV files, with
numbers rounded for print.

## Usage

``` r
da_export(
  x,
  file,
  format = c("docx", "latex", "html", "markdown", "csv"),
  tables = NULL,
  digits = 3,
  title = NULL
)

da_tables(x, digits = 3)
```

## Arguments

- x:

  a result of
  [`Griffing`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md),
  [`GriffingMeans`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingMeans.md),
  [`Hayman`](https://myaseen208.com/DiallelAnalysisR/reference/Hayman.md),
  [`PartialDiallel`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallel.md)
  or another analysis of the package.

- file:

  path of the file to write (its extension does not choose the format;
  `format` does).

- format:

  `"docx"` (Word), `"latex"`, `"html"`, `"markdown"` or `"csv"`.

- tables:

  names of the tables to write (default all; see `names(da_tables(x))`).

- digits:

  decimals of the printed numbers (default 3).

- title:

  title written above the tables (default: the label of the analysis).

## Value

`da_export()`: the path(s) of the file(s) written, invisibly.
`da_tables()`: a named list of data frames.

## Details

`da_tables()` returns the tables that `da_export()` writes, as a named
list of data frames, so that they can be edited first. Numbers are
rounded to `digits` decimals; p-values are printed with three decimals
and as `<0.001` below 0.001. Word documents need the packages officer
and flextable; the other formats need nothing beyond base R. For LaTeX,
the file holds one `table` environment per table and needs
`\usepackage{booktabs}` in the preamble. For CSV, each table goes to its
own file, named after `file` with the table name appended.

## See also

Other DiallelAnalysisR utilities:
[`da_notation()`](https://myaseen208.com/DiallelAnalysisR/reference/da_notation.md),
[`da_reference()`](https://myaseen208.com/DiallelAnalysisR/reference/da_reference.md),
[`da_save()`](https://myaseen208.com/DiallelAnalysisR/reference/da_save.md),
[`da_theme()`](https://myaseen208.com/DiallelAnalysisR/reference/da_theme.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
fit <-
  Griffing(
      y          = Yield
    , Rep        = Rep
    , Cross1     = Cross1
    , Cross2     = Cross2
    , data       = GriffingData1
    , Method     = 1
    , Model      = 1
    , Reciprocal = c("combined", "split")[1]
    )
names(da_tables(x = fit, digits = 3))
#> [1] "Analysis of variance"               "Components"                        
#> [3] "General combining ability effects"  "Specific combining ability effects"
#> [5] "Reciprocal effects"                 "Standard errors"                   
f <- tempfile(fileext = ".tex")
da_export(
    x      = fit
  , file   = f
  , format = c("docx", "latex", "html", "markdown", "csv")[2]
  , tables = NULL
  , digits = 3
  , title  = NULL
  )
cat(readLines(f)[1:12], sep = "\n")
#> % Griffing's Method 1, Model 1 (fixed effects); 8 parents, 4 replicates
#> % tables written by DiallelAnalysisR::da_export(); needs \usepackage{booktabs}
#> 
#> \begin{table}[htbp]
#> \centering
#> \caption{Analysis of variance}
#> \begin{tabular}{lrrrrr}
#> \toprule
#> Source & Df & Sum Sq & Mean Sq & F value & Pr(>F) \\
#> \midrule
#> gca & 7 & 3804.643 & 543.520 & 18.887 & $<$0.001 \\
#> sca & 28 & 22060.789 & 787.885 & 27.378 & $<$0.001 \\
```
