library(tidyverse)

q1 <- read_csv("Q1.csv")

str(q1)

q1 %>% 
  select(matches("Score")) %>% 
  select(-(1:2)) %>% 
  mutate(resp = 1:nrow(q1)) %>% 
  set_names(c(paste0("q1_", c(1:15, rep(16, 4), 17:19, rep(20, 4))), "resp")) %>% 
  pivot_longer(cols = -resp,
               names_to = "item",
               values_to = "raw_score") %>% 
  mutate(raw_score = str_extract_all(raw_score, "\\d\\.\\d{2}") %>% 
           unlist() %>% as.numeric()) %>% 
  group_by(resp, item) %>% 
  summarise(score = sum(raw_score)) %>% 
  mutate(max_score = ifelse(str_detect(item, "_16|_20"), 4, 1),
         item_num = str_extract_all(item, "\\d{1,2}$") %>% 
           unlist() %>% 
           as.integer(),
         scaled_score = score / max_score) %>% 
  ungroup() %>% 
  group_by(item_num) %>% 
  summarise(difficulty = mean(scaled_score)) %>% 
  ggplot(aes(item_num, difficulty)) +
  geom_point() +
  scale_x_continuous(breaks = 1:20) +
  geom_hline(yintercept = c(.05, .95))


