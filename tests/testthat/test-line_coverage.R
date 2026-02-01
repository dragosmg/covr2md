test_that("compose_line_coverage_details with empty input", {
    expect_identical(
        compose_line_coverage_details(NULL),
        "\n\n"
    )

    expect_s3_class(
        compose_line_coverage_details(NULL),
        "glue"
    )
})

test_that("compose_line_coverage_details with df", {
    line_cov <- tibble::tibble(
        file = c("R/foo.R", "R/bar.R", "R/baz.R"), # nolint
        lines_added = c(5, 4, 10),
        lines_covered = c(2, 4, 6)
    )

    expect_s3_class(
        compose_line_coverage_details(
            line_cov
        ),
        "glue"
    )

    expect_snapshot(
        compose_line_coverage_details(
            line_cov
        )
    )
})

test_that("compose_line_coverage_summary works", {
    expect_snapshot(
        compose_line_coverage_summary(NULL)
    )

    line_cov <- tibble::tibble(
        file = c("R/foo.R", "R/bar.R", "R/baz.R"), # nolint: nonportable_path_linter
        lines_added = c(5, 4, 10),
        lines_covered = c(2, 4, 6)
    )

    expect_snapshot(
        compose_line_coverage_summary(line_cov)
    )

    expect_s3_class(
        compose_line_coverage_summary(line_cov),
        "glue"
    )

    expect_snapshot(
        compose_line_coverage_summary(
            line_cov,
            target = 40
        )
    )
})
