# Theory and notation

\\ \newcommand{\mY}{\mathbf{Y}} \newcommand{\mT}{\mathbf{T}}
\newcommand{\mS}{\mathbf{S}} \newcommand{\mR}{\mathbf{R}}
\newcommand{\vg}{\mathbf{g}} \newcommand{\E}{\mathrm{E}}
\newcommand{\Var}{\mathrm{Var}} \newcommand{\Cov}{\mathrm{Cov}} \\

## 1 Abstract

The models behind the analyses, the notation used in the help pages and
vignettes, and the expected mean squares that turn mean squares into
variance components.

## 2 Notation

Scalars are upper-case letters in normal face, indices lower-case
italic, vectors lower-case bold and matrices upper-case bold; elements
of vectors and matrices keep their letter in normal face.

``` r

nt <-
  da_notation(
      format = c("table", "path", "tex")[1]
    )
nt[, symbol := paste0("$", symbol, "$")]
nt[, argument := ifelse(test = nzchar(argument), yes = paste0("`", argument, "`"), no = "")]
knitr::kable(x = nt[, .(symbol, kind, meaning, argument)])
```

| symbol | kind | meaning | argument |
|:---|:---|:---|:---|
| \\P\\ | scalar | number of parents |  |
| \\B\\ | scalar | number of replicates (blocks) |  |
| \\i, j, k, l\\ | index | parents; i female (Cross1), j male (Cross2) | `Cross1, Cross2` |
| \\\mathbf{Y}\\ | matrix | P x P matrix of cell means (female parents in rows) | `Means` |
| \\Y\_{ij}\\ | element | mean of cross i x j | `Means` |
| \\Y\_{i\cdot}, Y\_{\cdot j}, Y\_{\cdot\cdot}\\ | scalar | row, column and grand totals of the cell means |  |
| \\\mathbf{T}\\ | matrix | cell totals over replicates (Hayman) |  |
| \\\mu\\ | scalar | general mean |  |
| \\\mathbf{g}, g_i\\ | vector | general combining ability (gca) effects | `GCA` |
| \\\mathbf{S}, S\_{ij}\\ | matrix | specific combining ability (sca) effects, symmetric | `SCA` |
| \\\mathbf{R}, R\_{ij}\\ | matrix | reciprocal effects, R_ij = -R_ji | `Reciprocal` |
| \\MS_E, f_E\\ | scalar | error mean square of the block analysis and its degrees of freedom | `RCBD` |
| \\\sigma^2_m\\ | scalar | error variance of a cell mean, MS_E / B | `ANOVA (line Error)` |
| \\SS_g, SS_s, SS_r\\ | scalar | sums of squares of gca, sca and reciprocal effects | `ANOVA` |
| \\\sigma^2_g, \sigma^2_s, \sigma^2_r\\ | scalar | variances of gca, sca and reciprocal effects (random model) | `Genetic.Components` |
| \\\sigma^2_A, \sigma^2_D\\ | scalar | additive and dominance variances | `Genetic.Components` |
| \\V_r, W_r\\ | scalar | variance of array r and its covariance with the parents (Hayman) | `Wr.Vr.Table` |
| \\V\_{0L0}, V\_{1L1}, V\_{0L1}, W\_{0L01}\\ | scalar | variance of the parents, mean of Vr, variance of array means, mean of Wr | `VOLO` |
| \\D, H_1, H_2, F, h^2, E\\ | scalar | Hayman’s components of variation | `Components.of.Variation` |
| \\L, M\\ | scalar | numbers of parents in the two groups of a partial diallel |  |
| \\\mathbf{g}^{I}, \mathbf{g}^{II}\\ | vector | gca effects of the two groups (partial diallel) | `General` |

## 3 The diallel model

With \\P\\ parents in \\B\\ replicates, the mean of cross \\i \times j\\
(female \\i\\, male \\j\\) is \\ Y\_{ij} = \mu + g_i + g_j + S\_{ij} +
R\_{ij} + \bar{e}\_{ij}, \qquad S\_{ij} = S\_{ji}, \quad R\_{ij} =
-R\_{ji}, \\ where \\\vg\\ holds the general combining ability (gca)
effects of the parents, \\\mS\\ the specific combining ability (sca)
effects of the crosses and \\\mR\\ the reciprocal effects (Griffing
1956). The error of a cell mean has variance \\\sigma^2_m =
\sigma^2/B\\, estimated by \\MS_E/B\\ from the block analysis of the
plot data.

## 4 Least squares

The vector of cell means splits into orthogonal parts: the mean, the gca
part, the sca part and the reciprocal part. The sums of squares of the
analysis of variance are the squared lengths of these parts, and
Griffing’s formulas are their closed forms. The package computes the
closed forms and its tests check them against the explicit projection
for every method and several numbers of parents (vignette 13).

## 5 Fixed and random models

In the fixed model the effects are constants and are estimated with
their standard errors. In the random model \\g_i\\, \\S\_{ij}\\ and
\\R\_{ij}\\ are independent with variances \\\sigma^2_g\\,
\\\sigma^2_s\\, \\\sigma^2_r\\ and the mean squares have expectations
(Method 1) \\ \E(MS_g) = \sigma^2_m + \frac{2(P-1)}{P}\sigma^2_s +
2P\sigma^2_g, \quad \E(MS_s) = \sigma^2_m +
\frac{2(P^2-P+1)}{P^2}\sigma^2_s, \quad \E(MS_r) = \sigma^2_m +
2\sigma^2_r . \\ Solving these equations with the observed mean squares
gives the variance components; for non-inbred parents without epistasis
\\\sigma^2_A = 2\sigma^2_g\\ and \\\sigma^2_D = \sigma^2_s\\.

``` r

P <- 8
rbind(
    Method1 = c(gca = 2 * P, sca_in_gca = 2 * (P - 1) / P, sca = 2 * (P^2 - P + 1) / P^2)
  , Method2 = c(P + 2, 1, 1)
  , Method3 = c(2 * (P - 2), 2, 2)
  , Method4 = c(P - 2, 1, 1)
  )
```

            gca sca_in_gca     sca
    Method1  16       1.75 1.78125
    Method2  10       1.00 1.00000
    Method3  12       2.00 2.00000
    Method4   6       1.00 1.00000

## 6 Hayman’s model

Hayman (1954) works with the arrays of the diallel table (the progeny of
one parent) after averaging the reciprocal crosses. The variance \\V_r\\
of array \\r\\ and its covariance \\W_r\\ with the parents lie, under
the additive-dominance model, on a line of unit slope; the components
\\D\\ (additive), \\H_1\\ and \\H_2\\ (dominance), \\F\\ and \\h^2\\
follow from the variances and covariances of the arrays (vignette 06).

## 7 Summary

All analyses rest on the same table of cell means and the same error
mean square; the fixed model estimates effects, the random model
variance components, and Hayman’s approach the components of gene
action.

## 8 References

Griffing, B. (1956). Concept of general and specific combining ability
in relation to diallel crossing systems. *Australian Journal of
Biological Sciences*, 9(4), 463–493.

Hayman, B. I. (1954). The theory and analysis of diallel crosses.
*Genetics*, 39(6), 789–809.

Hayman, B. I. (1954). The analysis of variance of diallel tables.
*Biometrics*, 10(2), 235–244.

Mather, K. and Jinks, J. L. (1982). *Biometrical Genetics*, 3rd edition.
Chapman and Hall, London.
