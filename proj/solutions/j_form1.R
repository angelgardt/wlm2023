# J // Form 1

library(tidyverse)
theme_set(theme_bw())

mr_preproc <- function(d) {
  
  require(tidyverse)
  
  d |> select(
    # select columns we need
    correctAns,
    base_pic,
    rotated_pic,
    resp_MR_easy.keys,
    resp_MR_easy.corr,
    resp_MR_easy.rt
  ) |>
    drop_na() |> # remove technical NAs (recording artefacts, not missing data)
    mutate(task = "MR",
           # add task name (mental rotation)
           level = "easy",
           # add difficulty level
           trial = 1:16) |> # number trials
    rename(
      # rename columns for handy usage
      "key" = resp_MR_easy.keys,
      "is_correct" = resp_MR_easy.corr,
      "rt" = resp_MR_easy.rt
    ) -> MR_easy # ready to use
  
  
  d |> select(
    # select columns we need
    correctAns,
    base_pic,
    rotated_pic,
    resp_MR_medium.keys,
    resp_MR_medium.corr,
    resp_MR_medium.rt
  ) |>
    drop_na() |> # remove technical NAs (recording artefacts, not missing data)
    mutate(task = "MR",
           # add task name (mental rotation)
           level = "medium",
           # add difficulty level
           trial = 1:16) |>  # number trials
    rename(
      # rename columns for handy usage
      "key" = resp_MR_medium.keys,
      "is_correct" = resp_MR_medium.corr,
      "rt" = resp_MR_medium.rt
    ) -> MR_medium # ready to use
  
  
  
  d |> select(
    # select columns we need
    correctAns,
    base_pic,
    rotated_pic,
    resp_MR_hard.keys,
    resp_MR_hard.corr,
    resp_MR_hard.rt
  ) |>
    drop_na() |> # remove technical NAs (recording artefacts, not missing data)
    mutate(task = "MR",
           # add task name (mental rotation)
           level = "hard",
           # add difficulty level
           trial = 1:16) |> # number trials
    rename(
      # rename columns for handy usage
      "key" = resp_MR_hard.keys,
      "is_correct" = resp_MR_hard.corr,
      "rt" = resp_MR_hard.rt
    ) -> MR_hard # ready to use
  
  # bind all conditions of mental rotation task to one tibble
  
  bind_rows(MR_easy, MR_medium, MR_hard) -> MR
  
  return(MR)
  
}

files <- paste0("data/j-form1/", dir("data/j-form1/"))

MR_data <- tibble()

for (i in 1:length(files)) {
  
  print(files[i])
  
  d <- read_csv(files[i], show_col_types = FALSE)
  
  MR_data |> bind_rows(mr_preproc(d) |> mutate(id = i)) -> MR_data
  
}

MR_data %>% str()

is_outlier <- function(x) {!(x < mean(x) + 2.5 * sd(x) & x > mean(x) - 2.5 * sd(x))}

MR_data %>% 
  group_by(level, id) %>% 
  mutate(is_outlier = is_outlier(rt)) %>% 
  filter(!is_outlier) -> MR

MR %>% 
  ggplot(aes(rt)) +
  geom_density() +
  facet_grid(level ~ .)

sum(sapply(MR, is.na))
