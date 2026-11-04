# Crosses and reciprocals of eight parents without the parents (Griffing's Method 3)

The plots of
[`GriffingData1`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData1.md)
without the parents (56 cells).

## Usage

``` r
data(GriffingData3)
```

## Format

A `data.frame` with 224 rows (56 cells by 4 replicates) and the columns
of
[`GriffingData1`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData1.md):
`Cross1`, `Cross2`, `Rep`, `Yield`.

## Source

A subset of
[`GriffingData1`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData1.md).

## References

Griffing, B. (1956). Concept of general and specific combining ability
in relation to diallel crossing systems. *Australian Journal of
Biological Sciences*, **9**(4), 463–493.
[doi:10.1071/BI9560463](https://doi.org/10.1071/BI9560463)

## See also

[`Griffing`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md)

Other DiallelAnalysisR data:
[`Griffing56`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing56.md),
[`GriffingData1`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData1.md),
[`GriffingData2`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData2.md),
[`GriffingData4`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData4.md),
[`HaymanData`](https://myaseen208.com/DiallelAnalysisR/reference/HaymanData.md),
[`LineTesterData`](https://myaseen208.com/DiallelAnalysisR/reference/LineTesterData.md),
[`NCData`](https://myaseen208.com/DiallelAnalysisR/reference/NCData.md),
[`PartialDiallelData`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallelData.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
data(GriffingData3)
str(GriffingData3)
#> 'data.frame':    224 obs. of  4 variables:
#>  $ Cross1: Factor w/ 8 levels "1","2","3","4",..: 1 1 1 1 1 1 1 2 2 2 ...
#>  $ Cross2: Factor w/ 8 levels "1","2","3","4",..: 2 3 4 5 6 7 8 1 3 4 ...
#>  $ Rep   : Factor w/ 4 levels "1","2","3","4": 1 1 1 1 1 1 1 1 1 1 ...
#>  $ Yield : num  88.7 109.8 128.1 128.4 74.4 ...
```
