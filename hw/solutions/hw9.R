# HW9 // Solutions
# A. Angelgardt

# MAIN

# 1
library(tidyverse)
houses <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/hw9/house_price.csv")
str(houses)
houses %>% sapply(is.na) %>% apply(2, sum)

# 2
model1 <- lm(SalePrice ~ LotArea, houses)
summary(model1)

# 3
plot(model1)

houses %>% 
  ggplot(aes(LotArea, SalePrice)) +
  geom_point() +
  geom_smooth(method = "lm")

# 4
houses %>% 
  filter(SaleCondition == "Normal" | SaleCondition == "Partial" | SaleCondition == "Abnorml") -> houses_cond
nrow(houses_cond)

# 5
model2 <- lm(SalePrice ~ LotArea + SaleCondition, houses_cond)
summary(model2)

# 6
plot(model2)

houses %>% 
  ggplot(aes(LotArea, SalePrice)) +
  geom_point() +
  geom_smooth(method = "lm")

# 7
model3 <- lm(SalePrice ~ LotArea + LotFrontage, houses)
summary(model3)

# 8
car::vif(model3)

# 9
model4 <- lm(SalePrice ~ LotFrontage + LotArea * SaleCondition, houses_cond)
summary(model4)
plot(model4)

# 10
model4.1 <- update(model4, . ~ . -LotArea : SaleCondition)
anova(model4, model4.1)


# ADDITIONAL

# 1
### 250, 336, 314

houses %>% 
  slice(-c(250, 336, 314)) -> houses_noinfluential

model1.1 <- lm(SalePrice ~ LotArea, houses_noinfluential)
summary(model1.1)
plot(model1.1)
Metrics::rmse(houses$SalePrice, model1$fitted.values)
Metrics::rmse(houses_noinfluential$SalePrice, model1.1$fitted.values)

# 2
houses_cond %>% 
  mutate(fitted = model2$fitted.values) %>% 
  ggplot(aes(LotArea, SalePrice, color = SaleCondition)) +
  geom_point() +
  geom_line(aes(y = fitted))

# 3
## code may vary

# 4
## code may vary

### template ###

# report::report(model)
# ## from https://rempsyc.remi-theriault.com/articles/table
# # Gather summary statistics
# stats.table <- as.data.frame(summary(model)$coefficients)
# # Get the confidence interval (CI) of the regression coefficient
# CI <- confint(model)
# # Add a row to join the variables names and CI to the stats
# stats.table <- cbind(row.names(stats.table.2), stats.table, CI)
# # Rename the columns appropriately
# names(stats.table) <- c("Term", "B", "SE", "t", "p", "CI_lower", "CI_upper")
# my_table <- rempsyc::nice_table(stats.table)
# flextable::save_as_docx(my_table, path = "nice_table_mutlreg.docx")

# 5
reg_coef <- function(data, y, X) {
  data %>% select(all_of(X), all_of(y)) %>% drop_na() -> data_
  data_ %>% pull(y) -> y_
  data_ %>% select(all_of(X)) %>% as.matrix() %>% cbind(matrix(1, nrow = nrow(data_)), .) -> X_
  return(solve(t(X_) %*% X_) %*% t(X_) %*% y_)
}
reg_coef(data = houses,
         y = "SalePrice",
         X = c("LotArea", "LotFrontage"))
lm(SalePrice ~ LotArea + LotFrontage, houses)
