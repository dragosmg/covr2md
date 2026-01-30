# Digest file coverage

Take a `coverage` object (the output of
[`covr::package_coverage()`](http://covr.r-lib.org/reference/package_coverage.md),
extract the filecoverage component and transform it into a
`data.frame`/`tibble`.

## Usage

``` r
digest_coverage(x = covr::package_coverage())
```

## Arguments

- x:

  `<coverage>` object, defaults to
  [`covr::package_coverage()`](http://covr.r-lib.org/reference/package_coverage.md).

## Value

a `tibble` with 2 columns (`File` and `Coverage`) summarising testing
coverage at file level.

## Examples

``` r
if (FALSE) { # \dontrun{
library(covr)

covr::package_coverage("myawesomepkg") |>
  digest_coverage()
} # }
```
