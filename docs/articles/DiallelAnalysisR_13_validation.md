# Validation and the corrections of version 0.6.0

\\ \newcommand{\mY}{\mathbf{Y}} \newcommand{\mT}{\mathbf{T}}
\newcommand{\mS}{\mathbf{S}} \newcommand{\mR}{\mathbf{R}}
\newcommand{\vg}{\mathbf{g}} \newcommand{\E}{\mathrm{E}}
\newcommand{\Var}{\mathrm{Var}} \newcommand{\Cov}{\mathrm{Cov}} \\

## 1 Abstract

Every number the package computes is checked by its tests against an
independent calculation. This vignette shows the main checks and lists
the results that differ from version 0.6.0, with the reason for each
change.

## 2 Closed forms against the exact decomposition

The analyses use Griffing’s closed forms. The package also contains the
explicit least-squares projection of the cell means
(`DiallelAnalysisR:::.da_griffing_decompose()`), used only to check
them:

``` r

set.seed(seed = 1)
check <- function(P, m) {
  M <- matrix(data = rnorm(n = P * P, mean = 50, sd = 10), nrow = P, ncol = P)
  if (m %in% c(2, 4)) M[lower.tri(M)] <- NA
  if (m %in% c(3, 4)) diag(M) <- NA
  cf <- DiallelAnalysisR:::.da_griffing_closed(M, m)
  ex <- DiallelAnalysisR:::.da_griffing_decompose(M, m)
  max(abs(c(cf$ss - ex$ss, cf$g - ex$g, cf$ems - ex$ems)))
}
outer(X = 5:9, Y = 1:4, FUN = Vectorize(check))
```

                 [,1]         [,2]         [,3]         [,4]
    [1,] 1.250555e-12 5.343281e-12 1.557510e-11 6.281198e-12
    [2,] 3.410605e-12 7.730705e-12 1.011813e-11 1.318767e-11
    [3,] 1.227818e-11 1.273293e-11 4.473577e-11 1.705303e-11
    [4,] 4.718004e-11 1.818989e-12 3.365130e-11 1.000444e-11
    [5,] 4.484946e-11 1.114131e-11 2.683009e-11 9.549694e-12

The largest difference is of the order of rounding error for every
number of parents and method.

## 3 Sums of squares against a linear model

``` r

p <-
  PartialDiallel(
      y      = y
    , Rep    = Rep
    , Cross1 = Cross1
    , Cross2 = Cross2
    , data   = PartialDiallelData
    )
a <- anova(lm(formula = y ~ factor(Rep) + factor(Cross1) * factor(Cross2), data = PartialDiallelData))
cbind(package = p$ANOVA[c("GCA I", "GCA II", "SCA", "Error"), "Sum Sq"], lm = a[2:5, "Sum Sq"])
```

           package        lm
    [1,]  58.54176  58.54176
    [2,]  43.05313  43.05313
    [3,]  43.17996  43.17996
    [4,] 158.16721 158.16720

## 4 Results that changed

The examples of every help page of version 0.6.0 were run with both
versions; all results agree except these corrections:

