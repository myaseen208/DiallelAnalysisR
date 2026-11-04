# Hayman’s analysis

\\ \newcommand{\mY}{\mathbf{Y}} \newcommand{\mT}{\mathbf{T}}
\newcommand{\mS}{\mathbf{S}} \newcommand{\mR}{\mathbf{R}}
\newcommand{\vg}{\mathbf{g}} \newcommand{\E}{\mathrm{E}}
\newcommand{\Var}{\mathrm{Var}} \newcommand{\Cov}{\mathrm{Cov}} \\

## 1 Abstract

Hayman’s approach analyses a complete diallel (parents, \\F_1\\ and
reciprocals) for gene action: an analysis of variance that separates
additive, dominance, maternal and reciprocal effects; the variances
\\V_r\\ and covariances \\W_r\\ of the arrays and their graph; the
components \\D\\, \\H_1\\, \\H_2\\, \\F\\, \\h^2\\ and \\E\\; and tests
of the additive-dominance model.

## 2 The analysis

``` r

h <-
  Hayman(
      y      = Yield
    , Rep    = Rep
    , Cross1 = Cross1
    , Cross2 = Cross2
    , data   = HaymanData
    )
knitr::kable(x = h$ANOVA, digits = 3)
```

|              |  Df |     Sum Sq |  Mean Sq | F value | Pr(\>F) |
|:-------------|----:|-----------:|---------:|--------:|--------:|
| Total        | 255 | 127716.027 |       NA |      NA |      NA |
| Rep          |   3 |   1036.192 |  345.397 |   3.001 |   0.032 |
| Treatment    |  63 | 104923.873 | 1665.458 |  14.468 |   0.000 |
| Additive     |   7 |  15218.571 | 2174.082 |  18.887 |   0.000 |
| Non-Additive |  28 |  88243.154 | 3151.541 |  27.378 |   0.000 |
| b1           |   1 |   1367.594 | 1367.594 |  11.881 |   0.001 |
| b2           |   7 |  13530.165 | 1932.881 |  16.791 |   0.000 |
| b3           |  20 |  73345.396 | 3667.270 |  31.859 |   0.000 |
| Maternal     |   7 |    310.737 |   44.391 |   0.386 |   0.910 |
| Reciprocal   |  21 |   1151.411 |   54.829 |   0.476 |   0.976 |
| Error        | 189 |  21755.963 |  115.111 |      NA |      NA |

Line \\b_1\\ tests the mean dominance deviation of the crosses from the
parents (directional dominance), \\b_2\\ whether this deviation differs
among parents, \\b_3\\ the remaining dominance. Maternal and reciprocal
effects are not significant here.

## 3 Arrays: \\V_r\\ and \\W_r\\

After averaging reciprocal crosses, array \\r\\ (the progeny of parent
\\r\\) has variance \\V_r\\ and covariance \\W_r\\ with the parents:

``` r

knitr::kable(x = h$Wr.Vr.Table[, c("Wr", "Vr", "Wr.Minus.Vr", "Wr.Plus.Vr", "Yr")], digits = 2)
```

|      Wr |     Vr | Wr.Minus.Vr | Wr.Plus.Vr |     Yr |
|--------:|-------:|------------:|-----------:|-------:|
| -124.09 | 546.87 |     -670.97 |     422.78 |  85.65 |
|  -98.41 | 129.31 |     -227.72 |      30.90 |  98.26 |
|   97.33 | 171.95 |      -74.62 |     269.28 |  74.07 |
|   39.07 | 549.50 |     -510.43 |     588.57 |  91.64 |
|  155.78 | 317.59 |     -161.81 |     473.37 |  54.10 |
|   43.12 | 455.95 |     -412.83 |     499.08 | 100.39 |
|   44.36 | 428.02 |     -383.67 |     472.38 |  90.96 |
| -160.30 | 824.10 |     -984.40 |     663.80 |  82.00 |

## 4 The \\W_r\\-\\V_r\\ graph

``` r

plot(h)
```

