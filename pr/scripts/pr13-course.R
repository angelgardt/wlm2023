# pkgs <- c("mgcv", "glmnet")
# install.packages(pkgs[!pkgs %in% installed.packages()])

library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")
library(mgcv)
library(glmnet)

# 1
avocado <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr13/avocado.csv")
str(avocado)
avocado$AveragePrice
table(avocado$a_type)
avocado$Date2
unique(avocado$year)

# 2
avocado %>% 
  filter(region == "Sacramento" & a_type == "organic") -> av_s_org

av_s_org %>% 
  ggplot(aes(Date2, AveragePrice)) +
  geom_point() +
  geom_smooth()

# 3

poly2 <- lm(AveragePrice ~ poly(Date2, 2), av_s_org)

av_s_org %>% 
  ggplot(aes(Date2, AveragePrice)) +
  geom_point() +
  geom_line(aes(y = poly2$fitted.values),
            color = "blue")

# 4

poly3 <- lm(AveragePrice ~ poly(Date2, 3), av_s_org)

av_s_org %>% 
  ggplot(aes(Date2, AveragePrice)) +
  geom_point() +
  geom_line(aes(y = poly3$fitted.values),
            color = "blue")

# 5
poly7 <- lm(AveragePrice ~ poly(Date2, 7), av_s_org)
poly10 <- lm(AveragePrice ~ poly(Date2, 10), av_s_org)
poly20 <- lm(AveragePrice ~ poly(Date2, 20), av_s_org)

# 6

tibble(x = av_s_org$Date2,
       poly2 = poly2$fitted.values,
       poly3 = poly3$fitted.values,
       poly7 = poly7$fitted.values,
       poly10 = poly10$fitted.values,
       poly20 = poly20$fitted.values) %>% 
  pivot_longer(cols = -x) %>% 
  ggplot() +
  geom_point(data = av_s_org,
             aes(Date2, AveragePrice)) +
  geom_line(aes(x = x,
                y = value,
                color = name),
            size = 1) +
  facet_wrap(~ name)


## 7

summary(poly7)


## 8

gam1 <- gam(AveragePrice ~ s(Date2), data = av_s_org)
gam1$fitted.values

av_s_org %>% 
  ggplot(aes(Date2, AveragePrice)) +
  geom_point() +
  geom_line(aes(y = gam1$fitted.values),
            color = "blue") +
  labs(caption = gam1$call)



gam2 <- gam(AveragePrice ~ s(Date2, sp = .05), data = av_s_org)

av_s_org %>% 
  ggplot(aes(Date2, AveragePrice)) +
  geom_point() +
  geom_line(aes(y = gam2$fitted.values),
            color = "blue") +
  labs(caption = gam2$call)


gam3 <- gam(AveragePrice ~ s(Date2, sp = 1), data = av_s_org)

av_s_org %>% 
  ggplot(aes(Date2, AveragePrice)) +
  geom_point() +
  geom_line(aes(y = gam3$fitted.values),
            color = "blue") +
  labs(caption = gam3$call)


gam4 <- gam(AveragePrice ~ s(Date2, k = 20), data = av_s_org)

av_s_org %>% 
  ggplot(aes(Date2, AveragePrice)) +
  geom_point() +
  geom_line(aes(y = gam4$fitted.values),
            color = "blue") +
  labs(caption = gam4$call)

gam5 <- gam(AveragePrice ~ s(Date2, k = 4), data = av_s_org)

av_s_org %>% 
  ggplot(aes(Date2, AveragePrice)) +
  geom_point() +
  geom_line(aes(y = gam5$fitted.values),
            color = "blue") +
  labs(caption = gam5$call)

# 7
summary(gam1)


avocado %>% 
  filter(region == "Sacramento") %>% 
  mutate(a_type = as_factor(a_type)) -> av_s

av_s %>% 
  ggplot(aes(Date2, AveragePrice, color = a_type)) +
  geom_point()

gam6 <- gam(AveragePrice ~ s(Date2) + a_type, data = av_s)

av_s %>% 
  ggplot(aes(Date2, AveragePrice, color = a_type)) +
  geom_point() +
  geom_line(aes(y = gam6$fitted.values))

summary(gam6)


gam7 <- gam(AveragePrice ~ s(Date2, by = a_type), data = av_s)

av_s %>% 
  ggplot(aes(Date2, AveragePrice, color = a_type)) +
  geom_point() +
  geom_line(aes(y = gam7$fitted.values))

summary(gam7)



gam8 <- gam(AveragePrice ~ s(Date2, by = a_type) + a_type, data = av_s)

av_s %>% 
  ggplot(aes(Date2, AveragePrice, color = a_type)) +
  geom_point() +
  geom_line(aes(y = gam8$fitted.values))

summary(gam8)


AIC(gam6, gam7, gam8)
BIC(gam6, gam7, gam8)

par(mfrow = c(2, 2))
gam.check(gam8)

concurvity(gam8)


# 16

cpi <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr13/cpi.csv")
str(cpi)

cpi %>% 
  select(-prodazhi, -group) %>% 
  cor() %>% ggcorrplot::ggcorrplot(lab = TRUE)

# 17
cpi %>% pull(prodazhi) -> prodazhi
cpi %>% select(-prodazhi, -group) %>% as.matrix() -> preds

# 18
model_ridge <- cv.glmnet(x = preds, y = prodazhi, alpha = 0)
par(mfrow = c(1,1))
plot(model_ridge)
coef(model_ridge, s = "lambda.min")
coef(model_ridge, s = "lambda.1se")

# 19
model_lasso <- cv.glmnet(x = preds, y = prodazhi, alpha = 1)
plot(model_lasso)
coef(model_lasso, s = "lambda.min")
coef(model_lasso, s = "lambda.1se")


