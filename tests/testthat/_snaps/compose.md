# compose_comment works

    Code
      compose_comment(head_coverage, base_coverage, repo = "dragosmg/covr2ghdemo",
        pr_number = 3)
    Output
      <!-- covr2gh-code-coverage -->
      
      ## :safety_vest: Coverage summary
      
      ![badge](https://raw.githubusercontent.com/dragosmg/covr2ghdemo/covr2gh-storage/badges/increase-coverage/coverage_badge.svg)
      
      :white_check_mark: Merging PR [#3](https://github.com/dragosmg/covr2ghdemo/pull/3) ([`68ad63e`](head_sha_url)) into _main_ ([`8427de3`](base_sha_url)) - will **increase** coverage by `21.05` percentage points.
      :x:  Diff coverage: 0% (0 out of 7 added lines are covered by tests). Target coverage is at least `80%`.
      
      <details>
      <summary>Details</summary>
      
      ### Files impacted either by code or coverage changes
      
      |          File| Coverage head| Coverage base| &Delta; |                     |
      |-------------:|-------------:|-------------:|:-------:|:-------------------:|
      |   R/add_one.R|           40%|           40%|  0.00   | :heavy_equals_sign: |
      | R/add_three.R|            0%|            0%|  0.00   | :heavy_equals_sign: |
      |   R/add_two.R|        57.14%|            0%|  57.14  |     :arrow_up:      |
      |         Total|        31.58%|        10.53%|  21.05  |     :arrow_up:      |
      
      ### Coverage for added lines
      
      |          File| Lines added| Lines tested| Coverage|
      |-------------:|-----------:|------------:|--------:|
      |   R/add_one.R|           3|            0|       0%|
      | R/add_three.R|           3|            0|       0%|
      |   R/add_two.R|           1|            0|       0%|
      |         Total|           7|            0|       0%|
      </details>
      
      :recycle: Comment updated with the latest results.
      
      <sup>Created on <removed-date> with [covr2gh 0.0.0.9013](https://url-placeholder)</sup>

