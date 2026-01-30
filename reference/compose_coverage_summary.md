# Compose coverage summary

Builds the top level sentences of the summary.

## Usage

``` r
compose_coverage_summary(pr_details, delta)
```

## Arguments

- pr_details:

  a `<pr_details>` object representing a subset of the pull request
  metadata we need. The output of
  [`get_pr_details()`](https://dragosmg.github.io/covr2gh/reference/get_pr_details.md).

- delta:

  (numeric scalar) difference in total coverage between head of current
  branch and base branch.

## Value

a string (character scalar) containing the text for the coverage
summary.

## Examples

``` r
if (FALSE) { # \dontrun{
pr_details <- get_pr_details(
  repo = "dragosmg/covr2ghdemo",
  pr_number = 2
)

coverage_summary <- compose_coverage_summary(
  pr_details = pr_details,
  delta = 20.43
)
} # }
```
