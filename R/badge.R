#' Generate a coverage badge
#'
#' @param value (a numeric scalar) percentage coverage.
#'
#' @returns a SVG string invisibly
#'
#' @export
#' @examples
#' generate_badge(5)
#' generate_badge(48)
generate_badge <- function(value) {
    badge_params <- badge_params(value)

    badge_template_path <- fs::path_package(
        "templates",
        "badge.txt",
        package = "covr2gh"
    )

    badge_template <- readLines(badge_template_path) |>
        stringr::str_flatten(
            collapse = "\n"
        )

    badge_svg <- glue::glue_data(
        badge_params,
        badge_template,
        .trim = TRUE
    )

    invisible(badge_svg)
}

#' Build the URL to the badge SVG
#'
#' This is needed since the Markdown comment on GitHub does not allow embedded
#' images (e.g. as data URI https://en.wikipedia.org/wiki/Data_URI_scheme). In
#' theory we could encode an image as a base64 string and then use this with an
#' `<img>` tag in HTML (GitHub supports some tags in markdown). For example, we
#' could accomplish this with `knitr::image_uri()`.
#'
#' We have 2 choices:
#' * upload the badge to a separate, "storage" branch, or
#' * use an external URL (e.g. shields)
#'
#' The whole issue (that started this package) is that, in enterprise settings,
#' using an external URL might not be possible.
#' In a public repo, using a storage branch should not work when the PR comes
#' from a fork (as the automatic GHA token only has read privileges).
#' In conclusion, we can make a distinction between PR from forks (will use an
#' external URL) vs non-forks (which will upload the badge to the storage
#' branch).
#'
#' Once the PR is merged the workflow triggered on push to main will be able to
#' upload the badge to the storage branch since it's no longer an "external"
#' activity.
#'
#' @param pr_details a `pr_details` object (the output of `get_pr_details()`)
#' @param value (numeric) coverage value
#'
#' @returns a glue string.
#'
#' @keywords internal
build_badge_url <- function(pr_details, value) {
    is_fork <- pr_details$is_fork

    if (isTRUE(is_fork)) {
        # we use a shields badge as the workflow secret does not have enough
        # privileges to push to the storage branch
        badge_params <- badge_params(value)
        colour <- badge_params$value_colour |>
            stringr::str_remove(
                stringr::fixed("#")
            )
        value <- badge_params$value_char

        badge_url <- glue::glue(
            "https://img.shields.io/badge/coverage-{value}25-{colour}.svg"
        )
        return(badge_url)
    }

    repo <- pr_details$repo
    folder <- glue::glue(
        "covr2gh-storage/badges/{pr_details$head_name}" # nolint
    )

    badge_url <- glue::glue(
        "https://raw.githubusercontent.com/{repo}/{folder}/coverage_badge.svg"
    )

    badge_url
}
