# Published values used by the tests and vignettes

Reads `inst/extdata/reference.csv`: one row per published number, with
its source, the R call that recomputes it with this package (`call`),
the expression that extracts the number from the result (`extract`, in
terms of `x`), the printed value and the digits to compare. The same
file drives the test of published values and the vignette that
reproduces the published examples. Each distinct `call` is evaluated
once.

## Usage

``` r
da_reference(source = NULL, evaluate = FALSE, level = 1)
```

## Arguments

- source:

  optional regular expression; keep rows whose `source` matches.

- evaluate:

  logical; evaluate the rows and add columns `computed` and `agrees`
  (default `FALSE`).

- level:

  largest `level` evaluated (1 = fast rows, 2 = slow rows; default 1);
  rows above it get `NA`.

## Value

A `data.table` with columns `id`, `source`, `quantity`, `call`,
`extract`, `value`, `digits`, `level`, `note` (and `computed`,
`agrees`).

## See also

Other DiallelAnalysisR utilities:
[`da_export()`](https://myaseen208.com/DiallelAnalysisR/reference/da_export.md),
[`da_notation()`](https://myaseen208.com/DiallelAnalysisR/reference/da_notation.md),
[`da_save()`](https://myaseen208.com/DiallelAnalysisR/reference/da_save.md),
[`da_theme()`](https://myaseen208.com/DiallelAnalysisR/reference/da_theme.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
ref <-
  da_reference(
      source   = NULL
    , evaluate = FALSE
    , level    = 1
    )
ref
#>                  id                    source                     quantity
#>              <char>                    <char>                       <char>
#>  1:   g56_X1_ms_gca  Griffing (1956), Table 8 X1 mean square gca (Model I)
#>  2:   g56_X1_ms_sca  Griffing (1956), Table 8 X1 mean square sca (Model I)
#>  3: g56_X1_comp_gca  Griffing (1956), Table 8   X1 gca component (Model I)
#>  4: g56_X1_comp_sca  Griffing (1956), Table 8   X1 sca component (Model I)
#>  5:       g56_X1_g1  Griffing (1956), Table 9    X1 gca effect of parent 1
#>  6:       g56_X1_g2  Griffing (1956), Table 9    X1 gca effect of parent 2
#>  7:       g56_X1_g3  Griffing (1956), Table 9    X1 gca effect of parent 3
#>  8:       g56_X1_g4  Griffing (1956), Table 9    X1 gca effect of parent 4
#>  9:       g56_X1_g5  Griffing (1956), Table 9    X1 gca effect of parent 5
#> 10:       g56_X1_g6  Griffing (1956), Table 9    X1 gca effect of parent 6
#> 11:       g56_X1_g7  Griffing (1956), Table 9    X1 gca effect of parent 7
#> 12:       g56_X1_g8  Griffing (1956), Table 9    X1 gca effect of parent 8
#> 13:       g56_X1_g9  Griffing (1956), Table 9    X1 gca effect of parent 9
#> 14:    g56_X1_se_gg  Griffing (1956), Table 9             X1 SE(g_i - g_j)
#> 15:   g56_X1_se_sik Griffing (1956), Table 10           X1 SE(s_ij - s_ik)
#> 16:   g56_X1_se_skl Griffing (1956), Table 10           X1 SE(s_ij - s_kl)
#> 17:      g56_X1_s12 Griffing (1956), Table 10 X1 sca effect of cross 1 x 2
#> 18:      g56_X1_s13 Griffing (1956), Table 10 X1 sca effect of cross 1 x 3
#> 19:      g56_X1_s19 Griffing (1956), Table 10 X1 sca effect of cross 1 x 9
#> 20:      g56_X1_s29 Griffing (1956), Table 10 X1 sca effect of cross 2 x 9
#> 21:      g56_X1_s34 Griffing (1956), Table 10 X1 sca effect of cross 3 x 4
#> 22:      g56_X1_s49 Griffing (1956), Table 10 X1 sca effect of cross 4 x 9
#> 23:      g56_X1_s56 Griffing (1956), Table 10 X1 sca effect of cross 5 x 6
#> 24:      g56_X1_s68 Griffing (1956), Table 10 X1 sca effect of cross 6 x 8
#> 25:      g56_X1_s89 Griffing (1956), Table 10 X1 sca effect of cross 8 x 9
#> 26:   g56_X1_m2_2sg Griffing (1956), Table 13    X1 2 sigma^2_g (Model II)
#> 27:    g56_X1_m2_ss Griffing (1956), Table 13      X1 sigma^2_s (Model II)
#> 28:   g56_X2_ms_gca  Griffing (1956), Table 8 X2 mean square gca (Model I)
#> 29:   g56_X2_ms_sca  Griffing (1956), Table 8 X2 mean square sca (Model I)
#> 30: g56_X2_comp_gca  Griffing (1956), Table 8   X2 gca component (Model I)
#> 31: g56_X2_comp_sca  Griffing (1956), Table 8   X2 sca component (Model I)
#> 32:       g56_X2_g1  Griffing (1956), Table 9    X2 gca effect of parent 1
#> 33:       g56_X2_g2  Griffing (1956), Table 9    X2 gca effect of parent 2
#> 34:       g56_X2_g3  Griffing (1956), Table 9    X2 gca effect of parent 3
#> 35:       g56_X2_g4  Griffing (1956), Table 9    X2 gca effect of parent 4
#> 36:       g56_X2_g5  Griffing (1956), Table 9    X2 gca effect of parent 5
#> 37:       g56_X2_g6  Griffing (1956), Table 9    X2 gca effect of parent 6
#> 38:       g56_X2_g7  Griffing (1956), Table 9    X2 gca effect of parent 7
#> 39:       g56_X2_g8  Griffing (1956), Table 9    X2 gca effect of parent 8
#> 40:       g56_X2_g9  Griffing (1956), Table 9    X2 gca effect of parent 9
#> 41:    g56_X2_se_gg  Griffing (1956), Table 9             X2 SE(g_i - g_j)
#> 42:   g56_X2_se_sik Griffing (1956), Table 10           X2 SE(s_ij - s_ik)
#> 43:   g56_X2_se_skl Griffing (1956), Table 10           X2 SE(s_ij - s_kl)
#> 44:      g56_X2_s12 Griffing (1956), Table 10 X2 sca effect of cross 1 x 2
#> 45:      g56_X2_s13 Griffing (1956), Table 10 X2 sca effect of cross 1 x 3
#> 46:      g56_X2_s29 Griffing (1956), Table 10 X2 sca effect of cross 2 x 9
#> 47:      g56_X2_s34 Griffing (1956), Table 10 X2 sca effect of cross 3 x 4
#> 48:      g56_X2_s49 Griffing (1956), Table 10 X2 sca effect of cross 4 x 9
#> 49:      g56_X2_s56 Griffing (1956), Table 10 X2 sca effect of cross 5 x 6
#> 50:      g56_X2_s68 Griffing (1956), Table 10 X2 sca effect of cross 6 x 8
#> 51:   g56_X2_m2_2sg Griffing (1956), Table 13    X2 2 sigma^2_g (Model II)
#> 52:    g56_X2_m2_ss Griffing (1956), Table 13      X2 sigma^2_s (Model II)
#> 53:   g56_X3_ms_gca  Griffing (1956), Table 8 X3 mean square gca (Model I)
#> 54:   g56_X3_ms_sca  Griffing (1956), Table 8 X3 mean square sca (Model I)
#> 55: g56_X3_comp_gca  Griffing (1956), Table 8   X3 gca component (Model I)
#> 56: g56_X3_comp_sca  Griffing (1956), Table 8   X3 sca component (Model I)
#> 57:       g56_X3_g1  Griffing (1956), Table 9    X3 gca effect of parent 1
#> 58:       g56_X3_g2  Griffing (1956), Table 9    X3 gca effect of parent 2
#> 59:       g56_X3_g3  Griffing (1956), Table 9    X3 gca effect of parent 3
#> 60:       g56_X3_g4  Griffing (1956), Table 9    X3 gca effect of parent 4
#> 61:       g56_X3_g5  Griffing (1956), Table 9    X3 gca effect of parent 5
#> 62:       g56_X3_g6  Griffing (1956), Table 9    X3 gca effect of parent 6
#> 63:       g56_X3_g7  Griffing (1956), Table 9    X3 gca effect of parent 7
#> 64:       g56_X3_g8  Griffing (1956), Table 9    X3 gca effect of parent 8
#> 65:       g56_X3_g9  Griffing (1956), Table 9    X3 gca effect of parent 9
#> 66:    g56_X3_se_gg  Griffing (1956), Table 9             X3 SE(g_i - g_j)
#> 67:   g56_X3_se_sik Griffing (1956), Table 10           X3 SE(s_ij - s_ik)
#> 68:   g56_X3_se_skl Griffing (1956), Table 10           X3 SE(s_ij - s_kl)
#> 69:      g56_X3_s12 Griffing (1956), Table 10 X3 sca effect of cross 1 x 2
#> 70:      g56_X3_s13 Griffing (1956), Table 10 X3 sca effect of cross 1 x 3
#> 71:      g56_X3_s29 Griffing (1956), Table 10 X3 sca effect of cross 2 x 9
#> 72:      g56_X3_s34 Griffing (1956), Table 10 X3 sca effect of cross 3 x 4
#> 73:      g56_X3_s49 Griffing (1956), Table 10 X3 sca effect of cross 4 x 9
#> 74:      g56_X3_s56 Griffing (1956), Table 10 X3 sca effect of cross 5 x 6
#> 75:      g56_X3_s68 Griffing (1956), Table 10 X3 sca effect of cross 6 x 8
#> 76:   g56_X3_m2_2sg Griffing (1956), Table 13    X3 2 sigma^2_g (Model II)
#> 77:    g56_X3_m2_ss Griffing (1956), Table 13      X3 sigma^2_s (Model II)
#>                  id                    source                     quantity
#>              <char>                    <char>                       <char>
#>                                                                                                                                                   call
#>                                                                                                                                                 <char>
#>  1:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#>  2:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#>  3:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#>  4:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#>  5:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#>  6:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#>  7:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#>  8:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#>  9:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 10:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 11:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 12:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 13:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 14:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 15:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 16:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 17:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 18:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 19:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 20:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 21:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 22:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 23:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 24:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 25:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 26:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 2, ErrorMS = 11803.61 / 78, ErrorDf = 175)
#> 27:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 2, ErrorMS = 11803.61 / 78, ErrorDf = 175)
#> 28:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 29:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 30:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 31:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 32:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 33:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 34:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 35:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 36:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 37:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 38:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 39:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 40:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 41:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 42:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 43:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 44:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 45:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 46:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 47:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 48:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 49:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 50:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 51:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 2, ErrorMS = 235.82 / 78, ErrorDf = 175)
#> 52:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 2, ErrorMS = 235.82 / 78, ErrorDf = 175)
#> 53: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 54: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 55: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 56: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 57: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 58: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 59: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 60: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 61: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 62: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 63: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 64: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 65: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 66: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 67: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 68: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 69: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 70: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 71: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 72: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 73: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 74: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 75: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 76:  GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 2, ErrorMS = 9056.45 / 78, ErrorDf = 175)
#> 77:  GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 2, ErrorMS = 9056.45 / 78, ErrorDf = 175)
#>                                                                                                                                                   call
#>                                                                                                                                                 <char>
#>                                            extract   value digits level
#>                                             <char>   <num>  <int> <int>
#>  1:                      x$ANOVA['gca', 'Mean Sq'] 2325.74      2     1
#>  2:                      x$ANOVA['sca', 'Mean Sq']  339.44      2     1
#>  3:      x$Genetic.Components['gca', 'Components']  329.24      2     1
#>  4:      x$Genetic.Components['sca', 'Components']  318.39      2     1
#>  5:                                   x$GCA[['1']]    9.35      2     1
#>  6:                                   x$GCA[['2']]  -20.65      2     1
#>  7:                                   x$GCA[['3']]  -10.16      2     1
#>  8:                                   x$GCA[['4']]  -22.55      2     1
#>  9:                                   x$GCA[['5']]   -1.51      2     1
#> 10:                                   x$GCA[['6']]   -1.89      2     1
#> 11:                                   x$GCA[['7']]   28.12      2     1
#> 12:                                   x$GCA[['8']]   -6.93      2     1
#> 13:                                   x$GCA[['9']]   26.22      2     1
#> 14:                            x$StdErr[['gi_gj']]    2.45      2     1
#> 15:                          x$StdErr[['sij_sik']]    6.01      2     1
#> 16:                          x$StdErr[['sij_skl']]    5.48      2     1
#> 17:                                x$SCA['1', '2']    4.94      2     1
#> 18:                                x$SCA['1', '3']   14.46      2     1
#> 19:                                x$SCA['1', '9']   18.47      2     1
#> 20:                                x$SCA['2', '9']  -37.73      2     1
#> 21:                                x$SCA['3', '4']  -29.94      2     1
#> 22:                                x$SCA['4', '9']   30.97      2     1
#> 23:                                x$SCA['5', '6']  -36.16      2     1
#> 24:                                x$SCA['6', '8']   32.77      2     1
#> 25:                                x$SCA['8', '9']   -5.85      2     1
#> 26: x$Genetic.Components['Additive', 'Components']  567.52      2     1
#> 27:      x$Genetic.Components['sca', 'Components']  188.11      2     1
#> 28:                      x$ANOVA['gca', 'Mean Sq']   90.98      2     1
#> 29:                      x$ANOVA['sca', 'Mean Sq']    6.99      2     1
#> 30:      x$Genetic.Components['gca', 'Components']   12.91      2     1
#> 31:      x$Genetic.Components['sca', 'Components']    6.39      2     1
#> 32:                                   x$GCA[['1']]    0.27      2     1
#> 33:                                   x$GCA[['2']]   -5.48      2     1
#> 34:                                   x$GCA[['3']]   -3.96      2     1
#> 35:                                   x$GCA[['4']]   -2.23      2     1
#> 36:                                   x$GCA[['5']]    6.64      2     1
#> 37:                                   x$GCA[['6']]    2.24      2     1
#> 38:                                   x$GCA[['7']]    0.97      2     1
#> 39:                                   x$GCA[['8']]   -0.23      2     1
#> 40:                                   x$GCA[['9']]    1.78      2     1
#> 41:                            x$StdErr[['gi_gj']]    0.41      2     1
#> 42:                          x$StdErr[['sij_sik']]    1.01      2     1
#> 43:                          x$StdErr[['sij_skl']]    0.93      2     1
#> 44:                                x$SCA['1', '2']    0.53      2     1
#> 45:                                x$SCA['1', '3']    1.91      2     1
#> 46:                                x$SCA['2', '9']   -4.29      2     1
#> 47:                                x$SCA['3', '4']   -5.09      2     1
#> 48:                                x$SCA['4', '9']    5.27      2     1
#> 49:                                x$SCA['5', '6']   -5.25      2     1
#> 50:                                x$SCA['6', '8']    5.01      2     1
#> 51: x$Genetic.Components['Additive', 'Components']   24.00      2     1
#> 52:      x$Genetic.Components['sca', 'Components']    3.97      2     1
#> 53:                      x$ANOVA['gca', 'Mean Sq'] 1948.66      2     1
#> 54:                      x$ANOVA['sca', 'Mean Sq']  260.49      2     1
#> 55:      x$Genetic.Components['gca', 'Components']  276.09      2     1
#> 56:      x$Genetic.Components['sca', 'Components']  244.50      2     1
#> 57:                                   x$GCA[['1']]    9.08      2     1
#> 58:                                   x$GCA[['2']]  -15.17      2     1
#> 59:                                   x$GCA[['3']]   -6.20      2     1
#> 60:                                   x$GCA[['4']]  -20.32      2     1
#> 61:                                   x$GCA[['5']]   -8.15      2     1
#> 62:                                   x$GCA[['6']]   -4.13      2     1
#> 63:                                   x$GCA[['7']]   27.15      2     1
#> 64:                                   x$GCA[['8']]   -6.70      2     1
#> 65:                                   x$GCA[['9']]   24.44      2     1
#> 66:                            x$StdErr[['gi_gj']]    2.14      2     1
#> 67:                          x$StdErr[['sij_sik']]    5.24      2     1
#> 68:                          x$StdErr[['sij_skl']]    4.78      2     1
#> 69:                                x$SCA['1', '2']    4.41      2     1
#> 70:                                x$SCA['1', '3']   12.55      2     1
#> 71:                                x$SCA['2', '9']  -33.44      2     1
#> 72:                                x$SCA['3', '4']  -24.85      2     1
#> 73:                                x$SCA['4', '9']   25.70      2     1
#> 74:                                x$SCA['5', '6']  -30.91      2     1
#> 75:                                x$SCA['6', '8']   27.76      2     1
#> 76: x$Genetic.Components['Additive', 'Components']  482.32      2     1
#> 77:      x$Genetic.Components['sca', 'Components']  144.38      2     1
#>                                            extract   value digits level
#>                                             <char>   <num>  <int> <int>
#>                                                                                                                note
#>                                                                                                              <char>
#>  1: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#>  2:                                                                                                                
#>  3:                                                                                                                
#>  4: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#>  5:                                                                                                                
#>  6:                                                                                                                
#>  7:                                                                                                                
#>  8:                                                                                                                
#>  9:                                                                                                                
#> 10:                                                                                                                
#> 11:                                                                                                                
#> 12:                                                                                                                
#> 13:                                                                                                                
#> 14:                                                                                                                
#> 15:                                                                                                                
#> 16:                                                                                                                
#> 17:                                                                                                                
#> 18:                                                                                                                
#> 19:                                                                                                                
#> 20:                                                                                                                
#> 21:                                                                                                                
#> 22:                                                                                                                
#> 23:                                                                                                                
#> 24:                                                                                                                
#> 25: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 26:                                                                                                                
#> 27:                                                                                                                
#> 28:                                                                                                                
#> 29:                                                                                                                
#> 30:                                                                                                                
#> 31:                                                                                                                
#> 32:                                                                                                                
#> 33: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 34:                                                                                                                
#> 35:                                                                                                                
#> 36:                                                                                                                
#> 37:                                                                                                                
#> 38:                                                                                                                
#> 39:                                                                                                                
#> 40:                                                                                                                
#> 41:                                                                                                                
#> 42:                                                                                                                
#> 43: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 44:                                                                                                                
#> 45:                                                                                                                
#> 46:                                                                                                                
#> 47:                                                                                                                
#> 48:                                                                                                                
#> 49: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 50:                                                                                                                
#> 51:                                                                                                                
#> 52: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 53:                                                                                                                
#> 54:                                                                                                                
#> 55: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 56:                                                                                                                
#> 57:                                                                                                                
#> 58:                                                                                                                
#> 59:                                                                                                                
#> 60:                                                                                                                
#> 61:                                                                                                                
#> 62:                                                                                                                
#> 63:                                                                                                                
#> 64:                                                                                                                
#> 65:                                                                                                                
#> 66:                                                                                                                
#> 67:                                                                                                                
#> 68:                                                                                                                
#> 69:                                                                                                                
#> 70: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 71:                                                                                                                
#> 72: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 73:                                                                                                                
#> 74: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 75:                                                                                                                
#> 76: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 77: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#>                                                                                                                note
#>                                                                                                              <char>
# \donttest{
da_reference(
    source   = "."
  , evaluate = TRUE
  , level    = 1
  )
#>                  id                    source                     quantity
#>              <char>                    <char>                       <char>
#>  1:   g56_X1_ms_gca  Griffing (1956), Table 8 X1 mean square gca (Model I)
#>  2:   g56_X1_ms_sca  Griffing (1956), Table 8 X1 mean square sca (Model I)
#>  3: g56_X1_comp_gca  Griffing (1956), Table 8   X1 gca component (Model I)
#>  4: g56_X1_comp_sca  Griffing (1956), Table 8   X1 sca component (Model I)
#>  5:       g56_X1_g1  Griffing (1956), Table 9    X1 gca effect of parent 1
#>  6:       g56_X1_g2  Griffing (1956), Table 9    X1 gca effect of parent 2
#>  7:       g56_X1_g3  Griffing (1956), Table 9    X1 gca effect of parent 3
#>  8:       g56_X1_g4  Griffing (1956), Table 9    X1 gca effect of parent 4
#>  9:       g56_X1_g5  Griffing (1956), Table 9    X1 gca effect of parent 5
#> 10:       g56_X1_g6  Griffing (1956), Table 9    X1 gca effect of parent 6
#> 11:       g56_X1_g7  Griffing (1956), Table 9    X1 gca effect of parent 7
#> 12:       g56_X1_g8  Griffing (1956), Table 9    X1 gca effect of parent 8
#> 13:       g56_X1_g9  Griffing (1956), Table 9    X1 gca effect of parent 9
#> 14:    g56_X1_se_gg  Griffing (1956), Table 9             X1 SE(g_i - g_j)
#> 15:   g56_X1_se_sik Griffing (1956), Table 10           X1 SE(s_ij - s_ik)
#> 16:   g56_X1_se_skl Griffing (1956), Table 10           X1 SE(s_ij - s_kl)
#> 17:      g56_X1_s12 Griffing (1956), Table 10 X1 sca effect of cross 1 x 2
#> 18:      g56_X1_s13 Griffing (1956), Table 10 X1 sca effect of cross 1 x 3
#> 19:      g56_X1_s19 Griffing (1956), Table 10 X1 sca effect of cross 1 x 9
#> 20:      g56_X1_s29 Griffing (1956), Table 10 X1 sca effect of cross 2 x 9
#> 21:      g56_X1_s34 Griffing (1956), Table 10 X1 sca effect of cross 3 x 4
#> 22:      g56_X1_s49 Griffing (1956), Table 10 X1 sca effect of cross 4 x 9
#> 23:      g56_X1_s56 Griffing (1956), Table 10 X1 sca effect of cross 5 x 6
#> 24:      g56_X1_s68 Griffing (1956), Table 10 X1 sca effect of cross 6 x 8
#> 25:      g56_X1_s89 Griffing (1956), Table 10 X1 sca effect of cross 8 x 9
#> 26:   g56_X1_m2_2sg Griffing (1956), Table 13    X1 2 sigma^2_g (Model II)
#> 27:    g56_X1_m2_ss Griffing (1956), Table 13      X1 sigma^2_s (Model II)
#> 28:   g56_X2_ms_gca  Griffing (1956), Table 8 X2 mean square gca (Model I)
#> 29:   g56_X2_ms_sca  Griffing (1956), Table 8 X2 mean square sca (Model I)
#> 30: g56_X2_comp_gca  Griffing (1956), Table 8   X2 gca component (Model I)
#> 31: g56_X2_comp_sca  Griffing (1956), Table 8   X2 sca component (Model I)
#> 32:       g56_X2_g1  Griffing (1956), Table 9    X2 gca effect of parent 1
#> 33:       g56_X2_g2  Griffing (1956), Table 9    X2 gca effect of parent 2
#> 34:       g56_X2_g3  Griffing (1956), Table 9    X2 gca effect of parent 3
#> 35:       g56_X2_g4  Griffing (1956), Table 9    X2 gca effect of parent 4
#> 36:       g56_X2_g5  Griffing (1956), Table 9    X2 gca effect of parent 5
#> 37:       g56_X2_g6  Griffing (1956), Table 9    X2 gca effect of parent 6
#> 38:       g56_X2_g7  Griffing (1956), Table 9    X2 gca effect of parent 7
#> 39:       g56_X2_g8  Griffing (1956), Table 9    X2 gca effect of parent 8
#> 40:       g56_X2_g9  Griffing (1956), Table 9    X2 gca effect of parent 9
#> 41:    g56_X2_se_gg  Griffing (1956), Table 9             X2 SE(g_i - g_j)
#> 42:   g56_X2_se_sik Griffing (1956), Table 10           X2 SE(s_ij - s_ik)
#> 43:   g56_X2_se_skl Griffing (1956), Table 10           X2 SE(s_ij - s_kl)
#> 44:      g56_X2_s12 Griffing (1956), Table 10 X2 sca effect of cross 1 x 2
#> 45:      g56_X2_s13 Griffing (1956), Table 10 X2 sca effect of cross 1 x 3
#> 46:      g56_X2_s29 Griffing (1956), Table 10 X2 sca effect of cross 2 x 9
#> 47:      g56_X2_s34 Griffing (1956), Table 10 X2 sca effect of cross 3 x 4
#> 48:      g56_X2_s49 Griffing (1956), Table 10 X2 sca effect of cross 4 x 9
#> 49:      g56_X2_s56 Griffing (1956), Table 10 X2 sca effect of cross 5 x 6
#> 50:      g56_X2_s68 Griffing (1956), Table 10 X2 sca effect of cross 6 x 8
#> 51:   g56_X2_m2_2sg Griffing (1956), Table 13    X2 2 sigma^2_g (Model II)
#> 52:    g56_X2_m2_ss Griffing (1956), Table 13      X2 sigma^2_s (Model II)
#> 53:   g56_X3_ms_gca  Griffing (1956), Table 8 X3 mean square gca (Model I)
#> 54:   g56_X3_ms_sca  Griffing (1956), Table 8 X3 mean square sca (Model I)
#> 55: g56_X3_comp_gca  Griffing (1956), Table 8   X3 gca component (Model I)
#> 56: g56_X3_comp_sca  Griffing (1956), Table 8   X3 sca component (Model I)
#> 57:       g56_X3_g1  Griffing (1956), Table 9    X3 gca effect of parent 1
#> 58:       g56_X3_g2  Griffing (1956), Table 9    X3 gca effect of parent 2
#> 59:       g56_X3_g3  Griffing (1956), Table 9    X3 gca effect of parent 3
#> 60:       g56_X3_g4  Griffing (1956), Table 9    X3 gca effect of parent 4
#> 61:       g56_X3_g5  Griffing (1956), Table 9    X3 gca effect of parent 5
#> 62:       g56_X3_g6  Griffing (1956), Table 9    X3 gca effect of parent 6
#> 63:       g56_X3_g7  Griffing (1956), Table 9    X3 gca effect of parent 7
#> 64:       g56_X3_g8  Griffing (1956), Table 9    X3 gca effect of parent 8
#> 65:       g56_X3_g9  Griffing (1956), Table 9    X3 gca effect of parent 9
#> 66:    g56_X3_se_gg  Griffing (1956), Table 9             X3 SE(g_i - g_j)
#> 67:   g56_X3_se_sik Griffing (1956), Table 10           X3 SE(s_ij - s_ik)
#> 68:   g56_X3_se_skl Griffing (1956), Table 10           X3 SE(s_ij - s_kl)
#> 69:      g56_X3_s12 Griffing (1956), Table 10 X3 sca effect of cross 1 x 2
#> 70:      g56_X3_s13 Griffing (1956), Table 10 X3 sca effect of cross 1 x 3
#> 71:      g56_X3_s29 Griffing (1956), Table 10 X3 sca effect of cross 2 x 9
#> 72:      g56_X3_s34 Griffing (1956), Table 10 X3 sca effect of cross 3 x 4
#> 73:      g56_X3_s49 Griffing (1956), Table 10 X3 sca effect of cross 4 x 9
#> 74:      g56_X3_s56 Griffing (1956), Table 10 X3 sca effect of cross 5 x 6
#> 75:      g56_X3_s68 Griffing (1956), Table 10 X3 sca effect of cross 6 x 8
#> 76:   g56_X3_m2_2sg Griffing (1956), Table 13    X3 2 sigma^2_g (Model II)
#> 77:    g56_X3_m2_ss Griffing (1956), Table 13      X3 sigma^2_s (Model II)
#>                  id                    source                     quantity
#>              <char>                    <char>                       <char>
#>                                                                                                                                                   call
#>                                                                                                                                                 <char>
#>  1:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#>  2:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#>  3:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#>  4:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#>  5:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#>  6:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#>  7:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#>  8:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#>  9:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 10:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 11:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 12:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 13:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 14:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 15:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 16:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 17:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 18:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 19:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 20:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 21:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 22:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 23:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 24:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 25:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1642.48 / 78, ErrorDf = 2558)
#> 26:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 2, ErrorMS = 11803.61 / 78, ErrorDf = 175)
#> 27:  GriffingMeans(y = TotalYield, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 2, ErrorMS = 11803.61 / 78, ErrorDf = 175)
#> 28:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 29:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 30:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 31:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 32:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 33:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 34:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 35:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 36:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 37:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 38:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 39:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 40:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 41:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 42:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 43:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 44:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 45:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 46:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 47:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 48:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 49:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 50:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 46.61 / 78, ErrorDf = 2558)
#> 51:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 2, ErrorMS = 235.82 / 78, ErrorDf = 175)
#> 52:     GriffingMeans(y = CobWeight, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 2, ErrorMS = 235.82 / 78, ErrorDf = 175)
#> 53: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 54: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 55: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 56: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 57: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 58: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 59: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 60: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 61: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 62: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 63: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 64: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 65: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 66: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 67: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 68: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 69: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 70: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 71: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 72: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 73: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 74: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 75: GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 1, ErrorMS = 1247.39 / 78, ErrorDf = 2558)
#> 76:  GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 2, ErrorMS = 9056.45 / 78, ErrorDf = 175)
#> 77:  GriffingMeans(y = ShelledCorn, Cross1 = Cross1, Cross2 = Cross2, data = Griffing56, Method = 4, Model = 2, ErrorMS = 9056.45 / 78, ErrorDf = 175)
#>                                                                                                                                                   call
#>                                                                                                                                                 <char>
#>                                            extract   value digits level
#>                                             <char>   <num>  <int> <int>
#>  1:                      x$ANOVA['gca', 'Mean Sq'] 2325.74      2     1
#>  2:                      x$ANOVA['sca', 'Mean Sq']  339.44      2     1
#>  3:      x$Genetic.Components['gca', 'Components']  329.24      2     1
#>  4:      x$Genetic.Components['sca', 'Components']  318.39      2     1
#>  5:                                   x$GCA[['1']]    9.35      2     1
#>  6:                                   x$GCA[['2']]  -20.65      2     1
#>  7:                                   x$GCA[['3']]  -10.16      2     1
#>  8:                                   x$GCA[['4']]  -22.55      2     1
#>  9:                                   x$GCA[['5']]   -1.51      2     1
#> 10:                                   x$GCA[['6']]   -1.89      2     1
#> 11:                                   x$GCA[['7']]   28.12      2     1
#> 12:                                   x$GCA[['8']]   -6.93      2     1
#> 13:                                   x$GCA[['9']]   26.22      2     1
#> 14:                            x$StdErr[['gi_gj']]    2.45      2     1
#> 15:                          x$StdErr[['sij_sik']]    6.01      2     1
#> 16:                          x$StdErr[['sij_skl']]    5.48      2     1
#> 17:                                x$SCA['1', '2']    4.94      2     1
#> 18:                                x$SCA['1', '3']   14.46      2     1
#> 19:                                x$SCA['1', '9']   18.47      2     1
#> 20:                                x$SCA['2', '9']  -37.73      2     1
#> 21:                                x$SCA['3', '4']  -29.94      2     1
#> 22:                                x$SCA['4', '9']   30.97      2     1
#> 23:                                x$SCA['5', '6']  -36.16      2     1
#> 24:                                x$SCA['6', '8']   32.77      2     1
#> 25:                                x$SCA['8', '9']   -5.85      2     1
#> 26: x$Genetic.Components['Additive', 'Components']  567.52      2     1
#> 27:      x$Genetic.Components['sca', 'Components']  188.11      2     1
#> 28:                      x$ANOVA['gca', 'Mean Sq']   90.98      2     1
#> 29:                      x$ANOVA['sca', 'Mean Sq']    6.99      2     1
#> 30:      x$Genetic.Components['gca', 'Components']   12.91      2     1
#> 31:      x$Genetic.Components['sca', 'Components']    6.39      2     1
#> 32:                                   x$GCA[['1']]    0.27      2     1
#> 33:                                   x$GCA[['2']]   -5.48      2     1
#> 34:                                   x$GCA[['3']]   -3.96      2     1
#> 35:                                   x$GCA[['4']]   -2.23      2     1
#> 36:                                   x$GCA[['5']]    6.64      2     1
#> 37:                                   x$GCA[['6']]    2.24      2     1
#> 38:                                   x$GCA[['7']]    0.97      2     1
#> 39:                                   x$GCA[['8']]   -0.23      2     1
#> 40:                                   x$GCA[['9']]    1.78      2     1
#> 41:                            x$StdErr[['gi_gj']]    0.41      2     1
#> 42:                          x$StdErr[['sij_sik']]    1.01      2     1
#> 43:                          x$StdErr[['sij_skl']]    0.93      2     1
#> 44:                                x$SCA['1', '2']    0.53      2     1
#> 45:                                x$SCA['1', '3']    1.91      2     1
#> 46:                                x$SCA['2', '9']   -4.29      2     1
#> 47:                                x$SCA['3', '4']   -5.09      2     1
#> 48:                                x$SCA['4', '9']    5.27      2     1
#> 49:                                x$SCA['5', '6']   -5.25      2     1
#> 50:                                x$SCA['6', '8']    5.01      2     1
#> 51: x$Genetic.Components['Additive', 'Components']   24.00      2     1
#> 52:      x$Genetic.Components['sca', 'Components']    3.97      2     1
#> 53:                      x$ANOVA['gca', 'Mean Sq'] 1948.66      2     1
#> 54:                      x$ANOVA['sca', 'Mean Sq']  260.49      2     1
#> 55:      x$Genetic.Components['gca', 'Components']  276.09      2     1
#> 56:      x$Genetic.Components['sca', 'Components']  244.50      2     1
#> 57:                                   x$GCA[['1']]    9.08      2     1
#> 58:                                   x$GCA[['2']]  -15.17      2     1
#> 59:                                   x$GCA[['3']]   -6.20      2     1
#> 60:                                   x$GCA[['4']]  -20.32      2     1
#> 61:                                   x$GCA[['5']]   -8.15      2     1
#> 62:                                   x$GCA[['6']]   -4.13      2     1
#> 63:                                   x$GCA[['7']]   27.15      2     1
#> 64:                                   x$GCA[['8']]   -6.70      2     1
#> 65:                                   x$GCA[['9']]   24.44      2     1
#> 66:                            x$StdErr[['gi_gj']]    2.14      2     1
#> 67:                          x$StdErr[['sij_sik']]    5.24      2     1
#> 68:                          x$StdErr[['sij_skl']]    4.78      2     1
#> 69:                                x$SCA['1', '2']    4.41      2     1
#> 70:                                x$SCA['1', '3']   12.55      2     1
#> 71:                                x$SCA['2', '9']  -33.44      2     1
#> 72:                                x$SCA['3', '4']  -24.85      2     1
#> 73:                                x$SCA['4', '9']   25.70      2     1
#> 74:                                x$SCA['5', '6']  -30.91      2     1
#> 75:                                x$SCA['6', '8']   27.76      2     1
#> 76: x$Genetic.Components['Additive', 'Components']  482.32      2     1
#> 77:      x$Genetic.Components['sca', 'Components']  144.38      2     1
#>                                            extract   value digits level
#>                                             <char>   <num>  <int> <int>
#>                                                                                                                note
#>                                                                                                              <char>
#>  1: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#>  2:                                                                                                                
#>  3:                                                                                                                
#>  4: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#>  5:                                                                                                                
#>  6:                                                                                                                
#>  7:                                                                                                                
#>  8:                                                                                                                
#>  9:                                                                                                                
#> 10:                                                                                                                
#> 11:                                                                                                                
#> 12:                                                                                                                
#> 13:                                                                                                                
#> 14:                                                                                                                
#> 15:                                                                                                                
#> 16:                                                                                                                
#> 17:                                                                                                                
#> 18:                                                                                                                
#> 19:                                                                                                                
#> 20:                                                                                                                
#> 21:                                                                                                                
#> 22:                                                                                                                
#> 23:                                                                                                                
#> 24:                                                                                                                
#> 25: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 26:                                                                                                                
#> 27:                                                                                                                
#> 28:                                                                                                                
#> 29:                                                                                                                
#> 30:                                                                                                                
#> 31:                                                                                                                
#> 32:                                                                                                                
#> 33: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 34:                                                                                                                
#> 35:                                                                                                                
#> 36:                                                                                                                
#> 37:                                                                                                                
#> 38:                                                                                                                
#> 39:                                                                                                                
#> 40:                                                                                                                
#> 41:                                                                                                                
#> 42:                                                                                                                
#> 43: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 44:                                                                                                                
#> 45:                                                                                                                
#> 46:                                                                                                                
#> 47:                                                                                                                
#> 48:                                                                                                                
#> 49: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 50:                                                                                                                
#> 51:                                                                                                                
#> 52: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 53:                                                                                                                
#> 54:                                                                                                                
#> 55: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 56:                                                                                                                
#> 57:                                                                                                                
#> 58:                                                                                                                
#> 59:                                                                                                                
#> 60:                                                                                                                
#> 61:                                                                                                                
#> 62:                                                                                                                
#> 63:                                                                                                                
#> 64:                                                                                                                
#> 65:                                                                                                                
#> 66:                                                                                                                
#> 67:                                                                                                                
#> 68:                                                                                                                
#> 69:                                                                                                                
#> 70: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 71:                                                                                                                
#> 72: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 73:                                                                                                                
#> 74: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 75:                                                                                                                
#> 76: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#> 77: differs in the last printed digit: Table 6 gives the means to one decimal, Griffing worked from unrounded means
#>                                                                                                                note
#>                                                                                                              <char>
#>         computed agrees
#>            <num> <lgcl>
#>  1: 2325.7471825  FALSE
#>  2:  339.4389418   TRUE
#>  3:  329.2413924   TRUE
#>  4:  318.3815059  FALSE
#>  5:    9.3507937   TRUE
#>  6:  -20.6492063   TRUE
#>  7:  -10.1634921   TRUE
#>  8:  -22.5492063   TRUE
#>  9:   -1.5063492   TRUE
#> 10:   -1.8920635   TRUE
#> 11:   28.1222222   TRUE
#> 12:   -6.9349206   TRUE
#> 13:   26.2222222   TRUE
#> 14:    2.4528372   TRUE
#> 15:    6.0081995   TRUE
#> 16:    5.4847107   TRUE
#> 17:    4.9428571   TRUE
#> 18:   14.4571429   TRUE
#> 19:   18.4714286   TRUE
#> 20:  -37.7285714   TRUE
#> 21:  -29.9428571   TRUE
#> 22:   30.9714286   TRUE
#> 23:  -36.1571429   TRUE
#> 24:   32.7714286   TRUE
#> 25:   -5.8428571  FALSE
#> 26:  567.5166402   TRUE
#> 27:  188.1106085   TRUE
#> 28:   90.9809921   TRUE
#> 29:    6.9879365   TRUE
#> 30:   12.9119183   TRUE
#> 31:    6.3903724   TRUE
#> 32:    0.2682540   TRUE
#> 33:   -5.4746032  FALSE
#> 34:   -3.9603175   TRUE
#> 35:   -2.2317460   TRUE
#> 36:    6.6396825   TRUE
#> 37:    2.2396825   TRUE
#> 38:    0.9682540   TRUE
#> 39:   -0.2317460   TRUE
#> 40:    1.7825397   TRUE
#> 41:    0.4131980   TRUE
#> 42:    1.0121243   TRUE
#> 43:    0.9239389  FALSE
#> 44:    0.5285714   TRUE
#> 45:    1.9142857   TRUE
#> 46:   -4.2857143   TRUE
#> 47:   -5.0857143   TRUE
#> 48:    5.2714286   TRUE
#> 49:   -5.2571429  FALSE
#> 50:    5.0142857   TRUE
#> 51:   23.9980159   TRUE
#> 52:    3.9646032  FALSE
#> 53: 1948.6577778   TRUE
#> 54:  260.4948148   TRUE
#> 55:  276.0950855  FALSE
#> 56:  244.5026353   TRUE
#> 57:    9.0825397   TRUE
#> 58:  -15.1746032   TRUE
#> 59:   -6.2031746   TRUE
#> 60:  -20.3174603   TRUE
#> 61:   -8.1460317   TRUE
#> 62:   -4.1317460   TRUE
#> 63:   27.1539683   TRUE
#> 64:   -6.7031746   TRUE
#> 65:   24.4396825   TRUE
#> 66:    2.1375673   TRUE
#> 67:    5.2359493   TRUE
#> 68:    4.7797459   TRUE
#> 69:    4.4142857   TRUE
#> 70:   12.5428571  FALSE
#> 71:  -33.4428571   TRUE
#> 72:  -24.8571429  FALSE
#> 73:   25.7000000   TRUE
#> 74:  -30.9000000  FALSE
#> 75:   27.7571429   TRUE
#> 76:  482.3322751  FALSE
#> 77:  144.3864815  FALSE
#>         computed agrees
#>            <num> <lgcl>
# }
```
