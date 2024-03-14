# pkgs <- c("lme4", "lmerTest", "performance")
# install.packages(pkgs[!pkgs %in% installed.packages()])

library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")
library(lme4)
library(lmerTest)

# 1
share <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr14/share.csv")
str(share)

unique(share$trialtype)

share %>% 
  mutate(trialtype = as_factor(trialtype),
         id = as_factor(id),
         platform = as_factor(platform),
         time1 = 1000 * time1) %>% 
  filter(trialtype != "both") -> share

# 2
## a
model1 <- glm(time1 ~ setsize, data = share, family = Gamma)
summary(model1)

## b
share %>% 
  ggplot(aes(setsize, time1)) +
  geom_point() +
  geom_line(aes(y = model1$fitted.values),
            color = "blue",
            size = 2)

share$id %>% unique() %>% length()


# 3
model2 <- glm(time1 ~ setsize + id, family = Gamma, data = share)
summary(model2)

share %>% 
  ggplot(aes(setsize, time1, color = id)) +
  geom_point() +
  geom_line(aes(y = model2$fitted.values),
            size = 1)

# 4
share %>% 
  ggplot(aes(setsize, time1, shape = id)) +
  stat_summary(fun = mean, geom = "point", 
               position = position_dodge(.1)) +
  stat_summary(fun = mean, geom = "line", 
               position = position_dodge(.1)) +
  scale_shape_manual(values = c(65:90, 97:107))

# 5
## a
mix1 <- lmer(time1 ~ setsize + (1|id), data = share)
## b
mix2 <- lmer(time1 ~ setsize + (1 + setsize|id), data = share)

summary(mix1)
summary(mix2)

# remove.packages()
# install.packages()
# detach("package:Matrix", unload = TRUE)

# 6
anova(mix1, mix2, refit = FALSE)

# 7
## a
mix1.1 <- lmer(time1 ~ setsize + (1|id), data = share, REML = FALSE)

## b
performance::icc(mix1.1)


# 8
# plot(mix1.1)

## a
res1 <- tibble(
  share,
  fitted = fitted(mix1.1),
  resid = resid(mix1.1, type = "pearson"),
  sresid = resid(mix1.1, type = "pearson", scaled = TRUE)
)
str(res1)

## b
gg_res1 <- ggplot(res1, aes(y = sresid)) +
  geom_hline(yintercept = 0)

gg_res1 + geom_point(aes(x = fitted))

## c
gg_res1 + geom_boxplot(aes(x = factor(setsize)))

## d
gg_res1 + geom_boxplot(aes(x = id))


# 9
## a
mix3 <- lmer(time1 ~ setsize * trialtype * platform + (1|id), 
             data = share, REML = FALSE)

## b
res3 <- tibble(
  share,
  fitted = fitted(mix3),
  sresid = resid(mix3, type = "pearson", scaled = TRUE)
)
gg_res3 <- ggplot(res3, aes(y = sresid)) +
  geom_hline(yintercept = 0)
gg_res3 + geom_point(aes(x = fitted))
gg_res3 + geom_boxplot(aes(x = factor(setsize)))
gg_res3 + geom_boxplot(aes(x = id))


# 10
mix0 <- lmer(time1 ~ 1 + (1|id), data = share, REML = FALSE)
anova(mix0, mix3)

# 11
summary(mix3)

# 12
drop1(mix3)
mix3.1 <- update(mix3, .~. -setsize:trialtype:platform)
drop1(mix3.1)
mix3.2 <- update(mix3.1, .~. -setsize:platform)
drop1(mix3.2)
anova(mix3.2)

# 15
summary(mix3.2)


## 13
AIC(mix3, mix3.2)
BIC(mix3, mix3.2)


## 14

performance::r2(mix3.2)


## 16
## a
model3 <- glm(time1 ~ setsize + trialtype + platform + setsize:trialtype + trialtype:platform,
              family = Gamma, data = share)

## b
predictions <- tibble(
  share,
  glm_pred = predict(model3, share, type = "response"),
  glmm_pred = predict(mix3.2, share, type = "response")
)

## c
Metrics::rmse(predictions$time1, predictions$glm_pred)
Metrics::rmse(predictions$time1, predictions$glmm_pred)
Metrics::mape(predictions$time1, predictions$glm_pred)
Metrics::mape(predictions$time1, predictions$glmm_pred)



## 17
# posxmin1
# posxmax1
# posymin1
# posymax1

share %>% 
  mutate(is_correct = ifelse(
    click1x > posxmin1 & click1x < posxmax1 &
      click1y > posymin1 & click1y < posymax1,
    1, 0
  )) -> share

table(share$is_correct)

# 18

mix_log <- glmer(is_correct ~ setsize * trialtype * platform + (1|id),
                 family = binomial, data = share)
summary(mix_log)
drop1(mix_log, test = "Chi")
mix_log1 <- update(mix_log, .~. -setsize:trialtype:platform)
drop1(mix_log1, test = "Chi")
mix_log2 <- update(mix_log1, .~. -setsize:platform -trialtype:platform)
drop1(mix_log2, test = 'Chi')
mix_log3 <- update(mix_log2, .~. -platform)
drop1(mix_log3, test = "Chi")

summary(mix_log3)


## 19

mix_log0 <- glmer(is_correct ~ 1 + (1|id), family = binomial, data = share)
anova(mix_log0, mix_log3)

# 20

predicted_mixlog <- ifelse(predict(mix_log3, share, type = "response") > 0.95, 1, 0)

table(share$is_correct,
      predicted_mixlog)






