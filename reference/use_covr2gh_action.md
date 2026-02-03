# Set up a covr2gh GitHub Action workflow

Sets up a [GitHub Actions](https://github.com/features/actions) workflow
that calculates and reports test coverage:

- uses
  [`covr::package_coverage()`](http://covr.r-lib.org/reference/package_coverage.md).

- on a *pull request*:

  - calculates test coverage for head.

  - builds a badge (for use in the commit message).

    - if the PR does not come from a fork (write privileges for the
      automated GitHub Actions token), the badge is built with an
      internal function
      ([`generate_badge()`](https://dragosmg.github.io/covr2gh/reference/generate_badge.md))
      and committed to the `covr2gh-storage` branch.

    - if the PR comes from a fork (the GitHub Actions token only has
      read permissions), the badge is built with an external service
      (shields.io) and is not committed to the storage branch.

  - initialises or switches to the `covr2gh-storage` branch and saves a
    copy of the badge (only if the PR does not come from a fork).

  - switches to base branch and calculates test coverage.

  - compares coverage for head and base and posts a comment with the
    main findings.

  - uploads base coverage and badge as artifacts.

  - posts a workflow
    [summary](https://github.blog/news-insights/product-news/supercharging-github-actions-with-job-summaries/).

- on a *push to main*:

  - calculates test coverage for head and creates a badge.

  - switches to or creates the `covr2gh-storage` branch.

  - commits badge (which is referenced in the README).

  - uploads coverage as an artefact.

## Usage

``` r
use_covr2gh_action(badge = TRUE)
```

## Arguments

- badge:

  (logical) should a badge be added to README? Defaults to `TRUE`.

## Details

`use_covr2gh_action()` wraps
[`usethis::use_github_action()`](https://usethis.r-lib.org/reference/use_github_action.html).

## Examples

``` r
if (FALSE) { # \dontrun{
use_covr2gh_action()
} # }
```
