### P12 // Solutions
### A. Angelgardt

# MAIN

# 1
pkgs <- c("pROC", "psych")
install.packages(pkgs[!pkgs %in% installed.packages()])

library(tidyverse)
theme_set(theme_bw())

managers <- read_csv("../data/pr12/managers.csv")
# managers_reg <- read_csv("../data/pr12/managers_reg.csv")
str(managers)
managers %>% 
  select(-...1, -id) %>% 
  mutate(lvl = ifelse(lvl == "Менеджер", 1, 0)) -> mngrs


# 2
mngrs %>% 
  pivot_longer(-lvl) %>% 
  ggplot(aes(value, lvl)) +
  geom_point(position = position_jitter(width = .1, height = .1),
             alpha = .5) +
  facet_wrap(~ name)

mngrs %>% 
  select(-lvl) %>% 
  cor(
    #method = "sp"
    ) %>% 
  ggcorrplot::ggcorrplot(lab = TRUE)


# 3
model_lm <- lm(lvl ~ ., mngrs)
summary(model_lm)


# 4
par(mfrow = c(2, 2))
plot(model_lm)
mngrs %>% 
  mutate(fitted_lm = model_lm$fitted.values,
         L = qualification +
           autonomy +
           subdiv_regulations +
           company_regulations +
           direct_juniors +
           func_juniors +
           income_influence +
           error_cost) %>% 
ggplot(aes(L, lvl)) +
  geom_point(size = 2, alpha = .3) +
  geom_point(aes(y = fitted_lm),
             color = "darkred", alpha = .3)


# 5
model_glm <- glm(lvl ~ ., data = mngrs)
summary(model_glm)


# 6
par(mfrow = c(2, 2))
plot(model_glm)

