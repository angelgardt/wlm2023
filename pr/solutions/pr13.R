### P13 // Solutions
### A. Angelgardt

# MAIN

# 1
avocado <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr13/avocado.csv")
str(avocado)

# 2
## a
avocado %>% 
  filter(region == "Sacramento" & a_type == "organic") -> av_s_org

## b
av_s_org %>% 
  ggplot(aes(Date2, AveragePrice)) +
  geom_point() +
  # geom_smooth(method = "lm")
  # geom_smooth(method = "gam")
  geom_smooth()

# 3
## a
poly2 <- lm(AveragePrice ~ poly(Date2, 2), av_s_org)

## b
av_s_org %>% 
  ggplot(aes(Date2, AveragePrice)) +
  geom_point() +
  geom_line(aes(y = poly2$fitted.values), 
            color = "blue")

# 4
## a
poly3 <- lm(AveragePrice ~ poly(Date2, 3), av_s_org)

## b
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
            size = 1)

# 7
summary(poly7)

# 8
gam1 <- gam(AveragePrice ~ s(Date2), data = av_s_org)
av_s_org %>% 
  ggplot(aes(Date2, AveragePrice)) +
  geom_point() +
  geom_line(aes(y = gam1$fitted.values), 
            color = "blue") +
  labs(caption = gam1$call)

# 9
gam2 <- gam(AveragePrice ~ s(Date2, sp = .1), 
            data = av_s_org)
av_s_org %>% 
  ggplot(aes(Date2, AveragePrice)) +
  geom_point() +
  geom_line(aes(y = gam2$fitted.values), 
            color = "blue") +
  labs(caption = gam2$call)

gam3 <- gam(AveragePrice ~ s(Date2, sp = 1), 
            data = av_s_org)
av_s_org %>% 
  ggplot(aes(Date2, AveragePrice)) +
  geom_point() +
  geom_line(aes(y = gam3$fitted.values), 
            color = "blue") +
  labs(caption = gam3$call)

gam4 <- gam(AveragePrice ~ s(Date2, k = 20), 
            data = av_s_org)
av_s_org %>% 
  ggplot(aes(Date2, AveragePrice)) +
  geom_point() +
  geom_line(aes(y = gam4$fitted.values), 
            color = "blue") +
  labs(caption = gam4$call)

gam5 <- gam(AveragePrice ~ s(Date2, k = 4), 
            data = av_s_org)
av_s_org %>% 
  ggplot(aes(Date2, AveragePrice)) +
  geom_point() +
  geom_line(aes(y = gam5$fitted.values), 
            color = "blue") +
  labs(caption = gam5$call)

# 10
summary(gam1)

# 11
## a
avocado %>% 
  filter(region == "Sacramento") %>% 
  mutate(
    a_type = factor(a_type)
  ) -> avocado_sacr
## b

avocado_sacr %>% 
  ggplot(aes(Date2, AveragePrice, color = a_type)) +
  geom_point()

# 12
gam6 <- gam(AveragePrice ~ s(Date2) + a_type, 
            data = avocado_sacr)

tibble(x = avocado_sacr$Date2,
       a_type = avocado_sacr$a_type,
       y = gam6$fitted.values) %>% 
  ggplot() +
  geom_point(data = avocado_sacr,
             aes(Date2, AveragePrice, color = a_type)) +
  geom_line(aes(x = x, y = y, color = a_type))

summary(gam6)

# 13
gam7 <- gam(AveragePrice ~ s(Date2, by = a_type),
            data = avocado_sacr)

tibble(x = avocado_sacr$Date2,
       a_type = avocado_sacr$a_type,
       y = gam7$fitted.values) %>% 
  ggplot() +
  geom_point(data = avocado_sacr,
             aes(Date2, AveragePrice, color = a_type)) +
  geom_line(aes(x = x, y = y, color = a_type))

summary(gam7)

# 14
gam8 <- gam(AveragePrice ~ s(Date2, by = a_type) + a_type,
            data = avocado_sacr)

tibble(x = avocado_sacr$Date2,
       a_type = avocado_sacr$a_type,
       y = gam8$fitted.values) %>% 
  ggplot() +
  geom_point(data = avocado_sacr,
             aes(Date2, AveragePrice, color = a_type)) +
  geom_line(aes(x = x, y = y, color = a_type))

summary(gam8)

# 15
## a
AIC(gam6, gam7, gam8)
BIC(gam6, gam7, gam8)

## b
gam.check(gam8)

## c
concurvity(gam8)

# 16
cpi <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr13/cpi.csv")
str(cpi)
table(cpi$group)

# 17
cpi %>% pull(prodazhi) -> prodazhi
cpi %>% select(-prodazhi, -group) %>% as.matrix() -> preds
cor(preds) %>% ggcorrplot::ggcorrplot(lab = TRUE)

# 18
model_ridge <- cv.glmnet(x = preds, y = prodazhi, alpha = 0)
plot(model_ridge)
coef(model_ridge, s = "lambda.min")
coef(model_ridge, s = "lambda.1se")

# 19
model_lasso <- cv.glmnet(x = preds, y = prodazhi, alpha = 1)
plot(model_lasso)
coef(model_lasso, s = "lambda.min")
coef(model_lasso, s = "lambda.1se")

# 20



# ADDITIONAL

# 1

# 2

# 3

# 4

# 5

# 6

# 7

# 8

# 9

# 10
