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

test_that("extract_added_lines works", {
    # TODO add a couple of tests with more complicated diffs
    test_diff_text <- testthat::test_path(
        "fixtures",
        "diff_text.txt"
    ) |>
        readLines() |>
        stringr::str_flatten(
            collapse = "\n"
        )

    expect_snapshot(
        extract_added_lines(
            test_diff_text
        )
    )

    expect_identical(
        extract_added_lines(
            test_diff_text
        ),
        tibble::tibble(
            line = as.integer(
                c(11, 13, 14)
            ),
            source = c(
                "  if (!is.numeric(x)) {",
                "      \"`x` must be numeric. You supplied a {.class {class(x)}}\",", # nolint
                "      call = rlang::caller_env()"
            )
        )
    )
})

test_that("extract_added_lines with a more complex diff", {
    slightly_complex_diff_text <- testthat::test_path(
        "fixtures",
        "slightly_complex_diff_text.RDS"
    ) |>
        readRDS()

    expect_snapshot(
        purrr::map(
            slightly_complex_diff_text,
            extract_added_lines
        )
    )
})

test_that("extract_added_lines with a more complex diff reproducible", {
    # nolint start: nonportable_path_linter
    files <- c(
        "R/compose.R",
        "R/file_coverage.R",
        "R/github_action.R",
        "R/line_coverage.R",
        "R/pr_details.R",
        "R/to_md.R"
    )
    # nolint end

    pr_details <- structure(
        list(
            repo = "dragosmg/covr2gh", # nolint
            pr_number = 90,
            is_fork = FALSE,
            head_name = "badge-href-contd",
            head_sha = "8d59ad50711fc1054f431c3a64ac98138d09ca5d",
            base_name = "main",
            base_sha = "a0c335b6c2fbff30817be9308455ba3c9ff8dbf5",
            pr_html_url = "https://github.com/dragosmg/covr2gh/pull/90",
            diff_url = "https://github.com/dragosmg/covr2gh/pull/90.diff"
        ),
        class = "pr_details"
    )

    diff_text_pr90 <- readRDS(
        testthat::test_path(
            "fixtures",
            "diff_text_pr90.RDS"
        )
    )

    added_lines <- purrr::map(
        diff_text_pr90,
        extract_added_lines
    )

    # fmt: skip
    # these lines are checked and are correct
    expect_identical(
        added_lines$`R/github_action.R`$line,
        c(
            26, 31, 33, 41, 55, 56, 61, 63, 68,
            69, 70, 71, 73, 74
        ) |>
            as.integer()
    )

    # fmt: skip
    expect_identical(
        added_lines$`R/compose.R`$line,
        c(
            114, 116, 117, 118, 119, 120, 123,
            124, 125, 126, 127, 128, 134, 139,
            140, 141, 142, 143, 182, 183
        ) |>
            as.integer()
    )
})

test_that("get_diff_text works", {
    # nolint start: nonportable_path_linter
    pr_details <- get_pr_details(
        "dragosmg/covr2ghdemo",
        3
    )

    # relevant_files <- c(
    #     "R/add_one.R",
    #     "R/add_three.R",
    #     "R/add_two.R"
    # )
    # nolint end

    expect_snapshot(
        get_diff_text(
            pr_details = pr_details #,
            # relevant_files = relevant_files
        )
    )
})
