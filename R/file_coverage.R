#' Digest file coverage
#'
#' Takes a `coverage` object (the output of [covr::package_coverage()], extracts
#' the `"filecoverage"` component and transforms it into a `tibble`. It also
#' extracts the `"totalcoverage"` and adds it as the `"Overall"` row.
#'
#' @param x `<coverage>` object, defaults to [covr::package_coverage()].
#'
#' @returns a `tibble` with 2 columns (`File` and `Coverage`) summarising
#'   testing coverage at file level.
#'
#' @keywords internal
#' @examples
#' \dontrun{
#' library(covr)
#'
#' covr::package_coverage("myawesomepkg") |>
#'   file_coverage()
#' }
file_coverage <- function(x) {
    if (!inherits(x, "coverage")) {
        cli::cli_abort(
            "`x` must be a coverage object"
        )
    }

    x |>
        covr::coverage_to_list() |>
        purrr::list_c() |>
        tibble::enframe(
            name = "file",
            value = "coverage"
        ) |>
        dplyr::mutate(
            file = dplyr::if_else(
                nzchar(.data$file),
                .data$file,
                "Overall"
            ),
            coverage = as.numeric(
                .data$coverage
            )
        )
}

#' Combine head and base file-level coverage
#'
#' @inheritParams compose_comment
#'
#' @returns a`tibble` with 4 columns:
#'   * `file`: file name
#'   * `coverage_head`: coverage for the head branch
#'   * `coverage_base` coverage for the base branch, and
#'   * `delta`: difference in coverage between head and base.
#'
#' @keywords internal
combine_file_coverage <- function(
    head_coverage,
    base_coverage,
    changed_files
) {
    head_coverage_digest <- file_coverage(head_coverage)
    base_coverage_digest <- file_coverage(base_coverage)

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
    # TODO this does not capture situations when the code has changed, but the
    # coverage hasn't (i.e. coverage is 0)
    # * this is relevant
    # * need to return at capturing both files with changes to coverage and
    # those
    # with changes to content. In this case, because we use the files here to
    # subset the diff_text,
    # we miss a bunch of files functions with content change

    # keep any files with changes in coverage or NA delta
    diff_df |>
        dplyr::filter(
            .data$delta != 0 | # change in coverage
                is.na(.data$coverage_base) | # new files
                .data$file %in% changed_files | # changed files
                .data$file == "Overall"
        )
}

#' Compose the file coverage details section
#'
#' the section is made up of a subtitle (heading 3) and a table. if the input is
#' `NULL`, the output is an empty string.
#'
#' @param file_cov_df a `tibble`, the output of [combine_file_coverage()]
#'
#' @returns a glue object, a string with the section content.
#'
#' @keywords internal
compose_file_coverage_details <- function(file_cov_df) {
    file_cov_md_table <- file_cov_to_md(file_cov_df)

    subtitle <- ""

    if (!is.null(file_cov_df)) {
        subtitle <- "### Files with code or coverage changes"
    }

    file_cov_details <- glue::glue(
        "{subtitle}

        {file_cov_md_table}"
    )
    file_cov_details
}
