# Get pull request details

Sends a GET request to the GitHub API and fetches the PR details. The
output contains a subset of these, needed for downstream use.

## Usage

``` r
get_pr_details(repo, pr_number, call = rlang::caller_env())
```

## Arguments

- repo:

  (character) the repository name in the GitHub format (`"OWNER/REPO"`).

- pr_number:

  (integer) the PR number

- call:

  the execution environment to surface the error message from. Defaults
  to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

an object of class `pr_details` - a list with the following elements:

- `head_name`: name of the current branch

- `head_sha`: the sha of the last commit in the current branch

- `base_name`: the name of the destination branch

- `base_sha`: the sha of most recent commit on the destination branch

- `pr_html_url`: the URL to the PR HTML branch

- `diff_url`: the diff URL

## Examples

``` r
if (FALSE) { # \dontrun{
get_pr_details("dragosmg/covr2ghdemo", 2)
} # }
```
