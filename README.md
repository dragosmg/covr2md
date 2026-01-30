
<!-- README.md is generated from README.Rmd. Please edit that file -->

# covr2gh

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/dragosmg/covr2gh/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/dragosmg/covr2gh/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

{covr2gh} was born from a need and a want to have code coverage
information at hand (when reviewing a pull request) without depending on
a 3rd party vendor, a 3rd part GitHub Actions or having to pull 2
branches, run and compare coverages.

This would be useful in many enterprise settings where external services
are not easy to access (and neither are unvetted GitHub Actions).

The main focus is on presenting a brief summary (extracted from the
output of `covr::package_coverage()`) as a comment on a GitHub pull
request (PR).

## Installation

You can install the development version of covr2gh from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("dragosmg/covr2gh")
```

## Example

The package is designed to be used with GitHub Actions. It has an
accompanying workflow that does the following:

- runs `covr::package_coverage()` on both the head and base branches.
- summarises the outputs in a couple of sentences.
- adds collapsible sections with tables containing more details.
- renders a badge and pushes it to a dedicated branch
  (`covr2gh-storage`).

``` r
library(covr2gh)
my_pkg_coverage <- covr::package_coverage("path/to/myawesomepkg")
```
