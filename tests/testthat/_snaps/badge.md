# build_coverage_badge() works

    Code
      build_badge_url(10)
    Output
      https://img.shields.io/badge/coverage-10%25-red.svg

# build_coverage_badge() with NA and NULL

    Code
      build_badge_url(NA_real_)
    Output
      https://img.shields.io/badge/coverage-unknown-lightgrey.svg

---

    Code
      build_badge_url(NULL)
    Output
      https://img.shields.io/badge/coverage-unknown-lightgrey.svg

# build_coverage_badge() complains

    Code
      build_badge_url(c(75, 80))
    Condition
      Error in `build_badge_url()`:
      ! `percentage` must be a scalar double.

---

    Code
      build_badge_url("foo")
    Condition
      Error in `build_badge_url()`:
      ! `percentage` must be a scalar double.

---

    Code
      build_badge_url(TRUE)
    Condition
      Error in `build_badge_url()`:
      ! `percentage` must be a scalar double.

---

    Code
      build_badge_url(list(75))
    Condition
      Error in `build_badge_url()`:
      ! `percentage` must be a scalar double.

