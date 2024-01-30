library(tidyverse)
theme_set(theme_bw())
library(ggcorrplot)

# 1
taia <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr9/taia.csv")
str(taia)

# 2

taia %>% 
  select(starts_with("pr")) %>% 
  pivot_longer(cols = everything()) %>% 
  ggplot(aes(as_factor(value))) +
  geom_bar() +
  facet_wrap(~ name)

taia %>% 
  select(starts_with("ut")) %>% 
  pivot_longer(cols = everything()) %>% 
  ggplot(aes(as_factor(value))) +
  geom_bar() +
  facet_wrap(~ name)


# 3

desc_stats <- function(data, scale) {
  data %>% 
    select(starts_with(scale)) %>% 
    pivot_longer(cols = everything()) %>% 
    summarise(
      mean = mean(value),
      sd = sd(value),
      median = median(value),
      trimmed = mean(value, trim = 0.1),
      min = min(value),
      max = max(value),
      range = max - min,
      skew = psych::skew(value),
      kurt = psych::kurtosi(value),
      .by = name
    )
}

taia %>% 
  desc_stats("pr")
# moments


taia %>% 
  desc_stats("ut")


taia %>% 
  select(starts_with("pr")) %>% 
  psych::describe()

taia %>% 
  select(starts_with("un")) %>% 
  psych::describe()

# psych::describeBy()


# 5

taia %>% 
  select(starts_with("pr")) %>% 
  cor() -> pr_cor

taia %>% 
  select(starts_with("ut")) %>% 
  cor() -> ut_cor

taia %>% 
  select(starts_with("de")) %>% 
  cor() -> de_cor

taia %>% 
  select(starts_with("un")) %>% 
  cor() -> un_cor

# 6 

pr_cor %>% 
  ggcorrplot(
    type = "lower",
    lab = TRUE,
    show.legend = FALSE,
    color = c("indianred", "white", "royalblue")
  )

ut_cor %>% 
  ggcorrplot(
    type = "lower",
    lab = TRUE,
    show.legend = FALSE,
    color = c("indianred", "white", "royalblue")
  )

de_cor %>% 
  ggcorrplot(
    type = "lower",
    lab = TRUE,
    show.legend = FALSE,
    color = c("indianred", "white", "royalblue")
  )

un_cor %>% 
  ggcorrplot(
    type = "lower",
    lab = TRUE,
    show.legend = FALSE,
    color = c("indianred", "white", "royalblue")
  )


# 7

taia %>% 
  select(id, matches("^[[:alpha:]]{2}\\d{2}$")) %>% # colnames()
  select(-c(co07, ut10, de04, pr03, pr04, 
            fa03, fa07, de11, gt01, gt02, 
            gt03, gt04, gt05, gt06)) %>% # colnames()
  pivot_longer(cols = -id) %>% 
  summarise(DT = sum(value),
            .by = id) %>% 
  full_join(
    taia %>% 
      select(id, gt01, gt02, gt03, gt04, gt05, gt06) %>% 
      pivot_longer(cols = -id) %>% 
      summarise(GT = mean(value),
                .by = id)
  ) -> valid

# 9

cor.test(valid$DT, valid$GT)

# 8

valid %>% 
  ggplot(aes(DT, GT)) +
  geom_point(alpha = .3) +
  geom_smooth(method = "lm", color = "black")


# 10

taia$f_socnet %>% hist()
unique(taia$f_socnet)

taia %>% 
  select(id, f_socnet) %>% 
  full_join(valid) -> valid

cor.test(valid$DT, valid$f_socnet)
cor.test(valid$DT, valid$f_socnet, method = "sp")


# 11

valid %>% 
  ggplot(aes(DT, f_socnet)) +
  geom_point() +
  geom_smooth(method = "lm")

valid %>% 
  ggplot(aes(as_factor(f_socnet), DT)) +
  geom_boxplot() +
  geom_point(position = position_jitter(width = .2),
             alpha = .3)


# 12

nasa <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr9/nasatlx_score.csv")
str(nasa)

# 13

nasa %>% 
  filter(task == "MR" & level == "easy") %>% 
  select(ME, PH, TI, PE, EF, FR, OW) %>% 
  cor() -> mr_easy_cor

nasa %>% 
  filter(task == "MR" & level == "medium") %>% 
  select(ME, PH, TI, PE, EF, FR, OW) %>% 
  cor() -> mr_medium_cor

nasa %>% 
  filter(task == "MR" & level == "hard") %>% 
  select(ME, PH, TI, PE, EF, FR, OW) %>% 
  cor() -> mr_hard_cor

mr_easy_cor %>% 
  ggcorrplot(
    type = "lower",
    lab = TRUE,
    show.legend = FALSE,
    color = c("indianred", "white", "royalblue")
  )

mr_medium_cor %>% 
  ggcorrplot(
    type = "lower",
    lab = TRUE,
    show.legend = FALSE,
    color = c("indianred", "white", "royalblue")
  )

mr_hard_cor %>% 
  ggcorrplot(
    type = "lower",
    lab = TRUE,
    show.legend = FALSE,
    color = c("indianred", "white", "royalblue")
  )


## 14

mr_easy_cor %>% 
  atanh() -> mr_easy_cor_
mr_medium_cor %>% 
  atanh() -> mr_medium_cor_
mr_hard_cor %>% 
  atanh() -> mr_hard_cor_

((mr_easy_cor_ + mr_medium_cor_ + mr_hard_cor_) / 3) %>% 
  tanh() -> mr_pooled_cor

mr_pooled_cor %>% 
  ggcorrplot(
    type = "lower",
    lab = TRUE,
    show.legend = FALSE,
    color = c("indianred", "white", "royalblue")
  )


# 16
sink("converg_valid_results.txt")
cor.test(valid$DT, valid$GT)
sink()


# 17
apaTables::apa.cor.table(mr_pooled_cor, filename = "mr-pooled-cor.doc")


# 18
cor_res <- cor.test(valid$DT, valid$GT)
report::report(cor_res)


# 19

pwr::pwr.r.test(r = .3,
                sig.level = .05,
                power = .8)


# 20
taia %>% 
  select(matches("^[[:alpha:]]{2}\\d{2}$")) %>% 
  select(-c(gt01, gt02, gt03, gt04, gt05, gt06)) %>% # colnames()
  cor() %>% 
  qgraph::qgraph(
    layout = "spring",
    posCol = "royalblue",
    negCol = "indianred"
  )



