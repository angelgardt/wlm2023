library(tidyverse)
theme_set(theme_bw())
library(ggstance)

set.seed(123)
tibble(sym = rnorm(1000),
       right = rgamma(1000, 3),
       left = rbeta(1000, 7, 1.5)) -> sim
sim |> 
    ggplot(aes(x = sym, y = -.5)) +
    geom_boxploth() +
    geom_density(aes(x = sym), inherit.aes = FALSE) +
    stat_boxploth(geom = "vline", aes(xintercept = ..xlower..), linetype = "dashed") +
    stat_boxploth(geom = "vline", aes(xintercept = ..xmiddle..), linetype = "dashed") +
    stat_boxploth(geom = "vline", aes(xintercept = ..xupper..), linetype = "dashed") +
    geom_hline(yintercept = 0, color = "gray50") +
    labs(x = "Value", y = "")

sim |> 
    ggplot(aes(x = left, y = -.5)) +
    geom_boxploth() +
    geom_density(aes(x = left), inherit.aes = FALSE) +
    stat_boxploth(geom = "vline", aes(xintercept = ..xlower..), linetype = "dashed") +
    stat_boxploth(geom = "vline", aes(xintercept = ..xmiddle..), linetype = "dashed") +
    stat_boxploth(geom = "vline", aes(xintercept = ..xupper..), linetype = "dashed") +
    geom_hline(yintercept = 0, color = "gray50") +
    labs(x = "Value", y = "")

sim |> 
    ggplot(aes(x = right, y = -.5)) +
    geom_boxploth() +
    geom_density(aes(x = right), inherit.aes = FALSE) +
    stat_boxploth(geom = "vline", aes(xintercept = ..xlower..), linetype = "dashed") +
    stat_boxploth(geom = "vline", aes(xintercept = ..xmiddle..), linetype = "dashed") +
    stat_boxploth(geom = "vline", aes(xintercept = ..xupper..), linetype = "dashed") +
    geom_hline(yintercept = 0, color = "gray50") +
    labs(x = "Value", y = "")
