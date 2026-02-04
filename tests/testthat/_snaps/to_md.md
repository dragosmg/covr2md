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

# line_cov_loss_to_md

    Code
      line_cov_loss_to_md(tibble::tibble(file = "R/badge.R", lines_loss_cov = 6L,
        which_lines = "87-89, 92, 93, 96"))
    Output
      |      File| Lines w/ coverage loss|Which lines       |
      |---------:|----------------------:|:-----------------|
      | R/badge.R|                      6|87-89, 92, 93, 96 |
      |     Total|                      6|                  |

# file_cov_to_md

    Code
      file_cov_to_md(tibble::tibble(file = c("R/foo.R", "R/bar.R", "R/baz/R",
        "R/baz2.R", "Overall"), coverage_head = c(40, 78, 5, 30, 60), coverage_base = c(
        45, 80, 5, 25, 32), delta = c(-5, -2, 0, 5, 28)))
    Output
      |     File| Coverage head| Coverage base| &Delta; |                     |
      |--------:|-------------:|-------------:|:-------:|:-------------------:|
      |  R/foo.R|           40%|           45%|   -5    |    :arrow_down:     |
      |  R/bar.R|           78%|           80%|   -2    |    :arrow_down:     |
      |  R/baz/R|            5%|            5%|    0    | :heavy_equals_sign: |
      | R/baz2.R|           30%|           25%|    5    |     :arrow_up:      |
      |  Overall|           60%|           32%|   28    |     :arrow_up:      |

