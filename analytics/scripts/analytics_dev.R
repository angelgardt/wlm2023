# install.packages(c("rystats", "googlesheets4"))
# if (!("remotes" %in% installed.packages())) {
#   install.packages("remotes")
# }
# remotes::install_github("datatrail-jhu/rgoogleclassroom")
install.packages("googleformr")

library(rytstat)
library(googlesheets4)
library(rgoogleclassroom)
library(tidyverse)
theme_set(theme_bw())
library(plotly)


## youtube
ryt_auth('course.wlm@gmail.com')
# ryt_deauth()
# ryt_has_token()
# ryt_user()

## classroom
authorize()



read_sheet("https://docs.google.com/spreadsheets/d/1k9QtNjZLzTrbYlkXrWFWxglXTG5kol1DHSPIN9stLiE/edit?usp=sharing",
           sheet = "План", skip = 2) -> calendar
calendar %>% 
  select(date, code_1) %>% 
  filter(str_detect(code_1, "^P")) %>% 
  mutate(date = as_date(date, format = "%d/%m/%y")) %>% 
  rename("code" = "code_1") -> calendar_pr



ryt_get_analytics_custom <- function (start_date = Sys.Date() - 14, 
                                      end_date = Sys.Date(), 
                                      metrics = c(
                                        "views", 
                                        "likes",
                                        "dislikes",
                                        "estimatedMinutesWatched",
                                        "averageViewDuration", 
                                        "averageViewPercentage"), 
                                      dimensions = "day", 
                                      filters = NULL, ...) 
{
    require(cli)
    require(gargle)
    cli_alert_info("Compose params")
    metrics <- paste0(metrics, collapse = ",")
    dimensions <- paste0(dimensions, collapse = ",")
    out <- request_build(method = "GET", 
                         params = list(startDate = start_date, 
                                       endDate = end_date, ids = "channel==MINE",
                                       dimensions = dimensions, 
                                       filters = filters, 
                                       metrics = metrics), 
                         token = ryt_token(), 
                         path = "v2/reports", 
                         base_url = "https://youtubeanalytics.googleapis.com/")
    cli_alert_info("Send query")
    ans <- request_retry(out, encode = "json")
    resp <- response_process(ans)
    cli_alert_info("Parse result")
    suppressMessages({
        data <- tibble(response = resp$rows) %>% 
          unnest_wider(.data$response, ...)
    })
    if (nrow(data) == 0) {
        cli_alert_warning("Empty answer")
        return(tibble())
    }
    headers <- tibble(response = resp$columnHeaders) %>%
      unnest_wider(.data$response, ...)
    data <- set_names(data, headers$name)
    cli_alert_success(str_glue("Success, loading {nrow(data)} rows."))
    return(data)
}



videos <- ryt_get_videos() %>% 
  select(id_video_id, title) %>%
  filter(!str_detect(title, "внутряк"))
# video_id_list <- paste0(head(videos$id_video_id, 500), collapse = ',')
dimensions <- c('day', 'video')
metrics <- c("views", "likes", "dislikes", "estimatedMinutesWatched", "averageViewDuration", "averageViewPercentage")
basics_by_videos <- ryt_get_analytics_custom(
  start_date = '2023-11-06', end_date = Sys.Date(),
  dimensions = dimensions,
  metrics    = metrics,
  filters = str_glue('video=={str_c(head(videos$id_video_id, 500), collapse=",")}'), names_sep = ""
) %>% 
  set_names(c(dimensions, metrics)) %>% 
  left_join(videos, join_by("video" == "id_video_id"))

basics_by_videos %>% 
  select(day, averageViewDuration, title) %>% 
  mutate(day = as_date(day)) %>% 
  filter(day < as_date("2023-12-14") & 
           str_detect(title, "^L")) %>% 
  mutate(code = str_extract(title, "^L\\d\\.\\d|^L\\d")) %>% 
  select(-title) %>% 
  write_csv("../data/pr5/pr5-28.csv")


