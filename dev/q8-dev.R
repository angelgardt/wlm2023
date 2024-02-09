library(tidyverse)
theme_set(theme_bw())

ggplot() +
  geom_hline(yintercept = 0, linetype = "dotted", color = "gray") +
  geom_vline(xintercept = 0, linetype = "dotted", color = "gray") +
  geom_abline(slope = 1.3, intercept = -2.4, color = "blue4", size = 1) +
  geom_abline(slope = 0.8, intercept = -2.4, color = "red4", linetype = "dashed", size = 1) +
  xlim(-20, 20) +
  ylim(-20, 20) +
  labs(x = "X", y = "Y")


set.seed(13)
tibble(x = rnorm(100),
       y = 0.3 - 2.6 * x + rnorm(100)) -> r2_data

r2_data %>% 
  ggplot(aes(x, y)) +
  geom_point() +
  geom_abline(intercept = 0.3, slope = -2.6, size = 1, color = "red4") +
  geom_abline(intercept = 0.3, slope = -1.8, size = 1, color = "blue4") +
  geom_abline(intercept = -0.3, slope = 2.6, size = 1, color = "green4") +
  geom_abline(intercept = 0.25, slope = 0.4, size = 1, color = "orange4") +
  annotate(geom = "text", label = "A", x = -2, y = 6.5, color = "red4", size = 8) +
  annotate(geom = "text", label = "B", x = -2, y = 3, color = "blue4", size = 8) +
  annotate(geom = "text", label = "C", x = -2, y = 0.5, color = "orange4", size = 8) +
  annotate(geom = "text", label = "D", x = -2, y = -4, color = "green4", size = 8)


set.seed(5.5)
tibble(x = runif(1000, 30, 50),
       y = scale(rnorm(1000) + sqrt(x))) %>% 
  ggplot(aes(x, y)) +
  geom_point() +
  geom_smooth(method = "lm",
              color = "red",
              se = FALSE) +
  labs(x = "Fitted Values",
       y = "Standardized Residuals")


set.seed(5932)
tibble(X1 = rnorm(100),
       X2 = 3 + 2.3 * X1 + rnorm(100),
       X3 = .3 - 0.2 * X2 + rnorm(100),
       X4 = rnorm(100)) %>% 
  cor() %>% 
  ggcorrplot::ggcorrplot(colors = c("red3", "white", "blue3"), 
                         lab = TRUE, 
                         show.legend = FALSE,
                         type = "lower")
0.92^2


set.seed(9561)
tibble(X = rnorm(100),
       Y = -6 + 1.1 * X + 1.1 * X^2 + rnorm(100)) -> neg_r2 
neg_r2 %>% 
  ggplot(aes(X, Y)) +
  geom_point() +
  geom_abline(intercept = -3.3, slope = -1.6, size = 1, color = "red4") +
  geom_abline(intercept = -6, slope = 1.8, size = 1, color = "blue4") +
  geom_abline(intercept = -4, slope = 2.6, size = 1, color = "green4") +
  geom_abline(intercept = -6, slope = 0.4, size = 1, color = "orange4") +
  annotate(geom = "text", label = "A", x = -3, y = 2, color = "red4", size = 8) +
  annotate(geom = "text", label = "B", x = 2, y = -1.5, color = "blue4", size = 8) +
  annotate(geom = "text", label = "C", x = -2, y = -6, color = "orange4", size = 8) +
  annotate(geom = "text", label = "D", x = 2, y = 2, color = "green4", size = 8)


