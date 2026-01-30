# Get the ID of the covr2gh comment

Comments are identified by a specific comment, the "marker", by default
`"<!-- covr2gh-code-coverage -->"`. `get_comment_id()` looks for this
marker. If it can find it, it returns the comment ID, otherwise it
returns `NULL`.

## Usage

``` r
get_comment_id(
  repo,
  pr_number,
  marker = "<!-- covr2gh-code-coverage -->",
  call = rlang::caller_env()
)
```

## Arguments

- repo:

  (character) the repository name in the GitHub format (`"OWNER/REPO"`).

- pr_number:

  (integer) the PR number

- marker:

  (character scalar) string used to identify an issue comment generated
  with covr2gh. Defaults to `"<!-- covr2gh-code-coverage -->"`.

- call:

  the execution environment to surface the error message from. Defaults
  to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

a numeric scalar representing the comment id or `NULL`

## Details

The output of `get_comment_id()` is the used downstream by
[`post_comment()`](https://dragosmg.github.io/covr2gh/reference/post_comment.md)
post a new comment or to update an existing one.

## Examples

``` r
if (FALSE) { # \dontrun{
get_comment_id("dragosmg/demo-repo", 3)
} # }
```
