### P10 // Solutions
### A. Angelgardt

# MAIN

install.packages(c("Metrics", "rempsyc", "flextable"))

# 1
library(tidyverse)
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
# Gather summary statistics
stats.table <- as.data.frame(summary(model1)$coefficients)
# Get the confidence interval (CI) of the regression coefficient
CI <- confint(model1)
# Add a row to join the variables names and CI to the stats
stats.table <- cbind(row.names(stats.table), stats.table, CI)
# Rename the columns appropriately
names(stats.table) <- c("Term", "B", "SE", "t", "p", "CI_lower", "CI_upper")
my_table <- rempsyc::nice_table(stats.table)
flextable::save_as_docx(my_table, path = "nice_tablehere.docx")

# 9

# 10

# 11

# 12

# 13

# 14

# 15

# 16

# 17

# 18

# 19

# 20



# ADDITIONAL

# 1
car::ncvTest(model1) # heteroscedasticity

# 2

# 3

# 4

# 5

# 6

# 7

# 8

# 9

# 10
