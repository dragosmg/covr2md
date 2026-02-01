# value_to_char() clamps values gt 100 or lt 0

    Code
      value_to_char(100.78, verbose = TRUE)
    Message
      i `value` is greater than 100%. It will be adjusted to 100%.
    Output
      $num
      [1] 100
      
      $char
      [1] "100%"
      

---

    Code
      value_to_char(-1, verbose = TRUE)
    Message
      i `value` is less than 0%. It will be adjusted to 0%.
    Output
      $num
      [1] 0
      
      $char
      [1] "0%"
      

