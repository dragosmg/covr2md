# the GitHub comment should contain:
#   * the overall percentage (as badge) at the top
#   * a topline summary statement:
#     * "merging this PR (PR number & commit hash) into $destination_branch
#     will **increase** / **decrease** / **not change** coverage. The change in
#     coverage is."
#     * it would be great to somehow capture if the added lines are covered by
#     unit tests (or what percentage is)
#   * the H2 (?) title - Summary (or something like Codecov - "Additional
#   details and impacted files").
#   * a summary table for the all files or just those modified by the PR
#     * maybe just those modified by the PR as those would be more relevant.
#     * table could have these columns File, This branch, Destination branch,
#     delta + an indication at file level if coverage is increasing or
#     decreasing
#   * capture the commit hash somehow
#   * maybe something about the target coverage figure
#   * in the future something about direct vs indirect testing
#   * a notice about the fact this is a "sticky" comment that will be updated
#    by subsequent runs
#
# args:
#   * head_coverage (coverage object)
#   * base_coverage (coverage object)
#   * z - pr number
#

#' Compose a coverage comment
#'
#' @param head_coverage (coverage) active / current branch (`HEAD`) coverage.
#'   The output of [covr::package_coverage()] on the branch.
#' @param base_coverage (coverage) base / target branch coverage (coverage for
#'   the branch merging into). The output of [covr::package_coverage()] on the
#'   branch.
#' @param owner (character scalar) repo owner
#' @param repo (character scalar) repo name
#' @param pr_number (integerish scalar) pull request number
#' @param marker (character scalar) string used to identify an issue
#'   comment generated with covr2md. Defaults to
#'   `"<!-- covr2md-code-coverage -->"`.
#' @param keep_all_files (logical) include all files in the diff coverage table
#'   or just those modified by the PR.
#' @inheritParams knitr::kable
#'
#' @returns a character scalar with the content of the GitHub comment
#'
#' @export
#' @examples
#' \dontrun{
#' head_coverage <- covr::package_coverage()
#' system2("git", c("checkout", "main"))
#' base_coverage <- covr::package_coverage()
#'
#' compose_comment(
#'   head_coverage = head_coverage,
#'   base_coverage = base_coverage,
#'   owner = "dragosmg",
#'   repo = "covr2mddemo",
#'   pr_number = 3
#' )
#' }
compose_comment <- function(
  head_coverage,
  base_coverage,
  owner,
  repo,
  pr_number,
  marker = "<!-- covr2md-code-coverage -->",
  keep_all_files = FALSE,
  align = "rrrc"
) {
  # TODO add some checks on inputs

  if (isFALSE(keep_all_files)) {
    changed_files <- get_changed_files(
      owner = owner,
      repo = repo,
      pr_number = pr_number
    )
  }

  if (rlang::is_empty(changed_files)) {
    cli::cli_alert_info(
      "No coverage relevant files changed. Returning all files"
    )
    keep_all_files <- TRUE
  }

  diff_md_table <- compose_coverage_details(
    head_coverage = head_coverage,
    base_coverage = base_coverage,
    changed_files = changed_files,
    keep_all_files = keep_all_files,
    align = align
  )

  pr_details <- get_pr_details(
    owner = owner,
    repo = repo,
    pr_number = pr_number
  )

  total_head_coverage <- covr::percent_coverage(head_coverage)
  total_base_coverage <- covr::percent_coverage(base_coverage)
  delta_total_coverage <- round(total_head_coverage - total_base_coverage, 2)

  badge_url <- build_badge_url(total_head_coverage)

  coverage_summary <- compose_coverage_summary(pr_details, delta_total_coverage)

  glue::glue(
    "
    {marker}

    # Coverage report

    ![badge]({badge_url})

    ## Coverage summary

    {coverage_summary}

    ## Coverage details

    {diff_md_table}
    <br>
    Results for commit: {pr_details$head_sha}

    :recycle: Comment updated with the latest results.
    "
  )
}

# TODO look into logic invalidating the comment when the base_sha changes

# pr_details = a subset of the data we need (the API response)
#  * pr_number
#  * pr_html_url
#  * head_sha
#  * base_name
#  * base_sha
#  * delta in coverage.
compose_coverage_summary <- function(pr_details, delta) {
  delta_translation <- dplyr::case_when(
    delta > 0 ~ "increase",
    delta < 0 ~ "decrease",
    delta == 0 ~ "not change"
  )

  glue::glue(
    "Merging this PR ([#{ pr_details$pr_number}]({pr_details$pr_html_url}) - \\
    {pr_details$head_sha}) into _{pr_details$base_name}_ \\
    ({pr_details$base_sha}) - will **{delta_translation}** coverage."
  )
}

#' Compose coverage details
#'
#' @inheritParams compose_comment
#' @param changed_files (character) names of files changed by the PR. Usually
#'   the output of [get_changed_files()].
#'
#' @returns a markdown table of changes in coverage at file level between the
#'   head and base branches.
#'
#' @keywords internal
#' @examples
#' \dontrun{
#' changed_files <- get_changed_files(
#'   owner = "dragosmg",
#'   repo = "covr2mddemo",
#'   pr_number = 2
#' )
#'
#' coverage_details <- compose_coverage_details(
#'   head_coverage = head_coverage,
#'   base_coverage = base_coverage,
#'   changed_files = changed_files
#' )
#' }
compose_coverage_details <- function(
  head_coverage,
  base_coverage,
  changed_files,
  keep_all_files = FALSE,
  align = "rrrc"
) {
  # TODO handle the case when there are no relevant changed files
  # TODO think about when we would want to return all the files
  # (keep_all_files = TRUE), not just those touched by the PR
  diff_df <- derive_diff_df(
    head_coverage = head_coverage,
    base_coverage = base_coverage,
    changed_files = changed_files,
    keep_all_files = keep_all_files
  )

  diff_df_to_md(
    diff_df,
    align = align
  )
}
