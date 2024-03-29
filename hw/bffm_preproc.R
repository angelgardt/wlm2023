library(tidyverse)

bffm <- read_tsv("https://github.com/angelgardt/da-2023-ranepa/raw/master/data/big_five_bffm.csv")

set.seed(999)

ind <- sample(1:nrow(bffm), 30086)

bffm %>% 
  slice(ind) -> bffm_shrink

bffm_shrink %>% write_tsv("")
