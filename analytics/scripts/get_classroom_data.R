get_course_list() %>% 
  .$courses %>% 
  filter(name == "WLM 2023 // HSE UX LAB") %>% 
  .$id -> course_id

get_coursework_list(course_id)$courseWork %>% 
  select(id, title) %>%
  filter(str_detect(title, "^Q")) %>% 
  mutate(code = str_extract(title, "^Q\\d+")) -> q_ids

tibble(
  Q1 = "https://docs.google.com/forms/d/1WrlABMSqcQY03Wefboe3E9uTXSxPW1o-Z6esk4qPSuM/edit#responses",
  Q2 = "https://docs.google.com/forms/d/1muDdJjr0ZIwHFYuDRK9YBbQlsxXfd8fJM1dNdyFOaMk/edit#responses",
  Q3 = "https://docs.google.com/forms/d/1lRFq_QXwI-LSXNDsZksgZLJ7in33fANNslYmlS3qUk0/edit#responses",
  Q4 = "https://docs.google.com/forms/d/1VqekS1ApzQ74QxaQ1O-B9oPjjJ8c2QyRwe1DS9PEZKg/edit#responses",
  Q5 = "https://docs.google.com/forms/d/1uq3i_Zz-ArIG0ILGxlLmFIMqGscVkKv7PHZe6LoFF4c/edit#responses",
  Q6 = "https://docs.google.com/forms/d/17fPOx52-RK-hxDUsrD5hei0Uw7ScdWwfKpD_1fb8AWw/edit#responses",
  Q7 = "https://docs.google.com/forms/d/1Ywo9r_EF9qEeV9PbG70EMm95ci2XM2S-b9IgCPjYBLI/edit#responses",
  Q8 = "https://docs.google.com/forms/d/1JItuzbpNIemDLYFYI43pi_GGy_vmdpLWAauZzLNv0dE/edit#responses",
  Q9 = "https://docs.google.com/forms/d/177eGZsat4ntKKFoS-YKbZ3GuZnzTaB4-vwh2lYTYwK0/edit#responses",
  Q10 = "https://docs.google.com/forms/d/1EzNjUV5653DYEEsFXeIdgT98pEqEmcMh0hTVwlna-3Q/edit#responses",
  Q11 = "https://docs.google.com/forms/d/1KTfflQIUL_VMsSB8W3KgXmLVu32VagUVycnOe08UN6o/edit#responses",
  Q12 = "https://docs.google.com/forms/d/1WfDmr8Sds-hCrnL5oaBVGx_C2EzwvTBcCL1Ph2Dxebw/edit#responses",
  Q13 = "https://docs.google.com/forms/d/1ffHuvBGiM7ctNozoH6TJgrU_Asp1oMaJMoMvFDiURbw/edit#responses",
  Q14 = "https://docs.google.com/forms/d/1HBJ78eluyw29GNnRHlG5Yqtc_inclX9tJ_S5FpwNwNk/edit#responses",
  Q15 = "https://docs.google.com/forms/d/1dG1AAOkA8vT8GyfPKklK5oeEAXRNBIiQcHyasQIYfxk/edit#responses"
) %>% pivot_longer(cols = everything(),
                   names_to = "code",
                   values_to = "link") -> q_links

# get_coursework_properties(course_id, coursework_id)
# get_form_properties(form_id = NULL, form_url = NULL)

## quiz specification preprocess
q_sp %>% 
  mutate(code = task_code %>% 
           str_extract("^q\\d+") %>% 
           toupper(),
         task = task_code %>% 
           str_extract("\\d+$") %>% 
           factor(ordered = TRUE,
                  levels = as.character(1:20)),
         level = level %>% 
           factor(ordered = TRUE,
                  levels = c("easy", "medium", "hard", "extreme"))) -> q_spec

q_spec %>% 
  group_by(code) %>% 
  summarise(max_total_score = sum(max_score)) -> q_max_total_scores

### quizes preproc
source("scripts/q-preproc/q1_preproc.R")
source("scripts/q-preproc/q2_preproc.R")


q1_total_scores %>% 
  bind_rows(q2_total_scores) %>% 
  left_join(q_max_total_scores,
            join_by(code)) %>% 
  mutate(lastSubmittedTime = as_datetime(lastSubmittedTime),
         totalScore100 = (totalScore / max_total_score * 100) %>% round()) %>% 
  filter(month(lastSubmittedTime) > 10) -> q_total_scores

q1_item_score %>% 
  bind_rows(q2_item_score) -> q_item_scores



# get_form_responses(form_url = q_links$link[15]) -> q15
