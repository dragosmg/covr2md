test_that("get_pr_details() works", {
  owner <- "dragosmg"
  repo <- "covr2md"
  pr_number <- 12

  get_pr_details(owner, repo, pr_number)
})
