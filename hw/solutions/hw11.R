# HW11 // Solutions
# A. Angelgardt

# MAIN


# 1
library(tidyverse)
theme_set(theme_bw())

heart <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/hw11/framingham.csv")
str(heart)

## b
### no type correction needed
heart %>% sapply(is.na) %>% apply(2, sum) ## has NA, let's remove them
heart %>% drop_na() -> heart
nrow(heart)

# 2
set.seed(616)
ind_train <- sample(1:nrow(heart), size = 0.7 * nrow(heart), replace = FALSE)
heart %>% 
  slice(ind_train) -> heart_train
heart %>% 
  slice(-ind_train) -> heart_test

mean(heart_train$TenYearCHD) %>% round(2)


# 3
## a
model1 <- glm(TenYearCHD ~ ., family = binomial, data = heart_train)
summary(model1)
model1$deviance %>% round()

## b
model0 <- glm(TenYearCHD ~ 1, family = binomial, data = heart_train)
anova(model0, model1, test = "Chi")


# 4
## a
drop1(model1, test = "Chi")
model1.1 <- update(model1, .~. -heartRate)
drop1(model1.1, test = "Chi")
model1.2 <- update(model1.1, .~. -currentSmoker)
drop1(model1.2, test = "Chi")
model1.3 <- update(model1.2, .~. -diaBP)
drop1(model1.3, test = "Chi")
model1.4 <- update(model1.3, .~. -diabetes)
drop1(model1.4, test = "Chi")
model1.5 <- update(model1.4, .~. -BMI)
drop1(model1.5, test = "Chi")
model1.6 <- update(model1.5, .~. -prevalentStroke)
drop1(model1.6, test = "Chi")
model1.7 <- update(model1.6, .~. -prevalentHyp)
drop1(model1.7, test = "Chi")
model1.8 <- update(model1.7, .~. -BPMeds)
drop1(model1.8, test = "Chi")
model1.8$deviance %>% round()

## b
anova(model1, model1.8, test = "Chi")

AIC(model1, model1.8)
BIC(model1, model1.8)

## c
### no code
### no diference, base on AIC and BIC reduced model better


# 5
## a
predicted_tr <- ifelse(predict(model1.8, type = "response") > .6, 1, 0)
confmat_tr <- table(heart_train$TenYearCHD, predicted_tr)

## b
### accuracy
mean(heart_train$TenYearCHD == predicted_tr)
### precision
precision_tr = confmat_tr[2, 2] / (confmat_tr[2, 2] + confmat_tr[1, 2])
precision_tr
### recall
recall_tr = confmat_tr[2, 2] / (confmat_tr[2, 2] + confmat_tr[2, 1])
recall_tr
### F1
psych::harmonic.mean(c(precision_tr, recall_tr)) %>% round(3)

## c
### no code
### high accuracy, high precision --- model makes low mistakes
### low recall, consequently, low F1 --- model poorly catches the pattern


# 6
## a
## 0.7
predicted_tr07 <- ifelse(predict(model1.8, type = "response") > .7, 1, 0)
confmat_tr07 <- table(heart_train$TenYearCHD, predicted_tr07)

### accuracy
mean(heart_train$TenYearCHD == predicted_tr07)
### precision
precision_tr07 = confmat_tr07[2, 2] / (confmat_tr07[2, 2] + confmat_tr07[1, 2])
precision_tr07
### recall
recall_tr07 = confmat_tr07[2, 2] / (confmat_tr07[2, 2] + confmat_tr07[2, 1])
recall_tr07
### F1
psych::harmonic.mean(c(precision_tr07, recall_tr07)) %>% round(3)

## 0.8
predicted_tr08 <- ifelse(predict(model1.8, type = "response") > .8, 1, 0)
confmat_tr08 <- table(heart_train$TenYearCHD, predicted_tr08)

### accuracy
mean(heart_train$TenYearCHD == predicted_tr08)
### precision
precision_tr08 = confmat_tr08[2, 2] / (confmat_tr08[2, 2] + confmat_tr08[1, 2])
precision_tr08
### recall
recall_tr08 = confmat_tr08[2, 2] / (confmat_tr08[2, 2] + confmat_tr08[2, 1])
recall_tr08
### F1
psych::harmonic.mean(c(precision_tr08, recall_tr08)) %>% round(3)

## 0.9
predicted_tr09 <- ifelse(predict(model1.8, type = "response") > .9, 1, 0)
confmat_tr09 <- table(heart_train$TenYearCHD, predicted_tr09)

### accuracy
mean(heart_train$TenYearCHD == predicted_tr09)
### precision
precision_tr09 = confmat_tr09[2, 2] / (confmat_tr09[2, 2] + confmat_tr09[1, 2])
precision_tr09
### recall
recall_tr09 = confmat_tr09[2, 2] / (confmat_tr09[2, 2] + confmat_tr09[2, 1])
recall_tr09
### F1
psych::harmonic.mean(c(precision_tr09, recall_tr09)) %>% round(3)

## b
psych::harmonic.mean(c(precision_tr, recall_tr)) %>% round(3)
psych::harmonic.mean(c(precision_tr07, recall_tr07)) %>% round(3)
psych::harmonic.mean(c(precision_tr08, recall_tr08)) %>% round(3)
psych::harmonic.mean(c(precision_tr09, recall_tr09)) %>% round(3)


# 7
predicted_test <- ifelse(predict(model1.8, heart_test, type = "response") > 0.6, 1, 0)
mean(predicted_test) %>% round(3)


# 8
## a
confmat_test <- table(heart_test$TenYearCHD, predicted_test)

## accuracy
mean(heart_test$TenYearCHD == predicted_test)
## precision
precision_test = confmat_test[2, 2] / (confmat_test[2, 2] + confmat_test[1, 2])
precision_test
## recall
recall_test = confmat_test[2, 2] / (confmat_test[2, 2] + confmat_test[2, 1])
recall_test
## F1
psych::harmonic.mean(c(precision_test, recall_test)) %>% round(3)

## b
### no code
### accuracy higher which may be because of unbalanced data
### precision, recall and F1 lower that is good bacause of no overfitting


# 9
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

ggplot(data = NULL,
       aes(x = predict(model1.8, type = "response"),
           y = resid(model1.8, type = "pearson"))) +
  geom_point() +
  geom_smooth(method = "loess")

overdisp_fun(model1.8)


# 10
prediction_metrics <- function(data, response, threshold) {
  predicted <- ifelse(response > threshold, 1, 0)
  confmat <- table(data, predicted)
  acc = mean(data == predicted)
  precision = confmat[2, 2] / (confmat[2, 2] + confmat[1, 2])
  recall = confmat[2, 2] / (confmat[2, 2] + confmat[2, 1])
  F1 = psych::harmonic.mean(c(precision, recall))
  return(c(
    accuracy = acc,
    precision = precision,
    recall = recall,
    F1 = F1)
  )
}

prediction_metrics(data = heart_train$TenYearCHD,
                   response = predict(model1, type = "response"),
                   threshold = 0.6)



# ADDITIONAL

# 1


# 2


# 3


# 4


# 5

