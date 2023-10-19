setwd("~/wlm2023/pics-dev")

library(tidyverse)
theme_set(theme_bw())
library(plotly)

set.seed(123)
rnorm(10^6, mean = 300, sd = 100) -> pop

ggplot(NULL) +
  geom_histogram(aes(x = pop),
                 binwidth = 15,
                 fill = "gray50", 
                 color = "gray30") +
  geom_vline(xintercept = 300) +
  scale_x_continuous(breaks = seq(-200, 800, by = 100))

var_pop <- function (x) { sum((x - mean(x))^2) / length(x) }
mad <- function (x) { sum(abs(x - mean(x))) / length(x)} # mean absolute deviation

set.seed(567)
size <- 100 # sample size
n <-  2000 # num of samples
sim <- matrix(sample(pop, size * n), size)

means <- apply(sim, 2, mean)

ggplot(NULL) +
  geom_histogram(aes(x = means),
                 binwidth = 1,
                 fill = "gray50",
                 color = "gray30") +
  #geom_density(aes(x = means)) +
  geom_vline(xintercept = 300) +
  geom_vline(xintercept = mean(means),
             color = "darkred", linetype = "dashed")


vars <- apply(sim, 2, var) # n-1
vars_pop <- apply(sim, 2, var_pop) # n

(ggplot(NULL) +
  # geom_density(aes(x = vars)) +
  geom_histogram(aes(x = vars),
                 binwidth = 150,
                 fill = "gray50",
                 color = "gray30") +
  geom_vline(xintercept = 100^2) + 
  geom_vline(xintercept = mean(vars), color = "darkred", linetype = "dashed") +
  geom_vline(xintercept = mean(vars_pop), color = "darkgreen")) |> 
  ggplotly()


ggplot(NULL) +
  geom_histogram(aes(x = sqrt(vars)),
                 binwidth = 1,
                 fill = "gray50",
                 color = "gray30") +
  # geom_density(aes(x = sqrt(vars))) +
  geom_vline(xintercept = 100) +
  geom_vline(xintercept = mean(sqrt(vars)), color = "darkred", linetype = "dashed") +
  geom_vline(xintercept = mean(sqrt(vars_pop)), color = "darkgreen")



set.seed(567)
n = 100
sim2 <- 3:200 |> map(function(x) {matrix(sample(pop, x * n), x)})

str(sim2)

sim2_agg <- tibble(n = map(sim2, apply, MARGIN = 2, FUN = length) |> unlist(),
                   mean = map(sim2, apply, MARGIN = 2, FUN = mean) |> unlist(),
                   var = map(sim2, apply, MARGIN = 2, FUN = var) |> unlist(),
                   var_pop = map(sim2, apply, MARGIN = 2, FUN = var_pop) |> unlist(),
                   sd = map(sim2, apply, MARGIN = 2, FUN = sd) |> unlist(),
                   sd_pop = map(sim2, apply, MARGIN = 2, FUN = function(x) sqrt(var_pop(x))) |> unlist(),
                   mad = map(sim2, apply, MARGIN = 2, FUN = mad) |> unlist())

sim2_agg |> 
  ggplot(aes(n, mean)) +
  geom_point(alpha = .3, color = "gray") +
  geom_hline(yintercept = 300, color = "red") +
  # geom_smooth(color = "black") +
  labs(x = "Sample size", y = "Means")


sim2_agg |> 
  ggplot(aes(n, var)) +
  geom_point(alpha = .3, color = "gray") +
  geom_hline(yintercept = 100^2, color = "red") +
  # geom_smooth(color = "black") +
  labs(x = "Sample size", y = "Variances")

sim2_agg |> 
  ggplot(aes(n, var_pop)) +
  geom_point(alpha = .3, color = "gray") +
  geom_hline(yintercept = 100^2, color = "red") +
  geom_smooth(color = "black") +
  labs(x = "Sample size", y = "Variances")

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



