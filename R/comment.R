# PRs are issues
# All PRs are issues, but not all issues are PRs.
#' Get the ID of the covr2md comment
#'
#' Comments are identified by a specific comment, the "marker", by default
#' `"<!-- covr2md-code-coverage -->"`. `get_comment_id()` looks for this
#' marker. If it can find it, it returns the comment ID, otherwise it returns
#' `NULL`.
#'
#' The output of `get_comment_id()` is the used downstream by `post_comment()`
#' post a new comment or to update an existing one.
#'
#' @inheritParams get_pr_details
#' @inheritParams compose_comment
#'
#' @returns a numeric scalar representing the comment id or `NULL`
#'
#' @export
#' @examples
#' \dontrun{
#' get_comment_id("dragosmg/demo-repo", 3)
#' }
get_comment_id <- function(
  repo,
  pr_number,
  marker = "<!-- covr2md-code-coverage -->",
  call = rlang::caller_env()
) {
  if (!rlang::is_scalar_character(repo)) {
    cli::cli_abort(
      "`repo` must be a character scalar.",
      call = call
    )
  }

  if (!rlang::is_scalar_integerish(pr_number)) {
    cli::cli_abort(
      "`pr_number` must be an integer-like scalar.",
      call = call
    )
  }

  if (!rlang::is_scalar_character(marker)) {
    cli::cli_abort(
      "`marker` must be a character scalar.",
      call = call
    )
  }

  api_url <- glue::glue(
    "https://api.github.com/repos/{repo}/issues/{pr_number}/comments"
  )

  # TODO add test to confirm everything works with a NULL
  comments_info <- tryCatch(
    glue::glue("GET {api_url}") |>
      gh::gh(),
    error = function(e) NULL
  )

  if (rlang::is_null(comments_info)) {
    return(NULL)
  }

  # identify the comment that contains the marker we set
  comment_index <- comments_info |>
    # look in the body of the comment for the marker
    purrr::map("body") |>
    # detect_index identifies the position of the first match
    purrr::detect_index(
      \(x) stringr::str_detect(x, pattern = marker)
    )

  if (comment_index == 0) {
    return(NULL)
  }

  comments_info[[comment_index]]$id
}


#' Post a new comment or update an existing one
#'
#' @inheritParams get_pr_details
#' @param body (character scalar) the content of the body of the message.
#' @param comment_id (numeric) the ID of the issue comment to update. If `NULL`
#'   (the default), a new comment will be posted. Usually the output of
#'   [get_comment_id()].
#' @inheritParams compose_comment
#'
#' @returns a `gh_response` object containing the API response
#'
#' @export
#' @examples
#' \dontrun{
#' post_comment(
#'   "this is amazing",
#'   repo = "dragosmg/my-test-repo",
#'   pr_number = 3,
#'   comment_id = 123456789
#' )
#' }
post_comment <- function(
  body,
  repo,
  pr_number,
  comment_id = NULL
) {
  # TODO add checks for
  #  * body
  #  * repo
  #  * pr_number
  #  * comment_id
  #  * marker

  # posting a new comment vs updating an existing one requires hitting a
  # different endpoint

  # post / create a new issue comment
  api_url <- glue::glue(
    "https://api.github.com/repos/{repo}/issues/{pr_number}/comments"
  )

  if (!rlang::is_null(comment_id)) {
    # update an existing issue comment
    api_url <- glue::glue(
      "https://api.github.com/repos/{repo}/issues/comments/{comment_id}"
    )
  }

  response <- glue::glue("POST {api_url}") |>
    gh::gh(body = body)

  response
}

#' Delete a comment
#'
#' Thin wrapper for making a `DELETE` request to the GitHub API.
#'
#' @inheritParams get_pr_details
#' @param comment_id (numeric) the ID of the issue comment to delete.
#'
#' @returns a `gh_response` object
#'
#' @keywords internal
#' @examples
#' \dontrun{
#' delete_comment("dragosmg/this-is-my-repo", 4553)
#' }
delete_comment <- function(
  repo,
  comment_id
) {
  api_url <- glue::glue(
    "https://api.github.com/repos/{repo}/issues/comments/{comment_id}"
  )

  response <- glue::glue("DELETE {api_url}") |>
    gh::gh()

  response
}
