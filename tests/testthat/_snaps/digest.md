# digest_coverage() works

    Code
      digest_coverage(cov)
    Output
      # A tibble: 6 x 2
        file               coverage
        <chr>             <dbl[1d]>
      1 R/augment_cnp.R       100  
      2 R/cnp.R                70  
      3 R/decompose_cnp.R     100  
      4 R/extract.R            83.3
      5 R/validate_cnp.R       92.3
      6 Total                  91.9

# digest_coverage() complains

    Code
      digest_coverage(mtcars)
    Condition
      Error in `digest_coverage()`:
      ! `x` must be a coverage object

