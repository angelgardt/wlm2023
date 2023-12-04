library(tidyverse)

tibble(code = paste(rep(c("A", "B"), 
                        each = 3),
                    rep(c("D", "S", "N"), 
                        times = 2),
                    sep = "_"),
       n = rep(c(16, 18), each = 3)) %>% 
  filter(str_detect(code, "S$|N$"))


fs <- read_csv2("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr3/des_fs.csv")

fs %>% 
  select(id, cond, time) %>% 
  group_by(cond, id) %>% 
  summarise(rt = mean(time, na.rm = TRUE)) %>% 
  pivot_wider(names_from = cond, values_from = rt)
  
  separate(cond, into = c("cond", "present")) %>% 
  mutate(acc = ifelse(present == "p" & key == "'right'" |
                        present == "a" & key == "'left'", TRUE, FALSE)) %>% 
  group_by(cond, id) %>% 
  summarise(rt = mean(time, na.rm = TRUE),
            acc = mean(acc, na.rm = TRUE)) %>% 
  slice()
