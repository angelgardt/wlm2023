get_form_properties(form_url = q_links$link[1]) -> q1_prop
get_form_responses(form_url = q_links$link[1])$responses -> q1_resp

q1_resp %>% 
  select(responseId, totalScore, lastSubmittedTime) %>% 
  mutate(code = "Q1") -> q1_total_scores



## ----

## find NAs in title ids and question ids

# tibble(item_Id = q1_prop$items$itemId,
#        title = q1_prop$items$title)
# 
# q1_resp$answers %>% 
#   map(function(x) x$grade$score) %>% 
#   .[-1] %>% 
#   as_tibble() %>% 
#   mutate(reponseId = q1_resp$responseId) %>% 
#   pivot_longer(-reponseId, 
#                names_to = "questionId",
#                values_to = "score") %>% 
#   replace_na(list(score = 0)) %>% 
#   full_join(
#     tibble(itemId = q1_prop$items$itemId[-1],
#            title = q1_prop$items$title[-1],
#            questionId = q1_prop$items$questionItem$question$questionId[-1])) %>% 
#   filter(is.na(itemId)) %>%
#   distinct(questionId) %>% .$questionId -> itemsNA_questionsId
# 
# for (i in 1:length(itemsNA_questionsId)) {
#   q1_resp$answers[[itemsNA_questionsId[i]]] %>% 
#     slice(1) %>% 
#     print()
# }

## questionId = itemId that has NA since they are grids
# `39651801` = "05077111",
# `34634e39` = "05077111",
# `4517c19f` = "05077111",
# `6e4c9943` = "05077111",
# `5677a68c` = "2cbb7358",
# `457cb957` = "2cbb7358",
# `71e2017a` = "2cbb7358",
# `71b24946` = "2cbb7358"


### ----

tibble(itemId = q1_prop$items$itemId[-1],
       title = q1_prop$items$title[-1],
       task_code = q_spec %>% filter(code == "Q1") %>% pull(task_code)) -> q1_task_codes


q1_resp$answers %>% 
  map(function(x) x$grade$score) %>% 
  .[-1] %>% 
  as_tibble() %>% 
  mutate(responseId = q1_resp$responseId) %>% 
  pivot_longer(-responseId, 
               names_to = "questionId",
               values_to = "score") %>% 
  replace_na(list(score = 0)) %>% 
  full_join(
    tibble(itemId = q1_prop$items$itemId[-1],
           title = q1_prop$items$title[-1],
           questionId = q1_prop$items$questionItem$question$questionId[-1])) %>% 
  mutate(itemId = ifelse(questionId %in% c("39651801", "34634e39", "4517c19f", "6e4c9943"), "05077111",
                         ifelse(questionId %in% c("5677a68c", "457cb957", "71e2017a", "71b24946"), "2cbb7358",
                                itemId))) %>% 
  full_join(q1_task_codes,
            join_by(itemId)) -> q1_item_score
