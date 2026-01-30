#' Digest file coverage
#'
#' Take a `coverage` object (the output of [covr::package_coverage()], extract
#' the filecoverage component and transform it into a `data.frame`/`tibble`.
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
        cli::cli_abort(
            "`x` must be a coverage object"
        )
    }

    file_coverage_df <- x |>
        covr::coverage_to_list() |>
        purrr::pluck(
            "filecoverage"
        ) |>
        tibble::enframe(
            name = "file",
            value = "coverage"
        )

    total <- x |>
        covr::coverage_to_list() |>
        purrr::pluck("totalcoverage")

    total_coverage_df <- tibble::tibble(
        file = "Total",
        coverage = total
    )

    output <- dplyr::bind_rows(
        file_coverage_df,
        total_coverage_df
    )

    output
}

#' Derive a coverage tibble for the changed files
#'
#' @inheritParams compose_comment
#'
#' @returns a`tibble` with 4 columns:
#'   * `file`: file name
#'   * `coverage_head`: coverage for the current branch
#'   * `coverage_base` coverage for the base branch, and
#'   * `delta`: difference in coverage between head and base.
#'
#' @keywords internal
derive_file_cov_df <- function(
    head_coverage,
    base_coverage,
    changed_files
) {
    head_coverage_digest <- digest_coverage(head_coverage)

    base_coverage_digest <- digest_coverage(base_coverage)

    diff_df <- head_coverage_digest |>
        dplyr::left_join(
            base_coverage_digest,
            by = dplyr::join_by(
                file
            ),
            suffix = c(
                "_head",
                "_base"
            )
        ) |>
        dplyr::mutate(
            delta = .data$coverage_head - .data$coverage_base
        )

    # keep any files with changes in content (`changed_files`) or in coverage
    cov_change_files <- diff_df |>
        dplyr::filter(
            .data$delta != 0
        ) |>
        dplyr::pull(
            file
        )

    impacted_files <- c(
        union(
            changed_files,
            cov_change_files
        ),
        "Total"
    )

    diff_df <- diff_df |>
        dplyr::filter(
            file %in% impacted_files
        )

    diff_df
}
