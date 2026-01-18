coverage_to_md <- function(x, align = "rr") {
  x |>
    digest_coverage() |>
    knitr::kable(
      align = align
    )
}

# x = head coverage
# y = base coverage
#
# align = markdown column alignment
diff_to_md <- function(x, y, pr_files, align = "rr") {
  head_coverage <- digest_coverage(x)

  base_coverage <- digest_coverage(y)
}
