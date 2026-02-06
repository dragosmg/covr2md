# brings together file coverage details and line coverage details
compose_details_section <- function(
    file_coverage_details,
    line_coverage_details
) {
    if (file_coverage_details == "" && line_coverage_details == "") {
        return(glue::as_glue(""))
    }

    details_section <- glue::glue_data(
        list(
            file_coverage_details = file_coverage_details,
            line_coverage_details = line_coverage_details
        ),
        "
        <details>
        <summary>Details</summary>

        {file_coverage_details}

        {line_coverage_details}
        </details>
        "
    )

    details_section
}
