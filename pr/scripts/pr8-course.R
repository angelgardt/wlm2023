library(tidyverse)
theme_set(theme_bw())

# rm()
# rm(list = ls())

# 1
set.seed(404)
sim1 <- matrix(rnorm(1000 * 100, mean = 10, sd = 15), ncol = 1000)
sim2 <- matrix(rnorm(1000 * 100, mean = 10, sd = 15), ncol = 1000)
sim3 <- matrix(rnorm(1000 * 100, mean = 15, sd = 15), ncol = 1000)

# 2

sim1 %>% 
  apply(2, mean) %>% 
  tibble(x = .) %>% 
  ggplot(aes(x)) +
  geom_histogram()

sim1 %>% 
  apply(2, function(x) sd(x) / sqrt(length(x))) %>% 
  mean() -> sim1_se

sim1 %>% 
  apply(2, mean) %>% 
  tibble(x = .) %>% 
  ggplot(aes(x)) +
  geom_histogram(aes(y = after_stat(density))) +
  geom_function(fun = dnorm,
                args = list(mean = 10,
                            sd = sim1_se))


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

## 225

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
  geom_vline(aes(xintercept = mean(var)), color = "blue2") +
  geom_vline(aes(xintercept = mean(var_pop)), color = "green4")

  
# 5

set.seed(1010)

sim4 <- list()

for (i in 1:1000) {
  sim4[[i]] <- rnorm(i, mean = 10, sd = 15)
}

sim4[1:3]

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

ci <- function(x) {
  se <- sd(x) / sqrt(length(x))
  return(
    c(
      lower = mean(x) - 1.96 * se,
      mean = mean(x),
      upper = mean(x) + 1.96 * se
    )
  )
}

ci(sim1[,1])


# 8

sim1 %>% 
  apply(2, ci) %>% 
  t() %>% 
  as_tibble() %>% 
  mutate(sample = 1:1000,
         contains = ifelse(lower < 10 & upper > 10, 
                           TRUE, 
                           FALSE)) -> sim1_ci

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


# 10

## capture percantage

sim1_ci %>% 
  mutate(capture = ifelse(mean > lower[1] & mean < upper[1], 
                          TRUE, 
                          FALSE)) -> sim1_ci

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
  coord_flip()

sim1_ci$capture %>% mean()



# 11

t.test(x = sim1[, 1], mu = 10)
t.test(x = sim3[, 1], mu = 10)


# 12

tibble(x = rep(seq(-5, 5, by = .01), 10),
       df = rep(seq(1, 50, by = 5), each = 1001),
       dt = dt(x, df = df)) %>% 
  ggplot(aes(x, dt, color = df)) +
  geom_line() +
  geom_function(fun = dnorm,
                color = "red3")


# 13

pvaluesH0 <- list()

for (i in 1:ncol(sim1)) {
  pvaluesH0[[i]] <- t.test(sim1[,i], sim2[,i])$p.value
}

(unlist(pvaluesH0) < .05) %>% mean()
(unlist(pvaluesH0) < .005) %>% mean()


# 14

pvaluesH1 <- list()

for (i in 1:ncol(sim1)) {
  pvaluesH1[[i]] <- t.test(sim1[,i], sim3[,i])$p.value
}

(unlist(pvaluesH1) < .05) %>% mean()
(unlist(pvaluesH1) < .005) %>% mean()


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

n <- seq(2, 100, by = 5)
sim5 <- list()

for (i in 1:length(n)) {
  sim5[[i]] <- matrix(rnorm(n[i]*100), ncol = 100)
}

sim5 %>% 
  map(function(x){
    apply(x, 2, function(y) {
      t.test(y, mu = .5)$p.value
    })
  }) %>% 
  as_tibble(.name_repair = "universal") %>% 
  pivot_longer(cols =  everything()) %>% 
  mutate(name = str_remove(name, "\\.{3}") %>% 
           as.numeric()) %>% 
  ggplot(aes(value)) +
  geom_histogram() +
  facet_wrap(~ name)


# 17

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

