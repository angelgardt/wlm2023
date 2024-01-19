# HW7 // Solutions
# A. Angelgardt

# MAIN

# 1
set.seed(333)
sim1 <- matrix(rchisq(1000 * 100, 3), ncol = 1000)


# 2
sim1 %>% 
  apply(2, mean) %>% 
  tibble(x = .) %>% 
  ggplot(aes(x)) +
  geom_histogram()

# 3
sim1 %>% 
  apply(2, mean) %>% 
  tibble(x = .) %>% 
  ggplot(aes(x)) +
  geom_histogram() +
  geom_vline(xintercept = 3, color = "red") +
  geom_vline(aes(xintercept = mean(x)))

# 4
set.seed(555)
sim2 <- list()

for (i in 1:1000) {
  sim2[[i]] <- rchisq(i, 3)
}

# 5
sim2 %>% 
  map(var) %>% 
  unlist() %>% 
  tibble(x = 1:1000,
         y = .) %>% 
  ggplot(aes(x, y)) +
  geom_line() +
  geom_hline(yintercept = 2 * 3, color = "red")

# 6
ci <- function(x) {
  se <- sd(x) / sqrt(length(x))
  return(c(lower = mean(x) - 1.64 * se, 
           mean = mean(x), 
           upper = mean(x) + 1.64 * se))}

ci(sim1[, 1]) %>% round(2)

# 7

## a
sim1 %>% 
  apply(2, ci) %>% 
  t() %>% 
  as_tibble() %>% 
  mutate(sample = 1:1000,
         contains = ifelse(3 > lower & 3 < upper, TRUE, FALSE)) -> sim1_ci

sim1_ci %>%
  ggplot(aes(
    x = sample,
    y = mean,
    ymin = lower,
    ymax = upper,
    color = contains
  )) +
  geom_pointrange() +
  geom_hline(yintercept = 3) +
  coord_flip()

## b

sim1_ci %>% pull(contains) %>% mean()

# 8
## a
sim1_ci %>% 
  mutate(capture = ifelse(mean > lower[1000] & mean < upper[1000], TRUE, FALSE)) -> sim1_ci

sim1_ci %>%
  ggplot(aes(
    x = sample,
    y = mean,
    ymin = lower,
    ymax = upper,
    color = capture
  )) +
  geom_pointrange() +
  geom_hline(yintercept = 3) +
  coord_flip()

## b
sim1_ci %>% 
  pull(capture) %>% 
  mean()

# 9
sim2 %>% 
  map(function(x) sd(x)/sqrt(length(x))) %>% 
  unlist() %>% 
  tibble(x = 1:1000,
         y = .) %>% 
  ggplot(aes(x = x,
             y = y)) +
  geom_point()

sim2 %>% 
  map(ci) %>% 
  as_tibble(.name_repair = "minimal") %>% 
  set_names(1:1000) %>% 
  mutate(a = c("lower", "mean", "upper")) %>% 
  pivot_longer(cols = -a) %>% 
  pivot_wider(names_from = a, values_from = value) %>% 
  mutate(name = as.numeric(name)) %>% 
  ggplot(aes(x = name,
             y = mean,
             ymin = lower,
             ymax = upper)) +
  geom_errorbar()

# 10
set.seed(555)
sim3 <- list()

for (i in 1:200) {
  sim3[[i]] <- rchisq(100, i)
}


sim3 %>% 
  map(function(x) sd(x)/sqrt(length(x))) %>% 
  unlist() %>% 
  tibble(x = 1:200,
         y = .) %>% 
  ggplot(aes(x = x,
             y = y)) +
  geom_point()

sim3 %>% 
  map(ci) %>% 
  as_tibble(.name_repair = "minimal") %>% 
  set_names(1:200) %>% 
  mutate(a = c("lower", "mean", "upper")) %>% 
  pivot_longer(cols = -a) %>% 
  pivot_wider(names_from = a, values_from = value) %>% 
  mutate(name = as.numeric(name)) %>% 
  ggplot(aes(x = name,
             y = mean,
             ymin = lower,
             ymax = upper)) +
  geom_errorbar()
