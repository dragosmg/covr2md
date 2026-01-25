#' Get pull request details
#'
#' Sends a GET request to the GitHub API and fetches the PR details. The output
#' contains a subset of these, needed for downstream use.
#'
#' @param repo (character) the repository name in the GitHub format
#'   (`"OWNER/REPO"`).
#' @param pr_number (integer) the PR number
#' @param call the execution environment to surface the error message from.
#'   Defaults to [rlang::caller_env()].
#'
#' @returns an object of class `pr_details` - a list with the following
#' elements:
#'   * `head_name`: name of the current branch
#'   * `head_sha`: the sha of the last commit in the current branch
#'   * `base_name`: the name of the destination branch
#'   * `base_sha`: the sha of most recent commit on the destination branch
#'   * `pr_html_url`: the URL to the PR HTML branch
#'   * `diff_url`: the diff URL
#'
#' @export
#' @examples
#' \dontrun{
#' get_pr_details("dragosmg/covr2mddemo", 2)
#' }
get_pr_details <- function(
  repo,
  pr_number,
  call = rlang::caller_env()
) {
  # TODO check for GitHub format (`OWNER/REPO`)
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

  pr_api_url <- glue::glue(
    "https://api.github.com/repos/{repo}/pulls/{pr_number}"
  )

  pr_info <- glue::glue("GET {pr_api_url}") |>
    gh::gh()

  structure(
    list(
      pr_number = pr_number,
      head_name = pr_info$head$ref,
      head_sha = pr_info$head$sha,
      base_name = pr_info$base$ref,
      base_sha = pr_info$base$sha,
      pr_html_url = pr_info$html_url,
      diff_url = pr_info$diff_url
    ),
    class = "pr_details"
  )
}

#' Get changed files
#'
#' Sends a GET request to the GitHub API and retrieves the relevant files
#' involved in the PR. It only includes files that are under `R/` or `src/`.
#'
#' @inheritParams get_pr_details
#'
#' @returns a character vector containing the names of the changed files.
#'
#' @keywords internal
#' @examples
#' \dontrun{
#' get_changed_files("dragosmg/covr2mddemo", 2)
#' }
get_changed_files <- function(
  repo,
  pr_number,
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

  files_api_url <- glue::glue(
    "https://api.github.com/repos/{repo}/pulls/{pr_number}/files"
  )

  files_info <- glue::glue("GET {files_api_url}") |>
    gh::gh()

  changed_files <- purrr::map_chr(files_info, "filename")

  relevant_files_changed <- stringr::str_subset(
    changed_files,
    pattern = "^R/|^src"
  )

  relevant_files_changed
}
