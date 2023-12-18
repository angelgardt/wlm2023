# HW4 // Solutions
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

## center coordinates

res_x = 1920 # screen resolution x
res_y = 1080 # screen resolution y
gap = 10 # gap between stimuli
n_x = 7 # number of stimuli on x
n_y = 3 # number of stimuli on y
margin_x = 100 # margin on x
margin_y = 100 # margin on y
stim_size_x = 100 # stimulus size on x
stim_size_y = 100 # stimulus size on y
n_trials = 30 # number of trials

step_x = (res_x - 2*margin_x) / (n_x + 1)
step_y = (res_y - 2*margin_y) / (n_y + 1)

centers_x <- seq(margin_x + step_x, res_x - margin_x - step_x, step_x) - res_x / 2
centers_y <- seq(margin_y + step_y, res_y - margin_y - step_y, step_y) - res_y / 2


# 4

## jitter

jitter_x = floor((step_x - gap - stim_size_x) / 2)
jitter_y = floor((step_y - gap - stim_size_y) / 2)


# 5

## coordinates

tibble(
  coords = outer(centers_x, 
                 centers_y, 
                 "paste") %>% 
    as.vector() %>% 
    rep(times = n_trials)) %>% 
  separate(coords, 
           into = c("x", "y"), 
           sep = " ") %>% 
  mutate_all(as.numeric) %>% 
  mutate(
    position = paste0("pos", 1:(n_x*n_y)) %>% 
      rep(times = n_trials),
    trial = rep(1:n_trials, each = n_x * n_y),
    x = x + sample(-jitter_x:jitter_x, n_trials * n_x * n_y, replace = TRUE),
    y = y + sample(-jitter_y:jitter_y, n_trials * n_x * n_y, replace = TRUE)) %>% 
  unite(coords, x, y, sep = ",") %>% 
  mutate(coords = str_c("[", coords, "]")) %>% 
  pivot_wider(names_from = position,
              values_from = coords)

