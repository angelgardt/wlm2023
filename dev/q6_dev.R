library(tidyverse)
theme_set(theme_bw())
library(latex2exp)

tibble(x = seq(-4, 4, by = .05),
       y = dnorm(x)) -> q7_crit
q7_crit %>% 
  ggplot() +
  geom_line(aes(x, y)) +
  geom_area(data = q7_crit %>% 
              filter(x > 1.96),
            aes(x, y), 
            fill = "red", alpha = .5) +
  geom_area(data = q7_crit %>% 
              filter(x < -1.96),
            aes(x, y),
            fill = "red", alpha = .5) +
  annotate(geom = "text", label = "???",
           x = 2.3, y = 0.01) +
  labs(x = "Statistics", y = "Density")


set.seed(123)

sost1 <- list()
for (i in 1:1000) {
  sost1[[i]] <- rbeta(i, 5, 6)
}
names(sost1) <- 1:1000

sost1 %>% 
  map(mean) %>% 
  as_tibble() %>% 
  pivot_longer(cols = everything()) %>% 
  mutate(name = as.numeric(name)) %>% 
  ggplot(aes(name, value)) +
  geom_line() +
  geom_hline(yintercept = 5/(5+6),
             size = 1,
             color = "blue") +
  annotate(geom = "text",
           label = TeX("\\theta"),
           x = 1005, y = 0.47,
           color = "blue") +
  labs(x = "n", y = TeX("$\\hat{\\theta}$"))


set.seed(123)

sost2 <- list()
for (i in 1:1000) {
  sost2[[i]] <- rgamma(i, 1, 8)
}
names(sost2) <- 1:1000


sost2 %>% 
  map(mean) %>% 
  as_tibble() %>% 
  pivot_longer(cols = everything()) %>% 
  mutate(name = as.numeric(name)) %>% 
  ggplot(aes(name, value)) +
  geom_line() +
  geom_hline(yintercept = 0.2,
             size = 1,
             color = "blue") +
  annotate(geom = "text",
           label = TeX("\\theta"),
           x = 1005, y = 0.21,
           color = "blue") +
  labs(x = "n", y = TeX("$\\hat{\\theta}$"))

set.seed(123)

sost3 <- list()
for (i in 1:1000) {
  sost3[[i]] <- abs(rnorm(i, 1, 8) + rlnorm(i, 2, 2))
}
names(sost3) <- 1:1000

sost3 %>% 
  map(sum) %>% 
  as_tibble() %>% 
  pivot_longer(cols = everything()) %>% 
  mutate(name = as.numeric(name),
         value = -log(value) + rnorm(1000, 0.5)) -> sost3.1

sost3.1 %>% 
  ggplot(aes(name, value)) +
  geom_line() +
  geom_hline(yintercept = -10.5,
             size = 1,
             color = "blue") +
  annotate(geom = "text",
           label = TeX("\\theta"),
           x = 1010, y = -10,
           color = "blue") +
  labs(x = "n", y = TeX("$\\hat{\\theta}$"))


set.seed(123)
# sost4 <- list()
# for (i in 1:1000) {
#   sost4[[i]] <- rnorm(i, 25, 25)
# }
# names(sost4) <- 1:1000

sost4 %>%
tibble(name = 1:1000,
       value = rnorm(1000, 25, 10)) %>% 
  ggplot(aes(name, value)) +
  geom_line() +
  geom_hline(yintercept = 25,
             size = 1,
             color = "blue") +
  annotate(geom = "text",
           label = TeX("\\theta"),
           x = 1020, y = 30,
           color = "blue") +
  labs(x = "n", y = TeX("$\\hat{\\theta}$")) +
  ylim(-25, 100)


# q6_eff

ggplot() +
  geom_function(fun = dnorm, args = list(mean = 0, 1.5),
                color = "red3") +
  geom_function(fun = dnorm, args = list(mean = 0, 2.4),
                color = "blue3") +
  geom_function(fun = dnorm, args = list(mean = -1.4, 0.7),
                color = "green4") +
  geom_function(fun = dnorm, args = list(mean = 1.2, 3),
                color = "orange3") +
  geom_vline(xintercept = 0, linetype = "dashed") +
  annotate(geom = "text",
           label = TeX("$\\theta$"),
           x = .5, y = 0.4,
           size = 5) +
  annotate(geom = "text",
           label = TeX("$\\theta_{1}$"),
           x = -2.5, y = 0.4,
           color = "green4", size = 5) +
  annotate(geom = "text",
           label = TeX("$\\theta_{2}$"),
           x = 2.4, y = 0.2,
           color = "red3", size = 5) +
  annotate(geom = "text",
           label = TeX("$\\theta_{3}$"),
           x = -5, y = 0.05,
           color = "blue3", size = 5) +
  annotate(geom = "text",
           label = TeX("$\\theta_{4}$"),
           x = 5, y = 0.1,
           color = "orange3", size = 5) +
  xlim(-10, 10) +
  labs(x = "Estimation", y = "Density")

library(tidyverse)
theme_set(theme_bw())

ggplot() +
  geom_function(fun = dnorm) +
  geom_function(fun = dnorm,
                args = list(mean = .5,
                            sd = 2),
                color = "red4") +
  xlim(-5, 5)

moments::kurtosis(rnorm(100000, 0.5, 2)) - 3
