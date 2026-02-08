# badge_value() clamps values gt 100 or lt 0

    Code
      badge_value(100.78, verbose = TRUE)
    Message
      i `value` is greater than 100%. It will be adjusted to 100%.
    Output
      $num
      [1] 100
      
      $char
      [1] "100%"
      
      attr(,"class")
      [1] "badge_value"

---

    Code
      badge_value(-1, verbose = TRUE)
    Message
      i `value` is less than 0%. It will be adjusted to 0%.
    Output
      $num
      [1] 0
      
      $char
      [1] "0%"
      
      attr(,"class")
      [1] "badge_value"

# estimate_width_value complains

    Code
      estimate_width_value("foo")
    Condition
      Error in `estimate_width_value()`:
      ! `badge_value` must be created with `badge_value()`.

# estimate_text_length_value complains

    Code
      estimate_text_length_value("foo")
    Condition
      Error in `estimate_text_length_value()`:
      ! `badge_value` must be created with `badge_value()`.

# derive_badge_colour complains

    Code
      derive_badge_colour("foo")
    Condition
      Error in `derive_badge_colour()`:
      ! `badge_value` must be created with `badge_value()`.

