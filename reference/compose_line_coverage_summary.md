# Compose the line coverage summary

Builds the high-level sentence summarising the line coverage of the
patch.

## Usage

``` r
compose_line_coverage_summary(
  diff_line_coverage,
  target = 80,
  our_target = FALSE
)
```

## Arguments

- diff_line_coverage:

  a `tibble` the output of
  [`get_diff_line_coverage()`](https://dragosmg.github.io/covr2gh/reference/get_diff_line_coverage.md)

- target:

  (numeric) the target coverage for the diff. Defaults to 80, but
  [`compose_comment()`](https://dragosmg.github.io/covr2gh/reference/compose_comment.md)
  uses the total coverage for base.

## Value

a glue string, a sentence summarising the diff coverage.
