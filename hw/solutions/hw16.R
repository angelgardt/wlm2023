# HW16 // Solutions
# A. Angelgardt

# MAIN

library(tidyverse)
library(lavaan)


# 1
## a
bffm <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/hw16/bffm.csv")
str(bffm)

## b
### all correct

## c
bffm %>% is.na() %>% sum()


# 2
bffm %>% cor() %>% ggcorrplot::ggcorrplot(colors = c("red3", "white", "blue3"))


# 3
mdl1 <- "
AGR =~ AGR1 + AGR2 + AGR3 + AGR4 + AGR5 + AGR6 + AGR7 + AGR8 + AGR9 + AGR10
CSN =~ CSN1 + CSN2 + CSN3 + CSN4 + CSN5 + CSN6 + CSN7 + CSN8 + CSN9 + CSN10
EST =~ EST1 + EST2 + EST3 + EST4 + EST5 + EST6 + EST7 + EST8 + EST9 + EST10
EXT =~ EXT1 + EXT2 + EXT3 + EXT4 + EXT5 + EXT6 + EXT7 + EXT8 + EXT9 + EXT10
OPN =~ OPN1 + OPN2 + OPN3 + OPN4 + OPN5 + OPN6 + OPN7 + OPN8 + OPN9 + OPN10
"

model1 <- cfa(mdl1, bffm)
summary(model1)


# 4
fitmeasures(model1, c("CFI", "TLI", "SRMR", "RMSEA"))


# 5
## a
smodel1 <- standardizedsolution(model1)

## b
smodel1 %>% 
  filter(op == "=~")

smodel1 %>% 
  filter(op == "~~" & lhs == rhs)

smodel1 %>% 
  filter(op == "~~" & lhs != rhs)


# 6
mdl2 <- "
AGR =~ AGR1 + AGR2 + AGR3 + AGR4 + AGR5 + AGR6 + AGR7 + AGR8 + AGR9 + AGR10
CSN =~ CSN1 + CSN2 + CSN3 + CSN4 + CSN5 + CSN6 + CSN7 + CSN8 + CSN9 + CSN10
EST =~ EST1 + EST2 + EST3 + EST4 + EST5 + EST6 + EST7 + EST8 + EST9 + EST10
EXT =~ EXT1 + EXT2 + EXT3 + EXT4 + EXT5 + EXT6 + EXT7 + EXT8 + EXT9 + EXT10
OPN =~ OPN1 + OPN2 + OPN3 + OPN4 + OPN5 + OPN6 + OPN7 + OPN8 + OPN9 + OPN10
PER =~ AGR + CSN + EST + EXT + OPN
"

model2 <- cfa(mdl2, bffm)
summary(model2)


# 7
fitmeasures(model1, c("CFI", "TLI", "SRMR", "RMSEA"))
fitmeasures(model2, c("CFI", "TLI", "SRMR", "RMSEA"))


# 8
mis2 <- modificationindices(model2) %>% arrange(desc(mi))

choose(5, 2)

mis2 %>% 
  filter(lhs != rhs &
           !str_detect(lhs, "\\d$") &
           !str_detect(rhs, "\\d$")) # %>% select(lhs, op, rhs)


# 9
## a
mdl3 <- "
AGR =~ AGR1 + AGR2 + AGR3 + AGR4 + AGR5 + AGR6 + AGR7 + AGR8 + AGR9 + AGR10
CSN =~ CSN1 + CSN2 + CSN3 + CSN4 + CSN5 + CSN6 + CSN7 + CSN8 + CSN9 + CSN10
EST =~ EST1 + EST2 + EST3 + EST4 + EST5 + EST6 + EST7 + EST8 + EST9 + EST10
EXT =~ EXT1 + EXT2 + EXT3 + EXT4 + EXT5 + EXT6 + EXT7 + EXT8 + EXT9 + EXT10
OPN =~ OPN1 + OPN2 + OPN3 + OPN4 + OPN5 + OPN6 + OPN7 + OPN8 + OPN9 + OPN10
PER =~ AGR + CSN + EST + EXT + OPN
CSN ~~ EST
AGR ~~ EST
CSN ~~ EXT
AGR ~~ EXT
EST ~~ EXT
AGR ~~ CSN
AGR ~~ OPN
EXT ~~ OPN
EST ~~ OPN
CSN ~~ OPN
"

model3 <- cfa(mdl3, bffm)

## b
fitmeasures(model1, c("CFI", "TLI", "SRMR", "RMSEA"))
fitmeasures(model2, c("CFI", "TLI", "SRMR", "RMSEA"))
fitmeasures(model3, c("CFI", "TLI", "SRMR", "RMSEA"))


# 10

anova(model1, model2)
anova(model1, model3)
anova(model2, model3)



# ADDITIONAL

# 1


# 2


# 3


# 4


# 5

