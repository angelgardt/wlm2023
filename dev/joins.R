library(tidyverse)

x <- tribble(
  ~id, ~var1, ~var2,
  1, "Abc", 5,
  2, "Def", 16,
  5, "Mno", 11,
  7, "Stu", 96
)

y <- tribble(
  ~id, ~var3, ~var4,
  1, "cond1", 12.8,
  2, "cond1", 14.2,
  3, "cond2", 32.5,
  4, "cond2", 9.4
)

inner_join(x, y)
left_join(x, y)
right_join(x, y)
full_join(x, y)

x <- tribble(
  ~id, ~var1, ~var2,
  1, "Abc", 5,
  1, "Abc", 7,
  2, "Def", 16,
  5, "Mno", 11,
  7, "Stu", 96
)

y <- tribble(
  ~id, ~var3, ~var4,
  1, "cond1", 12.8,
  2, "cond1", 14.2,
  2, "cond1", 2.0,
  3, "cond2", 32.5,
  4, "cond2", 9.4
)

inner_join(x, y)
left_join(x, y)
right_join(x, y)
full_join(x, y)

semi_join(x, y)
semi_join(y, x)
anti_join(x, y)
anti_join(y, x)
