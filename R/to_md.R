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
#' Transform the diff df into markdown
#'
#' Makes the column names and the contents of the `delta` column more readable.
#' Transforms the output to markdown and collapses into a single string.
#'
#' @param diff_df (`tibble`) a diff df, the output of [derive_diff_df()]
#' @inheritParams knitr::kable
#'
#' @returns a character scalar containing markdown version of the diff df
#'   collapsed into a single string.
#'
#' @keywords internal
diff_df_to_md <- function(diff_df, align = "rrrc") {
  diff_df_prep <- diff_df |>
    dplyr::mutate(
      # recode delta into arrows or equal sign
      delta = dplyr::case_when(
        delta > 0 ~ ":arrow_up:",
        delta < 0 ~ ":arrow_down:",
        delta == 0 ~ ":heavy_equals_sign:"
      ),
      # add % to figures
      coverage_head = paste0(
        .data$coverage_head,
        "%"
      ),
      coverage_base = paste0(
        .data$coverage_base,
        "%"
      )
    )

  # rename to something more human readable
  diff_df_names <- diff_df_prep |>
    names() |>
    stringr::str_to_sentence() |>
    stringr::str_replace_all(
      stringr::fixed("_"),
      " "
    ) |>
    stringr::str_replace(
      stringr::fixed("Delta"),
      "&Delta;"
    )

  names(diff_df_prep) <- diff_df_names

  diff_md_table <- diff_df_prep |>
    knitr::kable(align = align) |>
    glue::glue_collapse(
      sep = "\n"
    )

  diff_md_table
}
