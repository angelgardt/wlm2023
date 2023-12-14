#1

library(tidyverse)
str(diamonds)

set.seed(123)
diamonds %>% 
    slice(sample(1:nrow(diamonds), 1000)) -> diam1000


#2 

ggplot()

diam1000 %>% 
    ggplot()

diam1000 %>% 
    ggplot(aes(x, y))


#3

diam1000 %>% 
    ggplot(aes(x, y)) +
    geom_point()

diam1000 %>% 
    ggplot(aes(x, y)) +
    geom_point() +
    geom_smooth()


#4

diam1000 %>% 
    ggplot(aes(x, y, color = color)) +
    geom_point(alpha = .5) +
    geom_smooth()


#5

diamonds %>% 
    ggplot(aes(cut, price)) +
    stat_summary(fun.data = mean_cl_boot, geom = "errorbar") +
    stat_summary(fun = mean, geom = "point")


#6

pd <- position_dodge(0.5)
diamonds %>% 
    ggplot(aes(cut, price, color = color)) +
    stat_summary(fun.data = mean_cl_boot, geom = "errorbar",
                 position = pd, width = .4) +
    stat_summary(fun = mean, geom = "point",
                 position = pd)


#7

diamonds %>% 
    ggplot(aes(cut, price, color = color)) +
    stat_summary(fun.data = mean_cl_boot, geom = "errorbar",
                 position = pd, width = .4) +
    stat_summary(fun = mean, geom = "point",
                 position = pd) +
    theme_bw() +
    theme(legend.position = "bottom")


#8

diamonds %>% 
    ggplot(aes(cut, price, color = color)) +
    stat_summary(fun.data = mean_cl_boot, geom = "errorbar",
                 position = pd, width = .4) +
    stat_summary(fun = mean, geom = "point",
                 position = pd) +
    theme_bw() +
    theme(legend.position = "bottom") +
    scale_color_manual(values = c('brown4', 
                                  'chocolate4', 
                                  'darkgoldenrod4', 
                                  'darkolivegreen', 
                                  'darkslategray', 
                                  'darkslateblue', 
                                  'deeppink4'))

diamonds %>% 
    ggplot(aes(cut, price, color = color)) +
    stat_summary(fun.data = mean_cl_boot, geom = "errorbar",
                 position = pd, width = .4) +
    stat_summary(fun = mean, geom = "point",
                 position = pd) +
    theme_bw() +
    theme(legend.position = "bottom") +
    scale_color_manual(values = colorspace::rainbow_hcl(diamonds$color %>%
                                                            unique() %>% 
                                                            length()))


#9
diamonds %>% 
    ggplot(aes(cut, price, color = color)) +
    stat_summary(fun.data = mean_cl_boot, geom = "errorbar",
                 position = pd, width = .4) +
    stat_summary(fun = mean, geom = "point",
                 position = pd) +
    theme_bw() +
    theme(legend.position = "bottom") +
    scale_color_manual(values = colorspace::rainbow_hcl(diamonds$color %>%
                                                            unique() %>% 
                                                            length())) +
    labs(x = "Качество огранки",
         y = "Цена",
         color = "Цвет",
         title = "Зависимость цены бриллианта от его характеристик",
         subtitle = "Качество огранки и цвет",
         caption = "отображен 95% доверительный интервал")


#10
diamonds %>% 
    ggplot(aes(cut, price, color = color)) +
    stat_summary(fun.data = mean_cl_boot, geom = "errorbar",
                 position = pd, width = .4) +
    stat_summary(fun = mean, geom = "point",
                 position = pd) +
    facet_wrap(~ clarity) +
    theme_bw() +
    theme(legend.position = "bottom") +
    scale_color_manual(values = colorspace::rainbow_hcl(diamonds$color %>%
                                                            unique() %>% 
                                                            length())) +
    labs(x = "Качество огранки",
         y = "Цена",
         color = "Цвет",
         title = "Зависимость цены бриллианта от его характеристик",
         subtitle = "Качество огранки, цвет и чистота",
         caption = "отображен 95% доверительный интервал")


#11
ggsave('graph1.png', width = 20, height = 20, units = 'cm')


#12
diamonds %>% 
    ggplot(aes(price)) +
    geom_histogram()

diamonds %>% 
    ggplot(aes(price)) +
    geom_density()


#13
diamonds %>% 
    ggplot(aes(color)) +
    geom_bar()


#14
diamonds %>% 
    ggplot(aes(cut, price, fill = color)) +
    geom_boxplot() +
    facet_wrap(~ clarity) +
    theme_bw() +
    theme(legend.position = "bottom") +
    scale_color_manual(values = colorspace::rainbow_hcl(diamonds$color %>%
                                                            unique() %>% 
                                                            length())) +
    labs(x = "Качество огранки",
         y = "Цена",
         color = "Цвет",
         title = "Зависимость цены бриллианта от его характеристик",
         subtitle = "Качество огранки, цвет и чистота",
         caption = "отображен 95% доверительный интервал")


#15
diamonds %>% 
    ggplot(aes(cut, price, fill = color)) +
    geom_violin() +
    facet_wrap(~ clarity) +
    theme_bw() +
    theme(legend.position = "bottom") +
    scale_color_manual(values = colorspace::rainbow_hcl(diamonds$color %>%
                                                            unique() %>% 
                                                            length())) +
    labs(x = "Качество огранки",
         y = "Цена",
         color = "Цвет",
         title = "Зависимость цены бриллианта от его характеристик",
         subtitle = "Качество огранки, цвет и чистота",
         caption = "отображен 95% доверительный интервал")


#16
fit <- lm(price ~ carat, diamonds)

diamonds %>% 
    ggplot(aes(carat, price)) +
    geom_point() +
    geom_line(aes(y = fit$fitted.values),
              color = "red")

#17
taia <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr5/taia_items.csv")
ggcorrplot::ggcorrplot(cor(taia %>% select(starts_with("pr"))))


#18
ggcorrplot::ggcorrplot(cor(taia %>% select(starts_with("pr"))),
                       type = "lower", lab = TRUE, lab_size = 3,
                       colors = c("indianred1", "white", "royalblue1"),
                       title = "Predictability. Interitems correlations",
                       show.legend = FALSE)


#19
set.seed(999)
sim <- matrix(rnorm(30*20, mean = 5, sd = 2), ncol = 20)

sim %>% 
    as_tibble() %>% 
    pivot_longer(cols = everything()) %>% 
    ggplot(aes(value)) +
    geom_histogram() +
    facet_wrap(~ name)


#20
sim %>% 
    as_tibble() %>% 
    pivot_longer(cols = everything()) %>% 
    ggplot(aes(value)) +
    geom_histogram() +
    facet_wrap(~ name) +
    geom_vline(xintercept = 5)








