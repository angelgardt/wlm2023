library(tidyverse)
theme_set(theme_bw())

#1
set.seed(123)
diamonds %>% 
  slice(sample(1:nrow(diamonds), 1000)) -> diam1000

#2-3
ggplot(diam1000, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm")

ggplot(diam1000, aes(x = carat, y = price)) +
  geom_point() + 
  geom_smooth(method = "lm")


#4-10
pd <- position_dodge(.6)
diamonds %>% 
  ggplot(aes(cut, price, color = clarity)) +
  stat_summary(fun.data = mean_cl_boot,
               geom = "errorbar",
               position = pd,
               width = .4) +
  stat_summary(fun = mean, 
               geom = "point",
               position = pd) +
  labs(x = "Качество огранки",
       y = "Цена",
       color = "Категория чистоты",
       title = "Зависимость цены бриллианта от его характеристик",
       subtitle = "Чистота и качество огранки",
       caption = "отображен 95% доверительный интервал") +
  theme_bw() +
  # scale_color_manual(values = c("brown4", 
  #                               "chocolate4", 
  #                               "darkgoldenrod4",
  #                               "darkolivegreen4",
  #                               "darkslateblue",
  #                               "darkslategray",
  #                               "deeppink4",
  #                               "seagreen4"))
  scale_color_manual(values = colorspace::rainbow_hcl(
    diamonds$clarity %>% unique() %>% length()
  )) +
  theme(legend.position = "bottom")


# 11
ggsave("price-cut-clarity.jpeg", 
       width = 20, 
       height = 20, 
       units = "cm",
       dpi = 600)

# diamonds %>% colnames

# 12
diamonds %>% 
  ggplot(aes(price)) +
  geom_density()


diamonds %>% 
  ggplot(aes(price)) +
  geom_histogram(binwidth = 1500)


diamonds %>% 
  ggplot(aes(price)) +
  geom_histogram() +
  facet_wrap(~ color)

diamonds %>% 
  ggplot(aes(price)) +
  geom_histogram() +
  facet_grid(cut ~ color)


diamonds %>% 
  ggplot(aes(color)) +
  geom_bar()


diamonds %>% 
  summarise(n = n(),
            .by = color) %>% 
  ggplot(aes(color, n)) +
  geom_col()


diamonds %>% 
  ggplot(aes(clarity, carat, 
             #fill = color
             )) +
  geom_boxplot() 
 # facet_wrap(~ cut)


diam1000 %>% 
  ggplot(aes(clarity, carat)) +
  geom_violin() +
  geom_point(position = position_dodge(.4),
             alpha = .2) +
  stat_summary(fun.data = mean_cl_boot,
               geom = "pointrange",
               color = "blue")



taia <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr5/taia_items.csv")

str(taia)

taia %>% select(starts_with("pr")) %>% cor() -> cormat

ggcorrplot::ggcorrplot(cormat,
                       type = "lower", lab = TRUE,
                       colors = c("indianred", "white", "royalblue"),
                       show.legend = FALSE,
                       title = "Predictability. Interitem correlations")


set.seed(999)
sim <- matrix(rnorm(30*20, mean = 5, sd = 2), ncol = 20)

sim %>% 
  as_tibble() %>% 
  pivot_longer(cols = everything()) %>% 
  ggplot(aes(value)) +
  geom_histogram() +
  facet_wrap(~ name) +
  geom_vline(xintercept = 5)



fit <- lm(price ~ carat, diamonds)

diamonds %>% 
  ggplot(aes(carat, price)) +
  geom_point() +
  geom_line(aes(y = fit$fitted.values),
            color = "red")



