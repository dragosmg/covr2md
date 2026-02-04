# line_cov_to_md works

    Code
      line_cov_to_md(tibble::tibble(file = c("foo.R", "bar.R", "baz.R"), lines_added = c(
        5, 4, 10), lines_covered = c(2, 4, 6), which_lines = c("1-4, 8", "5-8",
        "1-5, 8-10, 15, 16")))
    Output
      |  File| Lines added| Lines tested| Coverage|Which lines       |
      |-----:|-----------:|------------:|--------:|:-----------------|
      | foo.R|           5|            2|      40%|1-4, 8            |
      | bar.R|           4|            4|     100%|5-8               |
      | baz.R|          10|            6|      60%|1-5, 8-10, 15, 16 |
      | Total|          19|           12|   63.16%|                  |

