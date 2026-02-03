# covr2gh (development version)

* `use_covr2gh_action()` adds the `covr2gh.yaml` workflow file and inserts a
README badge (with `use_covr2gh_badge()`) if the {usethis} block
(`<!-- badges: start -->` and `<!-- badges: end -->`) exists.
* added GitHub Action workflow file.
* `generate_badge()` takes a coverage percentage and produces a badge.
* `compose_comment()` builds a comment while `post_comment()` posts it.
  * can set coverage target `diff_cov_target`, e.g.
    `compose_comment(..., diff_cov_target = 80, ...)`.
