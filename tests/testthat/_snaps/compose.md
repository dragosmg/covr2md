# compose_comment works

    Code
      compose_comment(head_coverage, base_coverage, repo = "dragosmg/covr2mddemo",
        pr_number = 3)
    Output
      <!-- covr2md-code-coverage -->
      
      ## Coverage summary
      
      ![badge](https://img.shields.io/badge/coverage-31.58%25-red.svg)
      
      :white_check_mark: Merging PR [#3](https://github.com/dragosmg/covr2mddemo/pull/3) (<removed-commit-sha>) into _main_ (<removed-commit-sha>) - will **increase** coverage by `21.05` percentage points.
      Diff coverage: 0% (0 out of 7 added lines are covered by tests).
      
      <details>
      
      <summary>Details on file coverage change</summary>
      <br/>
      
      |          File| Coverage head| Coverage base| &Delta; |                    |
      |-------------:|-------------:|-------------:|:-------:|-------------------:|
      |   R/add_one.R|           40%|           40%|  0.00   | :heavy_equals_sign:|
      | R/add_three.R|            0%|            0%|  0.00   | :heavy_equals_sign:|
      |   R/add_two.R|        57.14%|            0%|  57.14  |          :arrow_up:|
      |         Total|        31.58%|        10.53%|  21.05  |          :arrow_up:|
      
      </details>
      
      <br/>
      
      <details>
      
      <summary>Details on line coverage change</summary>
      <br/>
      
      |          File| Lines added| Lines tested| Coverage|
      |-------------:|-----------:|------------:|--------:|
      |   R/add_one.R|           3|            0|       0%|
      | R/add_three.R|           3|            0|       0%|
      |   R/add_two.R|           1|            0|       0%|
      |         Total|           7|            0|       0%|
      
      </details>
      
      :recycle: Comment updated with the latest results.
      
      <sup>Created on <removed-date> with [covr2md 0.0.0.9006](https://reprex.tidyverse.org)</sup>

