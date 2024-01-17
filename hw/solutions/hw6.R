# HW6 // Solutions
# A. Angelgardt

# MAIN

# 1
load(url("https://github.com/angelgardt/wlm2023/raw/master/data/hw6/dice.RData"))

dice1(10000) %>% table() %>% `/`(10000) #%>% sum()
dice2(10000) %>% table() %>% `/`(10000) #%>% sum()
dice3(10000) %>% table() %>% `/`(10000) #%>% sum()


# 2
task2 <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/hw6/task2.csv")
(task2$x * task2$p) %>% sum()

# 3
task2$x2 <- task2$x^2
((task2$x2 * task2$p) %>% sum()) - ((task2$x * task2$p) %>% sum())^2

# 4
## a
0.2 * 0.1 * 0.15

## b
(30 * 0.2 + 20 * 0.1 + 32 * 0.15) %>% round()

# 5
## a
(1 - .8) * (1-.7) * (1-.6)
## b
1 - ((1 - .8) * (1-.7) * (1-.6))

# 6


# 7


# 8


# 9


# 10

