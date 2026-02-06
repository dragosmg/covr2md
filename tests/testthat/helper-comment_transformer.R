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
        "[0-9a-f]{6,8}",
        "<removed-commit-sha>"
    )
}

# strip the package version
remove_pkg_version <- function(x) {
    # parts (I am old, I forget)
    # (?<![0-9.])- negative lookbehind. the character immediately before cannot
    # be a digit or a dot
    # (?:\\.\\d{1,4})? - optional fourth block
    #    * (?: ... ) - non-capturing group
    #    * \\. — dot separator
    #    * \\d{1,4} — fourth block digits
    #    * ? — make the entire group optional
    # (?![0-9.]) - negative lookahead. the character immediately after the match
    # cannot be a digit or a dot
    stringr::str_replace(
        x,
        stringr::regex(
            "(?<![0-9.])\\d{1,2}\\.\\d{1,2}\\.\\d{1,2}(?:\\.\\d{1,4})?(?![0-9.])"
        ),
        "<x.y.z.9000>"
    )
}

remove_date_sha_pkg_ver <- function(x) {
    x |>
        remove_date() |>
        remove_commit_sha() |>
        remove_pkg_version()
}
