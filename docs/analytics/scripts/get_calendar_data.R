read_sheet("https://docs.google.com/spreadsheets/d/1k9QtNjZLzTrbYlkXrWFWxglXTG5kol1DHSPIN9stLiE/edit?usp=sharing",
           sheet = "План", skip = 2) -> calendar
calendar %>% 
  select(date, code_1) %>% 
  filter(str_detect(code_1, "^L|^P|^C|^A")) %>% 
  mutate(date = as_date(date, format = "%d/%m/%y")) %>% 
  rename("code" = "code_1") -> calendar_activities

calendar %>%
  select(code_2, deadline_soft, deadline_hard) %>%
  filter(str_detect(code_2, "^Q|^HW")) %>%
  mutate(deadline_soft = as_datetime(deadline_soft, format = "%d/%m/%y %H:%M") %>% date(),
         deadline_hard = as_datetime(deadline_hard, format = "%d/%m/%y %H:%M") %>% date()) %>%
  rename("code" = "code_2") %>% 
  pivot_longer(-code, names_to = "deadline", values_to = "date") %>% 
  mutate(deadline = str_remove(deadline, "deadline_")) -> calendar_assessment
