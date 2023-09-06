setwd("~/wlm2023/pics-dev")

library(tidyverse)
theme_set(theme_bw())

set.seed(123)
rnorm(10^6, mean = 300, sd = 100) -> pop

hist(pop)

var_pop <- function (x) { sum((x - mean(x))^2) / length(x) }
mad <- function (x) { sum(abs(x - mean(x))) / length(x)} # mean absolute deviation

sim <- list()

set.seed(567)
for (i in 1:1000) {
  sim[[i]] <- sample(pop, size = 200)
}

means <- map(sim, mean) |> unlist()

ggplot(NULL) +
  geom_density(aes(x = means)) +
  geom_vline(xintercept = mean(means)) +
  geom_vline(xintercept = 300, color = "darkred")

vars <- map(sim, var) |> unlist() # n-1
vars_pop <- map(sim, var_pop) |> unlist() # n

ggplot(NULL) +
  geom_density(aes(x = vars)) +
  geom_vline(xintercept = mean(vars)) +
  geom_vline(xintercept = mean(vars_pop), color = "darkgreen") +
  geom_vline(xintercept = 100^2, color = "darkred")

ggplot(NULL) +
  geom_density(aes(x = sqrt(vars))) +
  geom_vline(xintercept = mean(sqrt(vars))) +
  geom_vline(xintercept = mean(sqrt(vars_pop)), color = "darkgreen") +
  geom_vline(xintercept = 100, color = "darkred")

sim2 <- list()

set.seed(567)
for (i in 2:200) {
  for (j in 1:50) {
    name <- paste0(i, "-", j)
    sim2[[name]] <- sample(pop, i)
  }
}

sim2_agg <- tibble(n = map(sim2, length) |> unlist(),
                   mean = map(sim2, mean) |> unlist(),
                   var = map(sim2, var) |> unlist(),
                   var_pop = map(sim2, var_pop) |> unlist(),
                   sd = map(sim2, sd) |> unlist(),
                   sd_pop = map(sim2, function(x) sqrt(var_pop(x))) |> unlist(),
                   mad = map(sim2, mad) |> unlist())

sim2_agg |> 
  ggplot(aes(n, mean)) +
  geom_point(alpha = .3, color = "gray") +
  geom_hline(yintercept = 300, color = "red") +
  geom_smooth()


sim2_agg |> 
  ggplot(aes(n, var)) +
  geom_point(alpha = .3, color = "gray") +
  geom_hline(yintercept = 100^2, color = "red") +
  geom_smooth()

sim2_agg |> 
  ggplot(aes(n, var_pop)) +
  geom_point(alpha = .3, color = "gray") +
  geom_hline(yintercept = 100^2, color = "red") +
  geom_smooth() 

sim3 <- tibble()
set.seed(987)
for (i in seq(5, 500, by = 5)) {
  tibble(n = i,
         s = sample(pop, i)) |> 
    bind_rows(sim3) -> sim3
}

sim3 |> 
  group_by(n) |> 
  summarise(sd = sd(s),
            mad = mad(s)) -> sim3_agg
sim3 |> 
  ggplot() +
  geom_point(aes(n, s), alpha = .3) +
  geom_line(data = sim3_agg, aes(n, sd), color = "red") +
  geom_line(data = sim3_agg, aes(n, mad), color = "blue")


set.seed(567)
sim4 <- list()
sds <- seq(0, 10, by = .5)
for (i in 1:length(sds)) {
  s <- rnorm(100, 0, sds[i])
  sim4[[i]] <- list(sd = sd(s),
                  mad = mad(s))
}

tibble(sds = sds,
       sd = sim4 |> map(function(x) x$sd) |> unlist(),
       mad = sim4 |> map(function(x) x$mad) |> unlist()) |> 
  pivot_longer(cols = -sds) |> 
  ggplot(aes(x = sds, y = value, color = name)) +
  geom_line()



