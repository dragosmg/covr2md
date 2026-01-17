test_that("digest_coverage() works", {
  cov <- readRDS(test_path("fixtures", "sample_coverage.RDS"))

  expect_snapshot(
    digest_coverage(cov)
  )

  expect_s3_class(
    digest_coverage(cov),
    "tbl_df"
  )
})
