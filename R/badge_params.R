#' Transform a coverage value into char
#'
#' Outputs both values as both are used downstream by various other helpers.
#' If the input values are `NA` or `NULL` it converts them to `"unknown"`.
#' If the values are greater than 100 or less than 0 it adjusts them to these
#' values
#'
#' @param value (numeric) coverage value. Can also be `NA` or `NULL`
#' @param verbose (logical) if we want messages around the clamping. Default is
#'   `FALSE`.
#' @param call (call) defaults to [rlang::caller_env()]
#'
#' @returns a list with 2 element:
#'   * `num`: the value as numeric
#'   * `char`: the value as character
#'
#' @keywords internal
#' @examples
#' \dontrun{
#' badge_value(26.78)
#' }
badge_value <- function(value, verbose = FALSE, call = rlang::caller_env()) {
    if (is.null(value) || is.na(value)) {
        return(
            structure(
                list(
                    num = NA_real_,
                    char = "unknown"
                ),
                class = "badge_value"
            )
        )
    }

    value_num <- value

    if (value > 100) {
        if (verbose) {
            cli::cli_alert_info(
                "{.arg value} is greater than 100%. It will be adjusted to 100%.",
                .envir = call
            )
        }
        value_num <- 100
    }

    if (value < 0) {
        if (verbose) {
            cli::cli_alert_info(
                "{.arg value} is less than 0%. It will be adjusted to 0%.",
                .envir = call
            )
        }
        value_num <- 0
    }

    value_char <- paste0(round(value_num), "%")

    structure(
        list(
            num = value_num,
            char = value_char
        ),
        class = "badge_value"
    )
}

#' Estimate the width of the value box
#'
#' @param badge_value (`badge_value`) the output of `badge_value()`
#' @param width_label (numeric) the width of the label box. Defaults to 60
#'   pixels.
#'
#' @returns numeric representing the with of the box in which the value will
#' appear
#'
#' @keywords internal
estimate_width_value <- function(
    badge_value,
    width_label = 60
) {
    if (!is_badge_value(badge_value)) {
        cli::cli_abort(
            "`badge_value` must be created with `badge_value()`."
        )
    }

    dplyr::case_when(
        badge_value$char == "unknown" ~ width_label,
        badge_value$char == "100%" ~ 40,
        nchar(badge_value$char) < 3 ~ 30,
        .default = 35
    )
}

#' Estimate the length of the value text
#'
#' @inheritParams estimate_width_value
#' @param text_length_label (numeric) the length of the label text. Defaults to
#'   50 pixels.
#'
#' @returns numeric representing the length of the label text
#'
#' @keywords internal
estimate_text_length_value <- function(badge_value, text_length_label = 50) {
    if (!is_badge_value(badge_value)) {
        cli::cli_abort(
            "`badge_value` must be created with `badge_value()`."
        )
    }

    dplyr::case_when(
        badge_value$char == "unknown" ~ text_length_label,
        badge_value$char == "100%" ~ 31,
        nchar(badge_value$char) < 3 ~ 20,
        .default = 26
    )
}

# no badge_url
# this should return all the parameters needed to build the badge
#   * value as numeric
#   * value as text
#   * colour
#   * badge_url
#   * label_width
#   * value_width based on value as text
#   * text_length for label
#   * text_length for value
#   * total_width = label_width + value_width
#   * text_value_start = label_width + value_width / 2

#' Build `badge_params`
#'
#' Take the value and build a list with all the value-dependent parameters
#' to be injected into the SVG template.
#'
#' @param value (numeric) coverage value
#'
#' @returns a list (a `badge_params` object) with the following elements:
#'   * value_num: the coverage value as numeric (adjusted, if necessary)
#'   * value_char: the coverage value as character
#'   * value_col: the colour for the *value* box
#'   * width_label: the width of the *label* box
#'   * width_value: the width of the *value* box
#'   * text_length_label: the length of the *label* text
#'   * text_length_value: the length of the *value* text
#'   * total_width: the total badge width
#'   * text_start_value: point along the x-axis where the *value* text should
#'   start
#'
#' @keywords internal
badge_params <- function(value) {
    badge_value <- badge_value(value)

    value_colour <- derive_badge_colour(badge_value)

    # the values hardcoded below generally work. i did not want to go down the
    # rabbit hole of trying to make the widths of the label and value boxes
    # entirely adaptive since:
    #   - the text in the label will always be "coverage"
    #   - the font family and font size are not exposed to the user
    #   - the height of the badge is the "standard" 20

    width_label <- 60

    width_value <- estimate_width_value(badge_value, width_label)

    text_length_label <- 50

    text_length_value <- estimate_text_length_value(
        badge_value,
        text_length_label = text_length_label
    )

    structure(
        list(
            value_num = badge_value$num,
            value_char = badge_value$char,
            value_colour = value_colour,
            width_label = width_label,
            width_value = width_value,
            text_length_label = text_length_label,
            text_length_value = text_length_value,
            total_width = width_label + width_value,
            text_start_value = width_label + width_value / 2
        ),
        class = "badge_params"
    )
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
#' @keywords internal
#' @examples
#' \dontrun{
#' derive_badge_colour(5)
#' }
derive_badge_colour <- function(
    badge_value,
    colours = coverage_thresholds
) {
    if (!is_badge_value(badge_value)) {
        cli::cli_abort(
            "`badge_value` must be created with `badge_value()`."
        )
    }

    if (badge_value$char == "unknown") {
        return("#9f9f9f")
    }

    idx <- findInterval(
        badge_value$num,
        coverage_thresholds$value,
        rightmost.closed = TRUE
    )

    value_colour <- coverage_thresholds$colour[idx]

    value_colour
}

is_badge_value <- function(x) {
    inherits(x, "badge_value")
}

is_badge_params <- function(x) {
    inherits(x, "badge_params")
}
