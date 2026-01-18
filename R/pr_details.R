get_pr_details <- function(
  owner = character(),
  repo = character(),
  pr_number = integer()
) {
  pr_api_url <- glue::glue(
    "https://api.github.com/repos/{owner}/{repo}/pulls/{pr_number}"
  )

  pr_info <- glue::glue("GET {pr_api_url}") |>
    gh::gh()

  list(
    head_name = pr_info$head$ref,
    head_sha = pr_info$head$sha,
    base_name = pr_info$base$ref,
    base_sha = pr_info$base$sha,
    pr_html_url = pr_info$html_url
  )
}

get_changed_files <- function(
  owner = character(),
  repo = character(),
  pr_number = integer()
) {
  files_api_url <- glue::glue(
    "https://api.github.com/repos/{owner}/{repo}/pulls/{pr_number}/files"
  )

  files_info <- glue::glue("GET {files_api_url}") |>
    gh::gh()

  changed_files <- purrr::map_chr(files_info, "filename")

  relevant_files_changed <- stringr::str_subset(
    changed_files,
    pattern = "^R/|^src"
  )

  list(
    head_name = pr_info$head$ref,
    head_sha = pr_info$head$sha,
    base_name = pr_info$base$ref,
    base_sha = pr_info$base$sha,
    pr_html_url = pr_info$html_url
  )
}
