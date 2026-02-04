test_that("short_hash works", {
    expect_identical(
        "a" |>
            cli::hash_sha256() |>
            short_hash() |>
            nchar(),
        7L
    )

    expect_identical(
        "a" |>
            cli::hash_sha256() |>
            short_hash(),
        "ca97811"
    )

    expect_identical(
        "a" |>
            cli::hash_sha256() |>
            short_hash(n = 8) |>
            nchar(),
        8L
    )

    expect_identical(
        "a" |>
            cli::hash_sha256() |>
            short_hash(n = 8),
        "ca978112"
    )
})

test_that("collapse_interval", {
    expect_identical(
        collapse_interval(3),
        "3"
    )

    expect_identical(
        collapse_interval(c(3, 4)),
        "3, 4"
    )

    expect_identical(
        collapse_interval(1:8),
        "1-8"
    )

    expect_identical(
        collapse_interval(53:89),
        "53-89"
    )
})

test_that("find_intervals", {
    expect_identical(
        find_intervals(
            c(55, 56, 57, 58, 60, 61, 62, 68, 69, 74, 77)
        ),
        "55-58, 60-62, 68, 69, 74, 77"
    )

    expect_identical(
        find_intervals(c(3, 4, 5, 6, 9, 10, 15, 16, 17, 18, 25, 26, 27)),
        "3-6, 9, 10, 15-18, 25-27"
    )

    expect_identical(
        find_intervals(c(1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 16, 17, 21)),
        "1-8, 14-17, 21"
    )

    expect_identical(
        find_intervals(c(53:57, 65:73, 89, 90, 91, 97)),
        "53-57, 65-73, 89-91, 97"
    )
})
