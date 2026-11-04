

# DiallelAnalysisR 1.0.0

## Changes visible to users

- Every function keeps its name, its arguments and the names of its
  results, so existing scripts run unchanged.
- Results print, summarise and plot: `plot()` draws the gca effects with
  standard-error bars and the sca effects as a heat map (`Griffing()`,
  `PartialDiallel()`), and the Wr-Vr graph (`Hayman()`); any component
  converts to a table with
  `data.table::as.data.table(x, component = "ANOVA")`.
- The usual model functions work on every result: `summary()` (t tests
  of every effect, the crosses with the largest sca effects), `anova()`,
  `coef()`, `vcov()`, `confint()`, `fitted()` and `residuals()` (plot
  level), `nobs()`, `df.residual()`, `predict()` (crosses from gca alone
  or from the full model) and `ggplot2::autoplot()`;
  `plot(which = "residuals")` and `plot(which = "qq")` check the block
  analysis.
- Column arguments accept a bare name (`y = Yield`), a string
  (`y = "Yield"`) or a vector.
- In Methods 2 and 4 a cross may be recorded either way round; missing
  crosses are reported by name.

## Corrections

- `Griffing()`, Model 1: the standard errors now use the error mean
  square; version 0.6.0 used the replicate mean square (with
  `GriffingData1`, Method 1: standard error of a gca effect 1.25 instead
  of 2.17).
- `Griffing()`, Method 2: the standard errors of the sca effects of
  selfs and of crosses were swapped.
- `Griffing()`, Method 4: the third standard error (a Method 1 formula
  that has no meaning in Method 4) is `NA`; the table of means has every
  parent in its rows and columns (was 7 x 7 with misaligned labels).
- `Griffing()`, Model 2, Methods 1 and 3: the p-value of the reciprocal
  line uses the error degrees of freedom (was the sca degrees of
  freedom).
- `Hayman()`: the column arguments are used (version 0.6.0 read the
  columns `Cross1` and `Cross2` by name).
- `Hayman()`: the lines b, b3 and d of the analysis of variance divided
  by the number of replicates where the formula has 4; the two agree
  only with 4 replicates (as in `HaymanData`).
- `Hayman()`: H2 = 4 V1L1 - 4 V0L1 - 2E (version 0.6.0 added 4 V0L1); Wr
  and Vr come from the reciprocal-averaged table (version 0.6.0 took Vr
  from the upper triangle and Wr from the unaveraged rows). F, H1 and
  the derived ratios change accordingly.
- `PartialDiallel()`: the column arguments are used (version 0.6.0 read
  `y`, `Rep`, `Cross1`, `Cross2` by name); the error line is on the plot
  scale (version 0.6.0 divided it by the number of replicates, inflating
  every F); the components are variance components (version 0.6.0 gave
  differences of mean squares).

## New

- `Griffing()`, Model 1: new components `GCA`, `SCA` (selfs included),
  `Reciprocal`; all results: `RCBD` (the block analysis of the plot
  data). `Hayman()`: new component `Tests` (uniformity t2, b = 0, b =
  1); named derived ratios.
- `Griffing()` handles missing plots (not missing crosses):
  least-squares cross means adjusted for blocks, with the harmonic mean
  of the plot numbers as the number of replicates.
- `GriffingMeans()`: Griffing’s analysis of a table of cross means with
  the error mean square and degrees of freedom of the experiment; data
  set `Griffing56` (Griffing 1956, Table 6) and 77 published values of
  Griffing’s Tables 8, 9, 10 and 13 in `reference.csv`, recomputed by
  `da_reference()`.
- `Heterosis()`: mid-parent, better-parent and standard heterosis with t
  tests.
- `Griffing(..., Reciprocal = "split")`: maternal and non-maternal
  reciprocal effects (Cockerham and Weir 1977) in Methods 1 and 3, with
  their tests, components and standard errors.
- `GardnerEberhart()`: Gardner and Eberhart’s Analyses II and III.
- `LineTester()`: line by tester analysis with proportional
  contributions, effects, standard errors and genetic variances;
  `NCDesign()`: North Carolina designs I, II and III; data sets
  `LineTesterData` and `NCData`.
- `GriffingEnv()`: Griffing’s analysis over several environments with
  gca, sca and reciprocal by environment interactions and, in Model 2,
  their variance components.
- `plot(x, which = "biplot")` for `Griffing()` and `LineTester()`
  results: a biplot of the cross means.
- `DiallelSim()` simulates diallel data with known effects;
  `DiallelPower()` estimates the power of the combining-ability tests
  for numbers of replicates.
- `da_tables()` and `da_export()`: the main tables of any result in
  Word, LaTeX, HTML, Markdown or CSV.
- Title and description of the package cover the new analyses;
  `citation("DiallelAnalysisR")` gives the reference of the package
  (also in the README and on the site).
- `DiallelApp()`: a Shiny application for every analysis, with plots,
  exports and the R code of the analysis.
- Complete help pages with the models and formulas; fifteen vignettes
  (HTML and PDF); notation table `da_notation()`; plot theme
  `da_theme()` and `da_save()`.
- Tests of every analysis against independent calculations and against
  version 0.6.0.

## Internal

- One computational core per analysis instead of eight copied branches;
  closed forms throughout; up to 60 times faster for 20 parents.

# DiallelAnalysisR 0.6.0

- Updated the DESCRIPTION file to fulfil the requirements of CRAN.

# DiallelAnalysisR 0.5.0

- Refined code.

# DiallelAnalysisR 0.4.0

- Removed vignettes.

# DiallelAnalysisR 0.3.0

- Added `PartialDiallel()` for the analysis of partial diallels.
- Added vignettes; refined code and documentation.

# DiallelAnalysisR 0.1.1

- First version: Griffing’s and Hayman’s diallel analyses.
