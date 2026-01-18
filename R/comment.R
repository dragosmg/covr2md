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
#   * x - head coverage (coverage object)
#   * y - base coverage (coverage object)
#   * z - pr number
#
compose_comment <- function(x, y, pr_number) {
  table_as_string <- to_md(x) |>
    glue::glue_collapse(
      sep = "\n"
    )

  head_coverage_digest <- digest_coverage(x)
  base_coverage_digest <- digest_coverage(y)

  total_head_coverage <- covr::percent_coverage(x)
  total_base_coverage <- covr::percent_coverage(y)

  badge_url <- build_badge_url(total_head_coverage)

  glue::glue(
    "
    # Coverage report

    ![badge]({badge_url})

    ## Coverage summary



    ## Coverage details

    {table_as_string}

    Results for commit: [insert commit hash / URL here]

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
compose_coverage_summary <- function(pr_details) {
  glue::glue(
    "Merging this PR ([#{github.event.pull_request.number}]({pr_html_url}) - {head_sha}) \\
  into {base_name} branch ({base_sha}) - will **increase** / **decrease** / **not change** coverage."
  )
}

# compose_coverage_details <- function()
