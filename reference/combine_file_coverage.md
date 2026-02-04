# Combine head and base file-level coverage

Combine head and base file-level coverage

## Usage

``` r
combine_file_coverage(head_coverage, base_coverage, changed_files)
```

## Arguments

- head_coverage:

  (coverage) active / current branch (`HEAD`) coverage. The output of
  [`covr::package_coverage()`](http://covr.r-lib.org/reference/package_coverage.md)
  on the head branch.

- base_coverage:

  (coverage) base / target branch coverage (coverage for the branch
  merging into). The output of
  [`covr::package_coverage()`](http://covr.r-lib.org/reference/package_coverage.md)
  on the base branch.

## Value

a`tibble` with 4 columns:

- `file`: file name

- `coverage_head`: coverage for the head branch

- `coverage_base` coverage for the base branch, and

- `delta`: difference in coverage between head and base.
