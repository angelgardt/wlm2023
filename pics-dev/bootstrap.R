setwd("~/wlm2023/pics-dev")

library(tidyverse)
theme_set(theme_bw())

set.seed(321)

pop_control <- rnorm(10^6, mean = 5, sd = 2)
pop_test <- rnorm(10^6, mean = 5, sd = 3)

sample_control <- sample(pop_control, size = 20)
sample_test = sample(pop_test, size = 20)

tibble(x = c(sample_control, sample_test),
       gr = rep(c("control", "test"), each = 20)) |> 
    ggplot(aes(x)) +
    geom_histogram() +
    facet_grid(gr ~ .)

# sample = sample_control
set.seed(555)
boot_ci <- function(sample, estimator, ..., tests = 10000, ci = .95) {
    n = length(sample)
    estimation = estimator(sample, ...)
    samples = matrix(sample(sample, n*tests, replace = TRUE), n)
    estimations = apply(samples, 2, estimator, ...)
    result = c(est = estimation,
        quantile(estimation - estimations, 
                      probs = c((1 - ci) / 2, 1 - (1 - ci) / 2)) + estimation)
    return(result)
}

control_ci <- boot_ci(sample_control, quantile, probs = .7)
test_ci <- boot_ci(sample_test, quantile, probs = .7)

# quantile(sample_control, .7)
# quantile(sample_test, .7)
# 
# quantile(pop_control, .7)
# quantile(pop_test, .7)

tibble(ci = c(control_ci, test_ci),
       side = rep(c("est", "low", "high"), times = 2),
       group = rep(c("control", "test"), each = 3)) |> 
    pivot_wider(names_from = side, values_from = ci) |>
    ggplot(aes(x = group)) +
    geom_point(aes(y = est), size = 2) +
    geom_errorbar(aes(ymin = low, ymax = high), width = .5)

