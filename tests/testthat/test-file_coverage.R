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
    # test 1
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

    changed_files <- "R/add_two.R"

    expect_snapshot(
        combine_file_coverage(
            head_coverage,
            base_coverage,
            changed_files
        )
    )

    expect_s3_class(
        combine_file_coverage(
            head_coverage,
            base_coverage,
            changed_files
        ),
        "tbl_df"
    )

    # test 2
    changed_files2 <- c("R/badge.R", "R/github_action.R")
    head_cov2 <- readRDS(
        test_path(
            "fixtures",
            "slightly_complex_head_cov.RDS"
        )
    )

    base_cov2 <- readRDS(
        test_path(
            "fixtures",
            "slightly_complex_base_cov.RDS"
        )
    )

    expect_snapshot(
        combine_file_coverage(
            head_coverage = head_cov2,
            base_coverage = base_cov2,
            changed_files = changed_files2
        )
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
