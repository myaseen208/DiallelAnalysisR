# Griffing’s methods with random effects

\\ \newcommand{\mY}{\mathbf{Y}} \newcommand{\mT}{\mathbf{T}}
\newcommand{\mS}{\mathbf{S}} \newcommand{\mR}{\mathbf{R}}
\newcommand{\vg}{\mathbf{g}} \newcommand{\E}{\mathrm{E}}
\newcommand{\Var}{\mathrm{Var}} \newcommand{\Cov}{\mathrm{Cov}} \\

## 1 Abstract

With random effects (Model 2), Griffing’s analysis estimates the
variances of general and specific combining ability and, through them,
the additive and dominance variances of the population the parents come
from.

## 2 Variance components

``` r

r1 <-
  Griffing(
      y          = Yield
    , Rep        = Rep
    , Cross1     = Cross1
    , Cross2     = Cross2
    , data       = GriffingData1
    , Method     = 1
    , Model      = 2
    , Reciprocal = c("combined", "split")[1]
    )
knitr::kable(x = r1$ANOVA, digits = 3)
```

|             |  Df |    Sum Sq | Mean Sq | F value | Pr(\>F) |
|:------------|----:|----------:|--------:|--------:|--------:|
| gca         |   7 |  3804.643 | 543.520 |   0.690 |   0.680 |
| sca         |  28 | 22060.789 | 787.885 |  27.378 |   0.000 |
| reciprocals |  28 |   365.537 |  13.055 |   0.454 |   0.992 |
| Error       | 189 |  5438.991 |  28.778 |      NA |      NA |

``` r

knitr::kable(x = r1$Genetic.Components, digits = 3)
```

|            | Components |
|:-----------|-----------:|
| gca        |    -14.440 |
| sca        |    426.166 |
| Reciprocal |     -7.861 |
| Error      |     28.778 |
| Additive   |    -28.881 |
| Dominant   |    426.166 |
| gca/sca    |     -0.034 |

In the random model gca is tested against sca (the mean square that
contains every term of \\\E(MS_g)\\ except \\\sigma^2_g\\), and sca and
reciprocals against the error.

## 3 All four methods

``` r

comp <-
  sapply(
      X   = 1:4
    , FUN = function(m) {
        f <-
          Griffing(
              y          = Yield
            , Rep        = Rep
            , Cross1     = Cross1
            , Cross2     = Cross2
            , data       = get(paste0("GriffingData", m))
            , Method     = m
            , Model      = 2
            , Reciprocal = c("combined", "split")[1]
            )
        f$Genetic.Components[c("gca", "sca", "Error"), "Components"]
      }
    )
dimnames(comp) <- list(c("gca", "sca", "Error"), paste("Method", 1:4))
round(x = comp, digits = 2)
```

          Method 1 Method 2 Method 3 Method 4
    gca     -14.44   -18.31    -9.59    -3.09
    sca     426.17   419.55   443.24   434.04
    Error    28.78    27.92    30.33    31.19

The variance of sca is far larger than that of gca in every method: in
this material most of the variation among crosses is non-additive. A
negative estimate (here gca) means that the true component is small; it
is reported as computed so that the analysis of variance and the
components stay consistent.

## 4 Additive and dominance variance

For non-inbred parents without epistasis \\\sigma^2_A = 2\sigma^2_g\\
and \\\sigma^2_D = \sigma^2_s\\; their ratio, and the ratio
\\\sigma^2_g/\sigma^2_s\\ (also called the predictability ratio),
indicate how far selection on parental performance can predict the
crosses.

``` r

r1$Genetic.Components[c("Additive", "Dominant", "gca/sca"), , drop = FALSE]
```

              Components
    Additive -28.8809045
    Dominant 426.1656570
    gca/sca   -0.0338846

## 5 Summary

Model 2 answers a question about a population (how much additive and
dominance variance) rather than about the parents tested; its components
come from the expected mean squares of vignette 03.

## 6 References

Griffing, B. (1956). Concept of general and specific combining ability
in relation to diallel crossing systems. *Australian Journal of
Biological Sciences*, 9(4), 463–493.

Singh, R. K. and Chaudhary, B. D. (2004). *Biometrical Methods in
Quantitative Genetic Analysis*. Kalyani Publishers, New Delhi.
