library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")
library(ez)

# 1
share <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr11/share.csv")
str(share)

unique(share$setsize)
unique(share$trialtype)

share %>% 
  filter(trialtype != "both" & correct1) %>% 
  mutate(setsize = as_factor(setsize)) -> share

# 2
share %>% 
  summarise(rt = mean(time1),
            .by = c(id, trialtype, setsize, platform)) -> share_agg

# 3
model_ind <- lm(rt ~ platform, share_agg)
summary(model_ind)
model_ind

share_agg %>% 
  summarise(mean(rt),
            .by = platform)

# 4
model_eff <- lm(rt ~ platform, share_agg,
                contrasts = list(platform = "contr.sum"))
model_eff
mean(share_agg$rt)
1.70776 + 0.05974
1.70776 - 0.05974


# 5
oneway_aov <- aov(rt ~ platform, share_agg)
summary(oneway_aov)

# 6
summary(model_ind)
summary(model_eff)
summary(oneway_aov)

# anova()

t.test(rt ~ platform, share_agg)
2.0063 ^ 2

# 7 
anova(model_ind)
anova(model_eff)

# 8
TukeyHSD(oneway_aov)

# 9
share_agg %>% 
  ggplot(aes(platform, rt)) +
  stat_summary(geom = "pointrange", fun.data = mean_cl_boot)

# 10
ezANOVA(data = share_agg,
        dv = rt,
        within = setsize,
        wid = id)

# 11
pairwise.t.test(x = share_agg$rt,
                g = share_agg$setsize,
                paired = TRUE,
                p.adjust.method = "bonf")

# 12
share_agg %>% 
  ggplot(aes(setsize, rt, group = 1)) +
  stat_summary(geom = "line", fun = mean,
               linetype = "dashed") +
  stat_summary(geom = "pointrange", fun.data = mean_cl_boot)

# 13
ez_mix <- ezANOVA(
  data = share_agg,
  dv = rt,
  between = platform,
  within = .(setsize, trialtype),
  wid = id,
  return_aov = TRUE,
  detailed = TRUE
)

ez_mix %>% psychReport::aovEffectSize()


# 14
pairwise.t.test(x = share_agg$rt,
                g = interaction(share_agg$trialtype, share_agg$setsize),
                paired = TRUE)

# 15
pd <- position_dodge(.5)
share_agg %>% 
  ggplot(aes(setsize,
             rt,
             color = trialtype,
             shape = platform,
             group = interaction(trialtype, platform))) +
  stat_summary(geom = "line", fun = mean,
               position = pd, linetype = "dashed") +
  stat_summary(geom = "pointrange", fun.data = mean_cl_boot,
               position = pd)

# 16
oneway_aov <- aov(rt ~ platform, share_agg)
summary(oneway_aov)

oneway_aov_2 <- aov(time1 ~ platform, share)
summary(oneway_aov_2)


# 17

fev <- read_tsv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr11/fev.txt")
str(fev)

fev_ind <- lm(FEV ~ Smoker * Sex, fev)
fev_eff <- lm(FEV ~ Smoker * Sex, fev,
              contrasts = list(Smoker = "contr.sum",
                               Sex = "contr.sum"))

table(fev$Smoker)
table(fev$Sex)


car::Anova(fev_ind, type = "II")
car::Anova(fev_eff, type = "II")
car::Anova(fev_ind, type = "III")
car::Anova(fev_eff, type = "III")

# 18

fev %>% 
  ggplot(aes(Smoker, FEV)) +
  stat_summary(geom = "pointrange", fun.data = mean_cl_boot)

fev %>% 
  ggplot(aes(Height, FEV,
             color = Smoker)) +
  geom_point() +
  geom_smooth(method = "lm")


# 19
fev_cov <- lm(FEV ~ Smoker * Height, fev)
drop1(fev_cov, test = "F", type = "III")
fev_cov1 <- update(fev_cov, .~. -Smoker:Height)
drop1(fev_cov1, test = "F", type = "III")


# 20
report::report(oneway_aov)
# report::report(ez_mix$aov) ????
apaTables::apa.aov.table(oneway_aov)
apaTables::apa.ezANOVA.table(ez_mix)
ez_mix %>% psychReport::aovEffectSize() %>% .$ANOVA %>% write_excel_csv("ez_mix.xlsx")

## ADDITIONAL

## 1
vowels <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr11/vowels.csv")

unique(vowels$position)

vowels %>% 
  mutate(reduction = as_factor(reduction),
         position = as_factor(position)) -> vowels


# 2
vowels %>% 
  ggplot(aes(reduction, duration)) +
  stat_summary(geom = "pointrange", fun.data = mean_cl_boot)


# 3
vowels %>% 
  ggplot(aes(reduction, duration, color = position)) +
  stat_summary(geom = "pointrange", fun.data = mean_cl_boot,
               position = position_dodge(.3))

# 4
levels(vowels$reduction)
contrasts(vowels$reduction) <- c(-.5, 1, -.5)

# 5

reduction_contr <- aov(duration ~ reduction, vowels)
summary(reduction_contr)
summary(reduction_contr,
        split = list(reduction = list("no vs other" = 1)))

# 6 

levels(vowels$reduction)
no_vs_other <- c(-.5, 1, -.5)
no_vs_first <- c(-1, 1, 0)
contr_mat <- cbind(no_vs_other, no_vs_first)
contrasts(vowels$reduction) <- contr_mat

# 7
reduction_contr2 <- aov(duration ~ reduction, vowels)
summary(reduction_contr2,
        split = list(reduction = list("no vs other" = 1,
                                      "no vs first" = 2)))
