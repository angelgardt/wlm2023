# pkgs <- c("lavaan", "semPlot", "googlesheets4", "WebPower")
# install.packages(pkgs[!pkgs %in% installed.packages()])

# https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr17/tolerance_uncertainty.csv
# https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr17/taia.csv


library(tidyverse)
library(lavaan)
library(semPlot)
library(googlesheets4)


tolunc <- read_csv2("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr17/tolerance_uncertainty.csv")
str(tolunc)
View(tolunc)

tolunc %>% select(-sex, -age) -> tu
cor(tu) %>% ggcorrplot::ggcorrplot(lab = TRUE)


tu_mdl <- "TU =~ tu1 + tu2 + tu3 + tu4 + tu5 + tu5 + tu6 + tu7 + tu8 + tu9 + tu10 + tu11 + tu12 + tu13 + tu14 + tu15 + tu16 + tu17 + tu18 + tu19 + tu20 + tu21 + tu22"
tu_model <- cfa(tu_mdl, tu)
summary(tu_model)


fitmeasures(tu_model, c("GFI", "AGFI", "CFI", "TLI", "SRMR", "RMSEA"))

tibble(metric = c("GFI", "AGFI", "CFI", "TLI", "SRMR", "RMSEA"),
       value = fitmeasures(tu_model, c("GFI", "AGFI", "CFI", "TLI", "SRMR", "RMSEA"))) %>% 
  pivot_wider(values_from = value, names_from = metric)


s_tu <- standardizedsolution(tu_model)

s_tu %>% filter(op == "=~")
s_tu %>% filter(op == "~~")


resid(tu_model, type = "cor")

# modificationindices()
modindices(tu_model) %>% arrange(desc(mi))


semPaths(tu_model, "std")


taia <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr17/taia.csv")
str(taia)

taia %>% select(matches("^(pr|co|ut|fa|de|un)\\d{2}$")) -> taia_items

cor(taia_items) %>% ggcorrplot::ggcorrplot()


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


fitmeasures(model1, c("cfi", "tli", "srmr", "rmsea"))

smodel1 <- standardizedsolution(model1)

smodel1 %>% filter(op == "=~") %>% # View()
  # filter(pvalue > .05)
  filter(est.std < .4)

smodel1 %>% filter(op == '~~' & lhs == rhs)
smodel1 %>% filter(op == '~~' & lhs != rhs)


inspect(model1, "std")$lambda

semPaths(model1, "std")


mdl2 <- "
PR =~ pr01 + pr02 + pr05 + pr06 + pr07 + pr08 + pr09 + pr10 
CO =~ co01 + co02 + co03 + co05 + co06 + co09 + co10
UT =~ ut01 + ut02 + ut03 + ut04 + ut05 + ut06 + ut07 + ut08 + ut09 + ut11 + ut12
FA =~ fa01 + fa02 + fa05 + fa06 + fa09 + fa10
DE =~ de01 + de02 + de03 + de05 + de06 + de07 + de08 + de10
UN =~ un01 + un02 + un03 + un04 + un05 + un06 + un07 + un08 + un09 + un10 + un11 + un12
TAIA =~ PR + CO + UT + FA + DE + UN
"
model2 <- cfa(mdl2, taia_items)


fitmeasures(model2, c("cfi", "tli", "srmr", "rmsea"))

smodel2 <- standardizedsolution(model2)

smodel2 %>% filter(op == '=~')
smodel2 %>% filter(op == '~~' & lhs == rhs)
smodel2 %>% filter(op == '~~' & lhs != rhs)


mi2 <- modindices(model2) %>% arrange(desc(mi))

mi2 %>% filter(op == "~~" & str_detect(lhs, "^[:upper:]")) %>% filter(mi > 10)
mi2 %>% filter(op == "~~" & str_detect(lhs, "^[:lower:]")) %>% filter(mi > 100) -> mi_max
mi2 %>% filter(op == "=~")


taia_question <- read_sheet("https://docs.google.com/spreadsheets/d/1om__1JaQYuhBSUdx6ulWjvGu1_jvG9e87IDL99i5USg/edit#gid=0")
str(taia_question)


taia_question %>% 
  filter(code %in% c(mi_max$lhs, mi_max$rhs))


semPaths(model2, "std")


mdl3 <- "
PR =~ pr01 + pr02 + pr05 + pr06 + pr07 + pr08 + pr09 + pr10 
CO =~ co01 + co02 + co03 + co05 + co06 + co09 + co10
UT =~ ut01 + ut02 + ut03 + ut04 + ut05 + ut06 + ut07 + ut08 + ut09 + ut11 + ut12
FA =~ fa01 + fa02 + fa05 + fa06 + fa09 + fa10
DE =~ de01 + de02 + de03 + de05 + de06 + de07 + de08 + de10
UN =~ un01 + un02 + un03 + un04 + un05 + un06 + un07 + un08 + un09 + un10 + un11 + un12
TAIA =~ PR + CO + UT + FA + DE + UN
PR ~~ UT
FA ~~ UN
CO ~~ UT
FA ~~ DE
"
model3 <- cfa(mdl3, taia_items)
summary(model3)

anova(model2, model3, test='Chi')

semPaths(model3, "std")

# correlation
pwr::pwr.r.test(r = .2, sig.level = .05, power = .8)
# simple linear
pwr::pwr.f2.test(u = 1, f2 = sqrt(.6), sig.level = .05, power = .8) # 10 + 2 = 12
# miltiple linear
pwr::pwr.f2.test(u = 3, f2 = sqrt(.3), sig.level = .05, power = .8) # 20 + 4 = 24

# ANOVA
## f = sqrt(etasq / (1 - etasq))
pwr::pwr.anova.test(k = 2, f = sqrt(.14 / (1 - .14)), sig.level = .05, power = 0.8)
WebPower::wp.rmanova(f = .35, ng = 1, nm = 3, nscor = 1, alpha = .05, power = 0.8, type = )
