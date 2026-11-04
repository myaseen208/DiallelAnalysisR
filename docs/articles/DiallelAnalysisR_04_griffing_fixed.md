# Griffing’s methods with fixed effects

\\ \newcommand{\mY}{\mathbf{Y}} \newcommand{\mT}{\mathbf{T}}
\newcommand{\mS}{\mathbf{S}} \newcommand{\mR}{\mathbf{R}}
\newcommand{\vg}{\mathbf{g}} \newcommand{\E}{\mathrm{E}}
\newcommand{\Var}{\mathrm{Var}} \newcommand{\Cov}{\mathrm{Cov}} \\

## 1 Abstract

Griffing’s four methods with the fixed-effects model (Model 1): the
analysis of variance, the gca, sca and reciprocal effects, their
standard errors and how to compare parents and crosses.

## 2 The four methods on one data set

The data sets for Methods 2 to 4 are subsets of the complete diallel, so
the methods can be compared directly.

``` r

fits <-
  lapply(
      X   = 1:4
    , FUN = function(m) Griffing(
          y          = Yield
        , Rep        = Rep
        , Cross1     = Cross1
        , Cross2     = Cross2
        , data       = get(paste0("GriffingData", m))
        , Method     = m
        , Model      = 1
        , Reciprocal = c("combined", "split")[1]
        )
    )
names(fits) <- paste("Method", 1:4)
do.call(
    what = rbind
  , args = lapply(X = fits, FUN = function(f) f$ANOVA[c("gca", "sca"), "Mean Sq"])
  )
```

                 [,1]     [,2]
    Method 1 543.5204 787.8853
    Method 2 264.4133 447.4681
    Method 3 801.7759 916.8174
    Method 4 446.6969 465.2278

## 3 Method 1: parents, \\F_1\\ and reciprocals

With \\a_i = Y\_{i\cdot} + Y\_{\cdot i}\\ and \\Y\_{\cdot\cdot}\\ the
grand total, \\ SS_g = \frac{1}{2P}\sum_i a_i^2 -
\frac{2}{P^2}Y\_{\cdot\cdot}^2, \qquad \hat{g}\_i = \frac{a_i}{2P} -
\frac{Y\_{\cdot\cdot}}{P^2}, \qquad \hat{R}\_{ij} = \frac{Y\_{ij} -
Y\_{ji}}{2} . \\

``` r

f1 <- fits[["Method 1"]]
knitr::kable(x = f1$ANOVA, digits = 3)
```

|             |  Df |    Sum Sq | Mean Sq | F value | Pr(\>F) |
|:------------|----:|----------:|--------:|--------:|--------:|
| gca         |   7 |  3804.643 | 543.520 |  18.887 |   0.000 |
| sca         |  28 | 22060.789 | 787.885 |  27.378 |   0.000 |
| reciprocals |  28 |   365.537 |  13.055 |   0.454 |   0.992 |
| Error       | 189 |  5438.991 |  28.778 |      NA |      NA |

``` r

knitr::kable(x = f1$Genetic.Components, digits = 4)
```

|            | Components |
|:-----------|-----------:|
| gca        |    32.1714 |
| sca        |   759.1076 |
| Reciprocal |    -7.8614 |
| gca/sca    |     0.0424 |

The table `Effects` keeps the layout of earlier versions: gca effects on
the diagonal, sca effects above it and reciprocal effects below it. The
full matrices are in `SCA` and `Reciprocal`:

``` r

round(x = f1$Effects, digits = 2)
```

          1     2     3     4     5      6      7      8
    1  0.06 -7.43 -3.49 29.66 27.30 -20.18  10.41 -31.03
    2  3.16  0.47  7.82  0.96 12.52 -17.00  -5.72   2.28
    3 -5.89  3.51  9.03  5.32 -6.17   2.39   2.98  25.89
    4 -2.09 -0.57 -1.02 -3.44 -0.65  21.85 -33.50 -31.42
    5  4.50 -1.48  3.01  0.95 -2.33  -0.43 -15.32  14.74
    6 -0.14  0.98  0.65 -1.43 -1.91  -1.93  22.59 -22.73
    7 -0.81  4.91  1.55  3.40  1.59   2.97   7.24  32.83
    8  1.96  1.25  1.17  0.06  0.75  -3.25   3.55  -9.10

