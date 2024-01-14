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
