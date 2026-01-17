# build a badge which badge needs to be in 2 places:
#   * in the PR comment
#   * in the Readme
#   * maybe stored in a separate branch (e.g. coverage-artifacts)?
build_badge_url <- function(percentage = NULL) {
  if (!rlang::is_null(percentage) && !rlang::is_scalar_double(percentage)) {
    rlang::abort("`percentage` must be a scalar double.")
  }

  value <- derive_badge_value(percentage)
  colour <- derive_badge_colour(percentage)

  svg_badge_url <- glue::glue(
    "https://img.shields.io/badge/coverage-{value}-{colour}.svg"
  )

  svg_badge_url
}

derive_badge_value <- function(percentage) {
  if (rlang::is_null(percentage)) {
    value <- "unknown"
    return(value)
  }

  if (!rlang::is_scalar_double(percentage)) {
    rlang::abort(
      "`percentage` must be a scalar double.",
      call = rlang::caller_env()
    )
  }

  value <- dplyr::case_when(
    rlang::is_dbl_na(percentage) ~ "unknown",
    .default = paste0(round(percentage, 2), "%25")
  )

  value
}

derive_badge_colour <- function(percentage) {
  if (rlang::is_null(percentage)) {
    colour <- "lightgrey"
    return(colour)
  }

  if (!rlang::is_scalar_double(percentage)) {
    rlang::abort(
      "`percentage` must be a scalar double.",
      call = rlang::caller_env()
    )
  }

  # these are the shields.io named colours
  # https://github.com/badges/shields/tree/master/badge-maker#colors
  colour <- dplyr::case_when(
    percentage >= 90 ~ "brightgreen",
    percentage >= 80 ~ "green",
    percentage >= 70 ~ "yellowgreen",
    percentage >= 60 ~ "yellow",
    percentage >= 50 ~ "orange",
    percentage >= 0 ~ "red",
    .default = "lightgrey"
  )

  colour
}
