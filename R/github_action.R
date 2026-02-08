# nolint start: line_length_linter

#' Set up a covr2gh GitHub Action workflow
#'
#' Sets up a [GitHub Actions](https://github.com/features/actions) workflow that
#' calculates and reports test coverage:
#'   * uses [covr::package_coverage()].
#'   * on a *pull request*:
#'     * calculates test coverage for head.
#'     * builds a badge (for use in the commit message).
#'     * initialises or switches to the `covr2gh-storage` branch.
#'     * switches to base branch and calculates test coverage.
#'     * compares coverage for head and base and posts a comment with the main
#'       findings.
#'     * uploads base coverage and badge as artefacts.
#'     * posts a workflow [summary](https://github.blog/news-insights/product-news/supercharging-github-actions-with-job-summaries/).
#'   * on a *push to main*:
#'     * calculates test coverage for head and creates a badge.
#'     * switches to or creates the `covr2gh-storage` branch.
#'     * commits badge (referenced in the README).
#'
#' `use_covr2gh_action()` wraps [usethis::use_github_action()].
#'
#' @param badge (logical) should a badge be added to README? Defaults to `TRUE`.
#'
#' @export
#' @examples
#' \dontrun{
#' use_covr2gh_action()
#' }
use_covr2gh_action <- function(badge = TRUE) {
    usethis::use_github_action(
        url = "https://github.com/dragosmg/covr2gh/blob/main/.github/workflows/covr2gh.yaml",
        # TODO add a link to the pkgdown article once finished
        readme = NULL
    )

    if (isTRUE(badge)) {
        use_covr2gh_badge()
    }

    invisible(TRUE)
}
# nolint end

#' Add a coverage README badge
#'
#' Inserts the markdown text for a coverage badge in the usethis block (between
#' `<!-- badges: start -->` and `<!-- badges: end -->`). The `src` URL for the
#' badge SVG points to a storage branch in the repo(`covr2gh-storage`). The link
#' out points to the actions workflow page.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' use_covr2gh_badge()
#' }
use_covr2gh_badge <- function() {
    check_is_package()

    # nolint start: nonportable_path_linter

    usethis::use_badge(
        badge_name = "covr2gh coverage",
        href = "/../actions/workflows/covr2gh.yaml",
        src = "/../covr2gh-storage/badges/main/coverage_badge.svg"
    )

    # nolint end

    invisible(TRUE)
}

is_package <- getFromNamespace("is_package", "usethis")

check_is_package <- getFromNamespace("check_is_package", "usethis")
