### P8 // Solutions
### A. Angelgardt

# MAIN

# 1

library(tidyverse)
theme_set(theme_bw())

set.seed(404)
matrix(rnorm(100*1000, mean = 10, sd = 15), ncol = 1000) -> sim1
matrix(rnorm(100*1000, mean = 10, sd = 15), ncol = 1000) -> sim2
matrix(rnorm(100*1000, mean = 15, sd = 15), ncol = 1000) -> sim3


# 2
sim1 %>% 
  apply(2, mean) %>% 
  tibble(x = .) %>% 
  ggplot(aes(x)) +
  geom_histogram()

sim1 %>% 
  apply(2, function(x) sd(x)/sqrt(length(x))) %>% 
  mean() -> sim1_se

sim1 %>% 
  apply(2, mean) %>% 
  tibble(x = .) %>% 
  ggplot(aes(x)) +
  geom_histogram(aes(y = after_stat(density))) +
  geom_function(fun = dnorm,
                args = list(mean = 10, sd = sim1_se))


# 3

sim1 %>% 
  apply(2, mean) %>% 
  tibble(x = .) %>% 
  ggplot(aes(x)) +
  geom_histogram(fill = "gray70") +
  geom_vline(xintercept = 10, color = "red2", size = 1) +
  geom_vline(aes(xintercept = mean(x)))

sim2 %>% 
  apply(2, mean) %>% 
  tibble(x = .) %>% 
  ggplot(aes(x)) +
  geom_histogram(fill = "gray70") +
  geom_vline(xintercept = 10, color = "red2", size = 1) +
  geom_vline(aes(xintercept = mean(x)))


# 4

var_pop <- function(x) {sum((x - mean(x))^2) / length(x)}

sim1 %>%
  as_tibble() %>% 
  pivot_longer(cols = everything()) %>% 
  group_by(name) %>% 
  summarise(var = var(value),
            var_pop = var_pop(value)) %>% 
  ggplot() +
  geom_histogram(aes(var),
                 fill = "lightblue3", alpha = .5) +
  geom_histogram(aes(var_pop),
                 fill = "seagreen3", alpha = .5) +
  geom_vline(xintercept = 225, color = "red2", size = 1) +
  geom_vline(aes(xintercept = mean(var)),
             color = "blue3", size = 1) +
  geom_vline(aes(xintercept = mean(var_pop)),
             color = "green3", size = 1) # + xlim(200, 250)

sim2 %>%
  as_tibble() %>% 
  pivot_longer(cols = everything()) %>% 
  group_by(name) %>% 
  summarise(var = var(value),
            var_pop = var_pop(value)) %>% 
  ggplot() +
  geom_histogram(aes(var),
                 fill = "lightblue3", alpha = .5) +
  geom_histogram(aes(var_pop),
                 fill = "seagreen3", alpha = .5) +
  geom_vline(xintercept = 225, color = "red2", size = 1) +
  geom_vline(aes(xintercept = mean(var)),
             color = "blue3", size = 1) +
  geom_vline(aes(xintercept = mean(var_pop)),
             color = "green3", size = 1) # + xlim(200, 250)


# 5

set.seed(1010)

sim4 <- list()

for (i in 1:1000) {
  sim4[[i]] <- rnorm(i, mean = 10, sd = 15)
}

sim4 %>% 
  map(mean) %>%
  unlist() %>% 
  tibble(x = 1:1000,
         y = .) %>% 
  ggplot(aes(x, y)) +
  geom_line() +
  geom_hline(yintercept = 10,
             color = "red2")


# 6

sim4 %>% 
  map(var) %>%
  unlist() %>% 
  tibble(x = 1:1000,
         y = .) %>% 
  ggplot(aes(x, y)) +
  geom_line() +
  geom_hline(yintercept = 225,
             color = "red2")


# 7

ci <- function(x) {se <- sd(x) / sqrt(length(x)); return(c(lower = mean(x)-1.96 * se, 
                                                           mean = mean(x), 
                                                           upper = mean(x) + 1.96 * se))}

ci(sim1[, 1])


# 8

sim1 %>% 
  apply(2, ci) %>% 
  t() %>% 
  as_tibble() %>% 
  # set_names("lower", "mean", "upper") %>% 
  mutate(sample = 1:1000,
         contains = ifelse(lower < 10 & upper > 10, TRUE, FALSE)) -> sim1_ci

sim1_ci %>% 
  ggplot(aes(x = sample)) +
  geom_pointrange(aes(y = mean, 
                      ymin = lower, 
                      ymax = upper,
                      color = contains),
                  alpha = .5) +
  geom_hline(yintercept = 10) +
  coord_flip()

sim1_ci$contains %>% mean()


# 9

sim1_ci %>% 
  mutate(capture = ifelse(mean > lower[1] & mean < upper[1], TRUE, FALSE)) -> sim1_ci

sim1_ci %>% 
  ggplot(aes(x = sample)) +
  geom_rect(aes(xmin = 0, xmax = 1000,
                ymin = lower[1], ymax = upper[1]),
            fill = "gray70", alpha = .01) +
  geom_pointrange(aes(y = mean, 
                      ymin = lower, 
                      ymax = upper,
                      color = capture),
                  alpha = .5) +
  geom_hline(yintercept = 10) +
  coord_flip()

