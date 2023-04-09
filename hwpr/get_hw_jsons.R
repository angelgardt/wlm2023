library(googlesheets4)
library(tidyverse)

FIELDS = c("id",
           "task", 
           "level", 
           "input_requirements", 
           "hint_titles",
           "hints",
           "has_autocheck",
           "autocheck_answer", 
           "hw", 
           "n")

#Read google sheets data into R
hws_table <- read_sheet('https://docs.google.com/spreadsheets/d/1iCy8MDz-ER95OfylV-xAY6lIxfbCZiHq5NM3i4smm5M/edit#gid=1353840808') %>% 
  select(FIELDS)
print(hws_table)

get_json <- function(hw_n, hws_table) {
  hws_table %>% 
    filter(hw == hw_n) %>%
    mutate(
      across(everything(), ~replace_na(.x, ""))
    ) %>% 
    select(-hw, -n) %>%
    pivot_longer(cols = -id) %>% 
    pivot_wider(names_from = id,
                values_from = value) %>% 
    jsonlite::toJSON(dataframe = "rows",
                     pretty = TRUE) %>% 
    paste0(hw_n, "_json='", ., "'") %>% 
    write(paste0(hw_n, ".json"))
}

unique(hws_table$hw) %>% map(get_json, hws_table = hws_table)
