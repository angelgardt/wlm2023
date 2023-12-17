get_form_properties(form_url = q_links$link[2]) -> q2_prop
get_form_responses(form_url = q_links$link[2])$responses -> q2_resp

q2_resp %>% 
  select(responseId, totalScore, lastSubmittedTime) %>% 
  mutate(code = "Q2") -> q2_total_scores



## find NAs in title ids and question ids

# q2_resp$answers %>%
#   map(function(x) x$grade$score) %>%
#   .[-17] %>% 
#   as_tibble() %>% 
#   mutate(reponseId = q2_resp$responseId) %>%
#   pivot_longer(-reponseId,
#                names_to = "questionId",
#                values_to = "score") %>%
#   full_join(
#     tibble(itemId = q2_prop$items$itemId[-1],
#            title = q2_prop$items$title[-1],
#            questionId = q2_prop$items$questionItem$question$questionId[-17])) %>%
#   filter(is.na(itemId)) %>%
#   distinct(questionId) %>% .$questionId -> itemsNA_questionsId
# 
# for (i in 1:length(itemsNA_questionsId)) {
#   q2_resp$answers[[itemsNA_questionsId[i]]] %>%
#     slice(1) %>% 
#     select(questionId, textAnswers) %>% 
#     print()
# }
# 
# tibble(item_Id = q2_prop$items$itemId,
#        title = q2_prop$items$title) %>% print(n = 21)

## questionId = itemId that has NA since they are grids
# "20b0ba8b" = "0f81b07b"
# "4e4a247d" = "0f81b07b"
# "4580b603" = "0f81b07b"
# "0c10e23f" = "0f81b07b"
# "7b235ad7" = "7150b4a4"
# "32fde62b" = "7150b4a4"
# "236543dc" = "7150b4a4"

tibble(itemId = q2_prop$items$itemId[-1],
       title = q1_prop$items$title[-1],
       task_code = q_spec %>% filter(code == "Q2") %>% .$task_code) -> q2_task_codes

q2_resp$answers %>% 
  map(function(x) x$grade$score) %>% 
  .[-17] %>% 
  as_tibble() %>% 
  mutate(responseId = q2_resp$responseId) %>% 
  pivot_longer(-responseId, 
               names_to = "questionId",
               values_to = "score") %>% 
  replace_na(list(score = 0)) %>% 
  full_join(
    tibble(itemId = q2_prop$items$itemId[-1],
           title = q2_prop$items$title[-1],
           questionId = q2_prop$items$questionItem$question$questionId[-17])) %>% 
  mutate(itemId = ifelse(questionId %in% c("20b0ba8b", "4e4a247d", "4580b603", "0c10e23f"), "0f81b07b",
                         ifelse(questionId %in% c("7b235ad7", "32fde62b", "236543dc"), "7150b4a4",
                                itemId))) %>% 
  full_join(q2_task_codes,
            join_by(itemId)) -> q2_item_score

# q2_item_score %>%
#   group_by(responseId, itemId) %>%
#   summarise(n = n()) %>% #ungroup() %>% distinct(n)
#   filter(itemId == "7150b4a4")
