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
#' @dev
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


#' Get the PR diff
#'
#' Sends a GET request to the GitHub API and retrieves the full PR diff, which
#' is a (comparison) between base (the starting point for the comparison) and
#' head (the endpoint). The diff is then filtered to only include the "relevant
#' files".
#'
#' @param pr_details a `pr_details` object.
#'
#' @returns a named list where the names are file names and the content of each
#' element is the patch for the specific file.
#'
#' @dev
#' @examples
#' \dontrun{
#' pr_details <- get_pr_details("<owner>/<repo>", 2)
#'
#' diff_text <- get_diff_text(pr_details)
#' }
get_diff_text <- function(pr_details) {
    # TODO add inputs checks
    # TODO standalone rlang?

    # the endpoint can be used to compare branches. once the PR is merged and
    # the head is deleted it returns a 404. comparing commits can be used, but
    # the separation between commit hashes is 2-dots (`..`), not 3

    req_url <- glue::glue_data(
        list(
            repo = pr_details$repo,
            base = pr_details$base_name,
            head = pr_details$head_name
        ),
        "https://api.github.com/repos/{repo}/compare/{base}...{head}"
    )

    # TODO tryCatch
    reply <- glue::glue("GET {req_url}") |>
        gh::gh()

    # get the patch element and use filename as name
    pull_patch <- function(x) {
        output <- list(x$patch)
        names(output) <- x$filename
        output
    }

    output <- reply$files |>
        purrr::keep(\(x) stringr::str_starts(x$filename, "R/|src/")) |>
        purrr::map(pull_patch) |>
        purrr::list_flatten()

    output
}

# input is the output of get_diff_text
# returns a data.frame with the position (line number) of the added lines (in
# the output file) and their contents
extract_added_lines <- function(diff_text) {
    split_diff <- diff_split(diff_text)

    added_lines <- split_diff$head_lines

    added_lines
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
#' @inheritParams compose_comment
#'
#' @returns a `tibble` with 3 columns:
#'   * file: file name
#'   * lines_added: total number of lines that would be added by merging the PR
#'   * lines_covered: number of added lines covered by unit tests
#'
#' @dev
get_diff_line_coverage <- function(
    pr_details,
    head_coverage
) {
    diff_text <- get_diff_text(
        pr_details = pr_details
    )

    if (rlang::is_empty(diff_text)) {
        return(NULL)
    }

    added_lines <- diff_text |>
        purrr::map(
            extract_added_lines
        ) |>
        purrr::list_rbind(
            names_to = "file_name"
        )

    line_coverage <- head_coverage |>
        covr::tally_coverage(by = "line") |>
        tibble::as_tibble()

    diff_line_coverage <- added_lines |>
        dplyr::left_join(
            line_coverage,
            by = dplyr::join_by(
                "file_name" == "filename",
                "line"
            )
        ) |>
        # missing coverage value implies the line does not contain runnable code
        dplyr::filter(
            !is.na(.data$value)
        ) |>
        dplyr::mutate(
            covered = .data$value != 0
        )

    # if we're left with 0 rows by this point -> all lines changed are
    # non-runnable -> return NULL
    if (nrow(diff_line_coverage) == 0) {
        return(NULL)
    }

    missing_cov <- diff_line_coverage |>
        dplyr::filter(
            !.data$covered
        ) |>
        dplyr::group_by(
            .data$file_name
        ) |>
        dplyr::summarise(
            missing = find_intervals(.data$line)
        ) |>
        dplyr::ungroup()

    totals <- diff_line_coverage |>
        dplyr::group_by(
            .data$file_name
        ) |>
        dplyr::summarise(
            lines_added = dplyr::n(),
            lines_covered = sum(.data$covered)
        ) |>
        dplyr::ungroup()

    output <- totals |>
        dplyr::left_join(
            missing_cov,
            by = dplyr::join_by(
                "file_name"
            )
        )

    output
}
