# Partial diallel: ten by four parents

A partial diallel in which each of ten parents of a first group (`1` to
`10`) is crossed with each of four parents of a second group (`11` to
`14`), in a randomized complete block experiment with four replicates.

## Usage

``` r
data(PartialDiallelData)
```

## Format

A `data.frame` with 160 rows (40 crosses by 4 replicates) and 4 columns:

- `Cross1`:

  parent of group I (integer `1` to `10`).

- `Cross2`:

  parent of group II (integer `11` to `14`).

- `Rep`:

  replicate (integer `1` to `4`).

- `y`:

  response (numeric).

## Source

Example data of the package, contributed by Pedro A. M. Barbosa.

## References

Kempthorne, O. and Curnow, R. N. (1961). The partial diallel cross.
*Biometrics*, **17**(2), 229–250.
[doi:10.2307/2527989](https://doi.org/10.2307/2527989)

## See also

[`PartialDiallel`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallel.md)

Other DiallelAnalysisR data:
[`Griffing56`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing56.md),
[`GriffingData1`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData1.md),
[`GriffingData2`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData2.md),
[`GriffingData3`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData3.md),
[`GriffingData4`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData4.md),
[`HaymanData`](https://myaseen208.com/DiallelAnalysisR/reference/HaymanData.md),
[`LineTesterData`](https://myaseen208.com/DiallelAnalysisR/reference/LineTesterData.md),
[`NCData`](https://myaseen208.com/DiallelAnalysisR/reference/NCData.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>), Pedro A. M. Barbosa
(<pedro.barbosa@usp.br>)

## Examples

``` r
data(PartialDiallelData)
str(PartialDiallelData)
#> 'data.frame':    160 obs. of  4 variables:
#>  $ Cross1: int  1 1 1 1 2 2 2 2 3 3 ...
#>  $ Cross2: int  11 12 13 14 11 12 13 14 11 12 ...
#>  $ Rep   : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ y     : num  18.2 16.4 13.1 17.7 17.6 ...
```
