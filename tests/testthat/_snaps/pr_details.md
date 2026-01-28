# get_pr_details() works

    Code
      get_pr_details(repo = "dragosmg/covr2ghdemo", pr_number = 2)
    Output
      $pr_number
      [1] 2
      
      $head_name
      [1] "add_three"
      
      $head_sha
      [1] "b3b920fde4c4d14db76fd037ee6786df754d3412"
      
      $base_name
      [1] "main"
      
      $base_sha
      [1] "63e9463f904c5c079296dbbe3b8c285cf6d95653"
      
      $pr_html_url
      [1] "https://github.com/dragosmg/covr2ghdemo/pull/2"
      
      $diff_url
      [1] "https://github.com/dragosmg/covr2ghdemo/pull/2.diff"
      
      attr(,"class")
      [1] "pr_details"

# get_changed_files() works

    Code
      get_changed_files(repo = "dragosmg/covr2ghdemo", pr_number = 2)
    Output
      [1] "R/add_one.R"   "R/add_three.R" "R/add_two.R"  

# extract_added_lines works

    Code
      extract_added_lines(test_diff_text)
    Output
      # A tibble: 3 x 2
         line text                                                                
        <dbl> <chr>                                                               
      1    12 "  if (!is.numeric(x)) {"                                           
      2    14 "      \"`x` must be numeric. You supplied a {.class {class(x)}}\","
      3    15 "      call = rlang::caller_env()"                                  

