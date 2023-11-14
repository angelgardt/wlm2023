library(tidyverse)
theme_set(theme_bw())

str(diamonds)

set.seed(34)
diam <- diamonds %>% slice(sample(1:nrow(diamonds),
                                  1000, replace = FALSE))
summary(diam)

diam %>% 
  ggplot(aes(x = x,
             y = y,
             # color = cut,
             shape = cut)) +
  geom_point(alpha = .3) +
  geom_smooth(method = "lm")

# mean_cl_boot(diam$price)

pd <- position_dodge(.7)

diam %>% 
  ggplot(aes(x = cut,
             y = price,
             color = color
             )) +
  # stat_summary(fun = mean, geom = "line", group = 1) +
  stat_summary(fun = mean,
               geom = "point",
               position = pd,
               size = 2) +
  stat_summary(fun.data = mean_cl_boot, 
               geom = "errorbar",
               position = pd,
               width = .9) +
  facet_wrap(~ clarity) +
  # facet_grid(color ~ clarity) +
  # scale_color_manual(values = c("brown4", 
  #                               "chocolate4", 
  #                               "darkgoldenrod4",
  #                               "darkolivegreen4", 
  #                               "darkslategray4", 
  #                               "darkslateblue",
  #                               "deeppink4")) +
  scale_color_manual(
    values = colorspace::rainbow_hcl(diam$color %>%
                                       unique() %>% 
                                       length())
    ) +
  scale_x_discrete(labels = c(
    Fair = "нормальное",
    Good = "хорошее",
    `Very Good` = "очень хорошее",
    Premium = "премиальное",
    Ideal = "идеальное"
  )) +
  labs(x = "Качество огранки",
       y = "Цена, руб",
       color = "Цвет",
       title = "Зависимость цены бриллиантов от их характеристик",
       subtitle = "Цвет и качество огранки",
       caption = "отображён 95% доверительный интервал") +
  theme(legend.position = "bottom",
        axis.text = element_text(family = "Times"),
        axis.text.x = element_text(
          angle = 90
        ))

ggsave("graph.png", 
         width = 20, 
         height = 20,
         units = "cm", 
         dpi = "print")

# str(diam$clarity)

diam %>% 
  ggplot(aes(price)) +
  geom_histogram(binwidth = 50)

diam %>% 
  ggplot(aes(price, fill = color)) +
  geom_density(alpha = .3)

diam %>% 
  ggplot(aes(color, fill = clarity)) +
  geom_bar(position = position_dodge())


diam %>% 
  ggplot(aes(color, fill = color)) +
  geom_bar(position = position_dodge()) +
  guides(fill = "none")



