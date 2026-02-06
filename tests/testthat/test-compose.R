test_that("compose_comment works", {
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
        compose_comment(
            head_coverage,
            base_coverage,
            repo = "dragosmg/covr2ghdemo", # nolint
            pr_number = 3
        ),
        transform = remove_date_sha_pkg_ver
    )
})
