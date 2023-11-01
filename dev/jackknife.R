setwd("~/wlm2023/pics-dev")

library(tidyverse)
theme_set(theme_bw())

var_pop <- function (x) { sum((x - mean(x))^2) / length(x) }

JN_bias_correction <- function(x, estimator) {
    n = length(x)
    theta_stars = vector("numeric", n)
    ind = 1:n
    for (i in ind) {
        sample = x[ind != i]
        theta_stars[i] = estimator(sample)
    }
    theta_hat = estimator(x)
    theta_dot = mean(theta_stars)
    bias_jack = (theta_dot - theta_hat) * (n - 1)
    theta_hat_jack = theta_hat - bias_jack
    return(theta_hat_jack)
}

start = 3

sample_sizes = start:50
tests = 100

results_good = sample_sizes
results_bad = sample_sizes
results_corrected = sample_sizes

for (n in sample_sizes) {
    samples = matrix(rnorm(n*tests), n)
    
    good_estimations = apply(samples, 2, var)
    bad_estimations = apply(samples, 2, var_pop)
    corrected_estimations = apply(samples, 2, JN_bias_correction, estimator = var_pop)
    
    results_good[n-start+1] = mean(good_estimations)
    results_bad[n-start+1] = mean(bad_estimations)
    results_corrected[n-start+1] = mean(corrected_estimations)
}

tibble(x = rep(sample_sizes, 3),
       y = c(results_good, results_bad, results_corrected),
       gr = factor(rep(1:3, each = length(sample_sizes)),
                   labels = c("results_good", "results_bad", "results_corrected"))) |> 
    ggplot(aes(x, y, color = gr)) +
    geom_jitter() +
    theme(legend.position = "bottom")



sample_sizes = start:100
tests = 100

results = sample_sizes
results_corrected = sample_sizes

for (n in sample_sizes) {
    samples = matrix(runif(n*tests), n)
    
    estimations = apply(samples, 2, max)
    corrected_estimations = apply(samples, 2, JN_bias_correction, estimator = max)
    
    results[n-start+1] = mean(estimations)
    results_corrected[n-start+1] = mean(corrected_estimations)
}

tibble(x = rep(sample_sizes, 2),
       y = c(results, results_corrected),
       gr = factor(rep(1:2, each = length(sample_sizes)),
                   labels = c("results", "results_corrected"))) |> 
    ggplot(aes(x, y, color = gr)) +
    geom_jitter() +
    theme(legend.position = "bottom")

