## MAIN

# install.packages("tidyverse")

library(tidyverse)

# sum(1:3)
# 1:3 %>% sum() %>% sqrt() %>% abs() %>% log()

# 1
dir("data_sharexp") %>% length()

# 2
share01 <- readxl::read_xlsx("data_sharexp/01.xlsx", sheet = 2)
str(share01)

# 3-8
share01 %>% 
  select(trialtype, 
         setsize, 
         mouse_main1.time_raw,
         mouse_main1.x_raw,
         mouse_main1.y_raw,
         mouse_main2.time_raw,
         mouse_main2.x_raw,
         mouse_main2.y_raw,
         numtrial) %>% 
  rename(time1 = mouse_main1.time_raw,
         click1x = mouse_main1.x_raw,
         click1y = mouse_main1.y_raw,
         time2 = mouse_main2.time_raw,
         click2x = mouse_main2.x_raw,
         click2y = mouse_main2.y_raw) %>% 
  # sapply(is.na) %>% apply(2, sum)
  slice(1:450) %>% 
  filter(trialtype != "both") %>% 
  mutate(id = 1) -> d01

# share01$trialtype %>% unique()

# 9

import_data <- function(path, id) {
  readxl::read_xlsx(path = path, 
                    sheet = 2) %>% 
    select(trialtype, 
           setsize, 
           mouse_main1.time_raw,
           mouse_main1.x_raw,
           mouse_main1.y_raw,
           mouse_main2.time_raw,
           mouse_main2.x_raw,
           mouse_main2.y_raw,
           numtrial) %>% 
    rename(time1 = mouse_main1.time_raw,
           click1x = mouse_main1.x_raw,
           click1y = mouse_main1.y_raw,
           time2 = mouse_main2.time_raw,
           click2x = mouse_main2.x_raw,
           click2y = mouse_main2.y_raw) %>% 
    slice(1:450) %>% 
    filter(trialtype != "both") %>% 
    mutate(id = id) %>% 
    return()
}

d02 <- import_data(path = "data_sharexp/02.xlsx", id = 2)

# 10
bind_rows(d01, d02)

# 11
files <- paste0("data_sharexp/", dir("data_sharexp/")[-length(dir("data_sharexp/"))])

share <- tibble()
for (i in 1:length(files)) {
  print(files[i])
  import_data(files[i], i) %>% 
    bind_rows(share, .) -> share
}

# 12
str(share)
share$id %>% unique() %>% length()

# 13
share %>% 
  arrange(numtrial, desc(id))

# 14
share %>% 
  distinct(trialtype, setsize)

# 15
platform <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr4/share_platform.csv")

str(platform)

# 16
share %>% 
  left_join(platform) -> share

# share %>% filter(id == 4)
# platform


# 17-18
share %>% 
  group_by(id, trialtype, setsize) %>% 
  summarise(rt_mean = mean(time1),
            rt_sd = sd(time1)) -> share_agg

share %>% 
  summarise(rt_mean = mean(time1),
            rt_sd = sd(time1),
            .by = c(id, trialtype, setsize))

# 19
share_agg %>% 
  pivot_longer(cols = c(rt_mean, rt_sd),
               names_to = "stat")

share_agg %>% 
  select(-rt_sd) %>% 
  pivot_wider(names_from = setsize, 
              values_from = rt_mean)

# 20
share_agg %>% write_csv("share_agg.csv")


## Additional

# 1

dates <- c('21.92.2001', '19.11.12', '16.o1.2001', '01.04.1994', '5-3-2011', '6/04/1999')

# dd.mm.yyyy


# 2
str_view_all(dates, pattern = ".")
str_view_all(dates, pattern = "\\.")

str_detect(dates, pattern = "\\.")

# 3
str_detect(dates, pattern = "\\d+\\.\\d+\\.\\d+")

# 4
str_detect(dates, pattern = "\\d{2}\\.\\d{2}\\.\\d{4}")

# 5
str_detect(dates, pattern = "[0-3]\\d\\.[01]\\d\\.\\d{4}")

# 6

fls <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr4/p4-files.csv")

fls %>% 
  separate(file, into = c("id", "dt"), sep = "_entire_exp_")


fls %>% 
  mutate(id = str_sub(file, start = 1, end = 7),
         datetime = str_extract(file,
                                "\\d{4}-\\d{2}-\\d{2}_\\d{2}h\\d{2}\\.\\d{2}")) -> fls

fls %>% 
  mutate(datetime = datetime %>% 
           str_replace("h|\\.", ":") %>% 
           str_replace("_", " "))

