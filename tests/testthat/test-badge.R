test_that("generate_badge", {
    expect_snapshot(
        (generate_badge(5))
    )

    expect_snapshot(
        (generate_badge(25))
    )

    expect_snapshot(
        (generate_badge(55))
    )

    expect_snapshot(
        (generate_badge(75))
    )

    expect_snapshot(
        (generate_badge(95))
    )
})

test_that("generate_badge with NA, NULL and out-of-bounds values", {
    expect_snapshot(
        (generate_badge(NA_real_))
    )

    expect_snapshot(
        (generate_badge(NULL))
    )

    expect_snapshot(
        (generate_badge(1302))
    )

    expect_snapshot(
        (generate_badge(-5))
    )
})

test_that("build_badge_url when PR from fork", {
    test_pr_details <- structure(
        list(
            repo = "<owner>/<repo>",
            pr_number = 3,
            is_fork = TRUE,
            head_name = "feature-a-branch",
            head_sha = cli::hash_sha256("a"),
            base_name = "main",
            base_sha = cli::hash_sha256("b"),
            pr_html_url = "https://github.com/<owner>/<repo>/pull/3",
            diff_url = "https://github.com/<owner>/<repo>/pull/3.diff"
        ),
        class = "pr_details"
    )

    expect_snapshot(
        build_badge_url(
            test_pr_details,
            78.35
        )
    )

    expect_snapshot(
        build_badge_url(
            test_pr_details,
            98.45
        )
    )

    expect_snapshot(
        build_badge_url(
            test_pr_details,
            23.35
        )
    )
})

test_that("build_badge_url when PR from fork", {
    test_pr_details <- structure(
        list(
            repo = "<owner>/<repo>",
            pr_number = 3,
            is_fork = FALSE,
            head_name = "feature-a-branch",
            head_sha = cli::hash_sha256("a"),
            base_name = "main",
            base_sha = cli::hash_sha256("b"),
            pr_html_url = "https://github.com/<owner>/<repo>/pull/3",
            diff_url = "https://github.com/<owner>/<repo>/pull/3.diff"
        ),
        class = "pr_details"
    )

    expect_snapshot(
        build_badge_url(
            test_pr_details,
            78.35
        )
    )

    expect_snapshot(
        build_badge_url(
            test_pr_details,
            98.45
        )
    )

    expect_snapshot(
        build_badge_url(
            test_pr_details,
            23.35
        )
    )
})
