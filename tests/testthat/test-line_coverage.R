test_that("compose_line_coverage_details with empty input", {
    expect_identical(
        compose_line_coverage_details(NULL),
        glue::as_glue("\n\n")
    )
})

test_that("compose_line_coverage_details with df", {
    line_cov <- tibble::tibble(
        file = c("foo.R", "bar.R", "baz.R"),
        lines_added = c(5, 4, 10),
        lines_covered = c(2, 4, 6)
    )

    expect_snapshot(
        compose_line_coverage_details(
            line_cov
        )
    )
})
