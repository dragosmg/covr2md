
<!-- README.md is generated from README.Rmd. Please edit that file -->

# covr2gh

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/dragosmg/covr2gh/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/dragosmg/covr2gh/actions/workflows/R-CMD-check.yaml)
[![covr2gh
coverage](/../covr2gh-storage/badges/main/coverage_badge.svg)](https://github.com/dragosmg/covr2gh/actions/workflows/covr2gh.yaml)
<!-- badges: end -->

> Test Coverage Summary on ‘GitHub’

{covr2gh} provides an automated way to summarise the impact of a pull
request (PR) on test coverage directly within GitHub.

It is designed to be used with GitHub Actions: once configured, coverage
insight is posted as a comment on the pull request.

The goal is to make test coverage feedback visible, concise, and
actionable, without requiring reviewers to leave GitHub or inspect full
coverage reports.

## Installation

You can install the development version of {covr2gh} from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("dragosmg/covr2gh")
```

## Usage

{covr2gh} includes a helper function that adds a GitHub Actions workflow
to your package. This workflow runs the necessary checks and posts
coverage feedback when pull requests are opened or updated.

``` r
covr2gh::use_covr2gh_action()
```

The helper function also adds a badge to your README, in the {usethis}
badge “block”, if present.

``` md
<!-- badges: start -->
![covr2gh-badge](...)
<!-- badges: end -->
```

After this initial setup step, no further manual interaction with the
package is typically required. Coverage comments are generated
automatically whenever the workflow is triggered on GitHub.
