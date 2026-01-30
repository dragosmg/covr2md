#' Get pull request details
#'
#' Sends a GET request to the GitHub API and fetches the PR details. The output
#' contains a subset of these, needed for downstream use.
#'
#' @param repo (character) the repository name in the GitHub format
#'   (`"OWNER/REPO"`).
#' @param pr_number (integer) the PR number
#' @param call the execution environment to surface the error message from.
#'   Defaults to [rlang::caller_env()].
#'
#' @returns an object of class `pr_details` - a list with the following
#' elements:
#'   * `head_name`: name of the current branch
#'   * `head_sha`: the sha of the last commit in the current branch
#'   * `base_name`: the name of the destination branch
#'   * `base_sha`: the sha of most recent commit on the destination branch
#'   * `pr_html_url`: the URL to the PR HTML branch
#'   * `diff_url`: the diff URL
#'
#' @export
#' @examples
#' \dontrun{
#' get_pr_details("dragosmg/covr2ghdemo", 2)
#' }
get_pr_details <- function(
    repo,
    pr_number,
    call = rlang::caller_env()
) {
    # TODO check for GitHub format (`OWNER/REPO`)
    if (!rlang::is_scalar_character(repo)) {
        cli::cli_abort(
            "`repo` must be a character scalar.",
            call = call
        )
    }

    if (!rlang::is_scalar_integerish(pr_number)) {
        cli::cli_abort(
            "`pr_number` must be an integer-like scalar.",
            call = call
        )
    }

    pr_api_url <- glue::glue(
        "https://api.github.com/repos/{repo}/pulls/{pr_number}"
    )

    pr_info <- glue::glue("GET {pr_api_url}") |>
        gh::gh()

    structure(
        list(
            repo = repo,
            pr_number = pr_number,
            head_name = pr_info$head$ref,
            head_sha = pr_info$head$sha,
            base_name = pr_info$base$ref,
            base_sha = pr_info$base$sha,
            pr_html_url = pr_info$html_url,
            diff_url = pr_info$diff_url
        ),
        class = "pr_details"
    )
}

#' Get changed files
#'
#' Sends a GET request to the GitHub API and retrieves the relevant files
#' involved in the PR. It only includes files that are under `R/` or `src/`.
#'
#' @inheritParams get_pr_details
#'
#' @returns a character vector containing the names of the changed files.
#'
#' @keywords internal
#' @examples
#' \dontrun{
#' get_changed_files("dragosmg/covr2ghdemo", 2)
#' }
get_changed_files <- function(
    repo,
    pr_number,
    call = rlang::caller_env()
) {
    if (!rlang::is_scalar_character(repo)) {
        cli::cli_abort(
            "`repo` must be a character scalar.",
            call = call
        )
    }

    if (!rlang::is_scalar_integerish(pr_number)) {
        cli::cli_abort(
            "`pr_number` must be an integer-like scalar.",
            call = call
        )
    }

    files_api_url <- glue::glue(
        "https://api.github.com/repos/{repo}/pulls/{pr_number}/files"
    )

    files_info <- glue::glue("GET {files_api_url}") |>
        gh::gh()

    changed_files <- purrr::map_chr(files_info, "filename")

    relevant_files_changed <- stringr::str_subset(
        changed_files,
        pattern = "^R/|^src"
    )

    relevant_files_changed
}

get_diff_text <- function(
    repo,
    pr_details,
    changed_files,
    call = rlang::caller_env()
) {
    # TODO add inputs checks
    # TODO standalone rlang?

    base_head <- glue::glue(
        "{pr_details$base_name}...{pr_details$head_name}"
    )

    req_url <- glue::glue(
        "https://api.github.com/repos/{repo}/compare/{base_head}"
    )

    # we can use this to somehow get the lines of code added
    reply <- glue::glue("GET {req_url}") |>
        gh::gh()

    # get the file patches as a named list where the names are the filenames and
    # the content of each element is the patch
    # we can then map over this list
    output <- reply$files |>
        purrr::keep(
            \(x) x$filename %in% changed_files
        ) |>
        purrr::map(
            \(x) purrr::keep_at(x, c("filename", "patch"))
        ) |>
        purrr::map(
            \(x) {
                output <- list(x$patch)
                names(output) <- x$filename
                output
            }
        )

    # TODO check relevancy of file

    output
}

