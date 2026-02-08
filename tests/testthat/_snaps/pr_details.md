# get_pr_details() works

    Code
      get_pr_details(repo = "dragosmg/covr2ghdemo", pr_number = 2)
    Output
      $repo
      [1] "dragosmg/covr2ghdemo"
      
      $pr_number
      [1] 2
      
      $is_fork
      [1] FALSE
      
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

# extract_added_lines works

    Code
      extract_added_lines(test_diff_text)
    Output
      # A tibble: 3 x 2
         line source                                                              
        <int> <chr>                                                               
      1    11 "  if (!is.numeric(x)) {"                                           
      2    13 "      \"`x` must be numeric. You supplied a {.class {class(x)}}\","
      3    14 "      call = rlang::caller_env()"                                  

# extract_added_lines with a more complex diff

    Code
      purrr::map(slightly_complex_diff_text, extract_added_lines)
    Output
      $`R/badge.R`
      # A tibble: 4 x 2
         line source                                                                  
        <int> <chr>                                                                   
      1    67 "    # make the URL external for now - the internal one does not work f~
      2    68 "    # repos anyway"                                                    
      3    69 "    is_fork <- TRUE"                                                   
      4    70 ""                                                                      
      
      $`R/github_action.R`
      # A tibble: 14 x 2
          line source                                                                
         <int> <chr>                                                                 
       1    34 "#' @inheritParams get_pr_details"                                    
       2    39 "#' use_covr2gh_action(\"<owner>/<repo>\")"                           
       3    41 "use_covr2gh_action <- function(repo, badge = TRUE) {"                
       4    49 "        use_covr2gh_badge(repo)"                                     
       5    63 "#' @inheritParams get_pr_details"                                    
       6    64 "#'"                                                                  
       7    69 "#' use_covr2gh_badge(\"<owner>/<repo>\")"                            
       8    71 "use_covr2gh_badge <- function(repo) {"                               
       9    76 "    href <- glue::glue("                                             
      10    77 "        \"https://github.com/{repo}/actions/workflows/covr2gh.yaml\""
      11    78 "    )"                                                               
      12    79 ""                                                                    
      13    81 "        badge_name = \"covr2gh-coverage\","                          
      14    82 "        href = href,"                                                
      

# get_diff_text works

    Code
      get_diff_text(pr_details = pr_details)
    Output
      $`R/add_one.R`
      [1] "@@ -9,9 +9,10 @@\n #' add_one(2)\n #' add_one(4)\n add_one <- function(x) {\n-  if (!rlang::is_double(x)) {\n+  if (!is.numeric(x)) {\n     cli::cli_abort(\n-      \"`x` must be numeric. You supplied a {.class {class(x)}}\"\n+      \"`x` must be numeric. You supplied a {.class {class(x)}}\",\n+      call = rlang::caller_env()\n     )\n   }\n   x + 1"
      
      $`R/add_three.R`
      [1] "@@ -9,13 +9,14 @@\n #' add_three(2)\n #' add_three(4)\n add_three <- function(x) {\n-  if (!rlang::is_double(x)) {\n+  if (!is.numeric(x)) {\n     cli::cli_abort(\n       \"`x` must be numeric. You supplied a {.class {class(x)}}\"\n     )\n   }\n \n   x |>\n-    add_two() |>\n+    add_one() |>\n+    add_one() |>\n     add_one()\n }"
      
      $`R/add_two.R`
      [1] "@@ -9,7 +9,7 @@\n #' add_two(2)\n #' add_two(4)\n add_two <- function(x) {\n-  if (!rlang::is_double(x)) {\n+  if (!is.numeric(x)) {\n     cli::cli_abort(\n       \"`x` must be numeric. You supplied a {.class {class(x)}}\"\n     )"
      

