test_that("file_coverage() works", {
    cov <- readRDS(
        test_path(
            "fixtures",
            "sample_coverage.RDS"
        )
    )

    expect_snapshot(
        file_coverage(cov)
    )

    expect_s3_class(
        file_coverage(cov),
        "tbl_df"
    )
})

test_that("file_coverage() complains", {
    expect_snapshot(
        error = TRUE,
        file_coverage(mtcars)
    )
})

test_that("combine_file_coverage works", {
    head_coverage <- readRDS(
        test_path(
            "fixtures",
            "head_coverage.RDS"
        )
    )
    base_coverage <- readRDS(
        test_path(
            "fixtures",
            "base_coverage.RDS"
        )
    )

    expect_snapshot(
        combine_file_coverage(
            head_coverage,
            base_coverage
        )
    )

    expect_s3_class(
        combine_file_coverage(
            head_coverage,
            base_coverage
        ),
        "tbl_df"
    )
})

test_that("compose_file_coverage_details works", {
    file_cov <- tibble::tibble(
        file = c("R/foo.R", "R/bar.R", "R/baz.R", "Overall"), # nolint
        coverage_head = c(56.2, 43.5, 78.34, 60.34),
        coverage_base = c(52.1, 12.5, 84.23, 54.5)
    ) |>
        dplyr::mutate(
            delta = coverage_head - coverage_base
        )

    expect_s3_class(
        compose_file_coverage_details(
            file_cov
        ),
        "glue"
    )

    expect_snapshot(
        compose_file_coverage_details(
            file_cov
        )
    )
})
