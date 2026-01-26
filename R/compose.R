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
#' @inheritParams get_pr_details
#' @param marker (character scalar) string used to identify an issue
#'   comment generated with covr2md. Defaults to
#'   `"<!-- covr2md-code-coverage -->"`.
#' @inheritParams knitr::kable
#'
#' @returns a character scalar with the content of the GitHub comment
#'
#' @export
#' @examples
#' \dontrun{
#' head_coverage <- covr::package_coverage()
#' system("git checkout main")
#' base_coverage <- covr::package_coverage()
#'
#' compose_comment(
#'   head_coverage = head_coverage,
#'   base_coverage = base_coverage,
#'   repo = "dragosmg/covr2mddemo",
#'   pr_number = 3
#' )
#' }
compose_comment <- function(
  head_coverage,
  base_coverage,
  repo,
  pr_number,
  marker = "<!-- covr2md-code-coverage -->"
) {
  # TODO add some checks on inputs
  # FIXME

  changed_files <- get_changed_files(
    repo = repo,
    pr_number = pr_number
  )

  if (rlang::is_empty(changed_files)) {
    cli::cli_alert_info(
      "No coverage relevant files changed. Returning all files"
    )
    # TODO check this scenario
    # keep_all_files <- TRUE
  }

  pr_details <- get_pr_details(
    repo = repo,
    pr_number = pr_number
  )

  total_head_coverage <- covr::percent_coverage(head_coverage)
  total_base_coverage <- covr::percent_coverage(base_coverage)
  delta_total_coverage <- round(total_head_coverage - total_base_coverage, 2)

  badge_url <- build_badge_url(total_head_coverage)

  coverage_summary <- compose_coverage_summary(
    pr_details,
    delta_total_coverage
  )

  # file_cov_md_table <- compose_file_cov_details(
  #   head_coverage = head_coverage,
  #   base_coverage = base_coverage,
  #   changed_files = changed_files,
  #   align = align
  # )

  file_cov_md_table <- derive_file_cov_df(
    head_coverage = head_coverage,
    base_coverage = base_coverage,
    changed_files = changed_files
  ) |>
    file_cov_df_to_md()

  diff_line_coverage <- get_diff_line_coverage(
    head_coverage = head_coverage,
    changed_files = changed_files,
    repo = repo,
    pr_details = pr_details
  )

  diff_coverage_summary <- compose_diff_coverage_summary(
    diff_line_coverage
  )

  diff_line_md_table <- line_coverage_to_md(
    diff_line_coverage
  )

  # TODO update URL with the correct pkgdown one once there is one
  sup <- glue::glue(
    "<sup>Created on {Sys.Date()} with \\
    [covr2md {packageVersion('covr2md')}](https://reprex.tidyverse.org)</sup>"
  )

  # TODO use diff_line_table for the second details
  glue::glue(
    "
    {marker}

    ## Coverage summary

    ![badge]({badge_url})

    {coverage_summary}
    {diff_coverage_summary}

    <details>
      <summary>Details on changes in file coverage</summary>
      <br/>

      {file_cov_md_table}
    </details>

    <details>
      <summary>Details on diff coverage</summary>
      <br/>

      {diff_line_md_table}
    </details>

    :recycle: Comment updated with the latest results.

    {sup}
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

#' Compose coverage summary
#'
#' Builds the top level sentences of the summary.
#'
#' @param pr_details a `<pr_details>` object representing a subset of the pull
#'   request metadata we need. The output of [get_pr_details()].
#' @param delta (numeric scalar) difference in total coverage between head of
#'   current branch and base branch.
#'
#' @returns a string (character scalar) containing the text for the coverage
#'   summary.
#'
#' @keywords internal
#' @examples
#' \dontrun{
#' pr_details <- get_pr_details(
#'   repo = "dragosmg/covr2mddemo",
#'   pr_number = 2
#' )
#'
#' coverage_summary <- compose_coverage_summary(
#'   pr_details = pr_details,
#'   delta = 20.43
#' )
#' }
compose_coverage_summary <- function(pr_details, delta) {
  delta_translation <- dplyr::case_when(
    delta > 0 ~ "increase",
    delta < 0 ~ "decrease",
    delta == 0 ~ "not change"
  )

  by_delta <- glue::glue(" by `{delta}` percentage points")

  by_delta <- dplyr::if_else(
    delta == 0,
    "",
    by_delta
  )

  emoji <- dplyr::if_else(
    delta >= 0,
    ":white_check_mark: ",
    ":x: "
  )

  glue::glue(
    "{emoji}Merging PR [#{ pr_details$pr_number}]({pr_details$pr_html_url}) \\
    ({pr_details$head_sha}) into _{pr_details$base_name}_ \\
    ({pr_details$base_sha}) - will **{delta_translation}** coverage{by_delta}."
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
#'   repo = "dragosmg/covr2mddemo",
#'   pr_number = 2
#' )
#'
#' file_coverage_details <- compose_file_cov_details(
#'   head_coverage = head_coverage,
#'   base_coverage = base_coverage,
#'   changed_files = changed_files
#' )
#' }
compose_file_cov_details <- function(
  head_coverage,
  base_coverage,
  changed_files,
  align = "rrrrc"
) {
  # TODO handle the case when there are no relevant changed files
  # TODO think about when we would want to return all the files, not just
  # those touched or affected by the PR
  file_cov_df <- derive_file_cov_df(
    head_coverage = head_coverage,
    base_coverage = base_coverage,
    changed_files = changed_files
  )

  file_cov_df_to_md(
    file_cov_df,
    align = align
  )
}

compose_diff_coverage_summary <- function(diff_line_coverage, target = 80) {
  diff_coverage <- diff_line_coverage |>
    dplyr::summarise(
      total_lines_added = sum(.data$lines_added),
      total_lines_covered = sum(.data$lines_covered)
    )

  percentage_line_coverage <- round(
    diff_coverage$total_lines_covered /
      diff_coverage$total_lines_added,
    2
  )

  emoji <- dplyr::if_else(
    percentage_line_coverage >= target,
    ":white_check_mark: ",
    ":x: "
  )

  glue::glue(
    "{emoji} Diff coverage: {percentage_line_coverage}% \\
    ({diff_coverage$total_lines_covered} out of \\
    {diff_coverage$total_lines_added} added lines are covered by tests). \\
    Target coverage is at least `{target}%`."
  )
}
