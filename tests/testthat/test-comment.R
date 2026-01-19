test_that("post_comment, get_comment_id & delete_comment work", {
  skip_if_offline()
  skip_on_ci()
  expect_no_error(
    a <- post_comment(
      body = "this is a test :sweat_smile:",
      owner = "dragosmg",
      repo = "covr2mddemo",
      pr_number = 3,
      marker = "<!-- covr2md-test -->"
    )
  )

  expect_s3_class(a, "gh_response")

  expect_no_error(
    get_comment_id(
      owner = "dragosmg",
      repo = "covr2mddemo",
      pr_number = 3,
      marker = "<!-- covr2md-test -->"
    )
  )

  expect_identical(
    get_comment_id(
      owner = "dragosmg",
      repo = "covr2mddemo",
      pr_number = 3,
      marker = "<!-- covr2md-code-coverage -->"
    ),
    3767770706
  )

  expect_no_error(
    d <- delete_comment(
      owner = "dragosmg",
      repo = "covr2mddemo",
      comment_id = a$id
    )
  )

  expect_s3_class(d, "gh_response")
})
