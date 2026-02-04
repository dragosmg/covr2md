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
#' @param value (numeric) coverage value
#'
#' @returns a glue string.
#'
#' @keywords internal
build_badge_url <- function(value) {
    badge_params <- badge_params(value)
    colour <- badge_params$value_colour |>
        stringr::str_remove(
            stringr::fixed("#")
        )

    badge_url <- glue::glue_data(
        list(
            value = badge_params$value_char,
            colour = colour
        ),
        "https://img.shields.io/badge/coverage-{value}25-{colour}.svg"
    )

    badge_url
}
