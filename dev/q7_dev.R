library(tidyverse)
theme_set(theme_bw())

(c(1:8, 6:1)/57) %>% sum()

tibble(x = -5:8,
       y = c(1:8, 6:1)/57) %>% 
  ggplot(aes(x, y)) +
  geom_point() +
  scale_x_continuous(breaks = -5:8) +
  scale_y_continuous(breaks = seq(0,1,by = .01)) +
  labs(x = "Value", y = "Probability") +
  theme(axis.text.x = element_text(size = 15))

set.seed(24)
tibble(x = c(rnorm(100, 5, 2), rnorm(30, -3, 4))) %>% 
  # pull() %>% quantile()
  ggplot(aes(y = x)) +
  geom_boxplot() +
  guides(x = "none") +
  scale_y_continuous(breaks = seq(-10, 10, by = 2)) +
  labs(y = "Value")

set.seed(13)
tibble(x = c(rbeta(100, 2, 3), rgamma(70, 2, 3))) %>% 
  # pull() %>% median()
  # pull() %>% mean()
  ggplot(aes(x)) +
  geom_histogram(aes(y = after_stat(density)),
                 fill = 'gray70') +
  geom_density() +
  geom_vline(xintercept = 0.35, color = "green4", size = 1) +
  geom_vline(xintercept = 0.54, color = "red4", linetype = "dashed", size = 1) +
  geom_vline(xintercept = 0.45, color = "blue4", linetype = "dotted", size = 1)


tibble(x = seq(0, 5, .01),
       y = df(x, df1 = 3, df2 = 104)) -> f_quantile

f_quantile %>% 
  ggplot(aes(x, y)) +
  geom_line() +
  geom_area(data = f_quantile %>% filter(x > qf(.95, df1 = 3, df2 = 104)),
            fill = "blue3", alpha = .5) +
  geom_vline(xintercept = qf(.95, df1 = 3, df2 = 104)) +
  annotate(geom = "text", label = "0.05",
           x = 3, y = .02, color = "darkblue") +
  labs(x = "Value", y = "Density")

tibble(x = seq(-3.5, 3.5, .01),
       y = dt(x, df = 5)) -> t_quantile

t_quantile %>% 
  ggplot(aes(x, y)) +
  geom_line(color = "darkblue") +
  geom_area(data = t_quantile %>% filter(x > qt(.025, df = 5) & x < qt(.975, df = 5)), 
            fill = "blue3", alpha = .5) +
  geom_vline(xintercept = qt(.975, df = 5)) +
  geom_vline(xintercept = qt(.025, df = 5)) +
  annotate(geom = "text", label = "0.95",
           x = 0, y = .1, color = "darkblue") +
  labs(x = "Value", y = "Density")

set.seed(605)
tibble(V1 = rnorm(1000, 5, 5),
       V2 = rbeta(1000, 4, 1) * 20,
       V3 = rgamma(1000, 2) * 5,
       V4 = rnorm(1000, 6, 2)) %>% 
  pivot_longer(cols = everything()) %>% 
  ggplot(aes(y = value)) +
  geom_boxplot() +
  facet_wrap(~ name, ncol = 4) +
  guides(x = "none") +
  labs(y = "Value")

set.seed(938)
tibble(A_x = rnorm(100),
       A_y = rnorm(100),
       B_x = rnorm(100),
       B_y = 2.3 * B_x + 2 + rnorm(100),
       C_x = rnorm(100),
       C_y = abs(C_x) + rnorm(100, .1),
       D_x = rnorm(100),
       D_y = D_x ^ 3 + rnorm(100, 0.6)^2,
       id = 1:100) %>% 
  pivot_longer(cols = -id) %>% 
  separate(name, into = c("graph", "axis")) %>% 
  pivot_wider(names_from = axis, values_from = value) -> cor_data

cor_data %>% 
  summarise(cor = cor(x, y),
            .by = graph)

cor_data %>% 
  ggplot(aes(x, y)) +
  geom_point() +
  facet_wrap(~ graph, scales = "free_y")



