# badge_value() works

    Code
      badge_value(34.34)
    Output
      $value_num
      [1] 34.34

      $value_char
      [1] "34%"


---

    Code
      badge_value(78.4334)
    Output
      $value_num
      [1] 78.4334

      $value_char
      [1] "78%"


---

    Code
      badge_value(98.34)
    Output
      $value_num
      [1] 98.34

      $value_char
      [1] "98%"


---

    Code
      badge_value(25.34)
    Output
      $value_num
      [1] 25.34

      $value_char
      [1] "25%"


---

    Code
      badge_value(69.34)
    Output
      $value_num
      [1] 69.34

      $value_char
      [1] "69%"


# badge_value() works with NULL and NA

    Code
      badge_value(NULL)
    Output
      $value_num
      [1] NA

      $value_char
      [1] "unknown"


---

    Code
      badge_value(NA)
    Output
      $value_num
      [1] NA

      $value_char
      [1] "unknown"


# badge_value() clamps values gt 100 or lt 0

    Code
      badge_value(100.78)
    Output
      $value_num
      [1] 100

      $value_char
      [1] "101%"


---

    Code
      badge_value(-1)
    Output
      $value_num
      [1] 0

      $value_char
      [1] "-1%"


---

    Code
      badge_value(100.78, verbose = TRUE)
    Message
      i `value` is greater than 100%. It will be adjusted to 100%.
    Output
      $value_num
      [1] 100

      $value_char
      [1] "101%"


---

    Code
      badge_value(-1, verbose = TRUE)
    Message
      i `value` is less than 0%. It will be adjusted to 0%.
    Output
      $value_num
      [1] 0

      $value_char
      [1] "-1%"
