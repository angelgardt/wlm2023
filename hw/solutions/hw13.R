# HW13 // Solutions
# A. Angelgardt

# MAIN

library(tidyverse)
library(lme4)
library(lmerTest)

# 1
laptops <- read_csv("https://raw.githubusercontent.com/angelgardt/da-2023-ranepa/master/data/laptop_price.csv")
str(laptops)

laptops %>% 
  mutate(Ram = Ram %>% 
           str_remove("GB") %>% 
           as.numeric(),
         Weight = Weight %>% 
           str_remove("kg") %>% 
           as.numeric()
         ) -> laptops

# 2

## code may vary

# 3
model1 <- lmer(Price_euros ~ Inches + (1|Company), laptops)

# 4
model0 <- lmer(Price_euros ~ 1 + (1|Company), laptops)
anova(model0, model1, test = "Chi")
summary(model1)
anova(model1)

# 5
# laptops$Ram %>% unique()
model2 <- lmer(Price_euros ~ Inches + Ram + (1|Company), laptops)

# 6
anova(model1, model2, test = "Chi")
## model2 significantly differs from model1

# 7
summary(model2)
anova(model2)
## Inches coefficient changed their sign coz of new predictor

# 8
## a
# laptops$TypeName %>% unique()
model3 <- lmer(Price_euros ~ Inches + Ram + (1|Company) + (1|TypeName), laptops)

## b
summary(model3)
## Inches coef lost their significance coz new random effect cautch some variance

# 9
anova(model2, model3, test = "Chi", refit = FALSE)

# 10
res <- tibble(
  laptops,
  fitted = fitted(model3),
  resid = resid(model3, type = 'pearson'),
  sresid = resid(model3, type = 'pearson', scaled = TRUE)
)
gg_res <- ggplot(res, aes(y = sresid)) +
  geom_hline(yintercept = 0)
gg_res + geom_point(aes(x = fitted))
gg_res + geom_boxplot(aes(x = Company))
gg_res + geom_boxplot(aes(x = TypeName))


# ADDITIONAL

# 1


# 2


# 3


# 4


# 5

