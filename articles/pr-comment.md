# The pull request comment

When the workflow runs, {covr2gh} posts a comment on the pull request
summarising the impact of merging the proposed changes on test coverage.

The comment is made up of two parts:

1.  A short summary.
2.  A collapsible *Details* section with additional information.

## Summary

Made up of two sentences, the *Summary* answers questions often raised
during code review.

The first sentence indicates whether merging the pull request will
change the overall test coverage.

The second sentence focuses on the changes introduced by the pull
request, indicating whether the newly added or modified lines are
covered by tests.

![A screen capture showing an example of summary
sentences.](../reference/figures/comment_summary.png)

The summary is always visible so reviewers can quickly factor coverage
changes into their review.

## Details

The *Details* section appears in a collapsible block and provides
additional context for the summary, in the form of two tables.

The first table reports files with changes in coverage.

![A screen capture showing the first table - focused on changes in
coverage by file - from the Details
section.](../reference/figures/comment_file_cov_details.png)

The second table reports coverage for lines added or modified by the
pull request. ![A screen capture showing the second table - focused on
diff coverage (coverage of lines added or modified) - from the Details
section.](../reference/figures/comment_line_cov_details.png)

These tables allow reviewers to inspect coverage changes in a bit more
depth should they need to. They are hidden by default to avoid
cluttering the pull request discussion.

Empty tables are not rendered. If both tables are empty, the entire
*Details* section is automatically suppressed.

![A screen capture showing a full comment
example.](../reference/figures/comment_with_details.png)
