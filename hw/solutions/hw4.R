# HW1 // Solutions
# A. Angelgardt

# MAIN

# 1
library(tidyverse)

base_time <- readxl::read_xlsx("../data/hw4/base.xlsx", "Time", skip = 1)
base_acc <- readxl::read_xlsx("../data/hw4/base.xlsx", "cor_answ", skip = 1)
super_time <- readxl::read_xlsx("../data/hw4/super.xlsx", "Time", skip = 1)
super_acc <- readxl::read_xlsx("../data/hw4/super.xlsx", "cor_answ", skip = 1)

# 2
nrow(base_acc); nrow(base_time); nrow(super_acc); nrow(super_time)

# 3
base_acc %>% 
  select(...20, ...21) %>% 
  bind_rows(
    super_acc %>% 
      select(...20, ...21)
  ) -> socdem
sapply(socdem, function(x) sum(is.na(x)))

# 4
socdem %>% 
  drop_na() %>% 
  set_names("sex", "age") -> socdem
nrow(socdem)

# 5
slice_select <- function(x) x %>% select(1:17) %>% slice(1:24)

base_acc %>% slice_select() -> base_acc
base_time %>% slice_select() -> base_time
super_acc %>% slice_select() -> super_acc
super_time %>% slice_select() -> super_time

# 6
base_acc %>% mutate(group = "base") -> base_acc
base_time %>% mutate(group = "base") -> base_time
super_acc %>% mutate(group = "super") -> super_acc
super_time %>% mutate(group = "super") -> super_time

# 7
base_acc %>% 
  bind_rows(super_acc) -> acc
base_time %>% 
  bind_rows(super_time) -> time

# 8
acc %>% 
  pivot_longer(-c("№_resp", "group"),
               values_to = "accuracy") %>% 
  separate(name, into = c("memory_setsize", "visual_setsize"), sep = "_stim_") %>% 
  rename(id = `№_resp`) -> acc
time %>% 
  pivot_longer(-c("№_resp", "group"),
               values_to = "reaction_time") %>% 
  separate(name, into = c("memory_setsize", "visual_setsize"), sep = "_stim_") %>% 
  rename(id = `№_resp`) -> time

# 9
acc %>% 
  full_join(time, 
            join_by(id, 
                    memory_setsize, 
                    visual_setsize, 
                    group)) -> hybrid
# 10
hybrid %>% 
  group_by(group, visual_setsize, memory_setsize) %>% 
  summarise(rt_mean = mean(reaction_time),
            rt_min = min(reaction_time),
            rt_max = max(reaction_time),
            rt_sd = sd(reaction_time))


# ADDITIONAL

# 1
dir("../data/hw4/") %>% 
  str_remove_all(".xlsx")

# 2
path <- "../data/hw4/"

preproc <- function(file, sheet, path_to_folder) {
  readxl::read_xlsx(paste0(path_to_folder, file), 
                    skip = 1, 
                    sheet = sheet) %>%
    select(1:17) %>%
    slice(1:24) %>%
    rename("id" = "№_resp") %>%
    pivot_longer(-id,
                 names_to = "cond",
                 values_to = sheet) %>%
    separate(cond,
             into = c("memory_setsize", "visual_setsize"),
             sep = "_stim_") %>%
    mutate(group = file %>%
             str_remove_all(".xlsx")) %>%
    return()
}

preproc("super.xlsx", "Time", path) %>% 
  bind_rows(
    preproc("base.xlsx", "Time", path)
  ) %>% 
  full_join(preproc("super.xlsx", "cor_answ", path) %>% 
              bind_rows(
                preproc("base.xlsx", "cor_answ", path)
              ), 
            join_by(id, 
                    memory_setsize, 
                    visual_setsize, 
                    group)) %>% 
  rename("reaction_time" = "Time",
         "accuracy" = "cor_answ")

# 3


# 4


# 5

