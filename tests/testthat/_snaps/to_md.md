# line_cov_to_md works

    Code
      line_cov_to_md(tibble::tibble(file = c("foo.R", "bar.R", "baz.R"), lines_added = c(
        5, 4, 10), lines_covered = c(2, 4, 6)))
    Output
      |  File| Lines added| Lines tested| Coverage|
      |-----:|-----------:|------------:|--------:|
      | foo.R|           5|            2|      40%|
      | bar.R|           4|            4|     100%|
      | baz.R|          10|            6|      60%|
      | Total|          19|           12|   63.16%|

