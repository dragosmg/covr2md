# Transform a line coverage tibble to markdown

Adds a total row, make column names more readable. Then transforms it to
markdown which gets collapsed into a single string.

## Usage

``` r
line_cov_to_md(diff_line_coverage, align = "rrrr")
```

## Arguments

- diff_line_coverage:

  (`tibble`) diff line coverage data. The output of
  [`derive_file_cov_df()`](https://dragosmg.github.io/covr2gh/reference/derive_file_cov_df.md)

- align:

  Column alignment: a character vector consisting of `'l'` (left), `'c'`
  (center) and/or `'r'` (right). By default or if `align = NULL`,
  numeric columns are right-aligned, and other columns are left-aligned.
  If `length(align) == 1L`, the string will be expanded to a vector of
  individual letters, e.g. `'clc'` becomes `c('c', 'l', 'c')`, unless
  the output format is LaTeX.

## Value

a markdown table as a string
