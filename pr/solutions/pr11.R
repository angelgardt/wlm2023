### P11 // Solutions
### A. Angelgardt

# MAIN


# 1
## a
share <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr11/share.csv")
## b
str(share)
## c
share %>% 
  filter(trialtype != "both" & correct1) %>% 
  mutate(setsize = as_factor(setsize)) -> share


# 2
share %>% 
  summarise(rt = mean(time1),
            .by = c(id, trialtype, setsize, platform)) -> share_agg


# 3
share_agg %>% 
  summarise(means = mean(rt),
            .by = platform)
model_ind <- lm(rt ~ platform, share_agg)
model_ind
summary(model_ind)

# 4
share_agg %>% 
  summarise(means = mean(rt),
            .by = platform)
share_agg$rt %>% mean()

model_eff <- lm(rt ~ platform, share_agg,
                contrasts = list(platform = contr.sum))
model_eff
summary(model_eff)

# 1.70776 + 0.05974
# 1.70776 - 0.05974


# 5
oneway_aov <- aov(rt ~ platform, share_agg)
summary(oneway_aov)


# 6
## a
summary(model_ind)
summary(model_eff)
summary(oneway_aov)

## b
t.test(rt ~ platform, share_agg)


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
        wid = id,
        detailed = TRUE)


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
ez_mix <- ezANOVA(data = share_agg,
                  dv = rt,
                  between = platform,
                  within = .(setsize, trialtype),
                  wid = id,
                  return_aov = TRUE,
                  detailed = TRUE)

ez_mix %>% psychReport::aovEffectSize()


# 14
pairwise.t.test(x = share_agg$rt,
                g = interaction(share_agg$trialtype, share_agg$setsize),
                paired = TRUE)


# 15
pd <- position_dodge(.5)
share_agg %>% 
  ggplot(aes(setsize, rt, 
             color = trialtype, 
             shape = platform,
             group = interaction(trialtype, platform))) +
  stat_summary(geom = "line", fun = mean,
               linetype = "dashed", position = pd) +
  stat_summary(geom = "pointrange", fun.data = mean_cl_boot, position = pd)


# 16
summary(aov(rt ~ platform, share_agg))
summary(aov(time1 ~ platform, share))


# 17
## a
fev <- read_tsv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr11/fev.txt")
str(fev)

## b
fev_ind <- lm(FEV ~ Smoker * Sex, fev)
fev_eff <- lm(FEV ~ Smoker * Sex, fev,
              contrasts = list(Smoker = "contr.sum",
                               Sex = "contr.sum"))

## c
table(fev$Smoker)
table(fev$Sex)

## d
car::Anova(fev_ind, type = "II")
car::Anova(fev_eff, type = "II")
car::Anova(fev_ind, type = "III")
car::Anova(fev_eff, type = "III")


# 18
fev %>% 
  ggplot(aes(Smoker, FEV)) +
  stat_summary(geom = "pointrange", fun.data = mean_cl_boot)

fev %>% 
  ggplot(aes(Height, FEV, color = Smoker)) +
  geom_point() +
  geom_smooth(method = "lm")


# 19
fev_cov <- lm(FEV ~ Smoker * Height, fev)
drop1(fev_cov, test = "F", type = "III")
fev_cov1 <- update(fev_cov, .~. -Smoker:Height)
drop1(fev_cov1, test = "F", type = "III")


# 20
report::report(oneway_aov)
report::report(ez_mix$aov)
apaTables::apa.aov.table(oneway_aov, filename = "oneway.doc")
apaTables::apa.ezANOVA.table(ez_mix)
ez_mix %>% psychReport::aovEffectSize() %>% .$ANOVA %>% write_excel_csv("ez_mix.xlsx")



# ADDITIONAL

# 1
vowels <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr11/vowels.csv")

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
summary(reduction_conts)
summary(reduction_conts,
        split = list(reduction = list("no vs other" = 1)))


# 6
levels(vowels$reduction)
no_vs_other <- c(-.5, 1, -.5)
no_vs_first <- c(-1, 1, 0)
cont_mat <- cbind(no_vs_other, no_vs_first)
contrasts(vowels$reduction) <- cont_mat


# 7
reduction_contr2 <- aov(duration ~ reduction, vowels)
summary(reduction_conts2)
summary(reduction_conts2,
        split = list(reduction = list("no vs other" = 1,
                                      "no vs first" = 2)))


# 8
levels(vowels$position)
contrasts(vowels$position) <- c(0, 0, .5, -1, 0, .5)


# 9
position_contr <- aov(duration ~ position, vowels)
summary(position_contr)
summary(position_contr,
        split = list(position = list("F vs T+O" = 1)))


# 10
levels(vowels$position)
contrasts(vowels$position) <- c(0, -1, .5, 0, .5, 0)
position_contr2 <- aov(duration ~ position, vowels)
summary(position_contr)
summary(position_contr,
        split = list(position = list("S vs R+T" = 1)))
