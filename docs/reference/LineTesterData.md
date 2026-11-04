# Line by tester example: eight lines crossed with three testers

Simulated yields of the 24 crosses of eight lines with three testers in
a randomized complete block experiment with three replicates, drawn from
a model with line, tester and line by tester effects. The data
illustrate
[`LineTester`](https://myaseen208.com/DiallelAnalysisR/reference/LineTester.md).

## Usage

``` r
data(LineTesterData)
```

## Format

A `data.frame` with 72 rows and 4 columns:

- `Line`:

  line (factor, `L1` to `L8`).

- `Tester`:

  tester (factor, `T1` to `T3`).

- `Rep`:

  replicate (factor, `1` to `3`).

- `Yield`:

  yield (numeric).

## Source

Simulated; the script is `data-raw/LineTesterNC.R` of the package
sources.

## References

Kempthorne, O. (1957). *An Introduction to Genetic Statistics*. John
Wiley and Sons, New York.

## See also

[`LineTester`](https://myaseen208.com/DiallelAnalysisR/reference/LineTester.md)

Other DiallelAnalysisR data:
[`Griffing56`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing56.md),
[`GriffingData1`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData1.md),
[`GriffingData2`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData2.md),
[`GriffingData3`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData3.md),
[`GriffingData4`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData4.md),
[`HaymanData`](https://myaseen208.com/DiallelAnalysisR/reference/HaymanData.md),
[`NCData`](https://myaseen208.com/DiallelAnalysisR/reference/NCData.md),
[`PartialDiallelData`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallelData.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
data(LineTesterData)
with(data = LineTesterData, expr = tapply(X = Yield, INDEX = list(Line, Tester), FUN = mean))
#>          T1       T2       T3
#> L1 76.10000 89.36667 74.00000
#> L2 71.40000 69.43333 62.03333
#> L3 68.23333 68.00000 65.16667
#> L4 80.36667 78.30000 67.13333
#> L5 90.70000 87.30000 81.93333
#> L6 74.03333 73.76667 71.63333
#> L7 94.06667 86.20000 76.36667
#> L8 90.63333 74.03333 75.43333
```
