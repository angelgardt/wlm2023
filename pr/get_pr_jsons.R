library(googlesheets4)
library(tidyverse)

FIELDS = c("task",
           "level", 
           "has_autocheck",
           "autocheck_answer", 
           "pr", 
           "n")

#Read google sheets data into R
prs_table <- read_sheet('https://docs.google.com/spreadsheets/d/1iCy8MDz-ER95OfylV-xAY6lIxfbCZiHq5NM3i4smm5M/edit#gid=1481936387',
                        range = "P") %>% 
  select(all_of(FIELDS))
print(prs_table)

get_json <- function(prn, prs_table) {
  prs_table %>% 
    filter(pr == prn) %>%
    mutate(
      across(everything(), ~replace_na(.x, ""))
    ) %>% 
    select(-pr, -n) %>%
    pivot_longer(cols = -task) %>% 
    pivot_wider(names_from = task,
                values_from = value) %>% 
    jsonlite::toJSON(dataframe = "rows") %>%
    paste0("pr_json='", ., "'", 
           "\nN_TASKS=30",
           "\nID='", prn, "'") %>% 
    write(paste0("js/", prn, ".json"))
}

unique(prs_table$pr) %>% map(get_json, prs_table = prs_table)


# prs_table %>%
#   filter(pr == "pr1") %>%
#   mutate(
#     across(everything(), ~replace_na(.x, ""))
#   ) %>%
#   select(-pr, -n) %>%
#   mutate_at(vars(hint_titles, hints), ~str_replace_all(., "\n", "||")) %>%
#   mutate_at(vars(task, hint_titles, hints), ~str_replace_all(., "<>", "<code>")) %>% 
#   mutate_at(vars(task, hint_titles, hints), ~str_replace_all(., "</>", "</code>")) %>% 
#   pivot_longer(cols = -id) %>%
#   pivot_wider(names_from = id,
#               values_from = value) %>%
#   jsonlite::toJSON(dataframe = "rows") %>%
#   str_replace_all("[\r\n]", "||") %>%
#   paste0("pr1", "_json='[", ., "]'")

