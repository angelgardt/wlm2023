# HW15 // Solutions
# A. Angelgardt

# MAIN

library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")
library(factoextra)


# 1
bffm <- read_tsv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/hw15/bffm.csv")
str(bffm)

bffm %>% 
  # select(matches("^[[:upper:]]{3}\\d+$")) %>% 
  # colnames()
  # sapply(unique)
  mutate(across(matches("^[[:upper:]]{3}\\d+$"), as.numeric)) %>% 
  drop_na() -> bffm

nrow(bffm)


# 2
## a
bffm %>% 
  select(matches("^[[:upper:]]{3}\\d+$")) -> bffm_q

## b
bffm_q %>% 
  cor() %>% 
  ggcorrplot::ggcorrplot(colors = c("red3", "white", "blue3"))

# 3

# https://raw.githubusercontent.com/angelgardt/da-2023-ranepa/master/data/direction_matrix_bffm.csv


# 4


# 5


# 6


# 7


# 8


# 9


# 10



# ADDITIONAL

# 1


# 2


# 3


# 4


# 5

