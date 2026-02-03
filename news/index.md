# Changelog

## covr2gh (development version)

- [`use_covr2gh_action()`](https://dragosmg.github.io/covr2gh/reference/use_covr2gh_action.md)
  adds the `covr2gh.yaml` workflow file and inserts a README badge (with
  [`use_covr2gh_badge()`](https://dragosmg.github.io/covr2gh/reference/use_covr2gh_badge.md))
  if the {usethis} block (`<!-- badges: start -->` and
  `<!-- badges: end -->`) exists.
- added GitHub Action workflow file.
- [`generate_badge()`](https://dragosmg.github.io/covr2gh/reference/generate_badge.md)
  takes a coverage percentage and produces a badge.
- [`compose_comment()`](https://dragosmg.github.io/covr2gh/reference/compose_comment.md)
  builds a comment while
  [`post_comment()`](https://dragosmg.github.io/covr2gh/reference/post_comment.md)
  posts it.
  - can set coverage target `diff_cov_target`, e.g.
    `compose_comment(..., diff_cov_target = 80, ...)`.
