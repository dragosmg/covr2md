test_that("get_pr_details() works", {
  owner <- "dragosmg"
  repo <- "covr2md"
  pr_number <- 14

  get_pr_details(owner, repo, pr_number)
})

test_that("get_changed_files() works", {
  owner <- "dragosmg"
  repo <- "covr2md"
  pr_number <- 14

  get_changed_files(owner, repo, pr_number)
})
