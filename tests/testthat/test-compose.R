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
      owner = "dragosmg",
      repo = "covr2mddemo",
      pr_number = 3
    )
  )
})

test_that("compose_coverage_summary works", {
  expect_equal(2 * 2, 4)
})

test_that("compose_coverage_details works", {
  expect_equal(2 * 2, 4)
})
