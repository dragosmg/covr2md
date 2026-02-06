test_that("compose_details_section works", {
    expect_identical(
        compose_details_section(
            file_coverage_details = "",
            line_coverage_details = ""
        ),
        ""
    )

    expect_snapshot(
        compose_details_section(
            file_coverage_details = "foo",
            line_coverage_details = "bar"
        )
    )

    expect_s3_class(
        compose_details_section(
            file_coverage_details = "foo",
            line_coverage_details = "bar"
        ),
        "glue"
    )
})
