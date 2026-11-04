# Complete diallel of eight parents (Griffing's Method 1)

Yield of an eight-parent diallel with parents, \\F_1\\ and reciprocal
\\F_1\\ (all 64 crosses) in a randomized complete block experiment with
four replicates. The data for Griffing's Methods 2, 3 and 4
([`GriffingData2`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData2.md),
[`GriffingData3`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData3.md),
[`GriffingData4`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData4.md))
are subsets of these plots, and
[`HaymanData`](https://myaseen208.com/DiallelAnalysisR/reference/HaymanData.md)
is the same data set.

## Usage

``` r
data(GriffingData1)
```

## Format

A `data.frame` with 256 rows (64 crosses by 4 replicates) and 4 columns:

- `Cross1`:

  female parent (factor, levels `1` to `8`).

- `Cross2`:

  male parent (factor, levels `1` to `8`); `Cross1 == Cross2` for the
  parents.

- `Rep`:

  replicate (factor, levels `1` to `4`).

- `Yield`:

  yield (numeric).

## Source

Example data of the package since its first version.

## References

Griffing, B. (1956). Concept of general and specific combining ability
in relation to diallel crossing systems. *Australian Journal of
Biological Sciences*, **9**(4), 463–493.
[doi:10.1071/BI9560463](https://doi.org/10.1071/BI9560463)

Singh, R. K. and Chaudhary, B. D. (2004). *Biometrical Methods in
Quantitative Genetic Analysis*. Kalyani Publishers, New Delhi.

## See also

[`Griffing`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md),
[`Hayman`](https://myaseen208.com/DiallelAnalysisR/reference/Hayman.md)

Other DiallelAnalysisR data:
[`Griffing56`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing56.md),
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
data(GriffingData1)
str(GriffingData1)
#> 'data.frame':    256 obs. of  4 variables:
#>  $ Cross1: Factor w/ 8 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 2 2 ...
#>  $ Cross2: Factor w/ 8 levels "1","2","3","4",..: 1 2 3 4 5 6 7 8 1 2 ...
#>  $ Rep   : Factor w/ 4 levels "1","2","3","4": 1 1 1 1 1 1 1 1 1 1 ...
#>  $ Yield : num  104.9 88.7 109.8 128.1 128.4 ...
with(data = GriffingData1, expr = tapply(X = Yield, INDEX = list(Cross1, Cross2), FUN = mean))
#>         1       2       3       4        5       6        7       8
#> 1  85.645  87.010  90.455 114.945 120.2900  68.550 107.6425  52.640
#> 2  80.690  98.260 111.575  88.170  99.9300  73.265  97.6400  85.650
#> 3 102.230 104.555  74.070 100.645  94.2850 100.885 111.5400 117.735
#> 4 119.115  89.310 102.675  91.640  85.2850 105.795  64.4500  46.855
#> 5 111.290 102.890  88.265  83.390  54.1025  84.150  81.9350  94.820
#> 6  68.835  71.295  99.575 108.665  87.9650 100.390 121.6100  53.740
#> 7 109.265  87.820 108.445  57.650  78.7500 115.670  90.9600 125.270
#> 8  48.720  83.145 115.400  46.740  93.3200  60.240 118.1700  82.000
```
