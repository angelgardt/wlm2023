library(tidyverse)
theme_set(theme_bw())

dir.create("antideriv_pics")


x_lines <- seq(-3, 3, length.out = 20) %>% round(3)

tibble(x = seq(-3, 3, by = .001),
       func = dnorm(x),
       integral = pnorm(x)) -> antideriv_data

tibble(x = x_lines,
       y = pnorm(x)) -> antideriv_points

# i = 3

for (i in 1:20) {
  gridExtra::grid.arrange(
    antideriv_data %>%
      ggplot(aes(x, integral)) +
      # geom_area(
      #   data = antideriv_data %>% filter(x < x_lines[2]),
      #   fill = "royalblue",
      #   alpha = .5
      # ) +
      geom_line(size = 1) +
      geom_vline(xintercept = x_lines[i],
                 color = "royalblue") +
      annotate(
        geom = "point",
        x = x_lines[i],
        y = antideriv_points$y[i],
        size = 2,
        color = "royalblue"
      ) +
      # #  facet_wrap(~ name, nrow = 2, scales = "free_y") +
      labs(y = "F(x)"),
    
    antideriv_data %>%
      ggplot(aes(x, func)) +
      geom_area(
        data = antideriv_data %>% filter(x < x_lines[i]),
        fill = "royalblue",
        alpha = .5
      ) +
      geom_line(size = 1) +
      geom_vline(xintercept = x_lines[i],
                 color = "royalblue") +
      #  facet_wrap(~ name, nrow = 2, scales = "free_y") +
      labs(y = "f(x)")
  ) -> current_plot
  
  ggsave(paste0("antideriv_pics/antideriv", i, ".png"), current_plot)
  
}
  
  # antideriv_data %>%
  #   ggplot(aes(x, integral)) +
  #   # geom_area(
  #   #   data = antideriv_data %>% filter(x < x_lines[2]),
  #   #   fill = "royalblue",
  #   #   alpha = .5
  #   # ) +
  #   geom_line(size = 1) +
  #   geom_vline(xintercept = x_lines[i],
  #              color = "royalblue") +
  #   annotate(geom = "point",
  #            x = x_lines[i],
  #            y = antideriv_points$y[i],
  #            size = 2,
  #            color = "royalblue") +
  #   # #  facet_wrap(~ name, nrow = 2, scales = "free_y") +
  #   labs(y = "Value"),
  # 
  # antideriv_data %>%
  #   ggplot(aes(x, func)) +
  #   geom_area(
  #     data = antideriv_data %>% filter(x < x_lines[i]),
  #     fill = "royalblue",
  #     alpha = .5
  #   ) +
  #   geom_line(size = 1) +
  #   geom_vline(xintercept = x_lines[i],
  #              color = "royalblue") +
  #   #  facet_wrap(~ name, nrow = 2, scales = "free_y") +
  #   labs(y = "Value")
  

# ggsave("pics/antideriv.png", antideriv)




# ggsave("pics/antideriv.svg", antideriv)
