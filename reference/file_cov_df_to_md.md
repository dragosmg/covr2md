# Transform the file coverage tibble into markdown

Makes the column names human readable, formats the data, and adds an
interpretation column. The transforms the output to markdown and
collapses into a single string.

## Usage

``` r
file_cov_df_to_md(file_cov_df, align = "rrrcc")
```

## Arguments

- file_cov_df:

  (`tibble`) a diff df, the output of
  [`derive_file_cov_df()`](https://dragosmg.github.io/covr2gh/reference/derive_file_cov_df.md)

- align:

  Column alignment: a character vector consisting of `'l'` (left), `'c'`
  (center) and/or `'r'` (right). By default or if `align = NULL`,
  numeric columns are right-aligned, and other columns are left-aligned.
  If `length(align) == 1L`, the string will be expanded to a vector of
  individual letters, e.g. `'clc'` becomes `c('c', 'l', 'c')`, unless
  the output format is LaTeX.

## Value

a character scalar containing markdown version of the diff df collapsed
into a single string.
