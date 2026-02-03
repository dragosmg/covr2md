#' Compose the line coverage summary
#'
#' Builds the high-level sentence summarising the line coverage of the patch.
#'
#' @param diff_line_coverage a `tibble` the output of [get_diff_line_coverage()]
#' @param target (numeric) the target coverage for the diff. Default to 80, but
#' most often the base total coverage should be used.
#'
#' @returns a glue string, a sentence summarising the diff coverage.
#'
#' @keywords internal
compose_line_coverage_summary <- function(diff_line_coverage, target = 80) {
    target <- round(target, 2)

    if (is.null(diff_line_coverage)) {
        # TODO we probably want to return this when we only have deletions
        # but i expect diff_line_coverage to be empty then
        return(
            ":heavy_equals_sign: Diff coverage: No lines added to tracked source files." # nolint
        )
    }

    diff_coverage <- diff_line_coverage |>
        dplyr::summarise(
            total_lines_added = sum(.data$lines_added),
            total_lines_covered = sum(.data$lines_covered)
        )

    line_coverage <- round(
        diff_coverage$total_lines_covered /
            diff_coverage$total_lines_added *
            100,
        2
    )

    emoji <- dplyr::if_else(
        line_coverage >= target,
        ":white_check_mark: ",
        ":x: "
    )

    glue::glue_data(
        list(
            emoji = emoji,
            line_coverage = line_coverage,
            lines_covered = diff_coverage$total_lines_covered,
            lines_added = diff_coverage$total_lines_added
        ),
        "{emoji} Diff coverage is {line_coverage}% ({lines_covered} out of \\
        {lines_added} added lines are covered by tests). Minimum accepted is \\
        `{target}%`."
    )
}

#' Compose the line coverage details section
#'
#' The section is made up of a subtitle (Heading 3) and a Markdown table. If
#' the input object is `NULL` an empty string is returned.
#'
#' This section will be part of the "More details" collapsible section of the
#' GitHub comment.
#'
#' @inheritParams compose_line_coverage_summary
#'
#' @returns a `glue` string
#'
#' @keywords internal
compose_line_coverage_details <- function(diff_line_coverage) {
    diff_line_md_table <- line_cov_to_md(diff_line_coverage)

    subtitle <- ""

    if (!is.null(diff_line_coverage)) {
        subtitle <- "### Coverage for added lines"
    }

    diff_cov_details <- glue::glue_data(
        list(
            subtitle = subtitle,
            diff_line_md_table = diff_line_md_table
        ),
        "{subtitle}

        {diff_line_md_table}",
        .trim = TRUE
    )

    diff_cov_details
}
