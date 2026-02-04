short_hash <- function(hash, n = 7) {
    stringr::str_sub(hash, 1, n)
}

find_intervals <- function(x) {
    run_diff <- c(1, diff(x))
    diff_list <- split(x, cumsum(run_diff != 1))

    purrr::map_chr(diff_list, collapse_interval) |>
        stringr::str_flatten_comma()
}

collapse_interval <- function(x) {
    if (length(x) == 1) {
        return(
            as.character(x)
        )
    } else if (length(x) == 2) {
        stringr::str_flatten_comma(x)
    } else {
        paste0(x[1], "-", x[length(x)])
    }
}
