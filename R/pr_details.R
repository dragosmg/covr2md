#' Get pull request details
#'
#' Sends a GET request to the GitHub API and outputs details about the PR.
#'
#' @param owner (character) the repo owner.
#' @param repo (character) the repo name
#' @param pr_number (integer) the PR number
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
  pr_number = integer()
) {
  pr_api_url <- glue::glue(
    "https://api.github.com/repos/{owner}/{repo}/pulls/{pr_number}"
  )

  pr_info <- glue::glue("GET {pr_api_url}") |>
    gh::gh()

  list(
    head_name = pr_info$head$ref,
    head_sha = pr_info$head$sha,
    base_name = pr_info$base$ref,
    base_sha = pr_info$base$sha,
    pr_html_url = pr_info$html_url
  )
}

get_changed_files <- function(
  owner = character(),
  repo = character(),
  pr_number = integer()
) {
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