``` r

round(x = f1$SCA[1:4, 1:4], digits = 2)
```

          1     2      3     4
    1 -5.23 -7.43  -3.49 29.66
    2 -7.43  6.58   7.82  0.96
    3 -3.49  7.82 -34.73  5.32
    4 29.66  0.96   5.32  7.77

## 4 Standard errors and comparisons

`StdErr` gives the standard errors of single effects and of differences
between effects; for Method 1 \\\Var(\hat{g}\_i) =
(P-1)\sigma^2_m/(2P^2)\\ and \\\Var(\hat{g}\_i - \hat{g}\_j) =
\sigma^2_m/P\\.

``` r

round(x = f1$StdErr, digits = 3)
```

         gi     sii     sij     rij   gi_gj sii_sjj sii_sij sii_sjk sij_sik sij_skl
      1.255   4.694   3.353   3.793   1.897   6.570   6.290   5.690   5.018   4.646
    rij_rkl
      5.364 

``` r

t_gca <- f1$GCA / f1$StdErr[["gi"]]
round(x = t_gca, digits = 2)
```

        1     2     3     4     5     6     7     8
     0.05  0.37  7.20 -2.74 -1.85 -1.54  5.77 -7.25 

A parent’s gca effect is significant at the 5% level when \\\|t\|\\
exceeds the \\t\\ quantile on the error degrees of freedom:

``` r

qt(p = 0.975, df = f1$ANOVA["Error", "Df"])
```

    [1] 1.972595

## 5 Predicting crosses from general combining ability

Under the fixed model a cross is predicted by \\\hat{\mu} + \hat{g}\_i +
\hat{g}\_j\\ from the gca effects alone (the prediction for a cross not
yet made) or by adding \\\hat{S}\_{ij} + \hat{R}\_{ij}\\ (which
reproduces the observed mean). The gap between the two is the specific
combining ability of the cross:

``` r

pr_g <- predict(object = f1, newdata = NULL, type = c("gca", "full")[1])
pr_f <- predict(object = f1, newdata = NULL, type = c("gca", "full")[2])
pr <- merge(x = pr_g, y = pr_f, by = c("Cross1", "Cross2"), suffixes = c("_gca", "_full"))
head(pr[order(-predicted_full)], 8)
```

       Cross1 Cross2 predicted_gca predicted_full
       <char> <char>         <num>          <num>
    1:      7      8      88.89031        125.270
    2:      6      7      96.05125        121.610
    3:      1      5      88.48500        120.290
    4:      4      1      87.37250        119.115
    5:      8      7      88.89031        118.170
    6:      3      8      90.67953        117.735
    7:      7      6      96.05125        115.670
    8:      8      3      90.67953        115.400

## 6 Methods 2, 3 and 4

``` r

knitr::kable(x = fits[["Method 2"]]$ANOVA, digits = 3)
```

|       |  Df |    Sum Sq | Mean Sq | F value | Pr(\>F) |
|:------|----:|----------:|--------:|--------:|--------:|
| gca   |   7 |  1850.893 | 264.413 |   9.470 |       0 |
| sca   |  28 | 12529.107 | 447.468 |  16.026 |       0 |
| Error | 105 |  2931.770 |  27.922 |      NA |      NA |

``` r

knitr::kable(x = fits[["Method 3"]]$ANOVA, digits = 3)
```

