# HW15 // Solutions
# A. Angelgardt

# MAIN

library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")
library(factoextra)
library(GPArotation)


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

bffm %>% 
  select(matches("^[[:upper:]]{3}\\d+$")) %>% colnames() -> cols


## b
bffm_q %>% 
  cor() %>% 
  ggcorrplot::ggcorrplot(colors = c("red3", "white", "blue3"))

# 3
dirmat <- read_tsv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/hw15/direction_matrix_bffm.csv")

dirmat %>%
  pivot_longer(-item_in_scale,
               values_to = "direction") %>%
  unite(item, name, item_in_scale, sep="") %>%
  full_join(
    bffm_q %>%
      mutate(id = 1:nrow(bffm_q)) %>% 
      pivot_longer(cols = -id,
                   names_to = "item",
                   values_to = "score"),
    join_by(item)
  ) %>%
  mutate(score = ifelse(direction == -1, 6 - score, score)) %>%
  select(-direction) %>%
  pivot_wider(names_from = "item",
              values_from = "score") %>% 
  select(-id) %>% 
  select(sort(tidyselect::peek_vars())) -> bffm_q

bffm_q %>% 
  cor() %>% 
  ggcorrplot::ggcorrplot(colors = c("red3", "white", "blue3"))


# 4
pca <- prcomp(bffm_q, scale. = TRUE)
summary(pca)


# 5
ggplot(NULL,
       aes(names(summary(pca)$importance[1, ]) %>% 
             factor(ordered = TRUE, levels = paste0("PC", 1:50)),
           summary(pca)$importance[1, ])) +
  geom_hline(yintercept = 1, linetype = "dashed") +
  geom_line(aes(group = 1)) +
  geom_point(size = 2) +
  labs(x = "Principal components",
       y = "Standard Deviation")


# 6
ggplot(NULL,
       aes(names(summary(pca)$importance[3, ]) %>% 
             factor(ordered = TRUE, levels = paste0("PC", 1:50)),
           summary(pca)$importance[3, ])) +
  geom_hline(yintercept = .8, linetype = "dashed") +
  geom_line(aes(group = 1)) +
  geom_point(size = 2) +
  labs(x = "Principal components",
       y = "Cumulative Variance Proportion")


# 7
EFAtools::BARTLETT(bffm_q)
EFAtools::KMO(bffm_q)


# 8
psych::fa.parallel(bffm_q, fa = "fa", fm = "ml")


# 9
factanal(bffm_q, factors = 5)
factanal(bffm_q, factors = 9)


# 10
factanal(bffm_q, factors = 5, rotation = "promax")
factanal(bffm_q, factors = 5, rotation = "oblimin")
