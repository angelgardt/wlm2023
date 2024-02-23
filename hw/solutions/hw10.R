# HW10 // Solutions
# A. Angelgardt

# MAIN

library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")
library(ez)


# 1
## a
fs <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/hw10/fs.csv")
str(fs)

## b
fs %>% 
  filter(pres == "p" & key == "right") -> fs_correct 
nrow(fs_correct)

# 2
## a
fs_correct %>% 
  mutate(setsize = as_factor(setsize)) %>% 
  summarise(rt = mean(time),
            .by = c(type, shadow, setsize, id)) -> fs_agg
## b
fs_agg %>%
  summarise(n = n(),
            .by = c(type, shadow, setsize))

# 3
ez_model <- ezANOVA(
  data = fs_agg,
  dv = rt,
  within = .(type, shadow, setsize),
  wid = id
)

ez_model

pairwise.t.test(x = fs_agg$rt,
                g = interaction(fs_agg$shadow, fs_agg$setsize),
                p.adjust.method = "bonf")

# 4
pd <- position_dodge(.5)

fs_agg %>% 
  ggplot(aes(setsize, rt, 
             color = type, 
             shape = shadow, 
             group = interaction(type, shadow))) +
  stat_summary(geom = "line", fun = mean, 
               linetype = "dashed", position = pd) +
  stat_summary(geom = "pointrange", fun.data = mean_cl_boot, 
               position = pd)

# 5
ez_model$ANOVA %>% write_excel_csv("ez_model.csv")

# 6
## a
app <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/hw10/app.csv")
str(app)

## b
app %>% 
  summarise(n = n(),
            .by = c(group, segment))

# 7
## no code

## unbalanced data, type III needed, sum-to-zero parametrization

# 8
app_eff <- lm(orders ~ group * segment, app,
              contrasts = list(group = contr.sum,
                               segment = contr.sum))
app_eff

# 9
car::Anova(app_eff, type = "III")

# 10
app %>% 
  ggplot(aes(group, orders, color = segment)) +
  stat_summary(geom = "pointrange", fun.data = mean_cl_boot)



# ADDITIONAL

# 1
vowels <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr11/vowels.csv") %>% 
  mutate(phoneme = as_factor(phoneme))

# 2
levels(vowels$phoneme)
# "ɐ"  "o"  "ə̝"  "ə"  "i"  "a"  "əᶷ" "u"  "e"  "ɪ"  "ʊ"  "ɨ"  "ɨ̞" 
i_vs_ɪ <- c(0, 0, 0, 0, 1, 0, 0, 0, 0, -1, 0, 0, 0)
e_vs_ɪ <- c(0, 0, 0, 0, 0, 0, 0, 0, 1, -1, 0, 0, 0)
a_vs_ɐ <- c(-1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0)
o_vs_ɐ <- c(-1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
u_vs_ʊ <- c(0, 0, 0, 0, 0, 0, 0, 1, 0, 0, -1, 0, 0)

contr_mat <- cbind(i_vs_ɪ,
                   e_vs_ɪ,
                   a_vs_ɐ,
                   o_vs_ɐ,
                   u_vs_ʊ)

# 3
contrasts(vowels$phoneme) <- contr_mat
f1_aov <- aov(f1 ~ phoneme, vowels)
summary(f1_aov,
        split = list(phoneme = list("i_vs_ɪ" = 1,
                                    "e_vs_ɪ" = 2,
                                    "a_vs_ɐ" = 3,
                                    "o_vs_ɐ" = 4,
                                    "u_vs_ʊ" = 5)))

# 4
f2_aov <- aov(f2 ~ phoneme, vowels)
summary(f2_aov,
        split = list(phoneme = list("i_vs_ɪ" = 1,
                                    "e_vs_ɪ" = 2,
                                    "a_vs_ɐ" = 3,
                                    "o_vs_ɐ" = 4,
                                    "u_vs_ʊ" = 5)))

# 5
vowels %>% 
  group_by(phoneme, reduction) %>% 
  summarise(f1 = mean_cl_boot(f1),
            f2 = mean_cl_boot(f2)) %>% 
  unnest() %>% 
  rename(f1mean = y,
         f1min = ymin,
         f1max = ymax,
         f2mean = y1,
         f2min = ymin1,
         f2max = ymax1) %>% 
  ggplot(aes(f2mean, f1mean, 
             color = factor(reduction,
                            ordered = TRUE,
                            levels = c("no", "first", "second")))) +
  geom_errorbar(aes(ymin = f1min, 
                    ymax = f1max)) +
  geom_errorbar(aes(xmin = f2min, 
                    xmax = f2max)) +
  geom_text(aes(label = phoneme), size = 5, color = "black") +
  scale_x_reverse(position = "top") +
  scale_y_reverse(position="right") +
  scale_color_discrete(labels = c("no" = "нет", 
                                  "first" = "первая",
                                  "second" = "вторая")) +
  labs(x = "F2", y = "F1", color = "Ступень редукции")
