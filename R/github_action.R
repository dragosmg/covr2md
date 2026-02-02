use_covr2gh_action <- function(badge = TRUE) {
    use_github_action(
        url = "",
    )

    if (isTRUE(badge)) {
        use_covr2gh_badge()
    }
}
use_covr2gh_badge <- function() {
    check_is_package()

    image_source <- "/../covr2gh-storage/badges/main/coverage-badge.svg"

    usethis::use_badge(
        badge_name = "coverage",
        href = "",
        src = image_source
    )
}

is_package <- function(base_path = usethis::proj_get()) {
    res <- tryCatch(
        rprojroot::find_package_root_file(
            path = base_path
        ),
        error = function(e) NULL
    )
    !is.null(res)
}

check_is_package <- function(call = rlang::caller_env()) {
    if (is_package()) {
        return(invisible())
    }

    project_name <- usethis::proj_get() |>
        fs::path_file()

    cli::cli_abort(
        c(
            "i" = "{.fn use_covr2gh_badge} is designed to work with packages.",
            "x" = "Project {.val {project_name}} is not an R package."
        )
    )
}
