### P17 // Solutions
### A. Angelgardt


# MAIN

# pkgs <- c("lavaan", "semPlot", "googlesheets4")
# install.packages(pkgs[!pkgs %in% installed.packages()])

library(tidyverse)
library(lavaan)
library(semPlot)
library(googlesheets4)

# 1
tolunc <- read_csv2("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr17/tolerance_uncertainty.csv")
str(tolunc)


# 2
tolunc %>% select(-sex, -age) -> tu
cor(tu) %>% ggcorrplot::ggcorrplot(lab = TRUE)


# 3
tu_mdl <- "TU =~ tu1 + tu2 + tu3 + tu4 + tu5 + tu6 + tu7 + tu8 + tu9 + tu10 + tu11 + tu12 + tu13 + tu14 + tu15 + tu16 + tu17 + tu18 + tu19 + tu20 + tu21 + tu22"
tu_model <- cfa(tu_mdl, tu)
summary(tu_model)


# 4
fitmeasures(tu_model, c("GFI", "AGFI", "CFI", "TLI", "SRMR", "RMSEA"))
s_tu <- standardizedsolution(tu_model)

s_tu %>% filter(op == "=~")
s_tu %>% filter(op == "~~")


# 5
resid(tu_model, type = "cor")


# 6
modindices(tu_model) %>% arrange(desc(mi))


# 7
semPaths(tu_model, "std")


# 8
taia <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr17/taia.csv")
str(taia)
taia %>% select(matches("^(pr|co|ut|fa|de|un)\\d{2}$")) -> taia_items
cor(taia_items) %>% ggcorrplot::ggcorrplot()


# 9
mdl1 <- "
PR =~ pr01 + pr02 + pr03 + pr04 + pr05 + pr06 + pr07 + pr08 + pr09 + pr10
CO =~ co01 + co02 + co03 + co04 + co05 + co06 + co08 + co09 + co10
UT =~ ut01 + ut02 + ut03 + ut04 + ut05 + ut06 + ut07 + ut08 + ut09 + ut11 + ut12
FA =~ fa01 + fa02 + fa03 + fa04 + fa05 + fa06 + fa07 + fa08 + fa09 + fa10
DE =~ de01 + de02 + de03 + de05 + de06 + de07 + de08 + de09 + de10 + de11
UN =~ un01 + un02 + un03 + un04 + un05 + un06 + un07 + un08 + un09 + un10 + un11 + un12
"
model1 <- cfa(mdl1, taia_items)
summary(model1)


# 10
fitmeasures(model1, c("CFI", "TLI", "SRMR", "RMSEA"))


# 11
smodel1 <- standardizedsolution(model1)

smodel1 %>% filter(op == "=~") %>% filter(est.std < .4)
smodel1 %>% filter(op == "~~" & lhs != rhs)
smodel1 %>% filter(op == "~~" & lhs == rhs)


# 12
inspect(model1, "std")$lambda


# 13
semPaths(model1, "std")


# 14
mdl2 <- "
PR =~ pr01 + pr02 + pr05 + pr06 + pr07 + pr08 + pr09 + pr10
CO =~ co01 + co02 + co03 + co05 + co06 + co09 + co10
UT =~ ut01 + ut02 + ut03 + ut04 + ut05 + ut06 + ut07 + ut08 + ut09 + ut11 + ut12
FA =~ fa01 + fa02 + fa05 + fa06 + fa09 + fa10
DE =~ de01 + de02 + de03 + de05 + de06 + de07 + de08 + de11
UN =~ un01 + un02 + un03 + un04 + un05 + un06 + un07 + un08 + un09 + un10 + un11 + un12
TAIA =~ PR + CO + UT + FA + DE + UN
"
model2 <- cfa(mdl2, taia_items)
summary(model2)


# 15
fitmeasures(model2, c("CFI", "TLI", "SRMR", "RMSEA"))

smodel2 <- standardizedsolution(model2)

smodel2 %>% filter(op == "=~")
smodel2 %>% filter(op == "~~" & lhs != rhs)
smodel2 %>% filter(op == "~~" & lhs == rhs)


# 16
mi2 <- modindices(model2) %>% arrange(desc(mi))
mi2 %>% filter(op == "~~" & str_detect(lhs, "^[:lower:]")) %>% filter(mi > 10)
mi2 %>% filter(op == "~~" & str_detect(lhs, "^[:upper:]")) # %>% select(1:3)
mi2 %>% filter(op == "=~")


# 17
taia_questions <- read_sheet("https://docs.google.com/spreadsheets/d/1om__1JaQYuhBSUdx6ulWjvGu1_jvG9e87IDL99i5USg/edit#gid=0")
str(taia_questions)


# 18
semPaths(model2, "std")


# 19
mdl3 <- "
PR =~ pr01 + pr02 + pr05 + pr06 + pr07 + pr08 + pr09 + pr10
CO =~ co01 + co02 + co03 + co05 + co06 + co09 + co10
UT =~ ut01 + ut02 + ut03 + ut04 + ut05 + ut06 + ut07 + ut08 + ut09 + ut11 + ut12
FA =~ fa01 + fa02 + fa05 + fa06 + fa09 + fa10
DE =~ de01 + de02 + de03 + de05 + de06 + de07 + de08 + de11
UN =~ un01 + un02 + un03 + un04 + un05 + un06 + un07 + un08 + un09 + un10 + un11 + un12
TAIA =~ PR + CO + UT + FA + DE + UN
FA ~~  UN
CO ~~  UT
PR ~~  UT
"
model3 <- cfa(mdl3, taia_items)
summary(model3)


# 20
anova(model2, model3, test = "Chi")



# ADDITIONAL

# 1
## sample sizes

### correlation
pwr::pwr.r.test(r = 0.2, sig.level = 0.05, power = 0.8)

### regression
## 0.02=small, 0.15=medium, and 0.35 large effect sizes
# u is a number of predictors
pwr::pwr.f2.test(u = 1, f2 = sqrt(0.6), sig.level = 0.05, power = 0.8) # 10 + 2 = 12
pwr::pwr.f2.test(u = 3, f2 = sqrt(0.3), sig.level = 0.05, power = 0.8) # 20 + 4 = 24

### ANOVA
# f = sqrt(etasq / (1 - etasq))
pwr::pwr.anova.test(k = 2, f = sqrt(0.14 / (1 - 0.14)), sig.level = 0.05, power = 0.8)
WebPower::wp.rmanova(f = 0.25, ng = 1, nm = 3, nscor = 1, alpha = 0.05, power = 0.8, type = 1)

### logistic
# p0= Prob(Y=1|X=0): the probability of observing 1 for the outcome variable Y when the predictor X equals 0
# p1= Prob(Y=1|X=1): the probability of observing 1 for the outcome variable Y when the predictor X equals 1
WebPower::wp.logistic(p0=0.15, p1=0.25, alpha=0.05, power=0.80, alternative="two.sided", family="normal")

### poisson
# exp0= the base rate under the null hyp.(must be positive value)
# exp1= the relative increase of the event rate. It is used for calculation of the effect size
WebPower::wp.poisson(exp0=1.0, exp1=0.80, alpha=0.05, power=0.80, alternative ="less", family="uniform")

### GAM

### mixed
## 20 наблюдений на каждый параметр



# 2

# 3

# 4

# 5

# 6

# 7

# 8

# 9

# 10