|             |  Df |    Sum Sq | Mean Sq | F value | Pr(\>F) |
|:------------|----:|----------:|--------:|--------:|--------:|
| gca         |   7 |  5612.432 | 801.776 |  26.434 |   0.000 |
| sca         |  20 | 18336.349 | 916.817 |  30.227 |   0.000 |
| reciprocals |  28 |   365.537 |  13.055 |   0.430 |   0.995 |
| Error       | 165 |  5004.571 |  30.331 |      NA |      NA |

``` r

knitr::kable(x = fits[["Method 4"]]$ANOVA, digits = 3)
```

|       |  Df |   Sum Sq | Mean Sq | F value | Pr(\>F) |
|:------|----:|---------:|--------:|--------:|--------:|
| gca   |   7 | 3126.878 | 446.697 |  14.323 |       0 |
| sca   |  20 | 9304.556 | 465.228 |  14.917 |       0 |
| Error |  81 | 2526.151 |  31.187 |      NA |      NA |

``` r

round(
    x      = rbind(
        Method1 = fits[[1]]$GCA
      , Method2 = fits[[2]]$GCA
      , Method3 = fits[[3]]$GCA
      , Method4 = fits[[4]]$GCA
      )
  , digits = 2
  )
```

                1     2     3     4     5     6     7      8
    Method1  0.06  0.47  9.03 -3.44 -2.33 -1.93  7.24  -9.10
    Method2 -0.31  2.38  5.93 -2.65 -4.71 -0.72  7.60  -7.52
    Method3 -0.09 -1.65 13.80 -5.75  1.99 -5.21  8.60 -11.69
    Method4 -0.86 -0.58 13.40 -6.76  2.33 -6.45 10.57 -11.66

The best general combiners (parents 3 and 7) and the poorest (parent 8)
are the same in all four methods; including the parents themselves
(Methods 1, 2) or the reciprocals (Methods 1, 3) changes the size of the
effects and the order of the parents in between.

## 7 Plots

``` r

plot(fits[["Method 2"]])
```

