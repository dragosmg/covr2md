# Post or update comment

`post_comment()` first checks if a "known" `covr2gh` comment exists on
the target pull request. If it does, then it updates it, if it doesn't,
then a a new comment is posted.

## Usage

``` r
post_comment(body, repo, pr_number, new = FALSE, delete = new)
```

## Arguments

- body:

  (character scalar) the content of the body of the message.

- repo:

  (character) the repository name in the GitHub format (`"OWNER/REPO"`).

- pr_number:

  (integer) the PR number

- new:

  (logical) post a new comment or update existing one. Defaults to
  `FALSE`.

- delete:

  (logical) whether to delete a comment. Useful when posting new
  comments (delete old ones).

## Value

a `gh_response` object containing the API response

## Examples

``` r
if (FALSE) { # \dontrun{
post_comment(
  "this is amazing",
  repo = "<owner>/<repo>",
  pr_number = 3
)
} # }
```
