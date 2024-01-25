### P9 // Solutions
### A. Angelgardt

# MAIN

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
    summarise(mean = mean(value),
              sd = sd(value),
              median = median(value),
              trimmed = mean(value, trim = 2.5),
              min = min(value),
              max = max(value),
              range = max - min,
              skew = psych::skew(value),
              kurt = psych::kurtosi(value),
              .by = name)
}

taia %>% 
  desc_stats("pr")

taia %>% 
  desc_stats("ut")


# 4
taia %>% 
  select(starts_with("pr")) %>% 
  psych::describe()

taia %>% 
  select(starts_with("ut")) %>% 
  psych::describe()


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
    type = "lower", lab = TRUE, lab_size = 3,
    colors = c("indianred1", "white", "royalblue1"),
    title = "Predictability. Interitems correlations",
    show.legend = FALSE
  )

de_cor %>% 
  ggcorrplot(
    type = "lower", lab = TRUE, lab_size = 3,
    colors = c("indianred1", "white", "royalblue1"),
    title = "Dependability. Interitems correlations",
    show.legend = FALSE
  )

ut_cor %>% 
  ggcorrplot(
    type = "lower", lab = TRUE, lab_size = 3,
    colors = c("indianred1", "white", "royalblue1"),
    title = "Utility. Interitems correlations",
    show.legend = FALSE
  )

un_cor %>% 
  ggcorrplot(
    type = "lower", lab = TRUE, lab_size = 3,
    colors = c("indianred1", "white", "royalblue1"),
    title = "Understanding. Interitems correlations",
    show.legend = FALSE
  )


# 7
taia %>% 
  select(id, matches("^[[:alpha:]]{2}\\d{2}$")) %>% # colnames()
  select(-c(co07, ut10, de04, pr03, pr04, fa03, fa07, de11, gt01, gt02, gt03, gt04, gt05, gt06)) %>% # colnames()
  pivot_longer(cols = -id) %>% # print()
  summarise(DT = sum(value),
            .by = id) %>% 
  full_join(
    taia %>% 
      select(id, gt01, gt02, gt03, gt04, gt05, gt06) %>% 
      pivot_longer(cols = -id) %>% 
      summarise(GT = mean(value),
                .by = id)
  ) -> valid


# 8
valid %>% 
  ggplot(aes(DT, GT)) +
  geom_point(alpha = .3) +
  geom_smooth(method = "lm", color = "black")


# 9
cor.test(valid$DT, valid$GT)


# 10
taia %>% 
  select(id, f_socnet) %>% 
  full_join(valid) -> valid

taia$f_socnet %>% unique()

cor.test(valid$DT, valid$f_socnet, method = "pearson")
cor.test(valid$DT, valid$f_socnet, method = "spearman")


# 11
valid %>% 
  ggplot(aes(DT, f_socnet)) +
  geom_point() +
  geom_smooth(method = "lm")

valid %>% 
  ggplot(aes(as_factor(f_socnet), DT)) +
  geom_boxplot() +
  geom_point(position = position_jitter(width = .2), alpha = .3)


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
  ggcorrplot(type = "lower", 
             lab = TRUE,
             lab_size = 3,
             colors = c("indianred1", "white", "royalblue1"),
             show.legend = FALSE)

mr_medium_cor %>% 
  ggcorrplot(type = "lower", 
             lab = TRUE,
             lab_size = 3,
             colors = c("indianred1", "white", "royalblue1"),
             show.legend = FALSE)

mr_hard_cor %>% 
  ggcorrplot(type = "lower", 
             lab = TRUE,
             lab_size = 3,
             colors = c("indianred1", "white", "royalblue1"),
             show.legend = FALSE)


# 14
mr_easy_cor %>% 
  atanh() -> mr_easy_cor_
mr_medium_cor %>% 
  atanh() -> mr_medium_cor_
mr_hard_cor %>% 
  atanh() -> mr_hard_cor_


# 15
((mr_easy_cor_ + mr_hard_cor_ + mr_medium_cor_) / 3) %>% 
  tanh() -> mr_pooled_cor


# 16
sink("converg_valid_results.txt")
cor.test(valid$DT, valid$GT)
sink()


# 17
apaTables::apa.cor.table(mr_pooled_cor, filename = "MR-pooled-cor.docx")


# 18
cor_res <- cor.test(valid$DT, valid$GT)
report::report(cor_res)


# 19
pwr::pwr.r.test(r = .3,
                sig.level = .05,
                power = .8)


# 20
taia %>% 
  select(matches("^[[:alpha:]]{2}\\d{2}$")) %>% # colnames()
  select(-c(gt01, gt02, gt03, gt04, gt05, gt06)) %>% 
  cor() %>% 
  qgraph::qgraph(
    layout = "spring",
    posCol = "royalblue",
    negCol = "indianred"
  )




# ADDITIONAL

# 1
cor.test(taia$f_socnet, taia$n_dighelp,
         method = "sp")
cor.test(taia$f_socnet, taia$n_dighelp,
         method = "kendall")


# 2
taia %>% 
  select(f_socnet, n_dighelp) %>% 
  drop_na() %>% 
  mutate(f_socnet = as_factor(f_socnet),
         n_dighelp = as_factor(n_dighelp)) %>% 
  ggplot() + 
  geom_mosaic(aes(x=product(f_socnet, n_dighelp), fill = f_socnet),
              conds = product(n_dighelp))


# 3
taia %>% 
  select(id, dig_job) %>% 
  full_join(valid) -> valid

ltm::biserial.cor(valid$DT, valid$dig_job)
t.test(valid$DT ~ valid$dig_job)


# 4
table(taia$dig_job, taia$dig_spec)
chisq.test(taia$dig_job, taia$dig_spec)


# 5
sqrt(chisq.test(taia$dig_job, taia$dig_spec)$statistic / length(taia$dig_job))


# 6
se_r <- function(r, n) {
  sqrt(
    (1 - r^2) / (n-2)
  )
}


# 7
r_ci <- function(r, se) {
  r_ = atanh(r)
  lower_ = r_ - 1.96 * se
  upper_ = r_ + 1.96 * se
  lower = tanh(lower_)
  upper = tanh(upper_)
  cover_zero = ifelse(sign(lower) == sign(upper), FALSE, TRUE)
  return(tibble(r = r,
                se = se,
                lower = lower,
                upper = upper,
                cover_zero = cover_zero))
}


# 8
r_n_se <- function(se) {
  return(tibble(se = se,
                n = (1 / se)^2 + 3))
}

r_n_se_lazy <- function(r, se) {
  return(tibble(r = r,
                se = se,
                n = ((1-r^2) / se^2) + 2))
}


# 9
mode <- function(x) {
  values <- sort(unique(x))
  freqs <- tabulate(x)
  which(freqs == max(freqs))
}


# 10
original <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr9/original_cormat.csv") %>% 
  select(-scale) %>% 
  as.matrix()
rownames(original) <- colnames(original)
psych::cortest(R1 = original, 
               R2 = mr_pooled_cor,
               n1 = 6,
               n2 = 69)

