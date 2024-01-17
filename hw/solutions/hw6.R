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
course1 = 520/1500
course2 = 480/1500
course3 = 315/1500
course4 = (1500-520-480-315)/1500

0.6 * course1 + 0.8 * course2 + 0.7 * course3 + 0.65 * course4

# 7
N = 146700000
ILL = 1550000
sens = 0.98
spec = 0.98

P_ILL = ILL / N
P_HEALTH = 1 - P_ILL
P_plus_if_ill = sens
P_plus_if_health = 1 - spec

(P_plus_if_ill * P_ILL) / (P_plus_if_ill * P_ILL + P_plus_if_health * P_HEALTH)

# 8
choose(30, 25) * (1/5)^25 * (4/5)^5 +
  choose(30, 26) * (1/5)^26 * (4/5)^4 +
  choose(30, 27) * (1/5)^27 * (4/5)^3 +
  choose(30, 28) * (1/5)^28 * (4/5)^2 +
  choose(30, 29) * (1/5)^29 * (4/5)^1 +
  choose(30, 30) * (1/5)^30 * (4/5)^0

# 9
## a
### 0, rt is a continuous rand var

## b
integrate(dgamma, 2, 6, shape = 2, rate = 1)

# 10
ggplot() +
  geom_function(fun = dnorm, args = list(mean = 8.2, sd = sqrt(37.21))) +
  xlim(-20, 40)