![](data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0nVVRGLTgnID8+CjxzdmcgeG1sbnM9J2h0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnJyB4bWxuczp4bGluaz0naHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluaycgd2lkdGg9JzUwNC4wMHB0JyBoZWlnaHQ9JzMwMi40MHB0JyB2aWV3Qm94PScwIDAgNTA0LjAwIDMwMi40MCc+CjxnIGNsYXNzPSdzdmdsaXRlJz4KPGRlZnM+CiAgPHN0eWxlIHR5cGU9J3RleHQvY3NzJz48IVtDREFUQVsKICAgIC5zdmdsaXRlIGxpbmUsIC5zdmdsaXRlIHBvbHlsaW5lLCAuc3ZnbGl0ZSBwb2x5Z29uLCAuc3ZnbGl0ZSBwYXRoLCAuc3ZnbGl0ZSByZWN0LCAuc3ZnbGl0ZSBjaXJjbGUgewogICAgICBmaWxsOiBub25lOwogICAgICBzdHJva2U6ICMwMDAwMDA7CiAgICAgIHN0cm9rZS1saW5lY2FwOiByb3VuZDsKICAgICAgc3Ryb2tlLWxpbmVqb2luOiByb3VuZDsKICAgICAgc3Ryb2tlLW1pdGVybGltaXQ6IDEwLjAwOwogICAgfQogICAgLnN2Z2xpdGUgdGV4dCB7CiAgICAgIHdoaXRlLXNwYWNlOiBwcmU7CiAgICB9CiAgICAuc3ZnbGl0ZSBnLmdseXBoZ3JvdXAgcGF0aCB7CiAgICAgIGZpbGw6IGluaGVyaXQ7CiAgICAgIHN0cm9rZTogbm9uZTsKICAgIH0KICBdXT48L3N0eWxlPgo8L2RlZnM+CjxyZWN0IHdpZHRoPScxMDAlJyBoZWlnaHQ9JzEwMCUnIHN0eWxlPSdzdHJva2U6IG5vbmU7IGZpbGw6ICNGRkZGRkY7Jy8+CjxkZWZzPgogIDxjbGlwUGF0aCBpZD0nY3BNQzR3TUh3MU1EUXVNREI4TUM0d01Id3pNREl1TkRBPSc+CiAgICA8cmVjdCB4PScwLjAwJyB5PScwLjAwJyB3aWR0aD0nNTA0LjAwJyBoZWlnaHQ9JzMwMi40MCcgLz4KICA8L2NsaXBQYXRoPgo8L2RlZnM+CjxnIGNsaXAtcGF0aD0ndXJsKCNjcE1DNHdNSHcxTURRdU1EQjhNQzR3TUh3ek1ESXVOREE9KSc+CjxyZWN0IHg9Jy0wLjAwMDAwMDAwMDAwMDA2NCcgeT0nMC4wMCcgd2lkdGg9JzUwNC4wMCcgaGVpZ2h0PSczMDIuNDAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDEuMDc7IHN0cm9rZTogI0ZGRkZGRjsgZmlsbDogI0ZGRkZGRjsnIC8+CjwvZz4KPGRlZnM+CiAgPGNsaXBQYXRoIGlkPSdjcE16a3VNRFY4TkRrd0xqQTFmREl6TGpFemZESTJOeTQ0TWc9PSc+CiAgICA8cmVjdCB4PSczOS4wNScgeT0nMjMuMTMnIHdpZHRoPSc0NTEuMDEnIGhlaWdodD0nMjQ0LjY5JyAvPgogIDwvY2xpcFBhdGg+CjwvZGVmcz4KPGcgY2xpcC1wYXRoPSd1cmwoI2NwTXprdU1EVjhORGt3TGpBMWZESXpMakV6ZkRJMk55NDRNZz09KSc+CjxyZWN0IHg9JzM5LjA1JyB5PScyMy4xMycgd2lkdGg9JzQ1MS4wMScgaGVpZ2h0PScyNDQuNjknIHN0eWxlPSdzdHJva2Utd2lkdGg6IDEuMDc7IHN0cm9rZTogbm9uZTsgZmlsbDogI0ZGRkZGRjsnIC8+CjxsaW5lIHgxPSczOS4wNScgeTE9JzE0NS45NycgeDI9JzQ5MC4wNScgeTI9JzE0NS45Nycgc3R5bGU9J3N0cm9rZS13aWR0aDogMC42NDsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cmVjdCB4PSc1Mi44MCcgeT0nMTQ1Ljk3JyB3aWR0aD0nMzguNTAnIGhlaWdodD0nMy44Micgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlOiBub25lOyBzdHJva2UtbGluZWNhcDogYnV0dDsgc3Ryb2tlLWxpbmVqb2luOiBtaXRlcjsgZmlsbDogIzFGNEU5RTsnIC8+CjxyZWN0IHg9JzEwNy44MCcgeT0nMTE2Ljk2JyB3aWR0aD0nMzguNTAnIGhlaWdodD0nMjkuMDAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDEuMDc7IHN0cm9rZTogbm9uZTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7IHN0cm9rZS1saW5lam9pbjogbWl0ZXI7IGZpbGw6ICMxRjRFOUU7JyAvPgo8cmVjdCB4PScxNjIuODAnIHk9JzczLjcxJyB3aWR0aD0nMzguNTAnIGhlaWdodD0nNzIuMjYnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDEuMDc7IHN0cm9rZTogbm9uZTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7IHN0cm9rZS1saW5lam9pbjogbWl0ZXI7IGZpbGw6ICMxRjRFOUU7JyAvPgo8cmVjdCB4PScyMTcuODAnIHk9JzE0NS45Nycgd2lkdGg9JzM4LjUwJyBoZWlnaHQ9JzMyLjMzJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAxLjA3OyBzdHJva2U6IG5vbmU7IHN0cm9rZS1saW5lY2FwOiBidXR0OyBzdHJva2UtbGluZWpvaW46IG1pdGVyOyBmaWxsOiAjMUY0RTlFOycgLz4KPHJlY3QgeD0nMjcyLjgwJyB5PScxNDUuOTcnIHdpZHRoPSczOC41MCcgaGVpZ2h0PSc1Ny4zNCcgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlOiBub25lOyBzdHJva2UtbGluZWNhcDogYnV0dDsgc3Ryb2tlLWxpbmVqb2luOiBtaXRlcjsgZmlsbDogIzFGNEU5RTsnIC8+CjxyZWN0IHg9JzMyNy44MCcgeT0nMTQ1Ljk3JyB3aWR0aD0nMzguNTAnIGhlaWdodD0nOC43NScgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlOiBub25lOyBzdHJva2UtbGluZWNhcDogYnV0dDsgc3Ryb2tlLWxpbmVqb2luOiBtaXRlcjsgZmlsbDogIzFGNEU5RTsnIC8+CjxyZWN0IHg9JzM4Mi44MCcgeT0nNTMuMzAnIHdpZHRoPSczOC41MCcgaGVpZ2h0PSc5Mi42Nycgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlOiBub25lOyBzdHJva2UtbGluZWNhcDogYnV0dDsgc3Ryb2tlLWxpbmVqb2luOiBtaXRlcjsgZmlsbDogIzFGNEU5RTsnIC8+CjxyZWN0IHg9JzQzNy44MCcgeT0nMTQ1Ljk3JyB3aWR0aD0nMzguNTAnIGhlaWdodD0nOTEuNjknIHN0eWxlPSdzdHJva2Utd2lkdGg6IDEuMDc7IHN0cm9rZTogbm9uZTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7IHN0cm9rZS1saW5lam9pbjogbWl0ZXI7IGZpbGw6ICMxRjRFOUU7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc2NS4xNywxMzAuNzQgNzguOTIsMTMwLjc0ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc3Mi4wNSwxMzAuNzQgNzIuMDUsMTY4LjgzICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc2NS4xNywxNjguODMgNzguOTIsMTY4LjgzICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPScxMjAuMTcsOTcuOTIgMTMzLjkyLDk3LjkyICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPScxMjcuMDUsOTcuOTIgMTI3LjA1LDEzNi4wMSAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDEuMDc7IHN0cm9rZS1saW5lY2FwOiBidXR0OycgLz4KPHBvbHlsaW5lIHBvaW50cz0nMTIwLjE3LDEzNi4wMSAxMzMuOTIsMTM2LjAxICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPScxNzUuMTcsNTQuNjYgMTg4LjkyLDU0LjY2ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPScxODIuMDUsNTQuNjYgMTgyLjA1LDkyLjc1ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPScxNzUuMTcsOTIuNzUgMTg4LjkyLDkyLjc1ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPScyMzAuMTcsMTU5LjI1IDI0My45MiwxNTkuMjUgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAxLjA3OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzIzNy4wNSwxNTkuMjUgMjM3LjA1LDE5Ny4zNCAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDEuMDc7IHN0cm9rZS1saW5lY2FwOiBidXR0OycgLz4KPHBvbHlsaW5lIHBvaW50cz0nMjMwLjE3LDE5Ny4zNCAyNDMuOTIsMTk3LjM0ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPScyODUuMTcsMTg0LjI2IDI5OC45MiwxODQuMjYgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAxLjA3OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzI5Mi4wNSwxODQuMjYgMjkyLjA1LDIyMi4zNSAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDEuMDc7IHN0cm9rZS1saW5lY2FwOiBidXR0OycgLz4KPHBvbHlsaW5lIHBvaW50cz0nMjg1LjE3LDIyMi4zNSAyOTguOTIsMjIyLjM1ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSczNDAuMTcsMTM1LjY3IDM1My45MywxMzUuNjcgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAxLjA3OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzM0Ny4wNSwxMzUuNjcgMzQ3LjA1LDE3My43NiAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDEuMDc7IHN0cm9rZS1saW5lY2FwOiBidXR0OycgLz4KPHBvbHlsaW5lIHBvaW50cz0nMzQwLjE3LDE3My43NiAzNTMuOTMsMTczLjc2ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSczOTUuMTgsMzQuMjYgNDA4LjkzLDM0LjI2ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc0MDIuMDUsMzQuMjYgNDAyLjA1LDcyLjM1ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSczOTUuMTgsNzIuMzUgNDA4LjkzLDcyLjM1ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc0NTAuMTgsMjE4LjYxIDQ2My45MywyMTguNjEgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAxLjA3OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzQ1Ny4wNSwyMTguNjEgNDU3LjA1LDI1Ni43MCAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDEuMDc7IHN0cm9rZS1saW5lY2FwOiBidXR0OycgLz4KPHBvbHlsaW5lIHBvaW50cz0nNDUwLjE4LDI1Ni43MCA0NjMuOTMsMjU2LjcwICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8L2c+CjxnIGNsaXAtcGF0aD0ndXJsKCNjcE1DNHdNSHcxTURRdU1EQjhNQzR3TUh3ek1ESXVOREE9KSc+Cjxwb2x5bGluZSBwb2ludHM9JzM5LjA1LDI2Ny44MiAzOS4wNSwyMy4xMyAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDAuODU7IHN0cm9rZS1saW5lY2FwOiBzcXVhcmU7JyAvPgo8dGV4dCB4PSczMy41NycgeT0nMjcxLjA5JyB0ZXh0LWFuY2hvcj0nZW5kJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzEzLjE3cHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+LTEwPC90ZXh0Pgo8dGV4dCB4PSczMy41NycgeT0nMjQ2LjcyJyB0ZXh0LWFuY2hvcj0nZW5kJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzguMjNweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz4tODwvdGV4dD4KPHRleHQgeD0nMzMuNTcnIHk9JzIyMi4zNScgdGV4dC1hbmNob3I9J2VuZCcgc3R5bGU9J2ZvbnQtc2l6ZTogOS45MHB4OyBmb250LWZhbWlseTogIk5pbWJ1cyBSb21hbiI7JyB0ZXh0TGVuZ3RoPSc4LjIzcHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+LTY8L3RleHQ+Cjx0ZXh0IHg9JzMzLjU3JyB5PScxOTcuOTgnIHRleHQtYW5jaG9yPSdlbmQnIHN0eWxlPSdmb250LXNpemU6IDkuOTBweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nOC4yM3B4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPi00PC90ZXh0Pgo8dGV4dCB4PSczMy41NycgeT0nMTczLjYxJyB0ZXh0LWFuY2hvcj0nZW5kJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzguMjNweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz4tMjwvdGV4dD4KPHRleHQgeD0nMzMuNTcnIHk9JzE0OS4yNCcgdGV4dC1hbmNob3I9J2VuZCcgc3R5bGU9J2ZvbnQtc2l6ZTogOS45MHB4OyBmb250LWZhbWlseTogIk5pbWJ1cyBSb21hbiI7JyB0ZXh0TGVuZ3RoPSc0Ljk0cHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+MDwvdGV4dD4KPHRleHQgeD0nMzMuNTcnIHk9JzEyNC44NycgdGV4dC1hbmNob3I9J2VuZCcgc3R5bGU9J2ZvbnQtc2l6ZTogOS45MHB4OyBmb250LWZhbWlseTogIk5pbWJ1cyBSb21hbiI7JyB0ZXh0TGVuZ3RoPSc0Ljk0cHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+MjwvdGV4dD4KPHRleHQgeD0nMzMuNTcnIHk9JzEwMC41MCcgdGV4dC1hbmNob3I9J2VuZCcgc3R5bGU9J2ZvbnQtc2l6ZTogOS45MHB4OyBmb250LWZhbWlseTogIk5pbWJ1cyBSb21hbiI7JyB0ZXh0TGVuZ3RoPSc0Ljk0cHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+NDwvdGV4dD4KPHRleHQgeD0nMzMuNTcnIHk9Jzc2LjEzJyB0ZXh0LWFuY2hvcj0nZW5kJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzQuOTRweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz42PC90ZXh0Pgo8dGV4dCB4PSczMy41NycgeT0nNTEuNzYnIHRleHQtYW5jaG9yPSdlbmQnIHN0eWxlPSdmb250LXNpemU6IDkuOTBweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nNC45NHB4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPjg8L3RleHQ+Cjx0ZXh0IHg9JzMzLjU3JyB5PScyNy4zOScgdGV4dC1hbmNob3I9J2VuZCcgc3R5bGU9J2ZvbnQtc2l6ZTogOS45MHB4OyBmb250LWZhbWlseTogIk5pbWJ1cyBSb21hbiI7JyB0ZXh0TGVuZ3RoPSc5Ljg4cHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+MTA8L3RleHQ+Cjxwb2x5bGluZSBwb2ludHM9JzQyLjQ1LDI2Ny44MSAzOS4wNSwyNjcuODEgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjg1OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzQyLjQ1LDI0My40NSAzOS4wNSwyNDMuNDUgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjg1OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzQyLjQ1LDIxOS4wOCAzOS4wNSwyMTkuMDggJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjg1OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzQyLjQ1LDE5NC43MSAzOS4wNSwxOTQuNzEgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjg1OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzQyLjQ1LDE3MC4zNCAzOS4wNSwxNzAuMzQgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjg1OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzQyLjQ1LDE0NS45NyAzOS4wNSwxNDUuOTcgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjg1OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzQyLjQ1LDEyMS42MCAzOS4wNSwxMjEuNjAgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjg1OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzQyLjQ1LDk3LjIzIDM5LjA1LDk3LjIzICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc0Mi40NSw3Mi44NiAzOS4wNSw3Mi44NiAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDAuODU7IHN0cm9rZS1saW5lY2FwOiBidXR0OycgLz4KPHBvbHlsaW5lIHBvaW50cz0nNDIuNDUsNDguNDkgMzkuMDUsNDguNDkgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjg1OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzQyLjQ1LDI0LjEyIDM5LjA1LDI0LjEyICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSczOS4wNSwyNjcuODIgNDkwLjA1LDI2Ny44MiAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDAuODU7IHN0cm9rZS1saW5lY2FwOiBzcXVhcmU7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc3Mi4wNSwyNjQuNDIgNzIuMDUsMjY3LjgyICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPScxMjcuMDUsMjY0LjQyIDEyNy4wNSwyNjcuODIgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjg1OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzE4Mi4wNSwyNjQuNDIgMTgyLjA1LDI2Ny44MiAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDAuODU7IHN0cm9rZS1saW5lY2FwOiBidXR0OycgLz4KPHBvbHlsaW5lIHBvaW50cz0nMjM3LjA1LDI2NC40MiAyMzcuMDUsMjY3LjgyICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPScyOTIuMDUsMjY0LjQyIDI5Mi4wNSwyNjcuODIgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjg1OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzM0Ny4wNSwyNjQuNDIgMzQ3LjA1LDI2Ny44MiAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDAuODU7IHN0cm9rZS1saW5lY2FwOiBidXR0OycgLz4KPHBvbHlsaW5lIHBvaW50cz0nNDAyLjA1LDI2NC40MiA0MDIuMDUsMjY3LjgyICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc0NTcuMDUsMjY0LjQyIDQ1Ny4wNSwyNjcuODIgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjg1OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjx0ZXh0IHg9JzcyLjA1JyB5PScyNzkuODUnIHRleHQtYW5jaG9yPSdtaWRkbGUnIHN0eWxlPSdmb250LXNpemU6IDkuOTBweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nNC45NHB4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPjE8L3RleHQ+Cjx0ZXh0IHg9JzEyNy4wNScgeT0nMjc5Ljg1JyB0ZXh0LWFuY2hvcj0nbWlkZGxlJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzQuOTRweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz4yPC90ZXh0Pgo8dGV4dCB4PScxODIuMDUnIHk9JzI3OS44NScgdGV4dC1hbmNob3I9J21pZGRsZScgc3R5bGU9J2ZvbnQtc2l6ZTogOS45MHB4OyBmb250LWZhbWlseTogIk5pbWJ1cyBSb21hbiI7JyB0ZXh0TGVuZ3RoPSc0Ljk0cHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+MzwvdGV4dD4KPHRleHQgeD0nMjM3LjA1JyB5PScyNzkuODUnIHRleHQtYW5jaG9yPSdtaWRkbGUnIHN0eWxlPSdmb250LXNpemU6IDkuOTBweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nNC45NHB4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPjQ8L3RleHQ+Cjx0ZXh0IHg9JzI5Mi4wNScgeT0nMjc5Ljg1JyB0ZXh0LWFuY2hvcj0nbWlkZGxlJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzQuOTRweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz41PC90ZXh0Pgo8dGV4dCB4PSczNDcuMDUnIHk9JzI3OS44NScgdGV4dC1hbmNob3I9J21pZGRsZScgc3R5bGU9J2ZvbnQtc2l6ZTogOS45MHB4OyBmb250LWZhbWlseTogIk5pbWJ1cyBSb21hbiI7JyB0ZXh0TGVuZ3RoPSc0Ljk0cHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+NjwvdGV4dD4KPHRleHQgeD0nNDAyLjA1JyB5PScyNzkuODUnIHRleHQtYW5jaG9yPSdtaWRkbGUnIHN0eWxlPSdmb250LXNpemU6IDkuOTBweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nNC45NHB4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPjc8L3RleHQ+Cjx0ZXh0IHg9JzQ1Ny4wNScgeT0nMjc5Ljg1JyB0ZXh0LWFuY2hvcj0nbWlkZGxlJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzQuOTRweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz44PC90ZXh0Pgo8dGV4dCB4PScyNjQuNTUnIHk9JzI5Mi4wMycgdGV4dC1hbmNob3I9J21pZGRsZScgc3R5bGU9J2ZvbnQtc2l6ZTogMTEuMDBweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nMjcuNDRweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz5wYXJlbnQ8L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0ndHJhbnNsYXRlKDE1LjI1LDE0NS40OCkgcm90YXRlKC05MCknIHRleHQtYW5jaG9yPSdtaWRkbGUnIHN0eWxlPSdmb250LXNpemU6IDExLjAwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzQyLjE3cHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+Z2NhIGVmZmVjdDwvdGV4dD4KPHRleHQgeD0nNy45NycgeT0nMTUuMjUnIHN0eWxlPSdmb250LXNpemU6IDExLjAwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzI3Ni42NHB4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPkdlbmVyYWwgY29tYmluaW5nIGFiaWxpdHkgZWZmZWN0cyAoYmFyczogKy8tIG9uZSBzdGFuZGFyZCBlcnJvcik8L3RleHQ+CjwvZz4KPC9nPgo8L3N2Zz4K)

## 8 Summary

Model 1 gives the effects of each parent and cross with their standard
errors; the `Effects` table keeps the layout of earlier versions and
`GCA`, `SCA`, `Reciprocal` give the effects in full.

## 9 References

Griffing, B. (1956). Concept of general and specific combining ability
in relation to diallel crossing systems. *Australian Journal of
Biological Sciences*, 9(4), 463–493.

Singh, R. K. and Chaudhary, B. D. (2004). *Biometrical Methods in
Quantitative Genetic Analysis*. Kalyani Publishers, New Delhi.
