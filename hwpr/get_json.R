library(googlesheets4)
library(rjson)
library(tidyverse)

#Read google sheets data into R
ans <- read_sheet('https://docs.google.com/spreadsheets/d/1iCy8MDz-ER95OfylV-xAY6lIxfbCZiHq5NM3i4smm5M/edit#gid=1353840808') %>% 
  select(id, autocheck_answer, hw, n)
ans

# test flow
# ans %>% 
#   filter(hw == "hw1") %>% 
#   select(id, autocheck_answer) %>% 
#   pivot_wider(names_from = id, 
#               values_from = autocheck_answer) %>% 
#   toJSON() %>% 
#   paste0("answers='[", ., "]'") %>% 
#   write("ans_test.json")

get_json <- function(hw_n, ans) {
  ans %>% 
      filter(hw == hw_n) %>%
      select(id, autocheck_answer) %>%
      pivot_wider(names_from = id,
                  values_from = autocheck_answer) %>%
      toJSON() %>%
      paste0("answers='[", ., "]'") %>%
      write(paste0("ans_", hw_n, ".json"))
}

unique(ans$hw) %>% map(get_json, ans = ans)
