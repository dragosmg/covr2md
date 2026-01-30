# Get changed files

Sends a GET request to the GitHub API and retrieves the relevant files
involved in the PR. It only includes files that are under `R/` or
`src/`.

## Usage

``` r
get_changed_files(repo, pr_number, call = rlang::caller_env())
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

a character vector containing the names of the changed files.

## Examples

``` r
if (FALSE) { # \dontrun{
get_changed_files("dragosmg/covr2ghdemo", 2)
} # }
```
