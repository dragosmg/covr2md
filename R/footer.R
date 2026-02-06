compose_footer <- function(
    pkg_ver = utils::packageVersion("covr2gh"),
    pkg_url = "https://dragosmg.github.io/covr2gh",
    date = Sys.Date()
) {
    glue::glue_data(
        list(
            date = date,
            pkg_ver = pkg_ver,
            pkg_url = pkg_url
        ),
        "<sup>Created on {date} with [covr2gh v{pkg_ver}]({pkg_url}).</sup>"
    )
}
