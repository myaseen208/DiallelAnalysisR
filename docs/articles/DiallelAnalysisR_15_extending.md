# Extending the package

\\ \newcommand{\mY}{\mathbf{Y}} \newcommand{\mT}{\mathbf{T}}
\newcommand{\mS}{\mathbf{S}} \newcommand{\mR}{\mathbf{R}}
\newcommand{\vg}{\mathbf{g}} \newcommand{\E}{\mathrm{E}}
\newcommand{\Var}{\mathrm{Var}} \newcommand{\Cov}{\mathrm{Cov}} \\

## 1 Abstract

How a new analysis is added to DiallelAnalysisR so that it fits the rest
of the package: a computational core, an exported function, a result
with methods, a help page, tests and a vignette section.

## 2 The parts of an analysis

1.  **Core**: an internal function `.da_<analysis>_core()` that takes
    the table of cell means (or the plot data) and returns the named
    list of results; no printing, no options.
2.  **Exported function**: checks the arguments (`.da_check_data()`,
    `.da_column()` for column arguments, `.da_check_number()` for
    codes), calls the core, and wraps the result with `.da_result()`,
    which adds the class `c("da_<analysis>", "da_result", "list")`.
3.  **Plot**: an internal `.da_plot_<analysis>()`;
    [`plot()`](https://rdrr.io/r/graphics/plot.default.html) finds it by
    the class.
4.  **Help page**: the model and every formula in LaTeX, every argument,
    every component of the result, references, examples with every
    argument written out.
5.  **Tests**: closed forms against an independent calculation; input
    errors; methods.
6.  **Vignette**: a section or a vignette in this series.

## 3 Building blocks available

``` r

cd <- DiallelAnalysisR:::.da_cell_data(
    y      = GriffingData1$Yield
  , p1     = GriffingData1$Cross1
  , p2     = GriffingData1$Cross2
  , rep    = GriffingData1$Rep
  , method = 1L
  , fn     = "example"
  )
names(cd)
```

     [1] "M"        "parents"  "R"        "mse"      "df_e"     "ss_e"
     [7] "anova"    "n_plots"  "cells"    "balanced" "plots"   

``` r

round(x = cd$M[1:3, 1:3], digits = 2)
```

           1      2      3
    1  85.65  87.01  90.46
    2  80.69  98.26 111.58
    3 102.23 104.56  74.07

``` r

cd$anova
```

               Df     Sum Sq   Mean Sq
    Rep         3   1036.192  345.3972
    Crosses    63 104923.873 1665.4583
    Residuals 189  21755.963  115.1109

`.da_cell_data()` gives the table of cell means, the error mean square
and its degrees of freedom for any of Griffing’s layouts; a new analysis
starts from it.

## 4 Example: heterosis over the mid-parent

The heterosis of
[`Heterosis()`](https://myaseen208.com/DiallelAnalysisR/reference/Heterosis.md)
was built from these blocks. Its first step, by hand:

``` r

cd2 <- DiallelAnalysisR:::.da_cell_data(
    y      = GriffingData2$Yield
  , p1     = GriffingData2$Cross1
  , p2     = GriffingData2$Cross2
  , rep    = GriffingData2$Rep
  , method = 2L
  , fn     = "example"
  )
M <- cd2$M
mid <- outer(X = diag(M), Y = diag(M), FUN = "+") / 2
het <- 100 * (M - mid) / mid
diag(het) <- NA
round(x = het[1:4, 1:4], digits = 1)
```

       1    2    3    4
    1 NA -5.4 13.3 29.7
    2 NA   NA 29.5 -7.1
    3 NA   NA   NA 21.5
    4 NA   NA   NA   NA

The exported function adds the argument checks, the better-parent and
standard heterosis, the \\t\\ tests with the standard error of each
difference from \\MS_E\\, a classed result, a plot method, tables for
[`da_export()`](https://myaseen208.com/DiallelAnalysisR/reference/da_export.md)
and tests:

``` r

h <-
  Heterosis(
      y      = Yield
    , Rep    = Rep
    , Cross1 = Cross1
    , Cross2 = Cross2
    , data   = GriffingData2
    , Check  = NULL
    , Better = c("higher", "lower")[1]
    )
all.equal(target = h$Heterosis$MP[1:3], current = het[1, 2:4], check.attributes = FALSE)
```

    [1] TRUE

## 5 Summary

Every analysis of the package follows the same pattern; a new one reuses
the cell-means table, the error mean square, the result class, the plot
theme and the test helpers.
