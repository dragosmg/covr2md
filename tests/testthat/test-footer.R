test_that("compose_footer works", {
    expect_identical(
        compose_footer(
            pkg_ver = "0.12.3",
            date = "2026-02-05"
        ),
        glue::as_glue(
            "<sup>Created on 2026-02-05 with [covr2gh v0.12.3](https://dragosmg.github.io/covr2gh).</sup>"
        )
    )

    expect_snapshot(
        compose_footer(),
        transform = remove_date_sha_pkg_ver
    )
})