sim1_ci$capture %>% mean()


# 10

sim2 %>% 
  apply(2, ci) %>% 
  t() %>% 
  as_tibble() %>% 
  set_names("lower", "mean", "upper") %>% 
  mutate(sample = 1:1000,
         contains = ifelse(lower < 10 & upper > 10, TRUE, FALSE)) -> sim2_ci

sim2_ci %>% 
  ggplot(aes(x = sample)) +
  geom_pointrange(aes(y = mean, 
                      ymin = lower, 
                      ymax = upper,
                      color = contains),
                  alpha = .5) +
  geom_hline(yintercept = 10) +
  coord_flip()

sim2_ci$contains %>% mean()


# 11

t.test(x = sim1[, 1], mu = 10)
t.test(x = sim3[, 1], mu = 10)


# 12
tibble(x = rep(seq(-5, 5, by = .01), 10),
       df = rep(seq(1, 50, by = 5), each = 1001),
       dt = dt(x, df = df)) %>% 
  ggplot(aes(x, dt, color = df)) +
  geom_line() +
  geom_function(fun = dnorm, color = "red3")


# 13

pvalsH0 <- list()

for (i in 1:ncol(sim1)) {
  pvalsH0[[i]] <- t.test(sim1[, i], sim2[, i])$p.value
}

(unlist(pvalsH0) <.05) %>% mean()
(unlist(pvalsH0) <.005) %>% mean()


# 14

pvalsH1 <- list()

for (i in 1:ncol(sim1)) {
  pvalsH1[[i]] <- t.test(sim1[, i], sim3[, i])$p.value
}

(unlist(pvalsH1) <.05) %>% mean()
(unlist(pvalsH1) <.005) %>% mean()


# 15

pvals <- list()

for (i in 1:ncol(sim1)) {
  pvals$H0[i] <- t.test(sim1[, i], sim2[, i])$p.value
  pvals$H1[i] <- t.test(sim1[, i], sim3[, i])$p.value
}

pvals %>% 
  as_tibble() %>% 
  pivot_longer(cols = everything()) %>% 
  ggplot(aes(value)) +
  geom_histogram() +
  facet_wrap(~ name)


# 16

# rm(list=ls())

n <- seq(2, 100, by = 5)
sim5 <- list()

for (i in 1:length(n)) {
  sim5[[i]] <- matrix(rnorm(n[i]*100), ncol = 100)
}

sim5 %>% 
  map(function(x) 
  {apply(x, 2, function(y) 
  {t.test(y, mu = .5)$p.value} 
  ) 
  } 
  ) %>% 
  as_tibble(.name_repair = "universal") %>% 
  pivot_longer(cols = everything()) %>% 
  mutate(name = str_remove(name, "\\.{3}") %>% 
           as.numeric()) %>% 
  ggplot(aes(value)) +
  geom_histogram() +
  facet_wrap(~ name)


# 17

# rm(list=ls())

ef <- seq(0, 1, by = 0.05)
sim6 <- list()

for (i in 1:length(ef)) {
  sim6[[i]] <- matrix(rnorm(50*100, mean = ef[i]), ncol = 100)
}

sim6 %>% 
  map(function(x) 
  {apply(x, 2, function(y) 
  {t.test(y, mu = 0)$p.value} 
  ) 
  } 
  ) %>% 
  as_tibble(.name_repair = "universal") %>% 
  pivot_longer(cols = everything()) %>% 
  mutate(name = str_remove(name, "\\.{3}") %>% 
           as.numeric()) %>% 
  ggplot(aes(value)) +
  geom_histogram() +
  facet_wrap(~ name)


# 18

# rm(list=ls())

sim5 %>% 
  map(function(x) 
  {apply(x, 2, function(y) 
  {effectsize::cohens_d(y, mu = .5)$Cohens_d} 
  ) 
  } 
  ) %>% 
  as_tibble(.name_repair = "universal") %>% 
  pivot_longer(cols = everything()) %>% 
  mutate(name = str_remove(name, "\\.{3}") %>% 
           as.numeric()) -> eff_size

eff_size %>% 
  ggplot(aes(value)) +
  geom_histogram() +
  facet_wrap(~ name)

eff_size %>% 
  filter(name > 15) %>% 
  ggplot(aes(value)) +
  geom_histogram() +
  facet_wrap(~ name)


# 19
# rm(list=ls())

set.seed(123)

# smpl <- rnorm(50)

smpl <- rnorm(50, 10, 15)

hist(smpl, breaks = 30)

matrix(sample(x = smpl, size = 50 * 10000, replace = TRUE), ncol = 10000) -> bs_mat

bs_mat %>% 
  apply(2, mean) -> bs_means

hist(bs_means, breaks = 20)

quantile(bs_means, .025); mean(smpl); quantile(bs_means, .975)

mean_cl_normal(smpl)
mean_cl_boot(smpl)



# 20

bs_mat %>% 
  apply(2, median) -> bs_medians

quantile(bs_medians, .025); median(smpl); quantile(bs_medians, .975)




# ADDITIONAL

# 1

# 2

# 3

# 4

# 5

# 6

# 7

# 8

# 9

# 10
