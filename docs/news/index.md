# Changelog

## DiallelAnalysisR 1.0.0

CRAN release: 2026-11-06

### Changes visible to users

- Every function keeps its name, its arguments and the names of its
  results, so existing scripts run unchanged.
- Results print, summarise and plot:
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html) draws the gca
  effects with standard-error bars and the sca effects as a heat map
  ([`Griffing()`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md),
  [`PartialDiallel()`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallel.md)),
  and the Wr-Vr graph
  ([`Hayman()`](https://myaseen208.com/DiallelAnalysisR/reference/Hayman.md));
  any component converts to a table with
  `data.table::as.data.table(x, component = "ANOVA")`.
- The usual model functions work on every result:
  [`summary()`](https://rdrr.io/r/base/summary.html) (t tests of every
  effect, the crosses with the largest sca effects),
  [`anova()`](https://rdrr.io/r/stats/anova.html),
  [`coef()`](https://rdrr.io/r/stats/coef.html),
  [`vcov()`](https://rdrr.io/r/stats/vcov.html),
  [`confint()`](https://rdrr.io/r/stats/confint.html),
  [`fitted()`](https://rdrr.io/r/stats/fitted.values.html) and
  [`residuals()`](https://rdrr.io/r/stats/residuals.html) (plot level),
  [`nobs()`](https://rdrr.io/r/stats/nobs.html),
  [`df.residual()`](https://rdrr.io/r/stats/df.residual.html),
  [`predict()`](https://rdrr.io/r/stats/predict.html) (crosses from gca
  alone or from the full model) and
  [`ggplot2::autoplot()`](https://ggplot2.tidyverse.org/reference/autoplot.html);
  `plot(which = "residuals")` and `plot(which = "qq")` check the block
  analysis.
- Column arguments accept a bare name (`y = Yield`), a string
  (`y = "Yield"`) or a vector.
- In Methods 2 and 4 a cross may be recorded either way round; missing
  crosses are reported by name.

### Corrections

- [`Griffing()`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md),
  Model 1: the standard errors now use the error mean square; version
  0.6.0 used the replicate mean square (with `GriffingData1`, Method 1:
  standard error of a gca effect 1.25 instead of 2.17).
- [`Griffing()`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md),
  Method 2: the standard errors of the sca effects of selfs and of
  crosses were swapped.
- [`Griffing()`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md),
  Method 4: the third standard error (a Method 1 formula that has no
  meaning in Method 4) is `NA`; the table of means has every parent in
  its rows and columns (was 7 x 7 with misaligned labels).
- [`Griffing()`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md),
  Model 2, Methods 1 and 3: the p-value of the reciprocal line uses the
  error degrees of freedom (was the sca degrees of freedom).
- [`Hayman()`](https://myaseen208.com/DiallelAnalysisR/reference/Hayman.md):
  the column arguments are used (version 0.6.0 read the columns `Cross1`
  and `Cross2` by name).
- [`Hayman()`](https://myaseen208.com/DiallelAnalysisR/reference/Hayman.md):
  the lines b, b3 and d of the analysis of variance divided by the
  number of replicates where the formula has 4; the two agree only with
  4 replicates (as in `HaymanData`).
- [`Hayman()`](https://myaseen208.com/DiallelAnalysisR/reference/Hayman.md):
  H2 = 4 V1L1 - 4 V0L1 - 2E (version 0.6.0 added 4 V0L1); Wr and Vr come
  from the reciprocal-averaged table (version 0.6.0 took Vr from the
  upper triangle and Wr from the unaveraged rows). F, H1 and the derived
  ratios change accordingly.
- [`PartialDiallel()`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallel.md):
  the column arguments are used (version 0.6.0 read `y`, `Rep`,
  `Cross1`, `Cross2` by name); the error line is on the plot scale
  (version 0.6.0 divided it by the number of replicates, inflating every
  F); the components are variance components (version 0.6.0 gave
  differences of mean squares).

### New

- [`Griffing()`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md),
  Model 1: new components `GCA`, `SCA` (selfs included), `Reciprocal`;
  all results: `RCBD` (the block analysis of the plot data).
  [`Hayman()`](https://myaseen208.com/DiallelAnalysisR/reference/Hayman.md):
  new component `Tests` (uniformity t2, b = 0, b = 1); named derived
  ratios.
- [`Griffing()`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md)
  handles missing plots (not missing crosses): least-squares cross means
  adjusted for blocks, with the harmonic mean of the plot numbers as the
  number of replicates.
- [`GriffingMeans()`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingMeans.md):
  Griffing’s analysis of a table of cross means with the error mean
  square and degrees of freedom of the experiment; data set `Griffing56`
  (Griffing 1956, Table 6) and 77 published values of Griffing’s Tables
  8, 9, 10 and 13 in `reference.csv`, recomputed by
  [`da_reference()`](https://myaseen208.com/DiallelAnalysisR/reference/da_reference.md).
- [`Heterosis()`](https://myaseen208.com/DiallelAnalysisR/reference/Heterosis.md):
  mid-parent, better-parent and standard heterosis with t tests.
- `Griffing(..., Reciprocal = "split")`: maternal and non-maternal
  reciprocal effects (Cockerham and Weir 1977) in Methods 1 and 3, with
  their tests, components and standard errors.
- [`GardnerEberhart()`](https://myaseen208.com/DiallelAnalysisR/reference/GardnerEberhart.md):
  Gardner and Eberhart’s Analyses II and III.
- [`LineTester()`](https://myaseen208.com/DiallelAnalysisR/reference/LineTester.md):
  line by tester analysis with proportional contributions, effects,
  standard errors and genetic variances;
  [`NCDesign()`](https://myaseen208.com/DiallelAnalysisR/reference/NCDesign.md):
  North Carolina designs I, II and III; data sets `LineTesterData` and
  `NCData`.
- [`GriffingEnv()`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingEnv.md):
  Griffing’s analysis over several environments with gca, sca and
  reciprocal by environment interactions and, in Model 2, their variance
  components.
- `plot(x, which = "biplot")` for
  [`Griffing()`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md)
  and
  [`LineTester()`](https://myaseen208.com/DiallelAnalysisR/reference/LineTester.md)
  results: a biplot of the cross means.
- [`DiallelSim()`](https://myaseen208.com/DiallelAnalysisR/reference/DiallelSim.md)
  simulates diallel data with known effects;
  [`DiallelPower()`](https://myaseen208.com/DiallelAnalysisR/reference/DiallelPower.md)
  estimates the power of the combining-ability tests for numbers of
  replicates.
- [`da_tables()`](https://myaseen208.com/DiallelAnalysisR/reference/da_export.md)
  and
  [`da_export()`](https://myaseen208.com/DiallelAnalysisR/reference/da_export.md):
  the main tables of any result in Word, LaTeX, HTML, Markdown or CSV.
- Title and description of the package cover the new analyses;
  `citation("DiallelAnalysisR")` gives the reference of the package
  (also in the README and on the site).
- [`DiallelApp()`](https://myaseen208.com/DiallelAnalysisR/reference/DiallelApp.md):
  a Shiny application for every analysis, with plots, exports and the R
  code of the analysis.
- Complete help pages with the models and formulas; fifteen vignettes
  (HTML and PDF); notation table
  [`da_notation()`](https://myaseen208.com/DiallelAnalysisR/reference/da_notation.md);
  plot theme
  [`da_theme()`](https://myaseen208.com/DiallelAnalysisR/reference/da_theme.md)
  and
  [`da_save()`](https://myaseen208.com/DiallelAnalysisR/reference/da_save.md).
- Tests of every analysis against independent calculations and against
  version 0.6.0.

### Internal

- One computational core per analysis instead of eight copied branches;
  closed forms throughout; up to 60 times faster for 20 parents.

## DiallelAnalysisR 0.6.0

CRAN release: 2024-09-13

- Updated the DESCRIPTION file to fulfil the requirements of CRAN.

## DiallelAnalysisR 0.5.0

CRAN release: 2023-03-31

- Refined code.

## DiallelAnalysisR 0.4.0

CRAN release: 2021-02-25

- Removed vignettes.

## DiallelAnalysisR 0.3.0

CRAN release: 2020-08-01

- Added
  [`PartialDiallel()`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallel.md)
  for the analysis of partial diallels.
- Added vignettes; refined code and documentation.

## DiallelAnalysisR 0.1.1

CRAN release: 2016-04-09

- First version: Griffing’s and Hayman’s diallel analyses.
