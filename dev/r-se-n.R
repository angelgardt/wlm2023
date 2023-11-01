setwd("~/wlm2023/pics-dev")

library(tidyverse)
library(plotly)
theme_set(theme_bw())

# calculate standard error of r
se_r <- function(r, n) {
  return(sqrt(1 - r^2) / sqrt(n - 2))
}

# calculate sample size based on r and standard error of r
# se_r_n <- function(r, se) {
#   return(list(r = r,
#               se = se,
#               n = (1 - r^2) / se^2 + 2))
# }

ci_r <- function(r, n, type = "both") {
  r_ = atanh(r)
  se_ = 1 / sqrt(n - 3)
  lower_ = r_ - 1.96 * se_
  upper_ = r_ + 1.96 * se_
  if (type == "both") {
    return(list(CI = c(lower = tanh(lower_),
                       upper = tanh(upper_))))
  } else if (type == "lower") {
    return(tanh(lower_))
  } else if (type == "upper") {
    return(tanh(upper_))
  } else {
    return(NULL)
  }
}

seq(0, 0.95, by = 0.05) |> length()
seq(5, 2000, by = 5) |> length()
seq(5, 1000, by = 5) |> length()

tibble(r = seq(0, 0.95, by = 0.05) |> rep(times = 200),
       n = seq(5, 1000, by = 5) |> rep(each = 20),
       se = se_r(r, n)) |> 
  plot_ly(x = ~r, y = ~n, z = ~se, type = "mesh3d")

facet_labs <- seq(0, 0.95, by = 0.05) %>% paste0("r = ", .)
names(facet_labs) <- seq(0, 0.95, by = 0.05)
tibble(r = seq(0, 0.95, by = 0.05) |> rep(times = 200),
       n = seq(5, 1000, by = 5) |> rep(each = 20),
       se = se_r(r, n)) |> 
  ggplot(aes(n, se)) +
  geom_line() +
  facet_wrap(~ r, labeller = labeller(r = facet_labs)) +
  labs(x = "Размер выборки", y = latex2exp::TeX("$SE_r$"))

facet_labs <- seq(0, 0.95, by = 0.05) %>% paste0("r = ", .)
names(facet_labs) <- seq(0, 0.95, by = 0.05)
tibble(r = seq(0, 0.95, by = 0.05) |> rep(times = 200),
       n = seq(5, 1000, by = 5) |> rep(each = 20),
       se = se_r(r, n),
       ci_l = ci_r(r, n, "lower"),
       ci_u = ci_r(r, n, "upper")) |> 
  ggplot(aes(x = n)) +
  geom_line(aes(y = se)) +
  geom_line(aes(y = ci_l), linetype = "dashed", color = "darkred") +
  geom_line(aes(y = ci_u), linetype = "dashed", color = "darkred") +
  geom_hline(yintercept = 0, linetype = "dotted", color = "darkred") +
  geom_hline(aes(yintercept = r), linetype = "dashed", color = "darkblue") +
  facet_wrap(~ r, labeller = labeller(r = facet_labs), scales = "free_y") +
  labs(x = "Размер выборки", y = latex2exp::TeX("$SE_r$")) +
  scale_x_continuous(breaks = seq(0, 1000, by = 100)) +
  theme(axis.text.x = element_text(angle = 90))

