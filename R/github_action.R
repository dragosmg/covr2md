# nolint start: line_length_linter

#' Set up a covr2gh GitHub Action workflow
#'
#' Sets up a [GitHub Actions](https://github.com/features/actions) workflow that
#' calculates and reports test coverage:
#'   * uses [covr::package_coverage()].
#'   * on a *pull request*:
#'     * calculates test coverage for head.
#'     * builds a badge (for use in the commit message).
#'       * if the PR does not come from a fork (write privileges for the
#'       automated GitHub Actions token), the badge is built with an internal
#'       function ([generate_badge()]) and committed to the `covr2gh-storage`
#'       branch.
#'       * if the PR comes from a fork (the GitHub Actions token only has read
#'       permissions), the badge is built with an external service (shields.io)
#'       and is not committed to the storage branch.
#'     * initialises or switches to the `covr2gh-storage` branch and saves a
#'       copy of the badge (only if the PR does not come from a fork).
#'     * switches to base branch and calculates test coverage.
#'     * compares coverage for head and base and posts a comment with the main
#'       findings.
#'     * uploads base coverage and badge as artifacts.
#'     * posts a workflow [summary](https://github.blog/news-insights/product-news/supercharging-github-actions-with-job-summaries/).
#'   * on a *push to main*:
#'     * calculates test coverage for head and creates a badge.
#'     * switches to or creates the `covr2gh-storage` branch.
#'     * commits badge (which is referenced in the README).
#'     * uploads coverage as an artefact.
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
#' `<!-- badges: start -->` and `<!-- badges: end -->`). The URL for the badge
#' SVG points to a storage branch in the repo(`covr2gh-storage`). The link out
#' points to the covr2gh pkgdown website (not yet - TODO update once there is
#' an article to point to).
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
    image_source <- "/../covr2gh-storage/badges/main/coverage-badge.svg"
    # nolint end

    usethis::use_badge(
        badge_name = "covr2gh coverage",
        href = "",
        src = image_source
    )

    invisible(TRUE)
}

# helpers mostly copied from usethis, but simpler as the use case is not as
# complex
# TODO check attribution - both for this and the unexported covr function
is_package <- function(base_path = usethis::proj_get()) {
    result <- tryCatch(
        rprojroot::find_package_root_file(
            path = base_path
        ),
        error = function(e) NULL
    )
    !is.null(result)
}

check_is_package <- function(call = rlang::caller_env()) {
    if (is_package()) {
        return(invisible())
    }

    # nolint start: keyword_quote_linter, object_usage_linter
    project_name <- usethis::proj_get() |>
        fs::path_file()

    cli::cli_abort(
        c(
            "i" = "{.fn use_covr2gh_badge} is designed to work with packages.",
            "x" = "Project {.val {project_name}} is not an R package."
        )
    )
    # nolint end
}
