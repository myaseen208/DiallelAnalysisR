# Griffing's (1956) maize diallel: cross means of nine inbred lines

The \\F_1\\ means of the 36 crosses among nine inbred lines of maize
(Griffing's Method 4) used in the numerical example of Griffing (1956),
from data of Griffing and Lindstrom (1954): six randomized blocks with
13 plants per plot. The error mean squares of the experiment (Griffing
1956, Table 7) are, per plant: within plots 1642.48 (total yield), 46.61
(cob weight), 1247.39 (shelled corn) on 2558 degrees of freedom;
varieties by blocks 11803.61, 235.82, 9056.45 on 175 degrees of freedom.
Divided by the 78 plants of a cross mean they give the error of
[`GriffingMeans`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingMeans.md)
for Model 1 and Model 2.

## Usage

``` r
data(Griffing56)
```

## Format

A `data.frame` with 36 rows and 5 columns:

- `Cross1`, `Cross2`:

  the two parents of the cross (factors, levels `1` to `9`;
  `Cross1 < Cross2`).

- `TotalYield`:

  \\X_1\\, total yield (the sum of the next two).

- `CobWeight`:

  \\X_2\\, cob weight.

- `ShelledCorn`:

  \\X_3\\, shelled corn weight.

## Source

Griffing (1956), Table 6, page 482.

## References

Griffing, B. (1956). Concept of general and specific combining ability
in relation to diallel crossing systems. *Australian Journal of
Biological Sciences*, **9**(4), 463–493.
[doi:10.1071/BI9560463](https://doi.org/10.1071/BI9560463)

Griffing, B. and Lindstrom, E. W. (1954). A study of the combining
abilities of corn inbreds having varying proportions of corn belt and
non-corn belt germ plasm. *Agronomy Journal*, **46**, 545–552.

## See also

[`GriffingMeans`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingMeans.md)

Other DiallelAnalysisR data:
[`GriffingData1`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData1.md),
[`GriffingData2`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData2.md),
[`GriffingData3`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData3.md),
[`GriffingData4`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData4.md),
[`HaymanData`](https://myaseen208.com/DiallelAnalysisR/reference/HaymanData.md),
[`LineTesterData`](https://myaseen208.com/DiallelAnalysisR/reference/LineTesterData.md),
[`NCData`](https://myaseen208.com/DiallelAnalysisR/reference/NCData.md),
[`PartialDiallelData`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallelData.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
data(Griffing56)
head(Griffing56)
#>   Cross1 Cross2 TotalYield CobWeight ShelledCorn
#> 1      1      2      240.0      31.8       208.2
#> 2      1      3      260.0      34.7       225.3
#> 3      1      4      230.4      32.3       198.1
#> 4      1      5      257.0      45.0       212.0
#> 5      1      6      241.5      39.0       202.5
#> 6      1      7      266.9      35.1       231.8
```
