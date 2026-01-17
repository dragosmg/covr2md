test_that("build_coverage_badge() works", {
  expect_snapshot(
    build_badge_url(10)
  )
})

test_that("build_coverage_badge() with NA and NULL", {
  expect_snapshot(
    build_badge_url(NA_real_)
  )

  expect_snapshot(
    build_badge_url(NULL)
  )
})

test_that("build_coverage_badge() complains", {
  # with non-scalar numeric inputs
  expect_snapshot(
    error = TRUE,
    build_badge_url(c(75, 80))
  )

  # with non-numeric inputs
  expect_snapshot(
    error = TRUE,
    build_badge_url("foo")
  )

  expect_snapshot(
    error = TRUE,
    build_badge_url(TRUE)
  )

  expect_snapshot(
    error = TRUE,
    build_badge_url(list(75))
  )
})
