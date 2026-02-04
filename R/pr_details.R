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
#'   * `repo`: GitHub repository (the value passed to the `repo` input argument)
#'   * `pr_number`: pull request number (the value passed to the `pr_number`
#'      argument)
#'   * `head_name`: name of the current branch
#'   * `head_sha`: the sha of the last commit in the current branch
#'   * `base_name`: the name of the destination branch
#'   * `base_sha`: the sha of most recent commit on the destination branch
#'   * `pr_html_url`: the URL to the PR HTML branch
#'   * `diff_url`: the diff URL
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' get_pr_details("<owner>/<myawesomerepo>", 2)
#' }
get_pr_details <- function(
    repo,
    pr_number,
    call = rlang::caller_env()
) {
    # TODO check for GitHub format (`OWNER/REPO`)
    # TODO I think usethis call this repo_spec. Might make sense to sync with
    # that?
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

    output <- structure(
        list(
            repo = repo,
            pr_number = pr_number,
            is_fork = pr_info$head$repo$fork,
            head_name = pr_info$head$ref,
            head_sha = pr_info$head$sha,
            base_name = pr_info$base$ref,
            base_sha = pr_info$base$sha,
            pr_html_url = pr_info$html_url,
            diff_url = pr_info$diff_url
        ),
        class = "pr_details"
    )

    output
}

#' Get changed files
#'
#' Sends a GET request to the GitHub API and retrieves the files modified by
#' the PR. It then subsets these to only includes the "relevant" files - i.e.
#' those under `R/` or `src/`.
#'
#' @inheritParams get_pr_details
#'
#' @returns a character vector containing the names of the changed files.
#'
#' @keywords internal
#' @examples
#' \dontrun{
#' get_changed_files("<owner>/<repo>", 2)
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

    relevant_files <- purrr::map_chr(files_info, "filename")

    relevant_files_changed <- stringr::str_subset(
        relevant_files,
        pattern = "^R/|^src"
    )

    relevant_files_changed
}

