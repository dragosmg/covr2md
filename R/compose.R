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

# used to identify a comment posted with covr2gh
covr2gh_comment <- "<!-- covr2gh-do-not-delete -->"

#' Compose a coverage comment
#'
#' @param head_coverage (coverage) active / current branch (`HEAD`) coverage.
#'   The output of [covr::package_coverage()] on the head branch.
#' @param base_coverage (coverage) base / target branch coverage (coverage for
#'   the branch merging into). The output of [covr::package_coverage()] on the
#'   base branch.
#' @param diff_cov_target (numeric) minimum accepted diff coverage. Defaults to
#'   `NULL` which is then interpreted as overall base branch coverage.
#' @inheritParams get_pr_details
#'
#' @returns a character scalar with the content of the GitHub comment
#'
#' @export
#' @examples
#' \dontrun{
#' coverage_head <- covr::package_coverage()
#' system("git checkout main")
#' coverage_main <- covr::package_coverage()
#'
#' compose_comment(
#'   head_coverage = coverage_head,
#'   base_coverage = coverage_main,
#'   repo = "<owner>/<repo>",
#'   pr_number = 3
#' )
#' }
compose_comment <- function(
    head_coverage,
    base_coverage,
    repo,
    pr_number,
    diff_cov_target = NULL
) {
    # TODO add some checks on inputs

    pr_details <- get_pr_details(
        repo = repo,
        pr_number = pr_number
    )

    total_head_coverage <- covr::percent_coverage(head_coverage)
    total_base_coverage <- covr::percent_coverage(base_coverage)

    delta_total_coverage <- round(
        total_head_coverage - total_base_coverage,
        2
    )

    badge_url <- build_badge_url(total_head_coverage)

    coverage_summary <- compose_coverage_summary(
        pr_details,
        delta_total_coverage
    )

    changed_files <- get_changed_files(
        repo = repo,
        pr_number = pr_number
    )

    # TODO handle the case when there are no relevant changed files
    #  this works, it just needs some tweaks

    # TODO think about when we would want to return all the files, not just
    # those touched or affected by the PR

    file_cov_df <- combine_file_coverage(
        head_coverage = head_coverage,
        base_coverage = base_coverage,
        changed_files = changed_files
    )

    file_coverage_details <- compose_file_coverage_details(
        file_cov_df
    )

    # changed_files = files that are being changed by the PR
    # relevant_files = files that are being changed by the PR and / or their
    # coverage has changed or they have not existed before (their base coverage)
    # is NA
    relevant_files <- setdiff(file_cov_df$file, "Overall")

    diff_line_coverage <- get_diff_line_coverage(
        head_coverage = head_coverage,
        relevant_files = relevant_files,
        repo = repo,
        pr_details = pr_details
    )

    if (is.null(diff_cov_target)) {
        diff_cov_target <- total_base_coverage
    }

    line_coverage_summary <- compose_line_coverage_summary(
        diff_line_coverage,
        target = diff_cov_target
    )

    line_coverage_details <- compose_line_coverage_details(
        diff_line_coverage
    )

    pkg_url <- glue::glue(
        "[covr2gh v{packageVersion('covr2gh')}](https://dragosmg.github.io/covr2gh)" # nolint
    )

    footer <- glue::glue_data(
        list(
            pkg_url = pkg_url
        ),
        "<sup>Created on {Sys.Date()} with {pkg_url}.</sup>"
    )

    glue::glue_data(
        list(
            comment = covr2gh_comment,
            badge_url = badge_url,
            coverage_summary = coverage_summary,
            line_coverage_summary = line_coverage_summary,
            file_coverage_details = file_coverage_details,
            line_coverage_details = line_coverage_details,
            footer = footer
        ),
        "{comment}

        ## :safety_vest: Coverage summary

        ![badge]({badge_url})

        {coverage_summary}
        {line_coverage_summary}

        <details>
        <summary>Details</summary>

        {file_coverage_details}

        {line_coverage_details}
        </details>

        :recycle: Comment updated with the latest results.

        {footer}"
    )
}

# TODO look into logic invalidating the comment when the base_sha changes

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
#'   repo = "<owner>/<repo>",
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

    by_delta <- glue::glue("by `{abs(delta)}` percentage points")

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

    head_sha_url <- glue::glue_data(
        list(
            repo = pr_details$repo,
            head_sha = pr_details$head_sha
        ),
        "https://github.com/{repo}/commit/{head_sha}"
    )

    base_sha_url <- glue::glue_data(
        list(
            repo = pr_details$repo,
            base_sha = pr_details$base_sha
        ),
        "https://github.com/{repo}/commit/{base_sha}"
    )

    glue::glue_data(
        list(
            emoji = emoji,
            pr_number = pr_details$pr_number,
            pr_html_url = pr_details$pr_html_url,
            short_hash_head = short_hash(pr_details$head_sha),
            head_sha_url = head_sha_url,
            short_hash_base = short_hash(pr_details$base_sha),
            base_sha_url = base_sha_url,
            delta_translation = delta_translation,
            by_delta = by_delta
        ),
        "{emoji} Merging PR [#{pr_number}]({pr_html_url}) \\
        ([`{short_hash_head}`](head_sha_url)) into _{pr_details$base_name}_ \\
        ([`{short_hash_base}`](base_sha_url)) - will **{delta_translation}** \\
        overall coverage {by_delta}."
    )
}
