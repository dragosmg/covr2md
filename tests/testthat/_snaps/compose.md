# compose_comment works

    Code
      compose_comment(head_coverage, base_coverage, repo = "dragosmg/covr2ghdemo",
        pr_number = 3)
    Output
      <!-- covr2gh-do-not-delete -->
      
      ## :safety_vest: Coverage summary
      
      ![badge](https://raw.githubusercontent.com/dragosmg/covr2ghdemo/covr2gh-storage/badges/increase-coverage/coverage_badge.svg)
      
      :white_check_mark:  Merging PR [#3](https://github.com/dragosmg/covr2ghdemo/pull/3) ([`48b3564`](head_sha_url)) into _main_ ([`c4477ac`](base_sha_url)) - will **increase** coverage by `21.05` percentage points.
      :x:  Diff coverage: 0% (0 out of 1 added lines are covered by tests). Target coverage is at least `10.53%`.
      
      <details>
      <summary>Details</summary>
      
      ### Files with code or coverage changes
      
      |        File| Coverage head| Coverage base| &Delta; |            |
      |-----------:|-------------:|-------------:|:-------:|:----------:|
      | R/add_two.R|        57.14%|            0%|  57.14  | :arrow_up: |
      |     Overall|        31.58%|        10.53%|  21.05  | :arrow_up: |
      
      ### Coverage for added lines
      
      |        File| Lines added| Lines tested| Coverage|
      |-----------:|-----------:|------------:|--------:|
      | R/add_two.R|           1|            0|       0%|
      |       Total|           1|            0|       0%|
      </details>
      
      :recycle: Comment updated with the latest results.
      
      <sup>Created on <removed-date> with [covr2gh v0.0.0.9015](https://dragosmg.github.io/covr2gh).</sup>

