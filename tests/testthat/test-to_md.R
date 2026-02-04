test_that("line_cov_to_md works", {
    expect_snapshot(
        line_cov_to_md(
            tibble::tibble(
                file = c("foo.R", "bar.R", "baz.R"),
                lines_added = c(5, 4, 10),
                lines_covered = c(2, 4, 6),
                missing = c("1-4, 8", "5-8", "1-5, 8-10, 15, 16")
            )
        )
    )

    expect_identical(
        line_cov_to_md(NULL),
        ""
    )
})

test_that("line_cov_loss_to_md", {
    expect_snapshot(
        tibble::tibble(
            file = "R/badge.R",
            lines_loss_cov = 6L,
            missing = "87-89, 92, 93, 96"
        ) |>
            line_cov_loss_to_md()
    )

    expect_identical(
        line_cov_loss_to_md(NULL),
        ""
    )
})

test_that("file_cov_to_md", {
    expect_snapshot(
        tibble::tibble(
            file = c("R/foo.R", "R/bar.R", "R/baz/R", "R/baz2.R", "Overall"),
            coverage_head = c(40, 78, 5, 30, 60),
            coverage_base = c(45, 80, 5, 25, 32),
            delta = c(-5, -2, 0, 5, 28)
        ) |>
            file_cov_to_md()
    )

    expect_identical(
        file_cov_to_md(NULL),
        ""
    )
})