#' Get the PR diff
#'
#' Sends a GET request to the GitHub API and retrieves the files modified by
#' the PR. It then subsets these to only includes files under `R/` or `src/`.
#'
#' @inheritParams get_pr_details
#' @inheritParams get_diff_line_coverage
#'
#' @returns a character vector containing the names of the changed files.
#'
#' @keywords internal
#' @examples
#' \dontrun{
#' pr_details <- get_pr_details("<owner>/<repo>", 2)
#' # TODO example
#' relevant_files <-
#' diff_text <- get_diff_text(pr_details, relevant_files)
#' }
get_diff_text <- function(
    pr_details,
    relevant_files,
    call = rlang::caller_env()
) {
    # ! TODO need to test diff logic with more complex diffs
    # TODO add inputs checks
    # TODO standalone rlang?
    repo <- pr_details$repo

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
    # TODO it would be useful if this worked when relevant files is NULL
    output <- reply$files |>
        # we focus on `relevant_files` to get to the added lines
        purrr::keep(
            \(x) x$filename %in% relevant_files
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
# get_diff_text returns a list so this function should be used with map
extract_added_lines <- function(diff_text) {
    raw_df <- diff_text |>
        stringr::str_split(
            pattern = stringr::fixed("\n")
        ) |>
        # TODO check if one
        # TODO this is a bit risky as for more complex diffs pluck(1) get the
        # first element. The function returns something, but not what we would
        # expect
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
                .data$is_hunk ~ "hunk",
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

#' Get the line coverage for the diff
#'
#' Are the added lines covered by unit tests?
#' Does this in several steps:
#'   * get the text of the git diff (the combined diff format)
#'   * extracts the added lines and calculates the new line numbers
#'   * does a bit of shuffling of the head coverage data to summarise at
#'   line level
#'   * summarises the number of lines added and number of lines covered by
#'   tests at file level
#'
#'
#' @inheritParams get_pr_details
#' @inheritParams compose_coverage_summary
#' @param relevant_files (character) files with changes in coverage
#' @inheritParams compose_comment
#'
#' @returns a `tibble` with 3 columns:
#'   * file: file name
#'   * lines_added: total number of lines that would be added by merging the PR
#'   * lines_covered: number of added lines covered by unit tests
#'
#' @keywords internal
get_diff_line_coverage <- function(
    repo,
    pr_details,
    relevant_files,
    head_coverage,
    base_coverage
) {
    diff_text <- get_diff_text(
        pr_details = pr_details,
        relevant_files = relevant_files
    ) |>
        purrr::flatten()

    if (rlang::is_empty(diff_text)) {
        # TODO exit early it means the relevant files haven't actually changed
        return(NULL)
    }

    added_lines <- diff_text |>
        # TODO see how this behaves with more complicated diffs - eg a tfrmt one
        purrr::map(
            extract_added_lines
        ) |>
        purrr::list_rbind(
            names_to = "file"
        )

    lines_head <- line_coverage(head_coverage) |>
        dplyr::select(
            -"source_prev",
            -"source_next"
        )
    # TODO check with tally - maybe the implementation is simpler
    # lines_head_tally <- covr::tally_coverage(head_coverage)
    # lines_base_tally <- covr::tally_coverage(base_coverage)

    lines_cov_change_wo_code_change <- cov_change_wo_code_change(
        head_coverage = head_coverage,
        base_coverage = base_coverage,
        added_lines = added_lines
    )

    # now we need to figure for which lines the coverage has
    # changed. given these have not changed, we assume they are in the same
    # file and have the same content
    # TODO this is not robust. we given these haven't changed we could stretch
    # the assumption that lines before and after remained the same

    # TODO maybe do a sense check here as `text` should be identical to `source`
    diff_line_coverage <- added_lines |>
        dplyr::left_join(
            lines_head,
            by = dplyr::join_by(
                "file",
                "line",
                "text" == "source"
            )
        ) |>
        # remove NAs as they map to comments, documentation etc.
        dplyr::filter(
            !is.na(.data$coverage)
        ) |>
        dplyr::mutate(
            covered = dplyr::if_else(
                .data$coverage == 0,
                0,
                1
            )
        )

    # TODO for the basic diff line coverage use tally_coverage()
    missing_line_cov <- diff_line_coverage |>
        dplyr::select(
            -"text"
        ) |>
        dplyr::filter(
            .data$covered == 0
        ) |>
        dplyr::group_by(
            .data$file
        ) |>
        dplyr::summarise(
            missing = find_intervals(.data$line)
        ) |>
        dplyr::ungroup()

    agg_line_cov <- diff_line_coverage |>
        dplyr::group_by(
            .data$file
        ) |>
        dplyr::summarise(
            lines_added = dplyr::n(),
            lines_covered = sum(.data$covered)
        ) |>
        dplyr::ungroup() |>
        dplyr::left_join(
            missing_line_cov,
            by = dplyr::join_by("file")
        )

    list(
        diff_line_coverage = agg_line_cov,
        lines_cov_change_wo_code_change = lines_cov_change_wo_code_change
    )
}

# extract line coverage from a coverage object
# capture previous and next lines for positional matching later
line_coverage <- function(coverage) {
    coverage |>
        to_report_data() |>
        purrr::pluck("full") |>
        purrr::list_rbind(
            names_to = "file"
        ) |>
        dplyr::mutate(
            coverage = as.numeric(.data$coverage)
        ) |>
        dplyr::group_by(file) |>
        dplyr::mutate(
            source_prev = dplyr::lag(
                .data$source,
                default = "<missing>"
            ),
            source_next = dplyr::lead(
                .data$source,
                default = "<missing>"
            )
        ) |>
        dplyr::ungroup() |>

        # NAs map to comments, documentation etc.
        dplyr::filter(
            !is.na(.data$coverage)
        ) |>
        dplyr::arrange(
            .data$file
        )
}

# figure out which lines have lost coverage without a change in content / code
# basically, lines that are covered by tests in base, but not in head
cov_change_wo_code_change <- function(
    head_coverage,
    base_coverage,
    added_lines
) {
    line_cov_head <- line_coverage(head_coverage)
    line_cov_base <- line_coverage(base_coverage)

    head_lines_with_cov_change <- line_cov_head |>
        # we only want the lines with 0 coverage in head
        dplyr::filter(
            .data$coverage == 0
        ) |>
        # and that have not been added
        dplyr::anti_join(
            added_lines,
            by = dplyr::join_by(
                "file",
                "line"
            )
        ) |>
        # now to figure which of these have coverage in base.
        # Assumptions, given these lines have not been added in head:
        # * they are in the same file as before,
        # * they have the same content as before
        # * their neighbours (line before and line after) have not changed. if
        # they did they would've likely been captured in a combined diff.
        # a bit of a stretch, but let's see if this holds
        dplyr::left_join(
            line_cov_base,
            by = dplyr::join_by(
                "file",
                "source",
                "source_prev",
                "source_next"
            ),
            suffix = c(
                "_head",
                "_base"
            ),
            multiple = "first"
        ) |>
        # we only want the lines that had coverage in base
        dplyr::filter(
            .data$coverage_base != 0
        ) |>
        dplyr::select(
            -"source_prev",
            -"source_next"
        )

    output <- head_lines_with_cov_change |>
        dplyr::group_by(
            .data$file
        ) |>
        dplyr::summarise(
            lines_loss_cov = dplyr::n(),
            which_lines = find_intervals(.data$line_head)
        ) |>
        dplyr::ungroup()

    if (nrow(output) == 0) {
        return(NULL)
    }

    output
}
