# HW12 // Solutions
# A. Angelgardt

# MAIN

# 1

library(tidyverse)
theme_set(theme_bw())
library(mgcv)
library(glmnet)

## a
pisa <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/hw12/pisasci2006.csv")
str(pisa)

## b
pisa %>% drop_na() -> pisa
nrow(pisa)

## c
GGally::ggpairs(pisa %>% select(-Country))


# 2
## a
gam1 <- gam(Overall ~ s(Interest) + s(Support) + s(Income) + s(Health), 
            data = pisa)

## b
gam0 <- gam(Overall ~ 1, data = pisa)
anova(gam0, gam1, test = "Chisq")



# 3
## a
summary(gam1)

## b
gam2 <- gam(Overall ~ s(Income) + s(Interest) + Support + Health, 
            data = pisa)
anova(gam1, gam2, test = "Chisq")
summary(gam2)


# 4
## a
lm2 <- lm(Overall ~ Interest + Income + Support + Health, 
          data = pisa)
summary(lm2)

## b
Metrics::rmse(pisa$Overall, lm2$fitted.values)
Metrics::rmse(pisa$Overall, gam2$fitted.values)
Metrics::mape(pisa$Overall, lm2$fitted.values)
Metrics::mape(pisa$Overall, gam2$fitted.values)


# 5
par(mfrow = c(2, 2))
gam.check(gam2)


# 6
concurvity(gam2)


# 7
pisa %>% 
  select(Overall, Issues, Explain, Evidence, HDI) %>% 
  cor() %>% ggcorrplot::ggcorrplot(lab = TRUE)


# 8
## a
Y <- pisa$Overall
X <- pisa %>% select(Issues, Explain, Evidence, HDI) %>% as.matrix()

## b
model_lasso <- cv.glmnet(x = X, y = Y, alpha = 1)
coef(model_lasso, s = "lambda.min")

## с
# HDI has zero coeff


# 9
X2 <- pisa %>% select(Issues, Explain, Evidence) %>% as.matrix()
model_ridge <- cv.glmnet(x = X2, y = Y, alpha = 0)
# coef(model_ridge, s = "lambda.min")


# 10
## a
lm <- lm(Overall ~ Issues + Explain + Evidence, pisa)

## b
Metrics::mape(pisa$Overall, lm$fitted.values)
Metrics::mape(pisa$Overall, predict(model_ridge, X2, s = "lambda.min"))
Metrics::rmse(pisa$Overall, lm$fitted.values)
Metrics::rmse(pisa$Overall, predict(model_ridge, X2, s = "lambda.min"))
