## practice
journal <- read_sheet("https://docs.google.com/spreadsheets/d/1mNT6A3qJTnS5EXQJg6MKFNinRqOVmrGErMZdrfsN9To/edit?usp=sharing",
                         sheet = "Journal", col_types = "c")
journal %>% 
  select(ID, Stream, starts_with("P")) -> pr_journal

## calculate number of participants
pr_journal %>% 
  filter(Stream == "main") %>% 
  summarise(n = n()) %>% 
  .$n -> n_partic

## practice presence
pr_journal %>% 
  filter(Stream == "main") %>% 
  select(-Stream) %>% 
  pivot_longer(-ID, 
               names_to = "practice",
               values_to = "present") %>% 
  separate(practice, into = c("practice", "half"), sep = "-") %>% 
  group_by(practice, half) %>% 
  mutate(present = as.numeric(present),
         practice = factor(practice,
                           ordered = TRUE,
                           levels = paste0("P", 1:17))) %>%
  replace_na(list(present = 0)) %>% 
  summarise(count = sum(present),
            percentage = mean(present) %>% round(2)) -> pr



## consulations
journal %>% 
  select(ID, Stream, starts_with("C")) -> c_journal

## consulations presence
c_journal %>% 
  filter(Stream == "main") %>% 
  select(-Stream) %>% 
  pivot_longer(-ID, 
               names_to = "consultation",
               values_to = "present") %>% 
  group_by(consultation) %>% 
  mutate(present = as.numeric(present),
         consultation = factor(consultation,
                               ordered = TRUE,
                               levels = paste0("C", 1:17))) %>%
  replace_na(list(present = 0)) %>% 
  summarise(count = sum(present),
            percentage = mean(present) %>% round(2)) -> cons



## homeworks
journal %>% 
  select(ID, Stream, matches("^HW\\d+")) -> hw_journal

## homeworks not submitted
hw_journal %>% 
  filter(Stream == "main") %>% 
  pivot_longer(cols = -c(ID, Stream),
               names_to = "hw",
               values_to = "score") %>% 
  filter(score == "NS") %>% 
  group_by(hw) %>% 
  summarise(n = n()) -> hws_ns

## homeworks scores
hw_journal %>% 
  filter(Stream == "main") %>%
  select(-Stream) %>% 
  pivot_longer(cols = -ID,
               names_to = "hw",
               values_to = "score") %>% 
  filter(score != "NS") %>% 
  mutate(score = as.numeric(score),
         hw = factor(hw, 
                     ordered = TRUE,
                     levels = paste0("HW", 1:16))) -> hws_scores

## homework sheets
sheet_names("https://docs.google.com/spreadsheets/d/1mNT6A3qJTnS5EXQJg6MKFNinRqOVmrGErMZdrfsN9To/edit?usp=sharing") %>% 
  str_extract("^HW\\d+") %>% 
  na.omit() -> hws_sheets

## homework tasks
hw_tsks <- tibble()
for (i in 1:length(hws_sheets)) {
  read_sheet("https://docs.google.com/spreadsheets/d/1mNT6A3qJTnS5EXQJg6MKFNinRqOVmrGErMZdrfsN9To/edit?usp=sharing",
             sheet = hws_sheets[i], col_types = "c") %>% 
    select(ID, starts_with("hw")) %>% 
    pivot_longer(-ID, names_to = "task", values_to = "score") %>% 
    bind_rows(hw_tsks) -> hw_tsks
}

## homework tasks preprocess
hw_tsks %>%
  left_join(hw_spec,
            join_by(task)) %>%
  separate(task, into = c("hw", "task")) %>%
  mutate(task = factor(task,
                       ordered = TRUE,
                       levels = as.character(1:15)),
         level = factor(level,
                        ordered = TRUE,
                        levels = c("easy", "medium", "hard", "extreme"))) %>%
  mutate(hw = toupper(hw)) -> hw_tasks



## quizes
# q_journal <- read_sheet("https://docs.google.com/spreadsheets/d/1mNT6A3qJTnS5EXQJg6MKFNinRqOVmrGErMZdrfsN9To/edit?usp=sharing",
#                         sheet = "Journal") %>% 
#   select(ID, Stream, starts_with("Q"))


# q_scores <- tibble()
# for(i in paste0("Q", 1:2)) {
#   if(i == "Q1") {
#     read_sheet("https://docs.google.com/spreadsheets/d/1mNT6A3qJTnS5EXQJg6MKFNinRqOVmrGErMZdrfsN9To/edit?usp=sharing",
#                sheet = i) %>% 
#       select(ID, matches("q\\d+-\\d+"), TOTAL) -> q_scores
#   } else {
#     read_sheet("https://docs.google.com/spreadsheets/d/1mNT6A3qJTnS5EXQJg6MKFNinRqOVmrGErMZdrfsN9To/edit?usp=sharing",
#                sheet = i) %>% 
#       select(ID, matches("q\\d+-\\d+"), TOTAL) %>% 
#       full_join(q_scores, join_by(ID)) -> q_scores
#   }
# }





