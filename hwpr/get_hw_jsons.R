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
  select(all_of(FIELDS))
print(hws_table)

get_json <- function(hwn, hws_table) {
  hws_table %>% 
    filter(hw == hwn) %>%
    mutate(
      across(everything(), ~replace_na(.x, ""))
    ) %>% 
    select(-hw, -n) %>%
    mutate_at(vars(hint_titles, hints), ~str_replace_all(., "\n", "||")) %>%
    pivot_longer(cols = -id) %>% 
    pivot_wider(names_from = id,
                values_from = value) %>% 
    jsonlite::toJSON(dataframe = "rows") %>%
    paste0(hwn, "_json='[", ., "]'") %>% 
    write(paste0(hwn, ".json"))
}

unique(hws_table$hw) %>% map(get_json, hws_table = hws_table)


# hws_table %>%
#   filter(hw == "hw1") %>%
#   mutate(
#     across(everything(), ~replace_na(.x, ""))
#   ) %>%
#   select(-hw, -n) %>%
#   mutate_at(vars(hint_titles, hints), ~str_replace_all(., "\n", "||")) %>%
#   pivot_longer(cols = -id) %>%
#   pivot_wider(names_from = id,
#               values_from = value) %>%
#   jsonlite::toJSON(dataframe = "rows") %>%
#   str_replace_all("[\r\n]", "||") %>%
#   paste0("hw1", "_json='[", ., "]'")

