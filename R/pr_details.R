#' Get pull request details
#'
#' Sends a GET request to the GitHub API and outputs details about the PR.
#'
#' @param owner (character) the repo owner.
#' @param repo (character) the repo name
#' @param pr_number (integer) the PR number
#' @param call the execution environment to surface the error message from.
#'   Defaults to [rlang::caller_env()].
#'
#' @returns a list with the following elements:
#'   * `head_name`: name of the current branch
#'   * `head_sha`: the sha of the last commit in the current branch
#'   * `base_name`: the name of the destination branch
#'   * `base_sha`: the sha of most recent commit on the destination branch
#'   * `pr_html_url`: the URL to the PR HTML branch
#'
#' @export
#' @examples
#' \dontrun{
#' get_pr_details("dragosmg", "covr2mddemo", "2")
#' }
get_pr_details <- function(
  owner = character(),
  repo = character(),
  pr_number = integer(),
  call = rlang::caller_env()
) {
  if (!rlang::is_scalar_character(owner)) {
    cli::cli_abort(
      "`owner` must be a character scalar.",
      call = call
    )
  }

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
    "https://api.github.com/repos/{owner}/{repo}/pulls/{pr_number}"
  )

  pr_info <- glue::glue("GET {pr_api_url}") |>
    gh::gh()

  list(
    pr_number = pr_number,
    head_name = pr_info$head$ref,
    head_sha = pr_info$head$sha,
    base_name = pr_info$base$ref,
    base_sha = pr_info$base$sha,
    pr_html_url = pr_info$html_url
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
#' @export
#' @examples
#' \dontrun{
#' get_changed_files("dragosmg", "covr2mddemo", 2)
#' }
get_changed_files <- function(
  owner = character(),
  repo = character(),
  pr_number = integer(),
  call = rlang::caller_env()
) {
  if (!rlang::is_scalar_character(owner)) {
    cli::cli_abort(
      "`owner` must be a character scalar.",
      call = call
    )
  }

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
    "https://api.github.com/repos/{owner}/{repo}/pulls/{pr_number}/files"
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
