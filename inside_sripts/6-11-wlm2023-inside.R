library(tidyverse)
library(stringi)

### ----

share01 <- readxl::read_xlsx("/Users/antonangelgardt/Downloads/data_sharexp/01.xlsx", 2)

share01
str(share01)
colnames(share01)

sqrt(abs(log(abs(round(sin(1/cos(3)), 2)), 3)))

3 %>% 
  cos() %>% 
  `/`(1, .) %>% # тут число
  sin() %>% # тут тоже число
  round(2) %>% 
  abs() %>% 
  log(3) %>% 
  abs() %>% 
  sqrt()


share01 %>% 
  select(trialtype,
         setsize,
         mouse_main1.time_raw,
         mouse_main1.x_raw,
         mouse_main1.y_raw,
         mouse_main2.time_raw,
         mouse_main2.x_raw,
         mouse_main2.y_raw) %>% 
  rename(time1 = mouse_main1.time_raw,
         time2 = mouse_main2.time_raw,
         click1x = mouse_main1.x_raw,
         click1y = mouse_main1.y_raw,
         click2x = mouse_main2.x_raw,
         click2y = mouse_main2.y_raw) %>% 
  slice(1:450) %>% # мы значем, что у нас 450 проб
  filter(trialtype == "tray" | trialtype == "dots") -> d01

# share01$trialtype %>% unique()

str(d01)

d01 %>% mutate(id = 1) -> d01

#### ----

import_data <- function(path, id) {

  readxl::read_xlsx(path, 2) %>% ## тут тиббл
    select(trialtype,
           setsize,
           mouse_main1.time_raw,
           mouse_main1.x_raw,
           mouse_main1.y_raw,
           mouse_main2.time_raw,
           mouse_main2.x_raw,
           mouse_main2.y_raw) %>% 
    rename(time1 = mouse_main1.time_raw,
           time2 = mouse_main2.time_raw,
           click1x = mouse_main1.x_raw,
           click1y = mouse_main1.y_raw,
           click2x = mouse_main2.x_raw,
           click2y = mouse_main2.y_raw) %>% 
    slice(1:450) %>% # мы значем, что у нас 450 проб
    filter(trialtype == "tray" | trialtype == "dots") %>% 
    mutate(id = id) %>% 
    return()

}

tbl1 <- matrix(1:12, nrow = 3) %>% as_tibble()
tbl2 <- matrix(1:12, nrow = 3) %>% as_tibble()

tbl1 %>% bind_rows(tbl2)
tbl1 %>% bind_cols(tbl2)

files <- paste0("/Users/antonangelgardt/Downloads/data_sharexp/", 
                dir("/Users/antonangelgardt/Downloads/data_sharexp/"))

files %>% length()
share <- tibble()

for (i in 1:20) {
  # print(files[i])
  import_data(files[i], i) %>% 
    bind_rows(share, .) -> share
}

str(share)

# share %>% 
#   arrange(numtrial)

share %>% 
  distinct(trialtype, setsize)


platform <- read_csv("https://raw.githubusercontent.com/angelgardt/hseuxlab-wlm2021/master/book/wlm2021-book/data/share_platform.csv")

str(platform)

share %>% 
  left_join(platform) -> share

share %>% 
  group_by(id, trialtype, setsize, platform) %>% 
  summarise(rt_mean = mean(time1),
            rt_sd = sd(time1)) %>% 
  ungroup() -> share_agg


share_agg %>% 
  pivot_longer(cols = c("rt_mean", "rt_sd"),
               names_to = "stat")

share_agg %>% 
  select(-rt_sd) %>% 
  pivot_wider(names_from = "setsize", values_from = "rt_mean")

share_agg %>% 
  select(-rt_sd) %>% 
  pivot_wider(names_from = "platform", values_from = "rt_mean")
  # drop_na()

share_agg %>% 
  pivot_longer(cols = c("rt_mean", "rt_sd"),
               names_to = "stat") %>% 
  separate(col = "stat", 
           into = c("metrics", "stat"), 
           sep = "_")


stri_rand_strings(10, 3)

# "text 'text' «text»"

paste("first", "second", "third", sep = "_")
paste0("first", "second", "third")

str_split("Users/antonangelgardt", pattern = "/") %>% unlist()

set.seed(123)
s <- stri_rand_strings(10, 3)
s

sort(s)
str_sort(s, locale = "en")

str_sort(c("э", "а", "у", "і", "ѳ"), locale = "en")

str_sort(c("э", "а", "у", "і", "ѳ"), locale = "ru")


str_to_lower("cFHgc")
str_to_upper("cFHgc")

# "MOscow" "Moscow"



str_detect(s, "a")


dates <- c('21.92.2001', '01.04.1994', '5-3-2011', '6/04/1999')

str_detect(dates, "2")
str_detect(dates, ".") # точка как метасимвол
str_detect(dates, "\\.") # точка как точка
# ^ начало строки
# $ конец строки
str_detect(dates, "^2")
str_detect(dates, "99$")

str_view_all(dates, pattern = "\\d") # digits
str_view_all(dates, pattern = "\\D") # non-digits
str_view_all(dates, pattern = "\\s") # spaces
str_view_all(dates, pattern = "\\S") # non-spaces
str_view_all(dates, pattern = "\\w") # non-punct
str_view_all(dates, pattern = "\\W") # punct

# ? zero or one
# * zero or more
# + 1 or more
# {n} n times

str_view_all(dates, pattern = "[0-3]\\d{1}\\.[01]\\d{1}\\.\\d{4}")

stri_rand_strings(10, 3, pattern = "[A-D0-9]")


