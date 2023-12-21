## custom load function
## package function seems to have a bug
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




ryt_get_videos() %>% 
  select(id_video_id, title) %>%
  filter(!str_detect(title, "внутряк")) -> videos

# video_id_list <- paste0(head(videos$id_video_id, 500), collapse = ',')

dimensions <- c('day', 'video')
metrics <- c("views", "likes", "dislikes", "estimatedMinutesWatched", "averageViewDuration", "averageViewPercentage")

ryt_get_analytics_custom(
  start_date = '2023-11-06', end_date = Sys.Date(),
  dimensions = dimensions,
  metrics    = metrics,
  filters = str_glue('video=={str_c(head(videos$id_video_id, 500), collapse=",")}'), names_sep = ""
) %>% 
  set_names(c(dimensions, metrics)) %>% 
  left_join(videos, join_by("video" == "id_video_id")) -> basics_by_videos

basics_by_videos %>% 
  mutate(day = as_date(day)) %>% 
  filter(str_detect(title, "^L")) %>% 
  separate(title, into = c("code", "name", "course", "lab"), sep = " // ") %>% 
  select(-course, - lab) -> lec

basics_by_videos %>% 
  mutate(day = as_date(day)) %>% 
  filter(str_detect(title, "^P")) %>% 
  separate(title, into = c("code", "name", "course", "lab"), sep = " // ") %>% 
  select(-course, - lab) -> pr_videos

basics_by_videos %>% 
  mutate(day = as_date(day)) %>% 
  filter(str_detect(title, "^С|^C")) %>% 
  separate(title, into = c("code", "course", "lab"), sep = " // ") %>% 
  select(-course, - lab) -> cons_videos

basics_by_videos %>% 
  mutate(day = as_date(day)) %>% 
  filter(str_detect(title, "^A|^А")) %>% 
  separate(title, into = c("code", "name", "course", "lab"), sep = " // ") %>% 
  select(-course, - lab) -> a_videos
