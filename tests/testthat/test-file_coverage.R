test_that("calculate_file_coverage() works", {
  cov <- readRDS(test_path("fixtures", "sample_coverage.RDS"))

  expect_snapshot(
    calculate_file_coverage(cov)
  )

  expect_s3_class(
    calculate_file_coverage(cov),
    "tbl_df"
  )
})
