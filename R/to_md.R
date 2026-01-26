#' Transform the file coverage tibble into markdown
#'
#' Makes the column names human readable, formats the data, and adds an
#' interpretation column. The transforms the output to markdown and collapses
#' into a single string.
#'
#' @param file_cov_df (`tibble`) a diff df, the output of [derive_file_cov_df()]
#' @inheritParams knitr::kable
#'
#' @returns a character scalar containing markdown version of the diff df
#'   collapsed into a single string.
#'
#' @keywords internal
file_cov_df_to_md <- function(file_cov_df, align = "rrrrc") {
  file_cov_df_prep <- file_cov_df |>
    dplyr::mutate(
      # add a brief visual interpretation of the delta with arrows or equal sign
      interpretation = dplyr::case_when(
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
  file_cov_df_prep_names <- file_cov_df_prep |>
    names() |>
    stringr::str_to_sentence() |>
    stringr::str_replace_all(
      stringr::fixed("_"),
      " "
    ) |>
    stringr::str_replace(
      stringr::fixed("Delta"),
      "&Delta;"
    ) |>
    stringr::str_replace(
      stringr::fixed("Interpretation"),
      ""
    )

  names(file_cov_df_prep) <- file_cov_df_prep_names

  file_cov_df_prep |>
    knitr::kable(
      align = align
    ) |>
    glue::glue_collapse(
      sep = "\n"
    )
}

#' Transform a line coverage tibble to markdown
#'
#' Adds a total row, make column names more readable. Then transforms it to
#' markdown which gets collapsed into a single string.
#'
#' @param diff_line_coverage (`tibble`) diff line coverage data. The output of
#'   [derive_file_cov_df()]
#' @inheritParams knitr::kable
#'
#' @returns a markdown table as a string
#'
#' @keywords internal
line_cov_to_md <- function(
  diff_line_coverage,
  align = "rrrr"
) {
  diff_coverage <- diff_line_coverage |>
    dplyr::group_by(
      .data$file
    ) |>
    dplyr::summarise(
      lines_added = sum(.data$lines_added),
      lines_covered = sum(.data$lines_covered)
    ) |>
    dplyr::ungroup()

  total_row <- diff_coverage |>
    dplyr::summarise(
      lines_added = sum(.data$lines_added),
      lines_covered = sum(.data$lines_covered)
    ) |>
    dplyr::mutate(
      file = "Total",
      .before = "lines_added"
    )

  output <- dplyr::bind_rows(
    diff_coverage,
    total_row
  ) |>
    dplyr::mutate(
      coverage = round(
        .data$lines_covered / .data$lines_added,
        2
      ),
      coverage = paste0(
        .data$coverage,
        "%"
      )
    ) |>
    dplyr::rename(
      File = file,
      `Lines added` = "lines_added",
      `Lines tested` = "lines_covered",
      Coverage = "coverage"
    )

  output |>
    knitr::kable(
      align = align
    ) |>
    glue::glue_collapse(
      sep = "\n"
    )
}