![](data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0nVVRGLTgnID8+CjxzdmcgeG1sbnM9J2h0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnJyB4bWxuczp4bGluaz0naHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluaycgd2lkdGg9JzUwNC4wMHB0JyBoZWlnaHQ9JzM2MC4wMHB0JyB2aWV3Qm94PScwIDAgNTA0LjAwIDM2MC4wMCc+CjxnIGNsYXNzPSdzdmdsaXRlJz4KPGRlZnM+CiAgPHN0eWxlIHR5cGU9J3RleHQvY3NzJz48IVtDREFUQVsKICAgIC5zdmdsaXRlIGxpbmUsIC5zdmdsaXRlIHBvbHlsaW5lLCAuc3ZnbGl0ZSBwb2x5Z29uLCAuc3ZnbGl0ZSBwYXRoLCAuc3ZnbGl0ZSByZWN0LCAuc3ZnbGl0ZSBjaXJjbGUgewogICAgICBmaWxsOiBub25lOwogICAgICBzdHJva2U6ICMwMDAwMDA7CiAgICAgIHN0cm9rZS1saW5lY2FwOiByb3VuZDsKICAgICAgc3Ryb2tlLWxpbmVqb2luOiByb3VuZDsKICAgICAgc3Ryb2tlLW1pdGVybGltaXQ6IDEwLjAwOwogICAgfQogICAgLnN2Z2xpdGUgdGV4dCB7CiAgICAgIHdoaXRlLXNwYWNlOiBwcmU7CiAgICB9CiAgICAuc3ZnbGl0ZSBnLmdseXBoZ3JvdXAgcGF0aCB7CiAgICAgIGZpbGw6IGluaGVyaXQ7CiAgICAgIHN0cm9rZTogbm9uZTsKICAgIH0KICBdXT48L3N0eWxlPgo8L2RlZnM+CjxyZWN0IHdpZHRoPScxMDAlJyBoZWlnaHQ9JzEwMCUnIHN0eWxlPSdzdHJva2U6IG5vbmU7IGZpbGw6ICNGRkZGRkY7Jy8+CjxkZWZzPgogIDxjbGlwUGF0aCBpZD0nY3BNQzR3TUh3MU1EUXVNREI4TUM0d01Id3pOakF1TURBPSc+CiAgICA8cmVjdCB4PScwLjAwJyB5PScwLjAwJyB3aWR0aD0nNTA0LjAwJyBoZWlnaHQ9JzM2MC4wMCcgLz4KICA8L2NsaXBQYXRoPgo8L2RlZnM+CjxnIGNsaXAtcGF0aD0ndXJsKCNjcE1DNHdNSHcxTURRdU1EQjhNQzR3TUh3ek5qQXVNREE9KSc+CjxyZWN0IHg9JzAuMDAnIHk9JzAuMDAnIHdpZHRoPSc1MDQuMDAnIGhlaWdodD0nMzYwLjAwJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAxLjA3OyBzdHJva2U6ICNGRkZGRkY7IGZpbGw6ICNGRkZGRkY7JyAvPgo8L2c+CjxkZWZzPgogIDxjbGlwUGF0aCBpZD0nY3BORFV1TnpKOE5Ea3dMakExZkRJekxqRXpmRE15TXk0Mk9RPT0nPgogICAgPHJlY3QgeD0nNDUuNzInIHk9JzIzLjEzJyB3aWR0aD0nNDQ0LjM0JyBoZWlnaHQ9JzMwMC41NScgLz4KICA8L2NsaXBQYXRoPgo8L2RlZnM+CjxnIGNsaXAtcGF0aD0ndXJsKCNjcE5EVXVOeko4TkRrd0xqQTFmREl6TGpFemZETXlNeTQyT1E9PSknPgo8cmVjdCB4PSc0NS43MicgeT0nMjMuMTMnIHdpZHRoPSc0NDQuMzQnIGhlaWdodD0nMzAwLjU1JyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAxLjA3OyBzdHJva2U6IG5vbmU7IGZpbGw6ICNGRkZGRkY7JyAvPgo8bGluZSB4MT0nNDUuNzInIHkxPScyMzcuMjEnIHgyPSc0OTAuMDUnIHkyPScyMzcuMjEnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDAuNjQ7IHN0cm9rZS1saW5lY2FwOiBidXR0OycgLz4KPGxpbmUgeDE9JzY1LjkxJyB5MT0nMzIzLjY5JyB4Mj0nNjUuOTEnIHkyPScyMy4xMycgc3R5bGU9J3N0cm9rZS13aWR0aDogMC42NDsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc2NS45MSwyMzcuMjEgNjcuOTQsMjIzLjAwIDY5Ljk3LDIxNy4xMiA3Mi4wMCwyMTIuNjAgNzQuMDMsMjA4LjgwIDc2LjA2LDIwNS40NCA3OC4wOSwyMDIuNDEgODAuMTIsMTk5LjYyIDgyLjE1LDE5Ny4wMyA4NC4xOCwxOTQuNTkgODYuMjEsMTkyLjI4IDg4LjI0LDE5MC4wOSA5MC4yNywxODguMDAgOTIuMzAsMTg1Ljk5IDk0LjMzLDE4NC4wNSA5Ni4zNiwxODIuMTkgOTguMzksMTgwLjM4IDEwMC40MiwxNzguNjMgMTAyLjQ1LDE3Ni45NCAxMDQuNDgsMTc1LjI4IDEwNi41MSwxNzMuNjcgMTA4LjU0LDE3Mi4xMSAxMTAuNTcsMTcwLjU3IDExMi42MCwxNjkuMDggMTE0LjYzLDE2Ny42MSAxMTYuNjYsMTY2LjE4IDExOC42OSwxNjQuNzcgMTIwLjcyLDE2My4zOSAxMjIuNzUsMTYyLjAzIDEyNC43OCwxNjAuNzAgMTI2LjgxLDE1OS40MCAxMjguODQsMTU4LjExIDEzMC44NywxNTYuODQgMTMyLjkwLDE1NS42MCAxMzQuOTMsMTU0LjM3IDEzNi45NiwxNTMuMTYgMTM4Ljk5LDE1MS45NyAxNDEuMDIsMTUwLjc5IDE0My4wNSwxNDkuNjMgMTQ1LjA4LDE0OC40OSAxNDcuMTEsMTQ3LjM2IDE0OS4xNCwxNDYuMjQgMTUxLjE3LDE0NS4xNCAxNTMuMjAsMTQ0LjA1IDE1NS4yMywxNDIuOTcgMTU3LjI2LDE0MS45MSAxNTkuMjksMTQwLjg1IDE2MS4zMiwxMzkuODEgMTYzLjM1LDEzOC43OCAxNjUuMzgsMTM3Ljc2IDE2Ny40MSwxMzYuNzUgMTY5LjQ0LDEzNS43NSAxNzEuNDcsMTM0Ljc2IDE3My41MCwxMzMuNzggMTc1LjUzLDEzMi44MSAxNzcuNTYsMTMxLjg1IDE3OS41OSwxMzAuODkgMTgxLjYyLDEyOS45NSAxODMuNjUsMTI5LjAxIDE4NS42OCwxMjguMDggMTg3LjcwLDEyNy4xNiAxODkuNzMsMTI2LjI1IDE5MS43NiwxMjUuMzQgMTkzLjc5LDEyNC40NSAxOTUuODIsMTIzLjU1IDE5Ny44NSwxMjIuNjcgMTk5Ljg4LDEyMS43OSAyMDEuOTEsMTIwLjkyIDIwMy45NCwxMjAuMDYgMjA1Ljk3LDExOS4yMCAyMDguMDAsMTE4LjM1IDIxMC4wMywxMTcuNTAgMjEyLjA2LDExNi42NiAyMTQuMDksMTE1LjgzIDIxNi4xMiwxMTUuMDAgMjE4LjE1LDExNC4xNyAyMjAuMTgsMTEzLjM2IDIyMi4yMSwxMTIuNTQgMjI0LjI0LDExMS43NCAyMjYuMjcsMTEwLjk0IDIyOC4zMCwxMTAuMTQgMjMwLjMzLDEwOS4zNSAyMzIuMzYsMTA4LjU2IDIzNC4zOSwxMDcuNzggMjM2LjQyLDEwNy4wMCAyMzguNDUsMTA2LjIzIDI0MC40OCwxMDUuNDYgMjQyLjUxLDEwNC43MCAyNDQuNTQsMTAzLjk0IDI0Ni41NywxMDMuMTggMjQ4LjYwLDEwMi40MyAyNTAuNjMsMTAxLjY4IDI1Mi42NiwxMDAuOTQgMjU0LjY5LDEwMC4yMCAyNTYuNzIsOTkuNDcgMjU4Ljc1LDk4Ljc0IDI2MC43OCw5OC4wMSAyNjIuODEsOTcuMjkgMjY0Ljg0LDk2LjU3IDI2Ni44Nyw5NS44NSAyNjguOTAsOTUuMTQgMjcwLjkzLDk0LjQzIDI3Mi45Niw5My43MyAyNzQuOTksOTMuMDIgMjc3LjAyLDkyLjMzIDI3OS4wNSw5MS42MyAyODEuMDgsOTAuOTQgMjgzLjExLDkwLjI1IDI4NS4xNCw4OS41NyAyODcuMTcsODguODggMjg5LjIwLDg4LjIxIDI5MS4yMyw4Ny41MyAyOTMuMjYsODYuODYgMjk1LjI5LDg2LjE5IDI5Ny4zMiw4NS41MiAyOTkuMzUsODQuODYgMzAxLjM4LDg0LjIwIDMwMy40MSw4My41NCAzMDUuNDQsODIuODggMzA3LjQ3LDgyLjIzIDMwOS41MCw4MS41OCAzMTEuNTMsODAuOTMgMzEzLjU2LDgwLjI5IDMxNS41OSw3OS42NSAzMTcuNjIsNzkuMDEgMzE5LjY1LDc4LjM3IDMyMS42OCw3Ny43NCAzMjMuNzEsNzcuMTEgMzI1Ljc0LDc2LjQ4IDMyNy43Nyw3NS44NSAzMjkuODAsNzUuMjMgMzMxLjgyLDc0LjYwIDMzMy44NSw3My45OCAzMzUuODgsNzMuMzcgMzM3LjkxLDcyLjc1IDMzOS45NCw3Mi4xNCAzNDEuOTcsNzEuNTMgMzQ0LjAwLDcwLjkyIDM0Ni4wMyw3MC4zMiAzNDguMDYsNjkuNzEgMzUwLjA5LDY5LjExIDM1Mi4xMiw2OC41MSAzNTQuMTUsNjcuOTEgMzU2LjE4LDY3LjMyIDM1OC4yMSw2Ni43MyAzNjAuMjQsNjYuMTMgMzYyLjI3LDY1LjU1IDM2NC4zMCw2NC45NiAzNjYuMzMsNjQuMzcgMzY4LjM2LDYzLjc5IDM3MC4zOSw2My4yMSAzNzIuNDIsNjIuNjMgMzc0LjQ1LDYyLjA1IDM3Ni40OCw2MS40OCAzNzguNTEsNjAuOTEgMzgwLjU0LDYwLjMzIDM4Mi41Nyw1OS43NiAzODQuNjAsNTkuMjAgMzg2LjYzLDU4LjYzIDM4OC42Niw1OC4wNyAzOTAuNjksNTcuNTAgMzkyLjcyLDU2Ljk0IDM5NC43NSw1Ni4zOCAzOTYuNzgsNTUuODMgMzk4LjgxLDU1LjI3IDQwMC44NCw1NC43MiA0MDIuODcsNTQuMTcgNDA0LjkwLDUzLjYxIDQwNi45Myw1My4wNyA0MDguOTYsNTIuNTIgNDEwLjk5LDUxLjk3IDQxMy4wMiw1MS40MyA0MTUuMDUsNTAuODkgNDE3LjA4LDUwLjM1IDQxOS4xMSw0OS44MSA0MjEuMTQsNDkuMjcgNDIzLjE3LDQ4LjczIDQyNS4yMCw0OC4yMCA0MjcuMjMsNDcuNjYgNDI5LjI2LDQ3LjEzIDQzMS4yOSw0Ni42MCA0MzMuMzIsNDYuMDcgNDM1LjM1LDQ1LjU1IDQzNy4zOCw0NS4wMiA0MzkuNDEsNDQuNTAgNDQxLjQ0LDQzLjk3IDQ0My40Nyw0My40NSA0NDUuNTAsNDIuOTMgNDQ3LjUzLDQyLjQxIDQ0OS41Niw0MS45MCA0NTEuNTksNDEuMzggNDUzLjYyLDQwLjg2IDQ1NS42NSw0MC4zNSA0NTcuNjgsMzkuODQgNDU5LjcxLDM5LjMzIDQ2MS43NCwzOC44MiA0NjMuNzcsMzguMzEgNDY1LjgwLDM3LjgwIDQ2Ny44MywzNy4zMCA0NjkuODYsMzYuODAgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAxLjA3OyBzdHJva2U6ICMxRjRFOUU7IHN0cm9rZS1saW5lY2FwOiBidXR0OycgLz4KPGxpbmUgeDE9Jy0zOTguNjInIHkxPSc4MS45NCcgeDI9JzkzNC4zOScgeTI9JzM5My44OCcgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlOiAjQjIxODJCOyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+CjxsaW5lIHgxPSctMTMxLjg5JyB5MT0nNjI0LjI0JyB4Mj0nNzk0LjczJyB5Mj0nLTI3Ny40Micgc3R5bGU9J3N0cm9rZS13aWR0aDogMS4wNzsgc3Ryb2tlOiAjNEQ0RDREOyBzdHJva2UtZGFzaGFycmF5OiA1LjY5LDUuNjk7IHN0cm9rZS1saW5lY2FwOiBidXR0OycgLz4KPGNpcmNsZSBjeD0nMzIxLjIwJyBjeT0nMjkzLjU4JyByPScyLjQ5JyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjcxOyBmaWxsOiAjMDAwMDAwOycgLz4KPGNpcmNsZSBjeD0nMTI2LjI4JyBjeT0nMjgxLjkxJyByPScyLjQ5JyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjcxOyBmaWxsOiAjMDAwMDAwOycgLz4KPGNpcmNsZSBjeD0nMTQ2LjE4JyBjeT0nMTkzLjAwJyByPScyLjQ5JyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjcxOyBmaWxsOiAjMDAwMDAwOycgLz4KPGNpcmNsZSBjeD0nMzIyLjQzJyBjeT0nMjE5LjQ2JyByPScyLjQ5JyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjcxOyBmaWxsOiAjMDAwMDAwOycgLz4KPGNpcmNsZSBjeD0nMjE0LjE3JyBjeT0nMTY2LjQ1JyByPScyLjQ5JyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjcxOyBmaWxsOiAjMDAwMDAwOycgLz4KPGNpcmNsZSBjeD0nMjc4Ljc2JyBjeT0nMjE3LjYyJyByPScyLjQ5JyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjcxOyBmaWxsOiAjMDAwMDAwOycgLz4KPGNpcmNsZSBjeD0nMjY1LjcyJyBjeT0nMjE3LjA2JyByPScyLjQ5JyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjcxOyBmaWxsOiAjMDAwMDAwOycgLz4KPGNpcmNsZSBjeD0nNDUwLjYyJyBjeT0nMzEwLjAzJyByPScyLjQ5JyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjcxOyBmaWxsOiAjMDAwMDAwOycgLz4KPHRleHQgeD0nMzIxLjIwJyB5PScyODguMzEnIHRleHQtYW5jaG9yPSdtaWRkbGUnIHN0eWxlPSdmb250LXNpemU6IDkuOTZweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nNC45N3B4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPjE8L3RleHQ+Cjx0ZXh0IHg9JzEyNi4yOCcgeT0nMjc2LjY0JyB0ZXh0LWFuY2hvcj0nbWlkZGxlJyBzdHlsZT0nZm9udC1zaXplOiA5Ljk2cHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzQuOTdweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz4yPC90ZXh0Pgo8dGV4dCB4PScxNDYuMTgnIHk9JzE4Ny43MycgdGV4dC1hbmNob3I9J21pZGRsZScgc3R5bGU9J2ZvbnQtc2l6ZTogOS45NnB4OyBmb250LWZhbWlseTogIk5pbWJ1cyBSb21hbiI7JyB0ZXh0TGVuZ3RoPSc0Ljk3cHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+MzwvdGV4dD4KPHRleHQgeD0nMzIyLjQzJyB5PScyMTQuMTknIHRleHQtYW5jaG9yPSdtaWRkbGUnIHN0eWxlPSdmb250LXNpemU6IDkuOTZweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nNC45N3B4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPjQ8L3RleHQ+Cjx0ZXh0IHg9JzIxNC4xNycgeT0nMTYxLjE4JyB0ZXh0LWFuY2hvcj0nbWlkZGxlJyBzdHlsZT0nZm9udC1zaXplOiA5Ljk2cHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzQuOTdweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz41PC90ZXh0Pgo8dGV4dCB4PScyNzguNzYnIHk9JzIxMi4zNScgdGV4dC1hbmNob3I9J21pZGRsZScgc3R5bGU9J2ZvbnQtc2l6ZTogOS45NnB4OyBmb250LWZhbWlseTogIk5pbWJ1cyBSb21hbiI7JyB0ZXh0TGVuZ3RoPSc0Ljk3cHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+NjwvdGV4dD4KPHRleHQgeD0nMjY1LjcyJyB5PScyMTEuNzknIHRleHQtYW5jaG9yPSdtaWRkbGUnIHN0eWxlPSdmb250LXNpemU6IDkuOTZweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nNC45N3B4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPjc8L3RleHQ+Cjx0ZXh0IHg9JzQ1MC42MicgeT0nMzA0Ljc2JyB0ZXh0LWFuY2hvcj0nbWlkZGxlJyBzdHlsZT0nZm9udC1zaXplOiA5Ljk2cHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzQuOTdweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz44PC90ZXh0Pgo8L2c+CjxnIGNsaXAtcGF0aD0ndXJsKCNjcE1DNHdNSHcxTURRdU1EQjhNQzR3TUh3ek5qQXVNREE9KSc+Cjxwb2x5bGluZSBwb2ludHM9JzQ1LjcyLDMyMy42OSA0NS43MiwyMy4xMyAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDAuODU7IHN0cm9rZS1saW5lY2FwOiBzcXVhcmU7JyAvPgo8dGV4dCB4PSc0MC4yNCcgeT0nMzA4LjYyJyB0ZXh0LWFuY2hvcj0nZW5kJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzE4LjExcHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+LTE1MDwvdGV4dD4KPHRleHQgeD0nNDAuMjQnIHk9JzI4NS45MScgdGV4dC1hbmNob3I9J2VuZCcgc3R5bGU9J2ZvbnQtc2l6ZTogOS45MHB4OyBmb250LWZhbWlseTogIk5pbWJ1cyBSb21hbiI7JyB0ZXh0TGVuZ3RoPScxOC4xMXB4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPi0xMDA8L3RleHQ+Cjx0ZXh0IHg9JzQwLjI0JyB5PScyNjMuMjAnIHRleHQtYW5jaG9yPSdlbmQnIHN0eWxlPSdmb250LXNpemU6IDkuOTBweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nMTMuMTdweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz4tNTA8L3RleHQ+Cjx0ZXh0IHg9JzQwLjI0JyB5PScyNDAuNDgnIHRleHQtYW5jaG9yPSdlbmQnIHN0eWxlPSdmb250LXNpemU6IDkuOTBweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nNC45NHB4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPjA8L3RleHQ+Cjx0ZXh0IHg9JzQwLjI0JyB5PScyMTcuNzcnIHRleHQtYW5jaG9yPSdlbmQnIHN0eWxlPSdmb250LXNpemU6IDkuOTBweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nOS44OHB4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPjUwPC90ZXh0Pgo8dGV4dCB4PSc0MC4yNCcgeT0nMTk1LjA2JyB0ZXh0LWFuY2hvcj0nZW5kJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzE0LjgxcHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+MTAwPC90ZXh0Pgo8dGV4dCB4PSc0MC4yNCcgeT0nMTcyLjM1JyB0ZXh0LWFuY2hvcj0nZW5kJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzE0LjgxcHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+MTUwPC90ZXh0Pgo8dGV4dCB4PSc0MC4yNCcgeT0nMTQ5LjYzJyB0ZXh0LWFuY2hvcj0nZW5kJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzE0LjgxcHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+MjAwPC90ZXh0Pgo8dGV4dCB4PSc0MC4yNCcgeT0nMTI2LjkyJyB0ZXh0LWFuY2hvcj0nZW5kJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzE0LjgxcHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+MjUwPC90ZXh0Pgo8dGV4dCB4PSc0MC4yNCcgeT0nMTA0LjIxJyB0ZXh0LWFuY2hvcj0nZW5kJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzE0LjgxcHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+MzAwPC90ZXh0Pgo8dGV4dCB4PSc0MC4yNCcgeT0nODEuNTAnIHRleHQtYW5jaG9yPSdlbmQnIHN0eWxlPSdmb250LXNpemU6IDkuOTBweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nMTQuODFweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz4zNTA8L3RleHQ+Cjx0ZXh0IHg9JzQwLjI0JyB5PSc1OC43OScgdGV4dC1hbmNob3I9J2VuZCcgc3R5bGU9J2ZvbnQtc2l6ZTogOS45MHB4OyBmb250LWZhbWlseTogIk5pbWJ1cyBSb21hbiI7JyB0ZXh0TGVuZ3RoPScxNC44MXB4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPjQwMDwvdGV4dD4KPHRleHQgeD0nNDAuMjQnIHk9JzM2LjA3JyB0ZXh0LWFuY2hvcj0nZW5kJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzE0LjgxcHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+NDUwPC90ZXh0Pgo8cG9seWxpbmUgcG9pbnRzPSc0OS4xMiwzMDUuMzUgNDUuNzIsMzA1LjM1ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc0OS4xMiwyODIuNjQgNDUuNzIsMjgyLjY0ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc0OS4xMiwyNTkuOTIgNDUuNzIsMjU5LjkyICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc0OS4xMiwyMzcuMjEgNDUuNzIsMjM3LjIxICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc0OS4xMiwyMTQuNTAgNDUuNzIsMjE0LjUwICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc0OS4xMiwxOTEuNzkgNDUuNzIsMTkxLjc5ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc0OS4xMiwxNjkuMDcgNDUuNzIsMTY5LjA3ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc0OS4xMiwxNDYuMzYgNDUuNzIsMTQ2LjM2ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc0OS4xMiwxMjMuNjUgNDUuNzIsMTIzLjY1ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc0OS4xMiwxMDAuOTQgNDUuNzIsMTAwLjk0ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc0OS4xMiw3OC4yMyA0NS43Miw3OC4yMyAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDAuODU7IHN0cm9rZS1saW5lY2FwOiBidXR0OycgLz4KPHBvbHlsaW5lIHBvaW50cz0nNDkuMTIsNTUuNTEgNDUuNzIsNTUuNTEgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjg1OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzQ5LjEyLDMyLjgwIDQ1LjcyLDMyLjgwICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc0NS43MiwzMjMuNjkgNDkwLjA1LDMyMy42OSAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDAuODU7IHN0cm9rZS1saW5lY2FwOiBzcXVhcmU7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSc2NS45MSwzMjAuMjkgNjUuOTEsMzIzLjY5ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPScxMTIuNjAsMzIwLjI5IDExMi42MCwzMjMuNjkgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjg1OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzE1OS4yOCwzMjAuMjkgMTU5LjI4LDMyMy42OSAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDAuODU7IHN0cm9rZS1saW5lY2FwOiBidXR0OycgLz4KPHBvbHlsaW5lIHBvaW50cz0nMjA1Ljk2LDMyMC4yOSAyMDUuOTYsMzIzLjY5ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPScyNTIuNjQsMzIwLjI5IDI1Mi42NCwzMjMuNjkgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjg1OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzI5OS4zMiwzMjAuMjkgMjk5LjMyLDMyMy42OSAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDAuODU7IHN0cm9rZS1saW5lY2FwOiBidXR0OycgLz4KPHBvbHlsaW5lIHBvaW50cz0nMzQ2LjAwLDMyMC4yOSAzNDYuMDAsMzIzLjY5ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8cG9seWxpbmUgcG9pbnRzPSczOTIuNjksMzIwLjI5IDM5Mi42OSwzMjMuNjkgJyBzdHlsZT0nc3Ryb2tlLXdpZHRoOiAwLjg1OyBzdHJva2UtbGluZWNhcDogYnV0dDsnIC8+Cjxwb2x5bGluZSBwb2ludHM9JzQzOS4zNywzMjAuMjkgNDM5LjM3LDMyMy42OSAnIHN0eWxlPSdzdHJva2Utd2lkdGg6IDAuODU7IHN0cm9rZS1saW5lY2FwOiBidXR0OycgLz4KPHBvbHlsaW5lIHBvaW50cz0nNDg2LjA1LDMyMC4yOSA0ODYuMDUsMzIzLjY5ICcgc3R5bGU9J3N0cm9rZS13aWR0aDogMC44NTsgc3Ryb2tlLWxpbmVjYXA6IGJ1dHQ7JyAvPgo8dGV4dCB4PSc2NS45MScgeT0nMzM1LjcxJyB0ZXh0LWFuY2hvcj0nbWlkZGxlJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzQuOTRweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz4wPC90ZXh0Pgo8dGV4dCB4PScxMTIuNjAnIHk9JzMzNS43MScgdGV4dC1hbmNob3I9J21pZGRsZScgc3R5bGU9J2ZvbnQtc2l6ZTogOS45MHB4OyBmb250LWZhbWlseTogIk5pbWJ1cyBSb21hbiI7JyB0ZXh0TGVuZ3RoPScxNC44MXB4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPjEwMDwvdGV4dD4KPHRleHQgeD0nMTU5LjI4JyB5PSczMzUuNzEnIHRleHQtYW5jaG9yPSdtaWRkbGUnIHN0eWxlPSdmb250LXNpemU6IDkuOTBweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nMTQuODFweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz4yMDA8L3RleHQ+Cjx0ZXh0IHg9JzIwNS45NicgeT0nMzM1LjcxJyB0ZXh0LWFuY2hvcj0nbWlkZGxlJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzE0LjgxcHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+MzAwPC90ZXh0Pgo8dGV4dCB4PScyNTIuNjQnIHk9JzMzNS43MScgdGV4dC1hbmNob3I9J21pZGRsZScgc3R5bGU9J2ZvbnQtc2l6ZTogOS45MHB4OyBmb250LWZhbWlseTogIk5pbWJ1cyBSb21hbiI7JyB0ZXh0TGVuZ3RoPScxNC44MXB4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPjQwMDwvdGV4dD4KPHRleHQgeD0nMjk5LjMyJyB5PSczMzUuNzEnIHRleHQtYW5jaG9yPSdtaWRkbGUnIHN0eWxlPSdmb250LXNpemU6IDkuOTBweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nMTQuODFweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz41MDA8L3RleHQ+Cjx0ZXh0IHg9JzM0Ni4wMCcgeT0nMzM1LjcxJyB0ZXh0LWFuY2hvcj0nbWlkZGxlJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzE0LjgxcHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+NjAwPC90ZXh0Pgo8dGV4dCB4PSczOTIuNjknIHk9JzMzNS43MScgdGV4dC1hbmNob3I9J21pZGRsZScgc3R5bGU9J2ZvbnQtc2l6ZTogOS45MHB4OyBmb250LWZhbWlseTogIk5pbWJ1cyBSb21hbiI7JyB0ZXh0TGVuZ3RoPScxNC44MXB4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPjcwMDwvdGV4dD4KPHRleHQgeD0nNDM5LjM3JyB5PSczMzUuNzEnIHRleHQtYW5jaG9yPSdtaWRkbGUnIHN0eWxlPSdmb250LXNpemU6IDkuOTBweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nMTQuODFweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz44MDA8L3RleHQ+Cjx0ZXh0IHg9JzQ4Ni4wNScgeT0nMzM1LjcxJyB0ZXh0LWFuY2hvcj0nbWlkZGxlJyBzdHlsZT0nZm9udC1zaXplOiA5LjkwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzE0LjgxcHgnIGxlbmd0aEFkanVzdD0nc3BhY2luZ0FuZEdseXBocyc+OTAwPC90ZXh0Pgo8dGV4dCB4PScyNjIuNjMnIHk9JzM0Ny44OScgc3R5bGU9J2ZvbnQtc2l6ZTogMTEuMDBweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nNy45NHB4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPlY8L3RleHQ+Cjx0ZXh0IHg9JzI3MC41NycgeT0nMzQ5LjYzJyBzdHlsZT0nZm9udC1zaXplOiA3LjcwcHg7IGZvbnQtZmFtaWx5OiAiTmltYnVzIFJvbWFuIjsnIHRleHRMZW5ndGg9JzIuNTZweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz5yPC90ZXh0Pgo8dGV4dCB0cmFuc2Zvcm09J3RyYW5zbGF0ZSgxNS4yNSwxNzkuODgpIHJvdGF0ZSgtOTApJyBzdHlsZT0nZm9udC1zaXplOiAxMS4wMHB4OyBmb250LWZhbWlseTogIk5pbWJ1cyBSb21hbiI7JyB0ZXh0TGVuZ3RoPScxMC4zOXB4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPlc8L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0ndHJhbnNsYXRlKDE2Ljk4LDE2OS41MCkgcm90YXRlKC05MCknIHN0eWxlPSdmb250LXNpemU6IDcuNzBweDsgZm9udC1mYW1pbHk6ICJOaW1idXMgUm9tYW4iOycgdGV4dExlbmd0aD0nMi41NnB4JyBsZW5ndGhBZGp1c3Q9J3NwYWNpbmdBbmRHbHlwaHMnPnI8L3RleHQ+Cjx0ZXh0IHg9JzcuOTcnIHk9JzE1LjI1JyBzdHlsZT0nZm9udC1zaXplOiAxMS4wMHB4OyBmb250LWZhbWlseTogIk5pbWJ1cyBSb21hbiI7JyB0ZXh0TGVuZ3RoPSczMjUuNDdweCcgbGVuZ3RoQWRqdXN0PSdzcGFjaW5nQW5kR2x5cGhzJz5Xci1WciBncmFwaDogbGltaXRpbmcgcGFyYWJvbGEsIHJlZ3Jlc3Npb24gKGIgPSAtMC4yNCksIHVuaXQgc2xvcGUgKGRhc2hlZCk8L3RleHQ+CjwvZz4KPC9nPgo8L3N2Zz4K)

