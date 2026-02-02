#' Identify the covr2gh comment
#'
#' Comments are identified by a specific "marker", in itself a comment. This is
#' hardcoded to `"<!-- covr2gh-do-not-delete -->"`. `get_comment_id()` looks for
#' this marker. If it can find it, it returns the comment ID, otherwise it
#' returns `NULL`.
#'
#' The output of `get_comment_id()` is the used `post_comment()` post a new
#' comment or update an existing one.
#'
#' @inheritParams get_pr_details
#' @inheritParams compose_comment
#'
#' @returns a numeric scalar representing the comment id or `NULL`
#'
#' @keywords internal
#' @examples
#' \dontrun{
#' get_comment_id("<owner>/<repo>", 3)
#' }
get_comment_id <- function(
    repo,
    pr_number,
    call = rlang::caller_env()
) {
    marker <- "<!-- covr2gh-do-not-delete -->"

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

    # identify the comment containing the marker
    comment_index <- comments_info |>
        # look in the comment body
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


#' Post or update comment
#'
#' `post_comment()` first checks if a "known" `covr2gh` comment exists on the
#' target pull request. If it does, then it updates it, if it doesn't, then a
#' a new comment is posted.
#'
#' @inheritParams get_pr_details
#' @param body (character scalar) the content of the body of the message.
#' @param new (logical) post a new comment or update existing one. Defaults to
#'   `FALSE`.
#' @param delete (logical) whether to delete a comment. Useful when posting new
#'   comments (delete old ones).
#' @inheritParams compose_comment
#'
#' @returns a `gh_response` object containing the API response
#'
#' @export
#' @examples
#' \dontrun{
#' post_comment(
#'   "this is amazing",
#'   repo = "<owner>/<repo>",
#'   pr_number = 3
#' )
#' }
post_comment <- function(
    body,
    repo,
    pr_number,
    new = FALSE,
    delete = new
) {
    comment_id <- get_comment_id(
        repo = repo,
        pr_number = pr_number
    )

    if (isTRUE(new) && isTRUE(delete) && !rlang::is_null(comment_id)) {
        delete_comment(repo, comment_id)
    }

    if (rlang::is_null(comment_id)) {
        new <- TRUE
    }

    # TODO add checks for
    #  * body
    #  * repo
    #  * pr_number

    # posting a new comment vs updating an existing one is accomplished by
    # using different endpoints

    if (isTRUE(new)) {
        # endpoint for posting a new issue comment
        api_url <- glue::glue(
            "https://api.github.com/repos/{repo}/issues/{pr_number}/comments"
        )
    } else {
        # endpoint for updating an existing one
        api_url <- glue::glue(
            "https://api.github.com/repos/{repo}/issues/comments/{comment_id}"
        )
    }

    response <- glue::glue("POST {api_url}") |>
        gh::gh(body = body)

    invisible(response)
}

#' Delete a comment
#'
#' Thin wrapper for making a `DELETE` request to the issue comments endpoint
#' of the GitHub API.
#'
#' @inheritParams get_pr_details
#' @param comment_id (numeric) the ID of the issue comment to delete.
#'
#' @returns a `gh_response` object
#'
#' @keywords internal
#' @examples
#' \dontrun{
#' delete_comment("<owner>/<repo>", 4553)
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

    invisible(response)
}