# input is the output of get_diff_text
# returns a data.frame with the position (line number) of the added lines (in
# the output file) and their contents
extract_added_lines <- function(diff_text) {
    raw_df <- diff_text |>
        stringr::str_split(
            pattern = stringr::fixed("\n")
        ) |>
        # TODO check if one
        purrr::pluck(1) |>
        tibble::tibble(raw = _)

    output <- raw_df |>
        dplyr::mutate(
            is_hunk = stringr::str_starts(
                raw,
                stringr::fixed("@@")
            ),
            # identify the start of the hunk in the destination file
            new_start = dplyr::if_else(
                .data$is_hunk,
                stringr::str_extract(.data$raw, "\\+(\\d+)"),
                NA_character_
            ),
            new_start = stringr::str_remove_all(
                .data$new_start,
                stringr::fixed("+")
            ),
            new_start = as.numeric(
                .data$new_start
            )
        ) |>
        # TODO this should hold with multiple hunks, but check
        tidyr::fill(
            "new_start",
            .direction = "down"
        ) |>
        # classify lines
        dplyr::mutate(
            type = dplyr::case_when(
                stringr::str_starts(
                    .data$raw,
                    stringr::fixed("+")
                ) &
                    # ++ indicates a line that did not exist in either parent
                    # was introduced by the merge resolution itself
                    stringr::str_starts(
                        .data$raw,
                        stringr::fixed("++"),
                        negate = TRUE
                    ) ~ "added",
                stringr::str_starts(
                    .data$raw,
                    stringr::fixed("-")
                ) ~ "deleted",
                TRUE ~ "context"
            ),
            advances = .data$type %in% c("added", "context")
        ) |>
        # compute output line numbers within hunks
        dplyr::group_by(
            .data$new_start
        ) |>
        dplyr::mutate(
            out_line = .data$new_start + cumsum(.data$advances) - 1
        ) |>
        dplyr::ungroup() |>
        # keep only added lines
        dplyr::filter(
            .data$type == "added"
        ) |>
        dplyr::mutate(
            line = .data$out_line,
            text = stringr::str_remove(.data$raw, "^\\+"),
            .keep = "none"
        )

    output
}

get_diff_line_coverage <- function(
    repo,
    pr_details,
    changed_files,
    head_coverage
) {
    diff_text <- get_diff_text(
        repo = repo,
        pr_details = pr_details,
        changed_files = changed_files
    ) |>
        purrr::flatten() # TODO ??????? needed?

    added_lines <- diff_text |>
        # TODO see how this behaves with more complicated diffs - eg a tfrmt one
        purrr::map(
            extract_added_lines
        ) |>
        purrr::list_rbind(
            names_to = "file"
        )

    lines_coverage <- head_coverage |>
        to_report_data() |>
        purrr::pluck("full") |>
        purrr::list_rbind(
            names_to = "file"
        ) |>
        dplyr::mutate(
            coverage = as.numeric(.data$coverage)
        )

    # TODO maybe do a sense check here as `text` should be identical to `source`
    diff_line_coverage <- added_lines |>
        dplyr::left_join(
            lines_coverage,
            by = dplyr::join_by(
                "file",
                "line"
            )
        ) |>
        dplyr::mutate(
            covered = dplyr::case_when(
                .data$coverage == 0 ~ 0,
                is.na(.data$coverage) ~ 0,
                .default = 1
            )
        ) |>
        dplyr::group_by(
            .data$file
        ) |>
        dplyr::summarise(
            lines_added = dplyr::n(),
            lines_covered = sum(.data$covered)
        ) |>
        dplyr::ungroup()

    diff_line_coverage
}