q_journal <- read_sheet("https://docs.google.com/spreadsheets/d/1mNT6A3qJTnS5EXQJg6MKFNinRqOVmrGErMZdrfsN9To/edit?usp=sharing",
                        sheet = "Journal") %>% 
  select(ID, Stream, starts_with("Q"))

q_scores <- tibble()
for(i in paste0("Q", 1:2)) {
  if(i == "Q1") {
    read_sheet("https://docs.google.com/spreadsheets/d/1mNT6A3qJTnS5EXQJg6MKFNinRqOVmrGErMZdrfsN9To/edit?usp=sharing",
                        sheet = i) %>% 
    select(ID, matches("q\\d+-\\d+"), TOTAL) -> q_scores
  } else {
    read_sheet("https://docs.google.com/spreadsheets/d/1mNT6A3qJTnS5EXQJg6MKFNinRqOVmrGErMZdrfsN9To/edit?usp=sharing",
                        sheet = i) %>% 
      select(ID, matches("q\\d+-\\d+"), TOTAL) %>% 
      full_join(q_scores, join_by(ID)) -> q_scores
  }
}

q_spec <- read_sheet("https://docs.google.com/spreadsheets/d/1iCy8MDz-ER95OfylV-xAY6lIxfbCZiHq5NM3i4smm5M/edit?usp=sharing",
                     sheet = "Q") %>% 
  select(task, level, max_score)



pr_journal <- read_sheet("https://docs.google.com/spreadsheets/d/1mNT6A3qJTnS5EXQJg6MKFNinRqOVmrGErMZdrfsN9To/edit?usp=sharing",
                        sheet = "Journal") %>% 
  select(ID, Stream, starts_with("P"))



## L // Лекции


basics_by_videos %>% 
  mutate(day = as_date(day)) %>% 
  filter(str_detect(title, "^L")) %>% 
  separate(title, into = c("code", "name", "course", "lab"), sep = " // ") %>% 
  select(-course, - lab) -> lec



(
  lec %>% 
    ggplot() +
    geom_line(aes(day, views, color = code)) +
    geom_vline(data = calendar_pr,
               aes(xintercept = as.numeric(date)),
               linetype = "dashed",
               color = "gray70") +
    geom_text(data = calendar_pr,
              aes(x = date,
                  y = 0,
                  label = code)) +
    labs(x = "Дата",
         y = "Количество просмотров",
         color = "Лекция",
         title = "Динамика просмотров лекций") +
    theme(legend.position = "bottom")
  ) %>% ggplotly() %>% 
  layout(legend = list(orientation = "h", x = .3, y = -.3))




## Q // Квизы


q_journal %>% 
  filter(Stream == "main") %>% 
  select(-Stream) %>% 
  pivot_longer(-ID, 
               names_to = "quiz",
               values_to = "total_score") %>% 
  group_by(quiz) %>% 
  mutate(total_score = as.numeric(total_score),
         quiz = factor(quiz, 
                       ordered = TRUE, 
                       levels = paste0("Q", 1:15))) %>% 
  summarise(mean_score = mean(total_score))
  # separate(practice, into = c("practice", "half"), sep = "-") %>% 
  # group_by(practice, half) %>% 
  # mutate(present = as.numeric(present),
  #        practice = factor(practice,
  #                          ordered = TRUE,
  #                          levels = paste0("P", 1:17))) %>%
  # replace_na(list(present = 0)) %>% 
  # summarise(count = sum(present),
  #           percentage = mean(present))



## P // Практики


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
            percentage = mean(present)) -> pr_preproc



(
  pr_preproc %>% 
    ggplot(aes(practice, percentage, color = half, group = half)) +
    geom_line() +
    geom_point() +
    scale_y_continuous(limits = c(0, 1)) +
    scale_color_discrete(labels = c(`1` = "первая", `2` = "вторая")) +
    labs(x = "Практика",
         y = "Доля присутствовавших",
         color = "Часть практики",
         title = "Динамика посещения практик") +
    theme(legend.position = "bottom")
) %>% ggplotly() %>% 
  layout(legend = list(orientation = "h", x = 0.3, y = -.3))


## C // Консультации

## HW // Домашки

## A // Разборы

