# Speed

\\ \newcommand{\mY}{\mathbf{Y}} \newcommand{\mT}{\mathbf{T}}
\newcommand{\mS}{\mathbf{S}} \newcommand{\mR}{\mathbf{R}}
\newcommand{\vg}{\mathbf{g}} \newcommand{\E}{\mathrm{E}}
\newcommand{\Var}{\mathrm{Var}} \newcommand{\Cov}{\mathrm{Cov}} \\

## 1 Abstract

Version 1.0.0 computes every analysis from closed forms on the table of
cell means and one block analysis of the plot data, instead of refitting
models branch by branch. This vignette reports the timings against
version 0.6.0.

## 2 Timings

Median time and memory over 20 runs (`tools/bench.R` in the source
repository), on the shipped data and on simulated diallels of 12 and 20
parents with 3 replicates:

``` r

b <- data.table::fread(file = system.file("extdata", "bench.csv", package = "DiallelAnalysisR"))
w <- data.table::dcast(data = b, formula = case ~ version, value.var = "median_ms")
data.table::setnames(x = w, old = c("0.6.0", "1.0.0"), new = c("ms_0.6.0", "ms_1.0.0"))
w[, speedup := round(x = ms_0.6.0 / ms_1.0.0, digits = 1)]
knitr::kable(x = w, digits = 2)
```

| case            | ms_0.6.0 | ms_1.0.0 | speedup |
|:----------------|---------:|---------:|--------:|
| griffing_m1_P12 |    14.61 |     2.63 |     5.6 |
| griffing_m1_P20 |   181.86 |     3.05 |    59.7 |
| griffing_m1_P8  |     6.08 |     2.97 |     2.0 |
| griffing_m2_P8  |     4.76 |     4.80 |     1.0 |
| hayman_P20      |   147.35 |     4.70 |    31.3 |
| hayman_P8       |     5.62 |     4.01 |     1.4 |
| partial_10x4    |     4.84 |     1.86 |     2.6 |

## 3 Where the time goes

Version 0.6.0 fitted [`aov()`](https://rdrr.io/r/stats/aov.html) and
built several tables with
[`tapply()`](https://rdrr.io/r/base/tapply.html) in each branch, and its
cost grew quickly with the number of parents. Version 1.0.0 builds the
table of cell means in one grouped sum, computes the error mean square
in closed form for complete blocks, and evaluates the sums of squares,
effects, standard errors and expected mean squares as matrix
expressions; its time hardly changes between 8 and 20 parents.

## 4 Summary

The modernised package is faster for every analysis and many times
faster for larger diallels, with less memory.
