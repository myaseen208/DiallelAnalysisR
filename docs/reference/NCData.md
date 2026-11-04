# North Carolina designs I, II and III: example data

Simulated yields for the three North Carolina designs, each in a
randomized complete block experiment with three replicates: Design I
with six males each mated to four different females, Design II with five
males crossed with four females, and Design III with twelve \\F_2\\
males backcrossed to the two inbred parents `P1` and `P2`. The data
illustrate
[`NCDesign`](https://myaseen208.com/DiallelAnalysisR/reference/NCDesign.md).

## Usage

``` r
data(NCData)
```

## Format

A `data.frame` with 204 rows and 5 columns:

- `Design`:

  design, `1`, `2` or `3` (integer).

- `Male`:

  male parent (character).

- `Female`:

  female parent (character; Design III: `P1` or `P2`).

- `Rep`:

  replicate (factor, `1` to `3`).

- `Yield`:

  yield (numeric).

## Source

Simulated; the script is `data-raw/LineTesterNC.R` of the package
sources.

## References

Comstock, R. E. and Robinson, H. F. (1948). The components of genetic
variance in populations of biparental progenies and their use in
estimating the average degree of dominance. *Biometrics*, **4**(4),
254–266. [doi:10.2307/3001412](https://doi.org/10.2307/3001412)

## See also

[`NCDesign`](https://myaseen208.com/DiallelAnalysisR/reference/NCDesign.md)

Other DiallelAnalysisR data:
[`Griffing56`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing56.md),
[`GriffingData1`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData1.md),
[`GriffingData2`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData2.md),
[`GriffingData3`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData3.md),
[`GriffingData4`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingData4.md),
[`HaymanData`](https://myaseen208.com/DiallelAnalysisR/reference/HaymanData.md),
[`LineTesterData`](https://myaseen208.com/DiallelAnalysisR/reference/LineTesterData.md),
[`PartialDiallelData`](https://myaseen208.com/DiallelAnalysisR/reference/PartialDiallelData.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
data(NCData)
table(NCData$Design)
#> 
#>  1  2  3 
#> 72 60 72 
```
