compose_line_coverage_summary <- function(diff_line_coverage, target = 80) {
    if (is.null(diff_line_coverage)) {
        # TODO we probably want to return this when we only have deletions
        # but i expect diff_line_coverage to be empty then
        return(
            ":heavy_equals_sign: Diff coverage: No lines added to relevant files."
        )
    }

    diff_coverage <- diff_line_coverage |>
        dplyr::summarise(
            total_lines_added = sum(.data$lines_added),
            total_lines_covered = sum(.data$lines_covered)
        )

    percentage_line_coverage <- round(
        diff_coverage$total_lines_covered /
            diff_coverage$total_lines_added,
        2
    )

    emoji <- dplyr::if_else(
        percentage_line_coverage >= target,
        ":white_check_mark: ",
        ":x: "
    )

    # TODO make target the current base coverage
    # nolint start: object_usage_linter
    glue::glue(
        "{emoji} Diff coverage: {percentage_line_coverage}% \\
    ({diff_coverage$total_lines_covered} out of \\
    {diff_coverage$total_lines_added} added lines are covered by tests). \\
    Target coverage is at least `{target}%`."
    )
    # nolint end
}

compose_line_coverage_details <- function(diff_line_coverage) {
    diff_line_md_table <- line_cov_to_md(diff_line_coverage)

    subtitle <- ""

    if (!is.null(diff_line_coverage)) {
        subtitle <- "### Coverage for added lines"
    }

    diff_cov_details <- glue::glue(
        "{subtitle}

        {diff_line_md_table}"
    )

    diff_cov_details
}
