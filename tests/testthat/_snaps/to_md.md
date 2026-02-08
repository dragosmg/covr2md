# line_cov_to_md works

    Code
      line_cov_to_md(tibble::tibble(file_name = c("foo.R", "bar.R", "baz.R"),
      lines_added = c(5, 4, 10), lines_covered = c(2, 4, 6), missing = c("1-3", NA,
        "2-4, 6")))
    Output
      |File name | Lines added| Lines tested| Coverage|Missing |
      |:---------|-----------:|------------:|--------:|:-------|
      |foo.R     |           5|            2|      40%|1-3     |
      |bar.R     |           4|            4|     100%|        |
      |baz.R     |          10|            6|      60%|2-4, 6  |
      |Total     |          19|           12|    63.2%|        |

