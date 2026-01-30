remove_date <- function(x) {
    stringr::str_replace_all(
        x,
        "[0-9]{4}-[0-9]{2}-[0-9]{2}",
        replacement = "<removed-date>"
    )
}

remove_commit_sha <- function(x) {
    stringr::str_replace_all(
        x,
        "[:alnum:]{40}",
        "<removed-commit-sha>"
    )
}

remove_date_commit_sha <- function(x) {
    x |>
        remove_date() |>
        remove_commit_sha()
}
