# DiallelAnalysisR: Diallel Analysis, Heterosis and Related Mating Designs

DiallelAnalysisR analyses diallel crosses of plant-breeding experiments
laid out in randomized complete blocks: Griffing's (1956) four methods
and two models, Hayman's (1954) analysis with the \\W_r\\-\\V_r\\ graph
and the components of variation, the partial diallel between two groups
of parents, heterosis, Gardner and Eberhart's models, line by tester and
North Carolina designs, diallels over environments, simulation and
planning, tables for papers and an interactive application.

## Details

**Functions.**

- [`Griffing`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md):
  combining-ability analysis by Griffing's Methods 1 to 4 and Models 1
  (fixed) and 2 (random): analysis of variance, gca, sca and reciprocal
  effects with standard errors, variance components.

- [`Hayman`](https://myaseen208.com/DiallelAnalysisR/reference/Hayman.md):
  Hayman's analysis of variance, the \\W_r\\-\\V_r\\ analysis and graph,
  the components \\D\\, \\H_1\\, \\H_2\\, \\F\\, \\h^2\\, \\E\\, genetic
  ratios and tests of the additive-dominance model.

- [`PartialDiallel`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallel.md):
  crosses between two groups of parents: gca of each group, sca,
  variance components.

- [`GriffingMeans`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingMeans.md):
  Griffing's analysis of a table of cross means;
  [`GriffingEnv`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingEnv.md):
  over several environments.

- [`Heterosis`](https://myaseen208.com/DiallelAnalysisR/reference/Heterosis.md):
  mid-parent, better-parent and standard heterosis with \\t\\ tests.

- [`GardnerEberhart`](https://myaseen208.com/DiallelAnalysisR/reference/GardnerEberhart.md):
  Gardner and Eberhart's Analyses II and III.

- [`LineTester`](https://myaseen208.com/DiallelAnalysisR/reference/LineTester.md),
  [`NCDesign`](https://myaseen208.com/DiallelAnalysisR/reference/NCDesign.md):
  line by tester analysis; North Carolina designs I to III.

- [`DiallelSim`](https://myaseen208.com/DiallelAnalysisR/reference/DiallelSim.md),
  [`DiallelPower`](https://myaseen208.com/DiallelAnalysisR/reference/DiallelPower.md):
  simulated diallels and the power of the tests.

- [`da_export`](https://myaseen208.com/DiallelAnalysisR/reference/da_export.md):
  the main tables in Word, LaTeX, HTML, Markdown or CSV;
  [`DiallelApp`](https://myaseen208.com/DiallelAnalysisR/reference/DiallelApp.md):
  the interactive application.

Every analysis returns the named list documented on its help page, with
a class and the methods `print`, `summary`, `plot` and `as.data.table`;
see
[`da-methods`](https://myaseen208.com/DiallelAnalysisR/reference/da-methods.md).
Utilities:
[`da_theme`](https://myaseen208.com/DiallelAnalysisR/reference/da_theme.md),
[`da_save`](https://myaseen208.com/DiallelAnalysisR/reference/da_save.md),
[`da_notation`](https://myaseen208.com/DiallelAnalysisR/reference/da_notation.md),
[`da_reference`](https://myaseen208.com/DiallelAnalysisR/reference/da_reference.md).

**Data.**
[`GriffingData1`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData1.md)
(complete diallel of eight parents), its subsets
[`GriffingData2`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData2.md),
[`GriffingData3`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData3.md),
[`GriffingData4`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData4.md)
for Methods 2 to 4,
[`HaymanData`](https://myaseen208.com/DiallelAnalysisR/reference/HaymanData.md),
[`PartialDiallelData`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallelData.md)
(ten by four parents),
[`Griffing56`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing56.md)
(Griffing's 1956 maize example),
[`LineTesterData`](https://myaseen208.com/DiallelAnalysisR/reference/LineTesterData.md)
and
[`NCData`](https://myaseen208.com/DiallelAnalysisR/reference/NCData.md).

**Vignettes.** Start with
[`vignette("DiallelAnalysisR_01_getting_started", package = "DiallelAnalysisR")`](https://myaseen208.com/DiallelAnalysisR/articles/DiallelAnalysisR_01_getting_started.md);
`browseVignettes("DiallelAnalysisR")` lists all of them, each as HTML
and as PDF.

## Notation

Scalars are upper-case letters in normal face, indices lower-case
italic, vectors lower-case bold and matrices upper-case bold; elements
of vectors and matrices keep their letter in normal face. The full table
is
[`da_notation()`](https://myaseen208.com/DiallelAnalysisR/reference/da_notation.md).

|  |  |
|----|----|
| \\P\\, \\B\\ | number of parents, number of replicates (blocks) |
| \\i\\, \\j\\ | female and male parent of a cross |
| \\\mathbf{Y}\\, \\Y\_{ij}\\ | matrix of cell means, mean of cross \\i \times j\\ |
| \\\mathbf{g}\\, \\g_i\\ | vector of gca effects, gca effect of parent \\i\\ |
| \\\mathbf{S}\\, \\\mathbf{R}\\ | matrices of sca and reciprocal effects |
| \\\sigma^2_g\\, \\\sigma^2_s\\, \\\sigma^2_r\\ | variances of gca, sca and reciprocal effects (random model) |
| \\MS_E\\, \\\sigma^2_m\\ | error mean square, error variance of a cell mean |
| \\V_r\\, \\W_r\\ | variance of array \\r\\, its covariance with the parents |
| \\D\\, \\H_1\\, \\H_2\\, \\F\\ | Hayman's components of variation |

## References

Griffing, B. (1956). Concept of general and specific combining ability
in relation to diallel crossing systems. *Australian Journal of
Biological Sciences*, **9**(4), 463–493.
[doi:10.1071/BI9560463](https://doi.org/10.1071/BI9560463)

Hayman, B. I. (1954). The theory and analysis of diallel crosses.
*Genetics*, **39**(6), 789–809.
[doi:10.1093/genetics/39.6.789](https://doi.org/10.1093/genetics/39.6.789)

Hayman, B. I. (1954). The analysis of variance of diallel tables.
*Biometrics*, **10**(2), 235–244.
[doi:10.2307/3001877](https://doi.org/10.2307/3001877)

Kempthorne, O. and Curnow, R. N. (1961). The partial diallel cross.
*Biometrics*, **17**(2), 229–250.
[doi:10.2307/2527989](https://doi.org/10.2307/2527989)

Singh, R. K. and Chaudhary, B. D. (2004). *Biometrical Methods in
Quantitative Genetic Analysis*. Kalyani Publishers, New Delhi.

## See also

[`da-methods`](https://myaseen208.com/DiallelAnalysisR/reference/da-methods.md),
[`da_notation`](https://myaseen208.com/DiallelAnalysisR/reference/da_notation.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>), ORCID 0000-0002-5923-1714;
Kent M. Eskridge; Pedro A. M. Barbosa; Yuhang Guo.
