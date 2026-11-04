# Simulate diallel data

`DiallelSim()` simulates plot data of a diallel in randomized complete
blocks, in one or several environments, from Griffing's model with
random effects. It serves teaching (data with known effects) and the
planning of experiments (see
[`DiallelPower`](https://myaseen208.com/DiallelAnalysisR/reference/DiallelPower.md)).

## Usage

``` r
DiallelSim(
  Parents,
  Method,
  Rep,
  Env = 1,
  Mean = 0,
  gca,
  sca,
  rec = 0,
  gcaEnv = 0,
  scaEnv = 0,
  EnvSD = 0,
  Block = 0,
  Error,
  seed = NULL
)
```

## Arguments

- Parents:

  number of parents \\P \geq 3\\.

- Method:

  Griffing's method, `1` to `4`: which crosses are grown.

- Rep:

  number of replicates (blocks) per environment.

- Env:

  number of environments (default `1`; the column `Env` is added when it
  is larger).

- Mean:

  overall mean \\\mu\\.

- gca, sca, rec:

  standard deviations of the gca, sca and reciprocal effects.

- gcaEnv, scaEnv:

  standard deviations of the gca \\\times\\ environment and sca
  \\\times\\ environment effects (default `0`).

- EnvSD:

  standard deviation of the environment effects (default `0`).

- Block:

  standard deviation of the block effects (default `0`).

- Error:

  standard deviation of the plot errors \\\sigma\\.

- seed:

  seed of the random numbers, or `NULL` (default) to leave the generator
  as it is.

## Value

A `data.frame` with columns `Cross1`, `Cross2`, `Rep`, `y` (and `Env`),
with the attribute `"truth"`: a list with `gca` (vector), `sca` and
`rec` (matrices) and `Mean`.

## Details

The response of the plot of cross \\i \times j\\ in block \\k\\ of
environment \\e\\ is \$\$y\_{ijke} = \mu + g_i + g_j + s\_{ij} +
r\_{ij} + \eta_e + (gE)\_{ie} + (gE)\_{je} + (sE)\_{ije} + b\_{ke} +
\varepsilon\_{ijke},\$\$ with independent normal effects of standard
deviations `gca`, `sca` (\\s\_{ij} = s\_{ji}\\), `rec` (\\r\_{ij} =
-r\_{ji}\\, Methods 1 and 3), `gcaEnv`, `scaEnv`, `Block` and `Error`;
environment effects \\\eta_e\\ have standard deviation `EnvSD`. The gca,
environment and block effects are centred to sum to zero and the sca
effects to zero row and column sums over the full \\P \times P\\ table
(Griffing's constraints of Methods 1 and 2). The true effects are
returned as the attribute `"truth"`.

## See also

[`DiallelPower`](https://myaseen208.com/DiallelAnalysisR/reference/DiallelPower.md),
[`Griffing`](https://myaseen208.com/DiallelAnalysisR/reference/Griffing.md),
[`GriffingEnv`](https://myaseen208.com/DiallelAnalysisR/reference/GriffingEnv.md)

Other DiallelAnalysisR planning:
[`DiallelPower()`](https://myaseen208.com/DiallelAnalysisR/reference/DiallelPower.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
d <-
  DiallelSim(
      Parents = 6
    , Method  = 1
    , Rep     = 3
    , Env     = 1
    , Mean    = 100
    , gca     = 5
    , sca     = 3
    , rec     = 1
    , gcaEnv  = 0
    , scaEnv  = 0
    , EnvSD   = 0
    , Block   = 2
    , Error   = 4
    , seed    = 123
    )
head(d)
#>   Cross1 Cross2 Rep         y
#> 1      1      1   1  91.31074
#> 2      1      2   1  92.49970
#> 3      1      3   1 104.10394
#> 4      1      4   1  90.53502
#> 5      1      5   1  94.83385
#> 6      1      6   1 108.32714
attr(x = d, which = "truth")$gca
#>         1         2         3         4         5         6 
#> -5.038142 -3.386651  5.557778 -1.883222 -1.589325  6.339561 
fit <-
  Griffing(
      y          = y
    , Rep        = Rep
    , Cross1     = Cross1
    , Cross2     = Cross2
    , data       = d
    , Method     = 1
    , Model      = 1
    , Reciprocal = c("combined", "split")[1]
    )
cbind(true = attr(x = d, which = "truth")$gca, estimated = fit$GCA)
#>        true estimated
#> 1 -5.038142 -5.419897
#> 2 -3.386651 -2.793203
#> 3  5.557778  5.586346
#> 4 -1.883222 -1.615612
#> 5 -1.589325 -2.148496
#> 6  6.339561  6.390862
```