Under the additive-dominance model the points lie on a line of unit
slope (dashed) inside the limiting parabola \\W_r^2 = V_r V\_{0L0}\\.
Parents near the origin carry mostly dominant genes, parents far from it
mostly recessive genes.

## 5 Tests of the model

``` r

knitr::kable(x = h$Tests, digits = 4)
```

|                             | Statistic |  Df | p.value |
|:----------------------------|----------:|----:|--------:|
| Uniformity of Wr - Vr (t^2) |    4.2485 |   6 |  0.0849 |
| b = 0 (t)                   |   -1.3293 |   6 |  0.2321 |
| b = 1 (t)                   |    6.8569 |   6 |  0.0005 |

A significant \\t^2\\ or a slope that differs from 1 indicates epistasis
or correlated gene distribution; the components below then need care. In
this data set the slope is negative and differs from 1, so the
additive-dominance model is not adequate.

## 6 Components of variation

``` r

knitr::kable(x = h$Components.of.Variation, digits = 3)
```

|     | Estimate |  StdErr | t.value |
|:----|---------:|--------:|--------:|
| E   |   29.677 |  74.009 |   0.401 |
| D   |  195.287 | 222.026 |   0.880 |
| F   |  406.984 | 524.628 |   0.776 |
| H1  | 1856.573 | 510.406 |   3.637 |
| H2  | 1516.416 | 444.053 |   3.415 |
| h2  |  136.597 | 313.481 |   0.436 |