mngrs %>% 
  mutate(fitted_glm = model_glm$fitted.values,
         L = qualification +
           autonomy +
           subdiv_regulations +
           company_regulations +
           direct_juniors +
           func_juniors +
           income_influence +
           error_cost) %>% 
  ggplot(aes(L, lvl)) +
  geom_point(size = 2, alpha = .3) +
  geom_point(aes(y = fitted_glm),
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
model1.3 <- update(model1.2, .~. -company_regulations)
drop1(model1.3, test = "Chi")
model1.4 <- update(model1.3, .~. -autonomy)
drop1(model1.4, test = "Chi")

## b
AIC(model1, model1.4)
BIC(model1, model1.4)

## c
car::vif(model1.4)

## d
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


# 12
predicted <- ifelse(predict(model1.4, type = "response") > .8, 1, 0)
confmat <- table(mngrs$lvl, predicted)


# 13
## accuracy
mean(mngrs$lvl == predicted)
## precision
precision = confmat[2,2] / (confmat[2,2] + confmat[1, 2])
precision
## recall
recall = confmat[2,2] / (confmat[2,2] + confmat[2, 1])
recall
## F1
(precision * recall) / (precision + recall) * 2 
psych::harmonic.mean(precision, recall)


# 14
pROC::roc(mngrs$lvl, predict(model1.4, type = "response"))
pROC::roc(mngrs$lvl, predict(model1.4, type = "response"))
pROC::auc(pROC::roc(mngrs$lvl, predict(model1.4, type = "response")))
# plot(pROC::roc(mngrs$lvl, predict(model1.4, type = "response")))

# 15
satis <- read_csv("../data/pr12/trust_data.csv")
str(satis)
par(mfrow = c(2, 2))
satis$errors_total %>% hist()


# 16
model2 <- glm(errors_total ~ feedback * explanation, data = satis, family = poisson)
summary(model2)


# 17
## a
model0_pois <- glm(errors_total ~ 1, data = satis, family = poisson)
anova(model0_pois, model2, test = "Chi")
car::Anova(model2)
(model3$null.deviance - model3$deviance) / model3$null.deviance
## b
overdisp_fun(model2)


# 18
model3 <- glm(errors_total ~ feedback * explanation, data = satis, family = quasipoisson)
summary(model3)


# 19
summary(model3)
summary(model2)


# 20
car::Anova(model3, test = "F")



# ADDITIONAL

# 1
set.seed(5432)
ind_train <- sample(1:nrow(mngrs), size = 0.7 * nrow(managers), replace = FALSE)
mngrs %>% 
  slice(ind_train) -> mngrs_train
mngrs %>% 
  slice(-ind_train) -> mngrs_test


# 2
## a
model4 <- glm(lvl ~ qualification + direct_juniors + func_juniors + income_influence, 
              data = mngrs_train, 
              family = binomial)
## b
pROC::roc(mngrs_train$lvl, predict(model4, type = "response"))


# 3
predicted_tr <- ifelse(predict(model4, type = "response") > .8, 1, 0)
confmat_tr <- table(mngrs_train$lvl, predicted_tr)
## presicion
precision_tr = confmat_tr[2,2] / (confmat_tr[2,2] + confmat_tr[1, 2])
precision_tr
## recall
recall_tr = confmat_tr[2,2] / (confmat_tr[2,2] + confmat_tr[2, 1])
recall_tr
## F1
(precision_tr * recall_tr) / (precision_tr + recall_tr) * 2 


# 4
predicted_test <- ifelse(predict(model4, mngrs_test, type = "response") > 0.8, 1, 0)


# 5
confmat_test <- table(mngrs_test$lvl, predicted_test)
## presicion
precision_test = confmat_test[2,2] / (confmat_test[2,2] + confmat_test[1, 2])
precision_test
## recall
recall_test = confmat_test[2,2] / (confmat_test[2,2] + confmat_test[2, 1])
recall_test
## F1
(precision_test * recall_test) / (precision_test + recall_test) * 2 


# 6
plot(pROC::roc(mngrs$lvl, predict(model1.4, type = "response")))
verification::roc.plot(mngrs$lvl, predict(model1.4, type = "response"))


# 7.0
## Модельная матрица и коэффициенты
X <- model.matrix(~ qualification + direct_juniors + func_juniors + income_influence, data = mngrs)
b <- coef(model1.4)
## Предсказанные значения и стандартные ошибки...
## ...в масштабе функции связи (логит)
mngrs$fit_eta <- X %*% b
mngrs$se_eta <- sqrt(diag(X %*% vcov(model1.4) %*% t(X)))
## ...в масштабе вероятностей (применяем функцию, обратную функции связи)
logit_back <- function(x) exp(x)/(1 + exp(x)) # обратная логит-трансформация
mngrs$fit_pi <- logit_back(mngrs$fit_eta)
mngrs$lwr <- logit_back(mngrs$fit_eta - 2 * mngrs$se_eta)
mngrs$upr <- logit_back(mngrs$fit_eta + 2 * mngrs$se_eta)


# 7

mngrs %>% 
  # pivot_longer(cols = c(qualification, direct_juniors, func_juniors, income_influence)) %>% 
  mutate(L = qualification + direct_juniors + func_juniors + income_influence) %>% 
  ggplot(
    aes(x = L,
        y = fit_eta)) +
  geom_ribbon(aes(ymin = fit_eta - 2 * se_eta,
                  ymax = fit_eta + 2 * se_eta),
              alpha = 0.5) +
  geom_line()


# 8
mngrs %>% 
  # pivot_longer(cols = c(qualification, direct_juniors, func_juniors, income_influence)) %>% 
  mutate(L = qualification + direct_juniors + func_juniors + income_influence) %>% 
  ggplot(
    aes(x = L,
        y = fit_pi)) +
  geom_ribbon(aes(ymin = lwr,
                  ymax = upr),
              alpha = 0.5) +
  geom_line()


# 9
model5 <- glm(lvl ~ qualification + direct_juniors + func_juniors + income_influence, 
              data = mngrs, 
              family = binomial(link = "probit"))
summary(model5)

# 10
model5.0 <- glm(lvl ~ 1, 
              data = mngrs, 
              family = binomial(link = "probit"))
anova(model5, model5.0, test = "Chi")
# anova(model5, test = "Chi")
car::Anova(model5)
overdisp_fun(model5)
