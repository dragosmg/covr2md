# add_line_num_head works

    Code
      add_line_num_head(head_df_pr90_file_cov)
    Output
      # A tibble: 15 x 5
          line raw                                                 hunk  head  context
         <int> <chr>                                               <lgl> <lgl> <lgl>  
       1    75 "@@ -76,6 +76,14 @@ combine_file_coverage <- funct~ TRUE  FALSE FALSE  
       2    76 "         dplyr::mutate("                           FALSE FALSE TRUE   
       3    77 "             delta = .data$coverage_head - .data$~ FALSE FALSE TRUE   
       4    78 "         )"                                        FALSE FALSE TRUE   
       5    79 "+    # TODO this does not capture situations when~ FALSE TRUE  FALSE  
       6    80 "+    # coverage hasn't (i.e. coverage is 0)"       FALSE TRUE  FALSE  
       7    81 "+    # * this is relevant"                         FALSE TRUE  FALSE  
       8    82 "+    # * need to return at capturing both files w~ FALSE TRUE  FALSE  
       9    83 "+    # those"                                      FALSE TRUE  FALSE  
      10    84 "+    # with changes to content. In this case, bec~ FALSE TRUE  FALSE  
      11    85 "+    # subset the diff_text,"                      FALSE TRUE  FALSE  
      12    86 "+    # we miss a bunch of files functions with co~ FALSE TRUE  FALSE  
      13    87 " "                                                 FALSE FALSE TRUE   
      14    88 "     # keep any files with changes in coverage or~ FALSE FALSE TRUE   
      15    89 "     diff_df |>"                                   FALSE FALSE TRUE   

---

    Code
      add_line_num_head(head_df_pr90_gha)
    Output
      # A tibble: 50 x 5
          line raw                                                 hunk  head  context
         <int> <chr>                                               <lgl> <lgl> <lgl>  
       1    22 "@@ -23,21 +23,22 @@"                               TRUE  FALSE FALSE  
       2    23 " #' `use_covr2gh_action()` wraps [usethis::use_gi~ FALSE FALSE TRUE   
       3    24 " #'"                                               FALSE FALSE TRUE   
       4    25 " #' @param badge (logical) should a badge be adde~ FALSE FALSE TRUE   
       5    26 "+#' @inheritParams get_pr_details"                 FALSE TRUE  FALSE  
       6    27 " #'"                                               FALSE FALSE TRUE   
       7    28 " #' @export"                                       FALSE FALSE TRUE   
       8    29 " #' @examples"                                     FALSE FALSE TRUE   
       9    30 " #' \\dontrun{"                                    FALSE FALSE TRUE   
      10    31 "+#' use_covr2gh_action(\"<owner>/<repo>\")"        FALSE TRUE  FALSE  
      # i 40 more rows

# diff_split works

    Code
      diff_split(diff1_text_pr90)
    Output
      $head_lines
      # A tibble: 8 x 2
         line source                                                                  
        <int> <chr>                                                                   
      1    79 "    # TODO this does not capture situations when the code has changed,~
      2    80 "    # coverage hasn't (i.e. coverage is 0)"                            
      3    81 "    # * this is relevant"                                              
      4    82 "    # * need to return at capturing both files with changes to coverag~
      5    83 "    # those"                                                           
      6    84 "    # with changes to content. In this case, because we use the files ~
      7    85 "    # subset the diff_text,"                                           
      8    86 "    # we miss a bunch of files functions with content change"          
      
      $base_lines
      NULL
      

---

    Code
      diff_split(diff1_text_pr90)
    Output
      $head_lines
      # A tibble: 8 x 2
         line source                                                                  
        <int> <chr>                                                                   
      1    79 "    # TODO this does not capture situations when the code has changed,~
      2    80 "    # coverage hasn't (i.e. coverage is 0)"                            
      3    81 "    # * this is relevant"                                              
      4    82 "    # * need to return at capturing both files with changes to coverag~
      5    83 "    # those"                                                           
      6    84 "    # with changes to content. In this case, because we use the files ~
      7    85 "    # subset the diff_text,"                                           
      8    86 "    # we miss a bunch of files functions with content change"          
      
      $base_lines
      NULL
      

---

    Code
      diff_split(slightly_complex_diff_text)
    Output
      $head_lines
      # A tibble: 4 x 2
         line source                                                                  
        <int> <chr>                                                                   
      1    67 "    # make the URL external for now - the internal one does not work f~
      2    68 "    # repos anyway"                                                    
      3    69 "    is_fork <- TRUE"                                                   
      4    70 ""                                                                      
      
      $base_lines
      NULL
      

