# Methods for DiallelAnalysisR results

The analysis functions of DiallelAnalysisR return the named list they
have always returned, now with the class
`c("da_<analysis>", "da_result", "list")`. Components are read as before
(`x$ANOVA`, `x[["Means"]]`); the methods below print, summarise and plot
the result and turn any component into a `data.table`.

## Usage

``` r
# S3 method for class 'da_result'
print(x, digits = 4L, ...)

# S3 method for class 'da_result'
summary(object, ...)

# S3 method for class 'summary.da_result'
print(x, ...)

# S3 method for class 'da_result'
format(x, ...)

# S3 method for class 'da_result'
as.data.table(x, keep.rownames = FALSE, ..., component = 1L)

# S3 method for class 'da_result'
as.data.frame(x, row.names = NULL, optional = FALSE, ..., component = 1L)

# S3 method for class 'da_result'
plot(x, ...)
```

## Arguments

- x, object:

  a DiallelAnalysisR result.

- digits:

  significant digits of printed numbers (default 4).

- ...:

  passed on (to [`print()`](https://rdrr.io/r/base/print.html) of the
  components, or to the plotting function for
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html)).

- keep.rownames, row.names, optional:

  as in
  [`data.table::as.data.table()`](https://rdrr.io/pkg/data.table/man/as.data.table.html)
  and [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html);
  row names of a matrix or data frame component are always kept, in a
  first column `term`.

- component:

  name or number of the component to convert (default: the first one).

## Value

[`print()`](https://rdrr.io/r/base/print.html) returns `x` invisibly;
[`summary()`](https://rdrr.io/r/base/summary.html) an object of class
`summary.da_result`; [`format()`](https://rdrr.io/r/base/format.html) a
character string; `as.data.table()` and
[`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html) the
chosen component as a table;
[`plot()`](https://rdrr.io/r/graphics/plot.default.html) a `ggplot`
object.

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)
