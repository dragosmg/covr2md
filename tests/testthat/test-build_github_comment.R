test_that("compose_comment() works", {
  coverage <- readRDS(test_path("fixtures", "sample_coverage.RDS"))

  expect_snapshot(
    compose_comment(
      coverage
    )
  )
})
