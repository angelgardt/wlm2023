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
par(mfrow = c(2, 2))
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

houses_cond %>% 
  ggplot(aes(LotArea, SalePrice, color = SaleCondition)) +
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
drop1(model4, test = "F")
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
  mutate(fitted = model2$fitted.values) %>% # colnames()
  ggplot(aes(LotArea, SalePrice, color = SaleCondition)) +
  geom_point(alpha = .3) +
  geom_line(aes(y = fitted), size = 2)

# 3
## code may vary

# 4
## code may vary
# report::report(model1)
# apaTables::apa.reg.table(model1, filename = "simple_reg.doc")

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
