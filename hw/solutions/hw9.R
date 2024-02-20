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


# 5


# 6


# 7


# 8


# 9


# 10



# ADDITIONAL

# 1


# 2


# 3


# 4


# 5

