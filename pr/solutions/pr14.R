### P14 // Solutions
### A. Angelgardt

pkgs <- c("lme4", "lmerTest", "performance")
install.packages(pkgs[!pkgs %in% installed.packages()])

# MAIN
library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")
library(lme4)
library(lmerTest)

# 1
share <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr14/share.csv")
str(share)
unique(share$trialtype)

share %>% mutate(trialtype = as_factor(trialtype),
                 time1 = 1000 * time1,
                 id = as_factor(id),
                 platform = as_factor(platform)) -> share

share %>% filter(trialtype != 'both') -> share

# 2
## a
model1 <- glm(time1 ~ setsize, family = Gamma, data = share)
summary(model1)

## b
share %>% ggplot(aes(setsize, time1)) +
  geom_point() +
  geom_line(aes(y = model1$fitted.values), 
            color= "blue", 
            size = 2)


# 3
## a
model2 <- glm(time1 ~ setsize + id, family = Gamma, data = share)
summary(model2)

# share %>% 
#   ggplot(aes(time1)) +
#   geom_density() +
#   facet_wrap(~ setsize)

## b
share %>% ggplot(aes(setsize, time1, color = id)) +
  geom_point() +
  geom_line(aes(y = model2$fitted.values),
            size = 1)


# 4
share %>% ggplot(aes(setsize, time1, shape = id)) +
  stat_summary(fun = mean, geom = 'point', position = position_dodge(.1)) +
  stat_summary(fun = mean, geom = 'line', position = position_dodge(.1)) +
  scale_shape_manual(values = c(65:90, 97:107))


# 5
## a
mix1 <- lmer(time1 ~ setsize + (1|id), data = share)
# summary(mix1)

## b
mix2 <- lmer(time1 ~ setsize + (1 + setsize|id), data = share)
# summary(mix2)

# 6
anova(mix1, mix2, refit = FALSE)


# 7
## a
mix1.1 <- lmer(time1 ~ setsize + (1|id), data = share, REML = FALSE)

## b
performance::icc(mix1.1)


# 8
# plot(mix1)
## a
res1 <- tibble(
  share,
  fitted = fitted(mix1.1),
  resid = resid(mix1.1, type = 'pearson'),
  sresid = resid(mix1.1, type = 'pearson', scaled = TRUE)
)
str(res1)

## b
gg_res1 <- ggplot(res1, aes(y = sresid)) +
  geom_hline(yintercept = 0)
gg_res1 + geom_point(aes(x = fitted))

## c
gg_res1 + geom_boxplot(aes(x = factor(share$setsize)))

## d
gg_res1 + geom_boxplot(aes(x = factor(share$id)))


# 9
## a
mix3 <- lmer(time1 ~ setsize * trialtype * platform + (1|id), data = share, REML = FALSE)

## b
res3 <- tibble(
  share,
  fitted = fitted(mix3),
  resid = resid(mix3, type = 'pearson'),
  sresid = resid(mix3, type = 'pearson', scaled = TRUE)
)
gg_res3 <- ggplot(res3, aes(y = sresid)) +
  geom_hline(yintercept = 0)
gg_res3 + geom_point(aes(x = fitted))
gg_res3 + geom_boxplot(aes(x = factor(share$setsize)))
gg_res3 + geom_boxplot(aes(x = factor(share$id)))


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


# 13
AIC(mix3, mix3.2)
BIC(mix3, mix3.2)


# 14
performance::r2(mix3.2)


# 15
summary(mix3.2)


# 16
## a
model3 <- glm(time1 ~ setsize + trialtype + platform + setsize:trialtype + trialtype:platform,
              family = Gamma, data = share)

## b
predictions <- 
  tibble(
    share,
    glm_pred = predict(model3, share, type = "response"),
    glmm_pred = predict(mix3.2, share, type = "response")
  )

## c
Metrics::rmse(predictions$time1, predictions$glm_pred)
Metrics::rmse(predictions$time1, predictions$glmm_pred)
Metrics::mape(predictions$time1, predictions$glm_pred)
Metrics::mape(predictions$time1, predictions$glmm_pred)


# 17
share %>% 
  mutate(is_correct = ifelse(click1x > posxmin1 & click1x < posxmax1 &
                               click1y > posymin1 & click1y < posymax1,
                             1, 0)) -> share # %>% pull(is_correct) %>% table()

# 18
mix_log <- glmer(is_correct ~ setsize * trialtype * platform + (1|id), family = binomial, data = share) ## failed
mix_log <- glmer(is_correct ~ setsize + (1|id), family = binomial, data = share)
summary(mix_log)

# 19
mix_log_0 <- glmer(is_correct ~ 1 + (1|id), family = binomial, data = share)
anova(mix_log_0, mix_log)

# 20
predicted_mixlog <- ifelse(predict(mix_log, share, type = "response") > .8, 1, 0)
table(share$is_correct, 
      predicted_mixlog)



# ADDITIONAL

# 1

# 2

# 3

# 4

# 5

# 6

# 7

# 8

# 9

# 10
