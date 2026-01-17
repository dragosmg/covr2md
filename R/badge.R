# build a badge which badge needs to be in 2 places:
#   * in the PR comment
#   * in the Readme
#   * maybe stored in a separate branch (e.g. coverage-artifacts)?
build_badge_url <- function(percentage = NULL) {
  if (!rlang::is_null(percentage) && !rlang::is_scalar_double(percentage)) {
    rlang::abort("`percentage` must be a scalar double.")
  }

  if (rlang::is_null(percentage)) {
    value <- "unknown"
    colour <- "lightgrey"
  } else {
    value <- dplyr::case_when(
      rlang::is_dbl_na(percentage) ~ "unknown",
      .default = paste0(percentage, "%25")
    )

    colour <- dplyr::case_when(
      rlang::is_null(percentage) ~ "lightgrey",
      percentage >= 95 ~ "brightgreen",
      percentage >= 90 ~ "green",
      percentage >= 80 ~ "yellowgreen",
      percentage >= 70 ~ "yellow",
      percentage >= 60 ~ "orange",
      percentage >= 0 ~ "red",
      .default = "lightgrey"
    )
  }

  svg_badge_url <- glue::glue(
    "https://img.shields.io/badge/coverage-{value}-{colour}.svg"
  )

  svg_badge_url
}
