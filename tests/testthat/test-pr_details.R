test_that("get_pr_details() works", {
    skip_if_offline()
    expect_snapshot(
        get_pr_details(
            repo = "dragosmg/covr2ghdemo", # nolint
            pr_number = 2
        )
    )
})

test_that("get_pr_details() complains with incorrect inputs", {
    # `repo` is not scalar
    expect_error(
        get_pr_details(
            repo = c("foo", "bar")
        ),
        "`repo` must be a character scalar.",
        fixed = TRUE
    )

    # `repo` is not character
    expect_error(
        get_pr_details(
            repo = 1
        ),
        "`repo` must be a character scalar.",
        fixed = TRUE
    )

    expect_error(
        get_pr_details(
            repo = FALSE
        ),
        "`repo` must be a character scalar.",
        fixed = TRUE
    )

    # `pr_number` is not scalar
    expect_error(
        get_pr_details(
            repo = "dragosmg/covr2ghdemo", # nolint
            pr_number = c(2, 3)
        ),
        "`pr_number` must be an integer-like scalar.",
        fixed = TRUE
    )

    # `pr_number` is not integerish
    expect_error(
        get_pr_details(
            repo = "dragosmg/covr2ghdemo", # nolint
            pr_number = "foo"
        ),
        "`pr_number` must be an integer-like scalar.",
        fixed = TRUE
    )

    expect_error(
        get_pr_details(
            repo = "dragosmg/covr2ghdemo", # nolint
            pr_number = FALSE
        ),
        "`pr_number` must be an integer-like scalar.",
        fixed = TRUE
    )
})

test_that("get_changed_files() works", {
    skip_if_offline()
    expect_snapshot(
        get_changed_files(
            repo = "dragosmg/covr2ghdemo", # nolint
            pr_number = 2
        )
    )
})

test_that("get_changed_files() complains with incorrect inputs", {
    # `repo` is not scalar
    expect_error(
        get_changed_files(
            repo = c("foo", "bar")
        ),
        "`repo` must be a character scalar.",
        fixed = TRUE
    )

    # `repo` is not character
    expect_error(
        get_changed_files(
            repo = 1
        ),
        "`repo` must be a character scalar.",
        fixed = TRUE
    )

    expect_error(
        get_changed_files(
            repo = FALSE
        ),
        "`repo` must be a character scalar.",
        fixed = TRUE
    )

    # TODO add test checking repo is in the expected format (`OWNER/REPO`)

    # `pr_number` is not scalar
    expect_error(
        get_changed_files(
            repo = "dragosmg/covr2ghdemo", # nolint
            pr_number = c(2, 3)
        ),
        "`pr_number` must be an integer-like scalar.",
        fixed = TRUE
    )

    # `pr_number` is not integerish
    expect_error(
        get_changed_files(
            repo = "dragosmg/covr2ghdemo", # nolint
            pr_number = "foo"
        ),
        "`pr_number` must be an integer-like scalar.",
        fixed = TRUE
    )

    expect_error(
        get_changed_files(
            repo = "dragosmg/covr2ghdemo", # nolint
            pr_number = FALSE
        ),
        "`pr_number` must be an integer-like scalar.",
        fixed = TRUE
    )
})

test_that("extract_added_lines works", {
    # TODO add a couple of tests with more complicated diffs
    test_diff_text <- testthat::test_path("fixtures", "diff_text.txt") |>
        readLines() |>
        stringr::str_flatten(
            collapse = "\n"
        )

    expect_snapshot(
        extract_added_lines(
            test_diff_text
        )
    )
})
