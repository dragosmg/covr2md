# get_pr_details() works

    Code
      get_pr_details(owner = "dragosmg", repo = "covr2mddemo", pr_number = 2)
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
      [1] "https://github.com/dragosmg/covr2mddemo/pull/2"
      
      attr(,"class")
      [1] "pr_details"

# get_changed_files() works

    Code
      get_changed_files(owner = "dragosmg", repo = "covr2mddemo", pr_number = 2)
    Output
      [1] "R/add_one.R"   "R/add_three.R" "R/add_two.R"  

