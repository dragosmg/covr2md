calculate_file_coverage <- function(x) {
  if (!inherits(x, "coverage")) {
    rlang::abort(
      "`x` must be a coverage object"
    )
  }

  output <- x |>
    covr::coverage_to_list() |>
    purrr::pluck(
      "filecoverage"
    ) |>
    tibble::enframe(
      name = "File",
      value = "Coverage"
    ) |>
    dplyr::mutate(
      Coverage = paste0(
        .data$Coverage,
        "%"
      )
    )

  output
}
