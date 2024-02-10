### P10 // Solutions
### A. Angelgardt

# MAIN

# install.packages(c("Metrics", "rempsyc", "flextable", "car))

# 1
library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")

managers <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr10/managers_reg.csv")
str(managers)

# 2
sapply(managers, class)
managers %>% select_if(is.numeric) %>% cor() # %>% ggcorrplot::ggcorrplot()

# 3
model1 <- lm(fot ~ grade_score, managers)
summary(model1)

# 4
cor(managers$fot, managers$grade_score)^2

# 5
par(mfrow = c(2,2))
plot(model1)

# 6
par(mfrow = c(1,1))
model1$residuals %>% hist()
plot(managers$grade_score, model1$residuals)

# 7
mean(model1$residuals^2) # MSE
Metrics::mse(managers$fot, model1$fitted.values)
sqrt(mean(model1$residuals^2)) # RMSE
Metrics::rmse(managers$fot, model1$fitted.values)
mean(abs(model1$residuals))
Metrics::mae(managers$fot, model1$fitted.values)
mean(abs((managers$fot - model1$fitted.values) / managers$fot))
Metrics::mape(managers$fot, model1$fitted.values)

# 8
report::report(model1)
apaTables::apa.reg.table(model1, filename = "simple_reg.doc")

## from https://rempsyc.remi-theriault.com/articles/table
# Gather summary statistics
stats.table <- as.data.frame(summary(model1)$coefficients)
# Get the confidence interval (CI) of the regression coefficient
CI <- confint(model1)
# Add a row to join the variables names and CI to the stats
stats.table <- cbind(row.names(stats.table), stats.table, CI)
# Rename the columns appropriately
names(stats.table) <- c("Term", "B", "SE", "t", "p", "CI_lower", "CI_upper")
my_table <- rempsyc::nice_table(stats.table)
flextable::save_as_docx(my_table, path = "nice_table_reg.docx")

# 9
managers %>% 
  ggplot(aes(grade_score, fot)) +
  geom_point() +
  geom_smooth(method = "lm")

managers %>% 
  ggplot(aes(grade_score, fot, color = region)) +
  geom_point() +
  geom_smooth(method = "lm")

# 10
model2 <- lm(fot ~ grade_score + region, managers)
summary(model2)

# 11
Metrics::mse(managers$fot, model1$fitted.values)
Metrics::mse(managers$fot, model2$fitted.values)
Metrics::mape(managers$fot, model1$fitted.values)
Metrics::mape(managers$fot, model2$fitted.values)

# 12
par(mfrow = c(2,2))
plot(model2)

# 13
model3 <- lm(fot ~ grade_score * region, managers)
summary(model3)

# 14
par(mfrow = c(2,2))
plot(model3)

# 15
Metrics::mse(managers$fot, model2$fitted.values)
Metrics::mse(managers$fot, model3$fitted.values)
Metrics::mape(managers$fot, model2$fitted.values)
Metrics::mape(managers$fot, model3$fitted.values)
anova(model2, model3)

# 16
report::report(model3)
## from https://rempsyc.remi-theriault.com/articles/table
# Gather summary statistics
stats.table.2 <- as.data.frame(summary(model3)$coefficients)
# Get the confidence interval (CI) of the regression coefficient
CI2 <- confint(model3)
# Add a row to join the variables names and CI to the stats
stats.table.2 <- cbind(row.names(stats.table.2), stats.table.2, CI2)
# Rename the columns appropriately
names(stats.table.2) <- c("Term", "B", "SE", "t", "p", "CI_lower", "CI_upper")
my_table_2 <- rempsyc::nice_table(stats.table.2)
flextable::save_as_docx(my_table_2, path = "nice_table_mutlreg.docx")

# 17
car_price <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr10/CarPrice_Assignment.csv")
str(car_price)
summary(car_price)
car_price %>% select_if(is.numeric) %>% cor() %>% ggcorrplot::ggcorrplot(colors = c("red", "white", "blue"), lab = TRUE)
car_price %>% select_if(is.numeric) %>% select(-car_ID, -symboling) -> car_price_num

# 18
model4 <- lm(price ~ ., car_price_num)
summary(model4)

# 19
car::vif(model4)
model4.1 <- update(model4, . ~ . -highwaympg)
summary(model4.1)
car::vif(model4.1)

# 20
model4.2 <- update(model4.1, . ~ . -curbweight)
summary(model4.2)
car::vif(model4.2)
model4.3 <- update(model4.2, . ~ . -boreratio)
drop1(model4.3, test = "F")
model4.4 <- update(model4.3, . ~ . -boreratio)
drop1(model4.4, test = "F")
model4.5 <- update(model4.4, . ~ . -wheelbase)
drop1(model4.5, test = "F")
model4.6 <- update(model4.5, . ~ . -carlength)
drop1(model4.6, test = "F")
model4.7 <- update(model4.6, . ~ . -carheight)
drop1(model4.7, test = "F")
model4.8 <- update(model4.7, . ~ . -citympg)
drop1(model4.8, test = "F")
car::vif(model4.8)
plot(model4.8)
summary(model4.8)
anova(model4, model4.8)

# ADDITIONAL

# 1
model5 <- lm(price ~ horsepower * citympg, car_price_num)
summary(model5)

# 2
plot(model5)
car::ncvTest(model5) # heteroscedasticity

# 3
car_price %>% 
  ggplot(aes(horsepower, price, color = carbody)) +
  geom_point() +
  geom_smooth(method = "lm")

model6 <- lm(price ~ horsepower * carbody, car_price)
summary(model6)

# 4
AIC(model4.8)
AIC(model6)
BIC(model4.8)
BIC(model6)

# 5

## sexy diagnostic plots

# 6

## separate dataset

# 7

## prediction

# 8



# 9

# 10
