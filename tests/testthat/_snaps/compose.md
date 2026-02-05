# compose_comment works

    Code
      compose_comment(head_coverage, base_coverage, repo = "dragosmg/covr2ghdemo",
        pr_number = 3)
    Output
      <!-- covr2gh-do-not-delete -->
      
      ## :safety_vest: Coverage summary
      
      ![badge](https://img.shields.io/badge/coverage-29%25-E4804E.svg)
      
      :x:  Merging PR [#3](https://github.com/dragosmg/covr2ghdemo/pull/3) ([`<removed-commit-sha>`](head_sha_url)) into _main_ ([`<removed-commit-sha>`](base_sha_url)) - will **decrease** overall coverage by `3.01` percentage points.
      :x:  Diff coverage is 28.57% (2 out of 7 added lines are covered by tests). Minimum accepted is `31.58%`.
      
      <details>
      <summary>Details</summary>
      
      ### Files with code or coverage changes
      
      |          File| Coverage head| Coverage base| &Delta; |                     |
      |-------------:|-------------:|-------------:|:-------:|:-------------------:|
      |   R/add_one.R|        33.33%|           40%|  -6.67  |    :arrow_down:     |
      | R/add_three.R|            0%|            0%|  0.00   | :heavy_equals_sign: |
      |   R/add_two.R|        57.14%|        57.14%|  0.00   | :heavy_equals_sign: |
      |       Overall|        28.57%|        31.58%|  -3.01  |    :arrow_down:     |
      
      ### Coverage for added lines
      
      |File name     | Lines added| Lines tested| Coverage|    Missing|
      |:-------------|-----------:|------------:|--------:|----------:|
      |R/add_one.R   |           3|            1|   33.33%|     14, 15|
      |R/add_three.R |           3|            0|       0%| 12, 19, 20|
      |R/add_two.R   |           1|            1|     100%|           |
      |Total         |           7|            2|   28.57%|           |
      </details>
      
      :recycle: Comment updated with the latest results.
      
      <sup>Created on <removed-date> with [covr2gh v0.0.0.9020](https://dragosmg.github.io/covr2gh).</sup>

