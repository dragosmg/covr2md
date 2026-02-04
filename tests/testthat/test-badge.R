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

test_that("build_badge_url", {
    expect_snapshot(
        build_badge_url(78.35)
    )

    expect_snapshot(
        build_badge_url(98.45)
    )

    expect_snapshot(
        build_badge_url(23.35)
    )
})
