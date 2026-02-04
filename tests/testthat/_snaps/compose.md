# compose_comment works

    Code
      compose_comment(head_coverage, base_coverage, repo = "dragosmg/covr2ghdemo",
        pr_number = 3)
    Output
      <!-- covr2gh-do-not-delete -->
      
      ## :safety_vest: Coverage summary
      
      ![badge](https://img.shields.io/badge/coverage-32%25-E4804E.svg)
      
      :white_check_mark:  Merging PR [#3](https://github.com/dragosmg/covr2ghdemo/pull/3) ([`<removed-commit-sha>`](head_sha_url)) into _main_ ([`<removed-commit-sha>`](base_sha_url)) - will **increase** overall coverage by `21.05` percentage points.
      :white_check_mark:  Diff coverage is 14.29% (1 out of 7 added lines are covered by tests). Minimum accepted is `10.53%`.
      
      <details>
      <summary>Details</summary>
      
      ### Files with code or coverage changes
      
      |          File| Coverage head| Coverage base| &Delta; |                     |
      |-------------:|-------------:|-------------:|:-------:|:-------------------:|
      |   R/add_one.R|           40%|           40%|  0.00   | :heavy_equals_sign: |
      | R/add_three.R|            0%|            0%|  0.00   | :heavy_equals_sign: |
      |   R/add_two.R|        57.14%|            0%|  57.14  |     :arrow_up:      |
      |       Overall|        31.58%|        10.53%|  21.05  |     :arrow_up:      |
      
      ### Coverage for added lines
      
      |          File| Lines added| Lines tested| Coverage|
      |-------------:|-----------:|------------:|--------:|
      |   R/add_one.R|           3|            1|   33.33%|
      | R/add_three.R|           3|            0|       0%|
      |   R/add_two.R|           1|            0|       0%|
      |         Total|           7|            1|   14.29%|
      </details>
      
      :recycle: Comment updated with the latest results.
      
      <sup>Created on <removed-date> with [covr2gh v0.0.0.9020](https://dragosmg.github.io/covr2gh).</sup>

