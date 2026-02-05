test_that("add_line_num_head works", {
    # head_df for the `R/file_coverage.R`
    head_df_pr90_file_cov <- readRDS(
        testthat::test_path(
            "fixtures",
            "head_df_pr90_file_cov.RDS"
        )
    )

    expect_snapshot(
        add_line_num_head(
            head_df_pr90_file_cov
        )
    )

    # head_df for `R/github_action.R`
    head_df_pr90_gha <- readRDS(
        testthat::test_path(
            "fixtures",
            "head_df_pr90_gha.RDS"
        )
    )

    expect_snapshot(
        add_line_num_head(
            head_df_pr90_gha
        )
    )
})

test_that("diff_split works", {
    diff1_text_pr90 <- readRDS(
        testthat::test_path(
            "fixtures",
            "diff1_pr90.RDS"
        )
    )

    expect_snapshot(
        diff_split(
            diff1_text_pr90
        )
    )

    diff_text_pr90 <- readRDS(
        testthat::test_path(
            "fixtures",
            "diff_text_pr90.RDS"
        )
    )

    expect_snapshot(
        diff_split(
            diff1_text_pr90
        )
    )

    slightly_complex_diff_text <- readRDS(
        testthat::test_path(
            "fixtures",
            "slightly_complex_diff_text.RDS"
        )
    )

    expect_snapshot(
        diff_split(
            slightly_complex_diff_text
        )
    )
})
