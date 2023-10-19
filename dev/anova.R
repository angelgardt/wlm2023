library(tidyverse)
theme_set(theme_bw())

## Sim data
set.seed(123)
tibble(iv1_gr1.iv2_gr1 = rnorm(100, 30, 30),
       iv1_gr1.iv2_gr2 = rnorm(100, 5, 10),
       iv1_gr2.iv2_gr2 = rnorm(100, 50, 20),
       iv1_gr2.iv2_gr1 = rnorm(100, 1, 15)) %>% 
  pivot_longer(cols = everything(),
               values_to = "dv") %>%
  separate(name, into = c("iv1", "iv2"), sep = "\\.") %>% 
  mutate(wid = paste0("w", rep(1:200, each = 2))) %>%
  mutate(id = 1:400) -> ds

ds %>% 
  ggplot() +
  stat_summary(aes(iv1, dv, color = iv2), 
               fun.data = mean_cl_boot, 
               geom = "pointrange") +
  stat_summary(data = ds %>% select(-iv2), 
               aes(iv1, dv), 
               fun.data = mean_cl_boot, 
               geom = "pointrange", 
               alpha = .5) +
  stat_summary(data = ds %>% select(-iv1), 
               aes(1.5, dv, color = iv2), 
               fun.data = mean_cl_boot, 
               geom = "pointrange", 
               alpha = .5)


## Null Model
lm0 <- lm(dv ~ 1, ds)
summary(lm0)
aov0 <- aov(dv ~ 1, ds)
summary(aov0)


## Model one effect
lm1 <- lm(dv ~ iv1, ds)
summary(lm1)
aov1 <- aov(dv ~ iv1, ds)
summary(aov1)
anova(lm1)
anova(lm0, lm1) # ?????


## Model two effects
lm2 <- lm(dv ~ iv1 + iv2, ds)
lm2.1 <- lm(dv ~ iv2, ds)
summary(lm2)
aov2 <- aov(dv ~ iv1 + iv2, ds)
summary(aov2)
anova(aov2)
anova(lm2.1, lm2)
anova(lm1, lm2)


## Model with interaction
lm3 <- lm(dv ~ iv1*iv2, ds)
summary(lm3)
aov3 <- aov(dv ~ iv1*iv2, ds)
summary(aov3)
anova(aov3)
anova(lm0, lm1, lm2, lm3)
