value_to_char <- function(value, verbose = FALSE, call = rlang::caller_env()) {
    if (is.null(value) || is.na(value)) {
        return(
            list(
                num = NA_real_,
                char = "unknown"
            )
        )
    }

    value_num <- value

    if (value > 100) {
        if (verbose) {
            cli::cli_alert_info(
                "{.arg value} is greater than 100%. It will be adjusted to 100%.",
                .envir = call
            )
        }
        value_num <- 100
    }

    if (value < 0) {
        if (verbose) {
            cli::cli_alert_info(
                "{.arg value} is less than 0%. It will be adjusted to 0%.",
                .envir = call
            )
        }
        value_num <- 0
    }

    value_char <- paste0(round(value_num), "%")

    list(
        num = value_num,
        char = value_char
    )
}

estimate_width_value <- function(
    badge_value,
    label_width = 60
) {
    dplyr::case_when(
        badge_value$char == "unknown" ~ label_width,
        badge_value$char == "100%" ~ 40,
        nchar(badge_value$char) < 3 ~ 30,
        .default = 35
    )
}

estimate_text_length_value <- function(badge_value, text_length_label = 50) {
    dplyr::case_when(
        badge_value$char == "unknown" ~ text_length_label,
        badge_value$char == "100%" ~ 31,
        nchar(badge_value$char) < 3 ~ 20,
        .default = 26
    )
}
