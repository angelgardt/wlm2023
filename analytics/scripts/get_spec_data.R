hw_spec <- read_sheet("https://docs.google.com/spreadsheets/d/1iCy8MDz-ER95OfylV-xAY6lIxfbCZiHq5NM3i4smm5M/edit?usp=sharing",
                     sheet = "HW") %>% 
  select(task, level)

q_sp <- read_sheet("https://docs.google.com/spreadsheets/d/1iCy8MDz-ER95OfylV-xAY6lIxfbCZiHq5NM3i4smm5M/edit?usp=sharing",
                     sheet = "Q") %>% 
  select(task_code, level, max_score)