``` r

knitr::kable(x = h$Other.Parameters, digits = 3)
```

|                                     | Other Parameters |
|:------------------------------------|-----------------:|
| Mean degree of dominance sqrt(H1/D) |            3.083 |
| Proportion of genes H2/(4H1)        |            0.204 |
| Dominant to recessive genes         |            2.021 |
| r(Wr + Vr, Yr)                      |           -0.155 |
| r^2(Wr + Vr, Yr)                    |            0.024 |
| Gene groups h2/H2                   |            0.090 |
| Narrow-sense heritability           |            0.136 |

\\\sqrt{H_1/D}\\ above 1 indicates overdominance; \\H_2/(4H_1)\\ below
0.25 an unequal distribution of positive and negative alleles among the
parents.

## 7 Summary

Hayman’s analysis asks how genes act rather than which parents combine
well; read the components only when the tests support the
additive-dominance model.

## 8 References

Hayman, B. I. (1954). The theory and analysis of diallel crosses.
*Genetics*, 39(6), 789–809.

Hayman, B. I. (1954). The analysis of variance of diallel tables.
*Biometrics*, 10(2), 235–244.

Mather, K. and Jinks, J. L. (1982). *Biometrical Genetics*, 3rd edition.
Chapman and Hall, London.

Singh, R. K. and Chaudhary, B. D. (2004). *Biometrical Methods in
Quantitative Genetic Analysis*. Kalyani Publishers, New Delhi.
