# pkgs <- c("pROC", "psych")
# install.packages(pkgs[!pkgs %in% installed.packages()])

library(tidyverse)
theme_set(theme_bw())

# 1
managers <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr12/managers.csv")
str(managers)
table(managers$lvl)

managers %>% 
  mutate(lvl = ifelse(lvl == "Менеджер", 1, 0)) %>% 
  select(-...1, -id) -> mngrs


# 2
mngrs %>% 
  pivot_longer(-lvl) %>% 
  ggplot(aes(value, lvl)) +
  geom_point(position = position_jitter(width = .1,
                                        height = .1),
             alpha = .3) +
  facet_wrap(~ name)

mngrs %>% 
  select(-lvl) %>% 
  cor() %>% 
  ggcorrplot::ggcorrplot(lab = TRUE)


# 3
model_lm <- lm(lvl ~ ., mngrs)
summary(model_lm)


# 4 
par(mfrow = c(2, 2))
plot(model_lm)

mngrs %>% 
  mutate(L = qualification +
           autonomy +
           subdiv_regulations +
           company_regulations +
           direct_juniors +
           func_juniors +
           income_influence +
           error_cost,
         fitted_lm = model_lm$fitted.values) %>% 
  ggplot(aes(L, lvl)) +
  geom_point(size = 2, alpha = .3) +
  geom_point(aes(y = fitted_lm),
             color = "darkred", alpha = .3)


# 5
model_glm <- glm(lvl ~ ., data = mngrs)
summary(model_glm)

# 6
plot(model_glm)

mngrs %>% 
  mutate(L = qualification +
           autonomy +
           subdiv_regulations +
           company_regulations +
           direct_juniors +
           func_juniors +
           income_influence +
           error_cost,
         fitted_lm = model_glm$fitted.values) %>% 
  ggplot(aes(L, lvl)) +
  geom_point(size = 2, alpha = .3) +
  geom_point(aes(y = fitted_lm),
             color = "darkred", alpha = .3)


# 7
model1 <- glm(lvl ~ ., family = binomial, data = mngrs)
summary(model1)

# 8
model0 <- glm(lvl ~ 1, family = binomial, data = mngrs)
anova(model0, model1, test = "Chi")

# 9
## a
car::Anova(model1)
## b
(model1$null.deviance - model1$deviance) / model1$null.deviance


# 10
## a
model1.1 <- update(model1, .~. -error_cost)
drop1(model1.1, test = "Chi")
model1.2 <- update(model1.1, .~. -subdiv_regulations)
drop1(model1.2, test = "Chi")
model1.3 <- update(model1.2, .~. -autonomy)
drop1(model1.3, test = 'Chi')
model1.4 <- update(model1.3, .~. -company_regulations)
drop1(model1.4, test = "Chi")

## b
AIC(model1, model1.4)
BIC(model1, model1.4)

## c
car::vif(model1.4)

## d
(model1$null.deviance - model1$deviance) / model1$null.deviance
(model1.4$null.deviance - model1.4$deviance) / model1.4$null.deviance


# 11
## a
ggplot(data = NULL,
       aes(x = predict(model1.4, type = "response"),
           y = resid(model1.4, type = "pearson"))) +
  geom_point() +
  geom_smooth(method = "loess")

## b
# https://bbolker.github.io/mixedmodels-misc/glmmFAQ.html#testing-for-overdispersioncomputing-overdispersion-factor
overdisp_fun <- function(model) {
  rdf <- df.residual(model)
  if (inherits(model, 'negbin'))
    rdf <- rdf - 1
  rp <- residuals(model, type = 'pearson')
  Pearson.chisq <- sum(rp ^ 2)
  prat <- Pearson.chisq / rdf
  pval <-
    pchisq(Pearson.chisq, df = rdf, lower.tail = FALSE)
  c(
    chisq = Pearson.chisq,
    ratio = prat,
    rdf = rdf,
    p = pval
  )
}

overdisp_fun(model1.4)


# model1.5 <- glm(lvl ~ qualification * income_influence + direct_juniors + func_juniors,
#                 family = binomial, data = mngrs)


# 12
predicted <- ifelse(predict(model1.4, type = "response") > .8, 1, 0)
confmat <- table(mngrs$lvl, predicted)
confmat

# 13
# table(mngrs$lvl)
## accuracy
mean(mngrs$lvl == predicted)
## precision
precision = confmat[2, 2] / (confmat[2, 2] + confmat[1, 2])
precision
## recall
recall = confmat[2, 2] / (confmat[2, 2] + confmat[2, 1])
recall
## F1
2 * precision * recall / (precision + recall)
psych::harmonic.mean(c(precision, recall))


# 14
pROC::roc(mngrs$lvl, predict(model1.4, type = "response"))
pROC::auc(pROC::roc(mngrs$lvl, predict(model1.4, type = "response")))
par(mfrow = c(1, 1))
plot(pROC::roc(mngrs$lvl, predict(model1.4, type = "response")))

summary(model1.4)
exp(1.6056)


# 15
satis <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr12/trust_data.csv")
str(satis)

satis$errors_total %>% hist()

# 16
model2 <- glm(errors_total ~ feedback * explanation, 
              family = poisson, data = satis)
summary(model2)

# 17
## a
model0_pois <- glm(errors_total ~ 1, family = poisson, data = satis)
anova(model0_pois, model2, test = "Chi")
car::Anova(model2)
(model2$null.deviance - model2$deviance) / model2$null.deviance

## b
overdisp_fun(model2)

# 18
model3 <- glm(errors_total ~ feedback * explanation, 
              family = quasipoisson, data = satis)

# 19
summary(model3)
summary(model2)

# 20
car::Anova(model3, test = "F")


# ??? negbinom  ???

## ADDITIONAL

# 1

set.seed(5432)
ind_train <- sample(1:nrow(mngrs), size = 0.7 * nrow(managers), replace = FALSE)
mngrs %>% 
  slice(ind_train) -> mngrs_train
mngrs %>% 
  slice(-ind_train) -> mngrs_test

# 2
model4 <- glm(lvl ~ qualification + 
                income_influence + 
                direct_juniors + 
                func_juniors,
              family = binomial, 
              data = mngrs_train)
pROC::roc(mngrs_train$lvl, predict(model4, type = "response"))

# 3
predicted_tr <- ifelse(predict(model4, type = "response") > .8, 1, 0)
confmat_tr <- table(mngrs_train$lvl, predicted_tr)

## accuracy
mean(mngrs_train$lvl == predicted_tr)
## precision
precision_tr = confmat_tr[2, 2] / (confmat_tr[2, 2] + confmat_tr[1, 2])
precision_tr
## recall
recall_tr = confmat_tr[2, 2] / (confmat_tr[2, 2] + confmat_tr[2, 1])
recall_tr
## F1
psych::harmonic.mean(c(precision_tr, recall_tr))

# 4
predicted_test <- ifelse(predict(model4, mngrs_test, type = "response") > 0.8, 1, 0)
predicted_test
confmat_test <- table(mngrs_test$lvl, predicted_test)

## accuracy
mean(mngrs_test$lvl == predicted_test)
## precision
precision_test = confmat_test[2, 2] / (confmat_test[2, 2] + confmat_test[1, 2])
precision_test
## recall
recall_test = confmat_test[2, 2] / (confmat_test[2, 2] + confmat_test[2, 1])
recall_test
## F1
psych::harmonic.mean(c(precision_test, recall_test))

