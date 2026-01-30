#' @keywords internal
#' @importFrom rlang .data
"_PACKAGE"

# Suppress R CMD check note
# Namespace in Imports field not imported from: PKG
#   All declared Imports should be used.
# to_report_data uses htmltools
ignore_unused_imports <- function() {
    htmltools::a # nocov
}

## usethis namespace: start
## usethis namespace: end
NULL
