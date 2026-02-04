# file_coverage() works

    Code
      file_coverage(cov)
    Output
      # A tibble: 6 x 2
        file              coverage
        <chr>                <dbl>
      1 R/augment_cnp.R      100  
      2 R/cnp.R               70  
      3 R/decompose_cnp.R    100  
      4 R/extract.R           83.3
      5 R/validate_cnp.R      92.3
      6 Overall               91.9

# file_coverage() complains

    Code
      file_coverage(mtcars)
    Condition
      Error in `file_coverage()`:
      ! `x` must be a coverage object

# combine_file_coverage works

    Code
      combine_file_coverage(head_coverage, base_coverage, changed_files)
    Output
      # A tibble: 4 x 4
        file          coverage_head coverage_base delta
        <chr>                 <dbl>         <dbl> <dbl>
      1 R/add_one.R            40            40     0  
      2 R/add_three.R           0             0     0  
      3 R/add_two.R            57.1           0    57.1
      4 Overall                31.6          10.5  21.0

# compose_file_coverage_details works

    Code
      compose_file_coverage_details(file_cov)
    Output
      ### Files with code or coverage changes
      
      |    File| Coverage head| Coverage base| &Delta; |              |
      |-------:|-------------:|-------------:|:-------:|:------------:|
      | R/foo.R|         56.2%|         52.1%|  4.10   |  :arrow_up:  |
      | R/bar.R|         43.5%|         12.5%|  31.00  |  :arrow_up:  |
      | R/baz.R|        78.34%|        84.23%|  -5.89  | :arrow_down: |
      | Overall|        60.34%|         54.5%|  5.84   |  :arrow_up:  |

