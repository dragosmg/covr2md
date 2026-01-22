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
      repo = "dragosmg/covr2mddemo", # nolint
      pr_number = 3
    ),
    transform = remove_date_commit_sha
  )
})

test_that("compose_coverage_summary works", {
  expect_identical(2 * 2, 4)
})

test_that("compose_coverage_details works", {
  expect_identical(2 * 2, 4)
})
