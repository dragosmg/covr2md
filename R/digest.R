#' Calculate file coverage
#'
#' @param x `<coverage>` object, defaults to [covr::package_coverage()].
#'
#' @returns a `tibble` with 2 columns (`File` and `Coverage`) summarising
#'   testing coverage at file level.
#'
#' @export
#' @examples
#' \dontrun{
#' library(covr)
#'
#' covr::package_coverage("myawesomepkg") |>
#'   digest_coverage()
#' }
digest_coverage <- function(x = covr::package_coverage()) {
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
