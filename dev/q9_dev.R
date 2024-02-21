library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")

tibble(
  A =     c("A1", "A1", "A2", "A2"),
  B =     c("B1", "B2", "B1", "B2"),
  Y =     c(1.70, 1.80, 1.75, 2.80),
  Ymin =  c(1.50, 1.60, 1.55, 2.60),
  Ymax =  c(1.90, 2.10, 1.95, 3.10),
  facet = "Средние по группам"
) %>% 
  bind_rows(
    tibble(
      A =     c("A1", "A2"),
      Y =     c(1.75, 2.275),
      Ymin =  c(1.55, 2.475),
      Ymax =  c(1.95, 2.075),
      facet = "Средние по фактору A"
    )
  ) %>% 
  bind_rows(
    tibble(
      A =     c("B1", "B2"),
      Y =     c(1.725, 2.30),
      Ymin =  c(1.525, 2.10),
      Ymax =  c(1.925, 2.50),
      facet = "Средние по фактору B"
    )
  ) %>% 
  ggplot(aes(A, Y, color = B, group = B)) +
  geom_line(position = position_dodge(.3)) +
  geom_errorbar(aes(ymin = Ymin,
                    ymax = Ymax),
                width = .2,
                position = position_dodge(.3)) +
  geom_point(size = 2,
             position = position_dodge(.3)) +
  facet_wrap(~ facet, scales = "free_x") +
  labs(x = "", color = "")


tibble(
  A =     c("A1", "A1", "A2", "A2", "A3", "A3"),
  B =     c("B1", "B2", "B1", "B2", "B1", "B2"),
  Y =     c(1.70, 1.75, 1.75, 2.20, 1.80, 1.95),
  Ymin =  c(1.50, 1.55, 1.55, 2.40, 1.60, 1.75),
  Ymax =  c(1.90, 1.95, 1.95, 2.00, 2.00, 2.15),
  facet = "Средние по группам"
) %>% 
  bind_rows(
    tibble(
      A =     c("A1", "A2", "A3"),
      Y =     c(1.725, 1.975, 1.875),
      Ymin =  c(1.625, 1.875, 1.775),
      Ymax =  c(1.825, 2.075, 1.975),
      facet = "Средние по фактору A"
    )
  ) %>%
  bind_rows(
    tibble(
      A =     c("B1", "B2"),
      Y =     c(1.75, 1.967),
      Ymin =  c(1.50, 1.717),
      Ymax =  c(2.00, 2.217),
      facet = "Средние по фактору B"
    )
  ) %>%
  ggplot(aes(A, Y, color = B, group = B)) +
  geom_line(position = position_dodge(.3)) +
  geom_errorbar(aes(ymin = Ymin,
                    ymax = Ymax),
                width = .2,
                position = position_dodge(.3)) +
  geom_point(size = 2,
             position = position_dodge(.3)) +
  facet_wrap(~ facet, scales = "free_x") +
  labs(x = "", color = "")
