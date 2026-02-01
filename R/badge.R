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
    # NAs are contagious, NULLs are not
    if (!is.null(value)) {
        value_adjusted <- max(min(value, 100), 0)

        if (!identical(value, value_adjusted)) {
            cli::cli_alert_info(
                "The coverage percentage has been adjusted to \\
                {.val {value_adjusted}} from the initial value of \\
                {.val {value}}."
            )
            value <- value_adjusted
        }
    }

    char_value <- "unknown" # nolint object_usage_linter

    if (!is.null(value) && !is.na(value)) {
        char_value <- paste0(round(value), "%")
    }

    # the values hardcoded below generally work. i did not want to go down the
    # rabbit hole of trying to make the widths of the label and value boxes
    # entirely adaptive since:
    #   - the text in the label will always be "coverage"
    #   - the font family and font size are not exposed to the user
    #   - the height of the badge is the "standard" 20

    label_width <- 60
    value_width <- dplyr::case_when(
        char_value == "unknown" ~ label_width,
        char_value == "100%" ~ 40,
        nchar(char_value) < 3 ~ 30,
        .default = 35
    )

    # nolint start object_usage_linter
    text_length_label <- 50
    text_length_value <- dplyr::case_when(
        char_value == "unknown" ~ text_length_label,
        char_value == "100%" ~ 31,
        nchar(char_value) < 3 ~ 20,
        .default = 26
    )

    total_width <- label_width + value_width

    text_value_start <- label_width + value_width / 2

    value_colour <- derive_value_colour(value)

    # nolint end

    badge_template_path <- fs::path_package(
        "templates",
        "badge.txt",
        package = "covr2gh"
    )
    badge_template <- readLines(badge_template_path) |>
        stringr::str_flatten(
            collapse = "\n"
        )

    badge_svg <- glue::glue(
        badge_template,
        .trim = TRUE
    )

    invisible(badge_svg)
}

coverage_thresholds <- tibble::tibble(
    value = c(0, 20, 40, 55, 70, 85, 100),
    colour = c(
        "#D9534F",
        "#E4804E",
        "#F0AD4E",
        "#DFB317",
        "#A4C61D",
        "#5CB85C",
        "#5CB85C"
    )
)

#' Derive the colour for the value part of the badge
#'
#' Maps a value to a certain interval and chooses the corresponding colour.
#'
#' @param value (integer-like scalar) coverage percentage
#' @param colours (`tibble`) a tibble with 2 columns `value` (threshold) and
#'   `colour`.
#'
#' @returns a colour hexcode as string
#'
#' @noRd
#' @examples
#' \dontrun{
#' derive_value_colour(5)
#' }
derive_value_colour <- function(
    value,
    colours = coverage_thresholds
) {
    if (is.null(value) || is.na(value)) {
        value_colour <- "#9f9f9f"
        return(value_colour)
    }

    idx <- findInterval(
        value,
        coverage_thresholds$value,
        rightmost.closed = TRUE
    )

    value_colour <- coverage_thresholds$colour[idx]

    value_colour
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
#' external URL) vs non-forks (which will upload the badge to the storage branch).
#'
#' Once the PR is merged the workflow triggered on push to main will be able to
#' upload the badge to the storage branch since it's no longer an "external"
#' activity.
#'
#' @param pr_details
#'
#' @returns a glue string.
#'
#' @keywords internal
build_badge_url <- function(pr_details) {
    repo <- pr_details$repo
    branch_folder <- glue::glue(
        "covr2gh-storage/badges/{pr_details$head_name}" # nolint
    )

    # nolint start line_length_linter
    glue::glue(
        "https://raw.githubusercontent.com/{repo}/{branch_folder}/coverage_badge.svg"
    )
    # nolint end
}
