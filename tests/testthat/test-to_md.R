test_that("line_cov_to_md works", {
    expect_snapshot(
        line_cov_to_md(
            tibble::tibble(
                file = c("foo.R", "bar.R", "baz.R"),
                lines_added = c(5, 4, 10),
                lines_covered = c(2, 4, 6)
            )
        )
    )

    expect_identical(
        line_cov_to_md(NULL),
        ""
    )
})