| Function | Result | Change |
|----|----|----|
| [`Griffing()`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md), Model 1 | `StdErr` | standard errors use the error mean square; 0.6.0 used the replicate mean square |
| [`Griffing()`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md), Method 2 | `StdErr` | standard errors of \\\hat{S}\_{ii}\\ and \\\hat{S}\_{ij}\\ were swapped in 0.6.0 |
| [`Griffing()`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md), Method 4 | `StdErr` | the third value (a Method 1 formula) is `NA` |
| [`Griffing()`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md), Method 4 | `Means` | all parents in rows and columns (0.6.0: 7 x 7, misaligned labels) |
| [`Griffing()`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md), Model 2, Methods 1, 3 | `ANOVA` | p-value of the reciprocal line on the error degrees of freedom |
| [`Hayman()`](https://myaseen208.com/DiallelAnalysisR/reference/Hayman.md) | `ANOVA` | lines \\b\\, \\b_3\\, \\d\\ divide by 4 where 0.6.0 divided by the number of replicates (equal only with 4 replicates) |
| [`Hayman()`](https://myaseen208.com/DiallelAnalysisR/reference/Hayman.md) | components | \\H_2 = 4V\_{1L1} - 4V\_{0L1} - 2E\\ (0.6.0 added \\4V\_{0L1}\\); \\W_r\\ and \\V_r\\ from the reciprocal-averaged table |
| [`Hayman()`](https://myaseen208.com/DiallelAnalysisR/reference/Hayman.md) | arguments | the column arguments are used (0.6.0 read `Cross1`, `Cross2` by name) |
| [`PartialDiallel()`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallel.md) | arguments | the column arguments are used (0.6.0 read `y`, `Rep`, `Cross1`, `Cross2` by name) |
| [`PartialDiallel()`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallel.md) | `ANOVA` | error line on the plot scale (0.6.0 divided it by the number of replicates, inflating every \\F\\) |
| [`PartialDiallel()`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallel.md) | components | variance components (0.6.0 gave differences of mean squares) |

The size of the first correction for this data set:

``` r

f <-
  Griffing(
      y          = Yield
    , Rep        = Rep
    , Cross1     = Cross1
    , Cross2     = Cross2
    , data       = GriffingData1
    , Method     = 1
    , Model      = 1
    , Reciprocal = c("combined", "split")[1]
    )
ms <- f$RCBD[c("Rep", "Residuals"), "Mean Sq"]
round(x = cbind(`1.0.0` = f$StdErr, `0.6.0` = f$StdErr * sqrt(ms[1] / ms[2])), digits = 3)
```

            1.0.0  0.6.0
    gi      1.255  2.173
    sii     4.694  8.131
    sij     3.353  5.808
    rij     3.793  6.571
    gi_gj   1.897  3.285
    sii_sjj 6.570 11.381
    sii_sij 6.290 10.896
    sii_sjk 5.690  9.856
    sij_sik 5.018  8.692
    sij_skl 4.646  8.047
    rij_rkl 5.364  9.292

## 5 Published values: Griffing (1956)

The checks above compare the package with exact computations. The
numerical example of Griffing (1956) adds a comparison with the
published tables: the means of 36 maize crosses in Table 6 (data set
`Griffing56`), analysed with Method 4 from the table of means by
[`GriffingMeans()`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingMeans.md)
with the error mean squares of Table 7 divided by the 78 plants of a
cross mean. The file `reference.csv` of the package holds 77 values from
Tables 8, 9, 10 and 13: mean squares, variance components and standard
errors of Model I and Model II for total yield, cob weight and shelled
corn.
[`da_reference()`](https://myaseen208.com/DiallelAnalysisR/reference/da_reference.md)
recomputes each of them:

``` r

ref <-
  da_reference(
      source   = "Griffing"
    , evaluate = TRUE
    , level    = 1
    )
nrow(ref)
```

    [1] 77

``` r

table(ref$agrees)
```

    FALSE  TRUE
       13    64 

The values that differ do so in the last printed digit, because Table 6
prints the means to one decimal place while Griffing worked from
unrounded means:

``` r

ref <- as.data.frame(x = ref)
d <- ref[!ref$agrees, c("quantity", "value", "computed")]
d$difference <- round(x = d$computed - d$value, digits = 3)
d$computed <- round(x = d$computed, digits = 2)
d
```

                           quantity   value computed difference
    1  X1 mean square gca (Model I) 2325.74  2325.75      0.007
    4    X1 sca component (Model I)  318.39   318.38     -0.008
    25 X1 sca effect of cross 8 x 9   -5.85    -5.84      0.007
    33    X2 gca effect of parent 2   -5.48    -5.47      0.005
    43           X2 SE(s_ij - s_kl)    0.93     0.92     -0.006
    49 X2 sca effect of cross 5 x 6   -5.25    -5.26     -0.007
    52      X2 sigma^2_s (Model II)    3.97     3.96     -0.005
    55   X3 gca component (Model I)  276.09   276.10      0.005
    70 X3 sca effect of cross 1 x 3   12.55    12.54     -0.007
    72 X3 sca effect of cross 3 x 4  -24.85   -24.86     -0.007
    74 X3 sca effect of cross 5 x 6  -30.91   -30.90      0.010
    76    X3 2 sigma^2_g (Model II)  482.32   482.33      0.012
    77      X3 sigma^2_s (Model II)  144.38   144.39      0.006

``` r

max(abs(d$difference))
```

    [1] 0.012

A few rows in full, for the total yield:

``` r

x1 <- ref[grepl(pattern = "^X1", x = ref$quantity), c("quantity", "value", "computed")]
x1$computed <- round(x = x1$computed, digits = 2)
head(x = x1, n = 10)
```

                           quantity   value computed
    1  X1 mean square gca (Model I) 2325.74  2325.75
    2  X1 mean square sca (Model I)  339.44   339.44
    3    X1 gca component (Model I)  329.24   329.24
    4    X1 sca component (Model I)  318.39   318.38
    5     X1 gca effect of parent 1    9.35     9.35
    6     X1 gca effect of parent 2  -20.65   -20.65
    7     X1 gca effect of parent 3  -10.16   -10.16
    8     X1 gca effect of parent 4  -22.55   -22.55
    9     X1 gca effect of parent 5   -1.51    -1.51
    10    X1 gca effect of parent 6   -1.89    -1.89

Only Griffing’s own tables are used: the values printed in a book can be
compared in the same way by adding rows to `reference.csv` (a call, the
expression that extracts the number, the printed value and its number of
decimals).

## 6 Summary

The analyses of variance, effects and components of version 0.6.0 are
confirmed wherever they were right; the corrections above concern
standard errors, three lines of Hayman’s analysis with other than four
replicates, two genetic components and the use of the column arguments.

## 7 References

Griffing, B. (1956). Concept of general and specific combining ability
in relation to diallel crossing systems. *Australian Journal of
Biological Sciences*, 9(4), 463–493.

Hayman, B. I. (1954). The theory and analysis of diallel crosses.
*Genetics*, 39(6), 789–809.

Hayman, B. I. (1954). The analysis of variance of diallel tables.
*Biometrics*, 10(2), 235–244.
