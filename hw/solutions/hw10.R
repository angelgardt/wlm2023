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


# 2


# 3


# 4


# 5

