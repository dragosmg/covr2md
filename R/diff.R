#' Split (un-combine) diff text
#'
#' Reverse-engineer the combined view of the diff.
#'
#' @param diff_text (character) string with the diff contents
#'
#' @returns a list with 2 tibbles:
#'  * `head_lines`: the numbered lines that were added in head
#'  * `base_lines`: the numbered lines that were removed from base
#'
#' Each `tibble` has 2 columns: `line` and `source``
#'
#' @dev
diff_split <- function(diff_text) {
    raw_diff_df <- diff_text |>
        stringr::str_split(
            pattern = stringr::fixed("\n")
        ) |>
        purrr::pluck(1) |>
        tibble::tibble(raw = _)

    combined_diff_df <- classify_lines(raw_diff_df)

    base_df <- combined_diff_df |>
        dplyr::filter(
            .data$hunk | .data$context | .data$base,
            !.data$merge
        ) |>
        dplyr::select(
            -"head",
            -"merge"
        )

    head_df <- combined_diff_df |>
        dplyr::filter(
            .data$hunk | .data$context | .data$head,
            !.data$merge
        ) |>
        dplyr::select(
            -"base",
            -"merge"
        )

    head_lines <- head_df |>
        add_line_num_head() |>
        dplyr::filter(
            !.data$hunk,
            .data$head
        ) |>
        dplyr::select(
            "line",
            "raw"
        ) |>
        dplyr::mutate(
            source = stringr::str_remove(
                .data$raw,
                "^\\+"
            )
        ) |>
        dplyr::select(
            -"raw"
        )

    base_lines <- base_df |>
        add_line_num_base() |>
        dplyr::filter(
            !.data$hunk,
            .data$base
        ) |>
        dplyr::select(
            "line",
            "raw"
        ) |>
        dplyr::mutate(
            source = stringr::str_remove(
                .data$raw,
                "^\\-"
            )
        ) |>
        dplyr::select(
            -"raw"
        )

    if (nrow(head_lines) == 0) {
        head_lines <- NULL
    }

    if (nrow(base_lines) == 0) {
        base_lines <- NULL
    }

    list(
        head_lines = head_lines,
        base_lines = base_lines
    )
}

#' Classify lines
#'
#' `-`: line appears in base, but not in head (was deleted)
#' `+`: line appears in head, but not in base (was added)
#' `++`: line was added, but does not appear in either head or base
#'       it indicates a line that did not exist in either parent and was
#'       introduced by the merge resolution itself
#' `@@`: hunk header
#' @param raw_diff_df (tibble) a raw diff tibble with a single column
#'   named `raw
#'
#' @returns a tibble with 5 additional columns, all logical, classifying the
#' rows into:
#'   * hunk:
#'   * base: present only in base (deleted)
#'   * head: present only in head (added)
#'   * merge: present neither in head nor in base
#'   * context: present both in head and in base
#'
#' @dev
classify_lines <- function(raw_diff_df) {
    #   * hunk = starts with "@@"
    #   * base = starts with "-"
    #   * head = starts with "+"
    #   * merge = starts with "++"
    #   * context = everything else

    # head might have some false positives (technically)
    raw_diff_df |>
        dplyr::mutate(
            hunk = stringr::str_starts(
                .data$raw,
                stringr::fixed("@@")
            ),
            base = stringr::str_starts(
                .data$raw,
                stringr::fixed("-")
            ),
            head = stringr::str_starts(
                .data$raw,
                stringr::fixed("+")
            ) &
                stringr::str_starts(
                    .data$raw,
                    stringr::fixed("++"),
                    negate = TRUE
                ),
            merge = stringr::str_starts(
                .data$raw,
                stringr::fixed("++")
            ),
            context = !(.data$hunk | .data$base | .data$head | .data$merge)
        )
}

#' Add line numbers for a head patch
#'
#' @param head_df (tibble) with 4 columns: `raw`, `hunk`, `head`, and
#'   `context`
#'
#' @returns a tibble with an extra integer column, `line` representing
#'   the line number in "head"
#'
#' @dev
add_line_num_head <- function(head_df) {
    output <- head_df |>
        dplyr::mutate(
            add = as.numeric(
                !.data$hunk
            ),
            head_start = dplyr::if_else(
                .data$hunk,
                stringr::str_extract(
                    .data$raw,
                    "\\+(\\d+)"
                ),
                NA_character_
            ),
            head_start = stringr::str_remove_all(
                .data$head_start,
                stringr::fixed("+")
            ),
            head_start = as.numeric(
                .data$head_start
            )
        ) |>
        tidyr::fill(
            "head_start",
            .direction = "down"
        ) |>
        dplyr::group_by(
            .data$head_start
        ) |>
        dplyr::mutate(
            line = .data$head_start + cumsum(.data$add) - 1
        ) |>
        dplyr::ungroup() |>
        dplyr::mutate(
            line = as.integer(
                .data$line
            )
        ) |>
        dplyr::select(
            "line",
            dplyr::everything()
        ) |>
        dplyr::select(
            -"add",
            -"head_start"
        )

    output
}

add_line_num_base <- function(base_df) {
    output <- base_df |>
        dplyr::mutate(
            add = as.numeric(
                !.data$hunk
            ),
            base_start = dplyr::if_else(
                .data$hunk,
                stringr::str_extract(
                    .data$raw,
                    "\\-(\\d+)"
                ),
                NA_character_
            ),
            base_start = stringr::str_remove_all(
                .data$base_start,
                stringr::fixed("-")
            ),
            base_start = as.numeric(
                .data$base_start
            )
        ) |>
        tidyr::fill(
            "base_start",
            .direction = "down"
        ) |>
        dplyr::group_by(
            .data$base_start
        ) |>
        dplyr::mutate(
            line = .data$base_start + cumsum(.data$add) - 1
        ) |>
        dplyr::ungroup() |>
        dplyr::mutate(
            line = as.integer(
                .data$line
            )
        ) |>
        dplyr::select(
            "line",
            dplyr::everything()
        ) |>
        dplyr::select(
            -"add",
            -"base_start"
        )

    output
}
