# Notation of DiallelAnalysisR

The symbols used in the help pages and vignettes of DiallelAnalysisR,
with their meaning and the argument or result component that holds them.
The notation follows one rule throughout: scalars are upper-case letters
in normal face (\\P\\, \\R\\), indices lower-case italic (\\i, j\\),
vectors lower-case bold (\\\mathbf{y}\\, \\\boldsymbol{\beta}\\) and
matrices upper-case bold (\\\mathbf{X}\\, \\\boldsymbol{\Sigma}\\).

## Usage

``` r
da_notation(format = c("table", "path", "tex"))
```

## Arguments

- format:

  `"table"` (default: a `data.table` with columns `symbol` (LaTeX),
  `text` (plain text), `kind` (scalar, index, vector, matrix, set,
  function, operator), `meaning` and `argument`), `"path"` (the path of
  `notation.csv`) or `"tex"` (the path of `Notations.tex`, the notation
  appendix used in the articles).

## Value

See `format`.

## See also

Other DiallelAnalysisR utilities:
[`da_export()`](https://myaseen208.com/DiallelAnalysisR/reference/da_export.md),
[`da_reference()`](https://myaseen208.com/DiallelAnalysisR/reference/da_reference.md),
[`da_save()`](https://myaseen208.com/DiallelAnalysisR/reference/da_save.md),
[`da_theme()`](https://myaseen208.com/DiallelAnalysisR/reference/da_theme.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
da_notation(
    format = c("table", "path", "tex")[1]
  )
#>                                          symbol                          text
#>                                          <char>                        <char>
#>  1:                                           P                             P
#>  2:                                           B                             B
#>  3:                                  i, j, k, l                       i j k l
#>  4:                                 \\mathbf{Y}                             Y
#>  5:                                      Y_{ij}                          Y_ij
#>  6: Y_{i\\cdot}, Y_{\\cdot j}, Y_{\\cdot\\cdot}                Y_i. Y_.j Y_..
#>  7:                                 \\mathbf{T}                             T
#>  8:                                        \\mu                            mu
#>  9:                            \\mathbf{g}, g_i                         g g_i
#> 10:                         \\mathbf{S}, S_{ij}                        S S_ij
#> 11:                         \\mathbf{R}, R_{ij}                        R R_ij
#> 12:                                   MS_E, f_E                      MS_E f_E
#> 13:                                 \\sigma^2_m                     sigma^2_m
#> 14:                            SS_g, SS_s, SS_r                SS_g SS_s SS_r
#> 15:       \\sigma^2_g, \\sigma^2_s, \\sigma^2_r sigma^2_g sigma^2_s sigma^2_r
#> 16:                    \\sigma^2_A, \\sigma^2_D           sigma^2_A sigma^2_D
#> 17:                                    V_r, W_r                         Vr Wr
#> 18:         V_{0L0}, V_{1L1}, V_{0L1}, W_{0L01}          V0L0 V1L1 V0L1 W0L01
#> 19:                      D, H_1, H_2, F, h^2, E                D H1 H2 F h2 E
#> 20:                                        L, M                           L M
#> 21:           \\mathbf{g}^{I}, \\mathbf{g}^{II}                        gI gII
#>                                          symbol                          text
#>                                          <char>                        <char>
#>        kind
#>      <char>
#>  1:  scalar
#>  2:  scalar
#>  3:   index
#>  4:  matrix
#>  5: element
#>  6:  scalar
#>  7:  matrix
#>  8:  scalar
#>  9:  vector
#> 10:  matrix
#> 11:  matrix
#> 12:  scalar
#> 13:  scalar
#> 14:  scalar
#> 15:  scalar
#> 16:  scalar
#> 17:  scalar
#> 18:  scalar
#> 19:  scalar
#> 20:  scalar
#> 21:  vector
#>        kind
#>      <char>
#>                                                                      meaning
#>                                                                       <char>
#>  1:                                                        number of parents
#>  2:                                            number of replicates (blocks)
#>  3:                              parents; i female (Cross1), j male (Cross2)
#>  4:                      P x P matrix of cell means (female parents in rows)
#>  5:                                                      mean of cross i x j
#>  6:                           row, column and grand totals of the cell means
#>  7:                                     cell totals over replicates (Hayman)
#>  8:                                                             general mean
#>  9:                                  general combining ability (gca) effects
#> 10:                      specific combining ability (sca) effects, symmetric
#> 11:                                         reciprocal effects, R_ij = -R_ji
#> 12:       error mean square of the block analysis and its degrees of freedom
#> 13:                                  error variance of a cell mean, MS_E / B
#> 14:                       sums of squares of gca, sca and reciprocal effects
#> 15:              variances of gca, sca and reciprocal effects (random model)
#> 16:                                         additive and dominance variances
#> 17:         variance of array r and its covariance with the parents (Hayman)
#> 18: variance of the parents, mean of Vr, variance of array means, mean of Wr
#> 19:                                         Hayman's components of variation
#> 20:                numbers of parents in the two groups of a partial diallel
#> 21:                          gca effects of the two groups (partial diallel)
#>                                                                      meaning
#>                                                                       <char>
#>                    argument
#>                      <char>
#>  1:                        
#>  2:                        
#>  3:          Cross1, Cross2
#>  4:                   Means
#>  5:                   Means
#>  6:                        
#>  7:                        
#>  8:                        
#>  9:                     GCA
#> 10:                     SCA
#> 11:              Reciprocal
#> 12:                    RCBD
#> 13:      ANOVA (line Error)
#> 14:                   ANOVA
#> 15:      Genetic.Components
#> 16:      Genetic.Components
#> 17:             Wr.Vr.Table
#> 18:                    VOLO
#> 19: Components.of.Variation
#> 20:                        
#> 21:                 General
#>                    argument
#>                      <char>
```
