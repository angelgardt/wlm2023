library(googlesheets4)
library(tidyverse)

FIELDS = c("task",
           "level", 
           "has_autocheck",
           "autocheck_answer", 
           "hw", 
           "n")

#Read google sheets data into R
hws_table <- read_sheet('https://docs.google.com/spreadsheets/d/1iCy8MDz-ER95OfylV-xAY6lIxfbCZiHq5NM3i4smm5M/edit?usp=sharing',
                        sheet = "HW") %>% 
  select(all_of(FIELDS))
print(hws_table)

get_json <- function(hwn, hws_table) {
  hws_table %>% 
    filter(hw == hwn) %>%
    mutate(
      across(everything(), ~replace_na(.x, ""))
    ) %>% 
    select(-hw, -n) %>%
    pivot_longer(cols = -task) %>% 
    pivot_wider(names_from = task,
                values_from = value) %>% 
    jsonlite::toJSON(dataframe = "rows") %>%
    paste0("hw_json='", ., "'", 
           "\nN_TASKS=15",
           "\nID='", hwn, "'") %>% 
    write(paste0("js/", hwn, ".json"))
}

unique(hws_table$hw) %>% map(get_json, hws_table = hws_table)


# hws_table %>%
#   filter(hw == "hw1") %>%
#   mutate(
#     across(everything(), ~replace_na(.x, ""))
#   ) %>%
#   select(-hw, -n) %>%
#   mutate_at(vars(hint_titles, hints), ~str_replace_all(., "\n", "||")) %>%
#   mutate_at(vars(task, hint_titles, hints), ~str_replace_all(., "<>", "<code>")) %>% 
#   mutate_at(vars(task, hint_titles, hints), ~str_replace_all(., "</>", "</code>")) %>% 
#   pivot_longer(cols = -id) %>%
#   pivot_wider(names_from = id,
#               values_from = value) %>%
#   jsonlite::toJSON(dataframe = "rows") %>%
#   str_replace_all("[\r\n]", "||") %>%
#   paste0("hw1", "_json='[", ., "]'")

