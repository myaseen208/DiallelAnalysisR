# Package index

## Diallel analyses

Griffing’s methods and models, from plot data, from a table of means and
over environments; Hayman’s analysis.

- [`Griffing()`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md)
  : Diallel analysis by Griffing's methods
- [`GriffingMeans()`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingMeans.md)
  : Griffing's analysis from a table of cross means
- [`GriffingEnv()`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingEnv.md)
  : Griffing's diallel analysis over several environments
- [`Hayman()`](https://myaseen208.com/DiallelAnalysisR/reference/Hayman.md)
  : Diallel analysis by Hayman's approach

## Heterosis

Heterosis over the parents and a check; Gardner and Eberhart’s Analyses
II and III.

- [`Heterosis()`](https://myaseen208.com/DiallelAnalysisR/reference/Heterosis.md)
  : Heterosis over the mid-parent, the better parent and a standard
  variety
- [`GardnerEberhart()`](https://myaseen208.com/DiallelAnalysisR/reference/GardnerEberhart.md)
  : Gardner and Eberhart's Analyses II and III of a diallel with parents

## Related mating designs

Crosses between two groups, lines by testers, and the North Carolina
designs.

- [`PartialDiallel()`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallel.md)
  : Partial diallel analysis (crosses between two groups of parents)
- [`LineTester()`](https://myaseen208.com/DiallelAnalysisR/reference/LineTester.md)
  : Line by tester analysis
- [`NCDesign()`](https://myaseen208.com/DiallelAnalysisR/reference/NCDesign.md)
  : North Carolina designs I, II and III

## Planning

Simulated diallels and the power of the tests for numbers of replicates.

- [`DiallelSim()`](https://myaseen208.com/DiallelAnalysisR/reference/DiallelSim.md)
  : Simulate diallel data
- [`DiallelPower()`](https://myaseen208.com/DiallelAnalysisR/reference/DiallelPower.md)
  [`plot(`*`<da_power>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/DiallelPower.md)
  : Power of the combining-ability tests for planning a diallel

## Results, tables and the application

Methods of the result objects, tables for papers, and the interactive
application.

- [`print(`*`<da_result>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/da-methods.md)
  [`summary(`*`<da_result>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/da-methods.md)
  [`print(`*`<summary.da_result>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/da-methods.md)
  [`format(`*`<da_result>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/da-methods.md)
  [`as.data.table(`*`<da_result>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/da-methods.md)
  [`as.data.frame(`*`<da_result>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/da-methods.md)
  [`plot(`*`<da_result>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/da-methods.md)
  : Methods for DiallelAnalysisR results
- [`print(`*`<summary.da_griffing>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/diallel-methods.md)
  [`print(`*`<summary.da_hayman>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/diallel-methods.md)
  [`print(`*`<summary.da_partial>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/diallel-methods.md)
  [`anova(`*`<da_result>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/diallel-methods.md)
  [`coef(`*`<da_griffing>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/diallel-methods.md)
  [`coef(`*`<da_hayman>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/diallel-methods.md)
  [`coef(`*`<da_partial>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/diallel-methods.md)
  [`vcov(`*`<da_griffing>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/diallel-methods.md)
  [`vcov(`*`<da_partial>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/diallel-methods.md)
  [`confint(`*`<da_griffing>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/diallel-methods.md)
  [`confint(`*`<da_partial>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/diallel-methods.md)
  [`fitted(`*`<da_result>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/diallel-methods.md)
  [`residuals(`*`<da_result>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/diallel-methods.md)
  [`nobs(`*`<da_result>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/diallel-methods.md)
  [`df.residual(`*`<da_result>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/diallel-methods.md)
  [`predict(`*`<da_griffing>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/diallel-methods.md)
  [`autoplot(`*`<da_result>`*`)`](https://myaseen208.com/DiallelAnalysisR/reference/diallel-methods.md)
  : Methods for the diallel analyses
- [`da_export()`](https://myaseen208.com/DiallelAnalysisR/reference/da_export.md)
  [`da_tables()`](https://myaseen208.com/DiallelAnalysisR/reference/da_export.md)
  : Export the tables of an analysis for a report or a paper
- [`DiallelApp()`](https://myaseen208.com/DiallelAnalysisR/reference/DiallelApp.md)
  : Interactive analysis in a web browser

## Data

Example data sets.

- [`Griffing56`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing56.md)
  : Griffing's (1956) maize diallel: cross means of nine inbred lines
- [`GriffingData1`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData1.md)
  : Complete diallel of eight parents (Griffing's Method 1)
- [`GriffingData2`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData2.md)
  : Parents and one set of crosses of eight parents (Griffing's Method
  2)
- [`GriffingData3`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData3.md)
  : Crosses and reciprocals of eight parents without the parents
  (Griffing's Method 3)
- [`GriffingData4`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData4.md)
  : One set of crosses of eight parents (Griffing's Method 4)
- [`HaymanData`](https://myaseen208.com/DiallelAnalysisR/reference/HaymanData.md)
  : Complete diallel of eight parents for Hayman's analysis
- [`LineTesterData`](https://myaseen208.com/DiallelAnalysisR/reference/LineTesterData.md)
  : Line by tester example: eight lines crossed with three testers
- [`NCData`](https://myaseen208.com/DiallelAnalysisR/reference/NCData.md)
  : North Carolina designs I, II and III: example data
- [`PartialDiallelData`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallelData.md)
  : Partial diallel: ten by four parents

## Utilities

- [`da_theme()`](https://myaseen208.com/DiallelAnalysisR/reference/da_theme.md)
  : ggplot2 theme of DiallelAnalysisR
- [`da_save()`](https://myaseen208.com/DiallelAnalysisR/reference/da_save.md)
  : Save a figure (vector PDF by default)
- [`da_notation()`](https://myaseen208.com/DiallelAnalysisR/reference/da_notation.md)
  : Notation of DiallelAnalysisR
- [`da_reference()`](https://myaseen208.com/DiallelAnalysisR/reference/da_reference.md)
  : Published values used by the tests and vignettes
- [`DiallelAnalysisR`](https://myaseen208.com/DiallelAnalysisR/reference/DiallelAnalysisR-package.md)
  [`DiallelAnalysisR-package`](https://myaseen208.com/DiallelAnalysisR/reference/DiallelAnalysisR-package.md)
  : DiallelAnalysisR: Diallel Analysis, Heterosis and Related Mating
  Designs
