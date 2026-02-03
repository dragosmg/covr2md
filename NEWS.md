# covr2gh (development version)

* added GitHub Action workflow file.
* `generate_badge()` takes a coverage percentage and produces a badge.
* `compose_comment()` builds a comment while `post_comment()` posts it.
  * can set coverage target `diff_cov_target`, e.g. `compose_comment(..., diff_cov_target = 80, ...)`.
