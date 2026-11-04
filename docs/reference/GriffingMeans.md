# Griffing's analysis from a table of cross means

`GriffingMeans()` performs Griffing's (1956) combining-ability analysis
when only the cross means and the error mean square are available, as in
published examples: the cross means come from `data` (one row per cross)
and the error from the experiment's analysis of variance. The analysis
is that of
[`Griffing`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md).

## Usage

``` r
GriffingMeans(y, Cross1, Cross2, data, Method, Model, ErrorMS, ErrorDf)
```

## Arguments

- y:

  column of `data` with the cross means (bare name, string or vector).

- Cross1, Cross2:

  columns of `data` with the two parents of each cross.

- data:

  a data frame with one row per cross (and per parent in Methods 1 and
  2).

- Method, Model:

  as in
  [`Griffing`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md).

- ErrorMS:

  error mean square on the basis of a cross mean (see Details).

- ErrorDf:

  degrees of freedom of `ErrorMS`.

## Value

An object of class `c("da_griffing", "da_result", "list")` with the
components of
[`Griffing`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md)
except `RCBD` (there are no plot data).

## Details

**Error.** `ErrorMS` is the error mean square on the basis of a cross
mean, Griffing's \\M'\_e = M_e/(bc)\\ for \\b\\ blocks and \\c\\ plants
per plot: for Model 1 the within-plot (or plot) error divided by the
number of observations per mean, for Model 2 the variety by block mean
square divided by the same number (Griffing 1956, Tables 8 and 12).
`ErrorDf` is its degrees of freedom. All other quantities, formulas and
components are as documented in
[`Griffing`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md).

## References

Griffing, B. (1956). Concept of general and specific combining ability
in relation to diallel crossing systems. *Australian Journal of
Biological Sciences*, **9**(4), 463–493.
[doi:10.1071/BI9560463](https://doi.org/10.1071/BI9560463)

## See also

[`Griffing`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md),
[`Griffing56`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing56.md)

Other DiallelAnalysisR analyses:
[`GardnerEberhart()`](https://myaseen208.com/DiallelAnalysisR/reference/GardnerEberhart.md),
[`Griffing()`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md),
[`GriffingEnv()`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingEnv.md),
[`Hayman()`](https://myaseen208.com/DiallelAnalysisR/reference/Hayman.md),
[`Heterosis()`](https://myaseen208.com/DiallelAnalysisR/reference/Heterosis.md),
[`LineTester()`](https://myaseen208.com/DiallelAnalysisR/reference/LineTester.md),
[`NCDesign()`](https://myaseen208.com/DiallelAnalysisR/reference/NCDesign.md),
[`PartialDiallel()`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallel.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
#-------------------------------------------------------------
## Griffing's (1956) example: Method 4, Model 1, total yield
#-------------------------------------------------------------
g56 <-
  GriffingMeans(
      y       = TotalYield
    , Cross1  = Cross1
    , Cross2  = Cross2
    , data    = Griffing56
    , Method  = 4
    , Model   = 1
    , ErrorMS = 1642.48 / 78
    , ErrorDf = 2558
    )
g56$ANOVA
#>         Df Sum Sq Mean Sq F value    Pr(>F)    
#> gca      8  18606 2325.75  110.45 < 2.2e-16 ***
#> sca     27   9165  339.44   16.12 < 2.2e-16 ***
#> Error 2558  53865   21.06                      
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
round(x = g56$GCA, digits = 2)
#>      1      2      3      4      5      6      7      8      9 
#>   9.35 -20.65 -10.16 -22.55  -1.51  -1.89  28.12  -6.93  26.22 

#-------------------------------------------------------------
## The same data with Model 2 (variety x block error)
#-------------------------------------------------------------
g56r <-
  GriffingMeans(
      y       = TotalYield
    , Cross1  = Cross1
    , Cross2  = Cross2
    , data    = Griffing56
    , Method  = 4
    , Model   = 2
    , ErrorMS = 11803.61 / 78
    , ErrorDf = 175
    )
g56r$Genetic.Components
#>          Components
#> gca      283.758320
#> sca      188.110608
#> Error    151.328333
#> Additive 567.516640
#> Dominant 188.110608
#> gca/sca    1.508465
```
