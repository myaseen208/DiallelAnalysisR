# Complete diallel of eight parents for Hayman's analysis

The data of
[`GriffingData1`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData1.md)
(parents, \\F_1\\ and reciprocals of eight parents, four replicates),
used in the examples of
[`Hayman`](https://myaseen208.com/DiallelAnalysisR/reference/Hayman.md).

## Usage

``` r
data(HaymanData)
```

## Format

A `data.frame` with 256 rows and 4 columns: `Cross1` (female parent),
`Cross2` (male parent), `Rep` (replicate), `Yield`.

## Source

Identical to
[`GriffingData1`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData1.md).

## References

Hayman, B. I. (1954). The theory and analysis of diallel crosses.
*Genetics*, **39**(6), 789–809.
[doi:10.1093/genetics/39.6.789](https://doi.org/10.1093/genetics/39.6.789)

## See also

[`Hayman`](https://myaseen208.com/DiallelAnalysisR/reference/Hayman.md)

Other DiallelAnalysisR data:
[`Griffing56`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing56.md),
[`GriffingData1`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData1.md),
[`GriffingData2`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData2.md),
[`GriffingData3`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData3.md),
[`GriffingData4`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData4.md),
[`LineTesterData`](https://myaseen208.com/DiallelAnalysisR/reference/LineTesterData.md),
[`NCData`](https://myaseen208.com/DiallelAnalysisR/reference/NCData.md),
[`PartialDiallelData`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallelData.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
data(HaymanData)
str(HaymanData)
#> 'data.frame':    256 obs. of  4 variables:
#>  $ Cross1: Factor w/ 8 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 2 2 ...
#>  $ Cross2: Factor w/ 8 levels "1","2","3","4",..: 1 2 3 4 5 6 7 8 1 2 ...
#>  $ Rep   : Factor w/ 4 levels "1","2","3","4": 1 1 1 1 1 1 1 1 1 1 ...
#>  $ Yield : num  104.9 88.7 109.8 128.1 128.4 ...
```
