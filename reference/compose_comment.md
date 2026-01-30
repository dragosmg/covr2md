# Compose a coverage comment

Compose a coverage comment

## Usage

``` r
compose_comment(
  head_coverage,
  base_coverage,
  repo,
  pr_number,
  marker = "<!-- covr2gh-code-coverage -->"
)
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

- repo:

  (character) the repository name in the GitHub format (`"OWNER/REPO"`).

- pr_number:

  (integer) the PR number

- marker:

  (character scalar) string used to identify an issue comment generated
  with covr2gh. Defaults to `"<!-- covr2gh-code-coverage -->"`.

## Value

a character scalar with the content of the GitHub comment

## Examples

``` r
if (FALSE) { # \dontrun{
head_coverage <- covr::package_coverage()
system("git checkout main")
base_coverage <- covr::package_coverage()

compose_comment(
  head_coverage = head_coverage,
  base_coverage = base_coverage,
  repo = "dragosmg/covr2ghdemo",
  pr_number = 3
)
} # }
```
