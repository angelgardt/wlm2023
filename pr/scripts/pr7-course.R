load(url("https://github.com/angelgardt/wlm2023/raw/master/data/pr7/dice.RData"))
library(tidyverse)
theme_set(theme_bw())

# 3
dice1(10000) %>% table() %>% `/`(10000)
dice2(10000) %>% table() %>% `/`(10000)

# 4

disc <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr7/pr7-4.csv")
disc

sum(disc$x * disc$p)

# 5

disc$x2 <- disc$x^2
sum(disc$x2 * disc$p) - (sum(disc$x * disc$p))^2


# 6
disc2 <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr7/pr7-6.csv")
disc2

disc2 %>% 
  mutate(x2 = x^2) %>% 
  summarise(p = sum(p),
            .by = x2) -> disc2_

sum(disc2_$x2 * disc2_$p) - (sum(disc2$x * disc2$p))^2


disc2 %>% 
  ggplot(aes(factor(x, ordered = TRUE), p)) +
  geom_point()


# rnorm(n, mean = , sd = )

tibble(x = seq(-10, 10, by = .001),
       y = dnorm(x, mean = 1.5, sd = sqrt(2.1))) %>% 
  ggplot(aes(x, y)) +
  geom_line()

ggplot() +
  geom_function(fun = dnorm, 
                args = list(mean = 1.5, 
                            sd = sqrt(2.1))) +
  xlim(-10, 10)

# 9

integrate(dnorm, -Inf, 5, mean = 1.5, sd = 1.449)
integrate(dnorm, 4, +Inf, mean = 1.5, sd = 1.449)
integrate(dnorm, -1, 1, mean = 1.5, sd = 1.449)


# 10

length(letters)

(1/26)^5

# 11

sum(130, 201, 94)

agent1 = 130 / 425
agent2 = 201 / 425
agent3 = 94 / 425

agent1 * .05 + agent2 * .07 + agent3 * .025


# 12

(agent1 * .05) / (agent1 * .05 + agent2 * .07 + agent3 * .025)
(agent2 * .07) / (agent1 * .05 + agent2 * .07 + agent3 * .025)


# 13

(1/4)^10
(3/4)^10


# 14

choose(10, 6) * (1/4)^6 * (3/4)^4 +
choose(10, 7) * (1/4)^7 * (3/4)^3 +
choose(10, 8) * (1/4)^8 * (3/4)^2 +
choose(10, 9) * (1/4)^9 * (3/4)^1 +
choose(10, 10) * (1/4)^10 * (3/4)^0

set.seed(120)
rnorm(1000, 10, 5) -> vec_norm

ggplot(data = NULL) + 
  geom_histogram(aes(vec_norm))

scale(vec_norm) -> vec_stand

ggplot(data = NULL) + 
  geom_histogram(aes(x = vec_stand, 
                     y = after_stat(density))) +
  geom_function(fun = dnorm, 
                args = list(mean = 0, 
                             sd = 1))



c(rnorm(1000, 10, 5), rnorm(1000, 3, 3)) -> vec

scale(vec) -> vec_scaled

gridExtra::grid.arrange(
ggplot(data = NULL) +
  geom_histogram(aes(vec)),
ggplot(data = NULL) +
  geom_histogram(aes(vec_scaled))
)

"gridExtra" %in% installed.packages()
