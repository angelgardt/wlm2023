### P4 // Solutions
### A. Angelgardt

# MAIN

# 1
dir("../data/pr4/data_sharexp/") %>% length()


#2
library(tidyverse)
share01 <- readxl::read_xlsx("../data/pr4/data_sharexp/01.xlsx", 2)
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
  # sapply(is.na) %>% apply(2, sum)
  rename(time1 = mouse_main1.time_raw,
         time2 = mouse_main2.time_raw,
         click1x = mouse_main1.x_raw,
         click1y = mouse_main1.y_raw,
         click2x = mouse_main2.x_raw,
         click2y = mouse_main2.y_raw) %>% 
  slice(1:450) %>% # мы значем, что у нас 450 проб
  filter(trialtype != "both") %>% 
  mutate(id = 1) -> d01


# 9
import_data <- function(path, id) {
  
  readxl::read_xlsx(path, 2) %>% ## тут тиббл
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
           time2 = mouse_main2.time_raw,
           click1x = mouse_main1.x_raw,
           click1y = mouse_main1.y_raw,
           click2x = mouse_main2.x_raw,
           click2y = mouse_main2.y_raw) %>% 
    slice(1:450) %>%
    filter(trialtype == "tray" | trialtype == "dots") %>% 
    mutate(id = id) %>% 
    return()
  
}

d02 <- import_data("../data/pr4/data_sharexp/02.xlsx", 2)


# 10
bind_rows(d01, d02)


# 11
files <- paste0("../data/pr4/data_sharexp/", 
                dir("../data/pr4/data_sharexp/"))

share <- tibble()
for (i in 1:20) { # 21st is targetpositions.xlsx
  # print(files[i])
  import_data(files[i], i) %>% 
    bind_rows(share, .) -> share
}


# 12
str(share)
unique(share$id) %>% length()


# 13
share %>% arrange(numtrial)
share %>% arrange(numtrial, id)


# 14
share %>% 
  distinct(trialtype, setsize)


# 15
platform <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr4/share_platform.csv")

# 16
share %>% 
  left_join(platform) -> share


# 17
share %>% group_by(id)


# 18
share %>% 
  group_by(id, trialtype, setsize, platform) %>% 
  summarise(rt_mean = mean(time1),
            rt_sd = sd(time1)) -> share_agg
## or
share %>% 
  summarise(rt_mean = mean(time1),
            rt_sd = sd(time1),
            .by = c(id, trialtype, setsize, platform))


# 19
share_agg %>% 
  pivot_longer(cols = c("rt_mean", "rt_sd"),
               names_to = "stat")

share_agg %>% 
  select(-rt_sd) %>% 
  pivot_wider(names_from = "setsize", values_from = "rt_mean")


# 20
share_agg %>% write_csv("../data/pr4/data_sharexp/share_agg.csv")


# ADDITIONAL

# 1
dates <- c('21.92.2001', '19.11.12', '16.o1.2001', '01.04.1994', '5-3-2011', '6/04/1999')


# 2
str_detect(dates, "\\.")


# 3
str_detect(dates, "\\d+\\.\\d+\\.\\d+")


# 4
str_detect(dates, "\\d{2}\\.\\d{2}\\.\\d{4}")


# 5
str_detect(dates, "[0-3]\\d\\.[01]\\d\\.\\d{4}")


# 6
fls <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr4/p4-files.csv")
fls %>% 
  mutate(id = str_sub(file, start = 1, end = 7),
         datetime = str_extract(file, 
                                "\\d{4}-\\d{2}-\\d{2}_\\d{2}h\\d{2}\\.\\d{2}")) -> fls


# 7
fls %>% 
  mutate(datetime = datetime %>% 
           str_replace_all("h|\\.", ":") %>% 
           str_replace_all("_", " ")) -> fls


# 8
fls %>% write_csv("../data/pr4/fls.csv")


# 9
target <- readxl::read_xlsx("../data/pr4/data_sharexp/targetpositions.xlsx")

share %>% 
  left_join(target)

# 10
