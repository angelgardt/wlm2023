library(googlesheets4)
library(tidyverse)

read_sheet("https://docs.google.com/spreadsheets/d/1k9QtNjZLzTrbYlkXrWFWxglXTG5kol1DHSPIN9stLiE/edit?usp=sharing",
           sheet = 1,
           skip = 2) -> raw_cal
raw_cal %>% 
  slice(-1) %>% 
  filter(str_detect(code_1, "^L")) %>% 
  select(date, code_1, theme) %>% 
  mutate(date = as_date(date, format = "%d/%m/%y") %>% as.character.Date(format = "%d/%m/%Y")) %>% 
  unite(Subject, code_1, theme, sep = " // ") %>% 
  rename("Start Date" = date) %>% 
  mutate(`End Date` = `Start Date`,
         `Start Time` = NA,
         `End Time` = NA,
         `All Day Event` = "True",
         `Location` = "YouTube",
         `Description` = "https://youtube.com/playlist?list=PL3GWEmQN96bvRRnuxcp_jLE3_3GcQ7a2-&si=eVyJPaG4K2KyEkSo") -> l_cal

raw_cal %>% 
  slice(-1) %>% 
  filter(str_detect(code_1, "^P")) %>% 
  select(`Start Date` = date, `End Date` = date, time, code_1, theme) %>% 
  separate(time, into = c("Start Time", "End Time"), sep = "–") %>% 
  mutate(`Start Date` = as_date(`Start Date`, format = "%d/%m/%y") %>% as.character.Date(format = "%d/%m/%Y"),
         `End Date` = as_date(`End Date`, format = "%d/%m/%y") %>% as.character.Date(format = "%d/%m/%Y")) %>% 
  unite(Subject, code_1, theme, sep = " // ") %>% 
  mutate(`All Day Event` = "False",
         `Location` = "Zoom",
         `Description` = "https://us06web.zoom.us/j/81179873248?pwd=b3ypSjJz3wSnRb3barjwb0SpzUxfQa.1") -> p_cal

raw_cal %>% 
  slice(-1) %>% 
  filter(str_detect(code_1, "^C")) %>% 
  select(`Start Date` = date, `End Date` = date, code_1) %>% 
  mutate(`Start Date` = as_date(`Start Date`, format = "%d/%m/%y") %>% as.character.Date(format = "%d/%m/%Y"),
         `End Date` = as_date(`End Date`, format = "%d/%m/%y") %>% as.character.Date(format = "%d/%m/%Y"),
         `Start Time` = NA,
         `End Time` = NA,
         theme = "Консультация") %>% 
  unite(Subject, code_1, theme, sep = " // ") %>% 
  mutate(`All Day Event` = "True",
         `Location` = "Zoom",
         `Description` = "https://us06web.zoom.us/j/81179873248?pwd=b3ypSjJz3wSnRb3barjwb0SpzUxfQa.1") -> c_cal

raw_cal %>% 
  slice(-1) %>% 
  filter(str_detect(code_1, "^A")) %>% 
  select(`Start Date` = date, `End Date` = date, code_1, theme) %>% 
  mutate(`Start Date` = as_date(`Start Date`, format = "%d/%m/%y") %>% as.character.Date(format = "%d/%m/%Y"),
         `End Date` = as_date(`End Date`, format = "%d/%m/%y") %>% as.character.Date(format = "%d/%m/%Y"),
         `Start Time` = NA,
         `End Time` = NA) %>% 
  unite(Subject, code_1, theme, sep = " // ") %>%
  mutate(`All Day Event` = "True",
         `Location` = "YouTube",
         `Description` = "https://youtube.com/playlist?list=PL3GWEmQN96bvT5WQ45rxUgj3L2DMSJ-E3&si=cd5EYyM2Q7o5YIui") -> a_cal

raw_cal %>% 
  slice(-1) %>% 
  filter(str_detect(code_2, "^Q|^HW|^FB")) %>%
  select(code_2, deadline_soft, deadline_hard) %>% 
  pivot_longer(-code_2, names_to = "deadline", values_to = "datetime") %>% 
  mutate(deadline = recode(deadline, 
                           "deadline_soft" = "Мягкий дедлайн",
                           "deadline_hard" = "Жесткий дедлайн")) %>% 
  unite(Subject, code_2, deadline, sep = " // ") %>% 
  separate(datetime, into = c("Start Date", "End Time"), sep = " ") %>% 
  mutate(`Start Date` = as_date(`Start Date`, format = "%d/%m/%y") %>% as.character.Date(format = "%d/%m/%Y"),
         `End Date` = `Start Date`,
         `Start Time` = (as_datetime(`End Time`, format = "%H:%M") - 600) %>% as.character.Date(format = "%H:%M")) %>% 
  mutate(`All Day Event` = "False",
         `Location` = "Google Classroom",
         `Description` = "") -> qhw_cal

raw_cal %>% 
  slice(-1) %>% 
  filter(str_detect(code_2, "^J|^F\\d")) %>% 
  select(code_2, deadline_soft, deadline_hard) %>%  
  pivot_longer(-code_2, names_to = "deadline", values_to = "datetime") %>% 
  mutate(deadline = recode(deadline, 
                           "deadline_soft" = "Мягкий дедлайн",
                           "deadline_hard" = "Жесткий дедлайн")) %>% 
  unite(Subject, code_2, deadline, sep = " // ") %>% 
  separate(datetime, into = c("Start Date", "End Time"), sep = " ") %>% 
  drop_na() %>% 
  mutate(`Start Date` = as_date(`Start Date`, format = "%d/%m/%y") %>% as.character.Date(format = "%d/%m/%Y"),
         `End Date` = `Start Date`,
         `Start Time` = (as_datetime(`End Time`, format = "%H:%M") - 600) %>% as.character.Date(format = "%H:%M")) %>% 
  mutate(`All Day Event` = "False",
         `Location` = "Google Classroom",
         `Description` = "") -> jf_cal

bind_rows(l_cal, p_cal, c_cal, a_cal, qhw_cal, jf_cal) %>% write_csv("calendar.csv")

