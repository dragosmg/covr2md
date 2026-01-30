# Derive a coverage tibble for the changed files

Derive a coverage tibble for the changed files

## Usage

``` r
derive_file_cov_df(head_coverage, base_coverage, changed_files)
```

## Arguments

- head_coverage:

  (coverage) active / current branch (`HEAD`) coverage. The output of
  [`covr::package_coverage()`](http://covr.r-lib.org/reference/package_coverage.md)
  on the branch.

- base_coverage:

  (coverage) base / target branch coverage (coverage for the branch
  merging into). The output of
  [`covr::package_coverage()`](http://covr.r-lib.org/reference/package_coverage.md)
  on the branch.

## Value

a`tibble` with 4 columns:

- `file`: file name

- `coverage_head`: coverage for the current branch

- `coverage_base` coverage for the base branch, and

- `delta`: difference in coverage between head and base.
