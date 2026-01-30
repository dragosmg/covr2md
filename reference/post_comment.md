# Post a new comment or update an existing one

Post a new comment or update an existing one

## Usage

``` r
post_comment(body, repo, pr_number, comment_id = NULL)
```

## Arguments

- body:

  (character scalar) the content of the body of the message.

- repo:

  (character) the repository name in the GitHub format (`"OWNER/REPO"`).

- pr_number:

  (integer) the PR number

- comment_id:

  (numeric) the ID of the issue comment to update. If `NULL` (the
  default), a new comment will be posted. Usually the output of
  [`get_comment_id()`](https://dragosmg.github.io/covr2gh/reference/get_comment_id.md).

## Value

a `gh_response` object containing the API response

## Examples

``` r
if (FALSE) { # \dontrun{
post_comment(
  "this is amazing",
  repo = "dragosmg/my-test-repo",
  pr_number = 3,
  comment_id = 123456789
)
} # }
```
