# HW5 // Solutions
# A. Angelgardt

# MAIN

# 1
library(tidyverse)
share <- read_delim("data/hw5/share.csv", delim = " ", locale = locale(decimal_mark = ","))

share %>% 
  ggplot(aes(as_factor(setsize), time1)) +
  stat_summary(fun = mean, geom = "point")

# 2

pd = position_dodge(.7)

share %>% 
  filter(trialtype != "both") %>% 
  ggplot(aes(as_factor(setsize), time1,
             color = trialtype,
             shape = platform)) +
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar",
               position = pd) +
  stat_summary(fun = mean, geom = "point",
               position = pd)

# 3
share %>% 
  filter(trialtype != "both") %>% 
  ggplot(aes(as_factor(setsize), time1,
             color = trialtype,
             shape = platform,
             group = interaction(trialtype, platform))) +
  stat_summary(fun = mean, geom = "line",
               position = pd) +
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar",
               position = pd) +
  stat_summary(fun = mean, geom = "point",
               position = pd)

# 4
share %>% 
  filter(trialtype != "both") %>% 
  ggplot(aes(as_factor(setsize), time1,
             color = trialtype,
             shape = platform,
             group = interaction(trialtype, platform))) +
  stat_summary(fun = mean, geom = "line",
               position = pd, linetype = "dashed", alpha = .7) +
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar",
               position = pd) +
  stat_summary(fun = mean, geom = "point",
               position = pd, size = 3)

# 5
share %>% 
  filter(trialtype != "both") %>% 
  ggplot(aes(as_factor(setsize), time1,
             color = trialtype,
             shape = platform,
             group = interaction(trialtype, platform))) +
  stat_summary(fun = mean, geom = "line",
               position = pd, linetype = "dashed", alpha = .7) +
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar",
               position = pd, width = .3) +
  stat_summary(fun = mean, geom = "point",
               position = pd, size = 3)

# 6
share %>% 
  filter(trialtype != "both") %>% 
  ggplot(aes(as_factor(setsize), time1,
             color = trialtype,
             shape = platform,
             group = interaction(trialtype, platform))) +
  stat_summary(fun = mean, geom = "line",
               position = pd, linetype = "dashed", alpha = .7) +
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar",
               position = pd, width = .3) +
  stat_summary(fun = mean, geom = "point",
               position = pd, size = 3) +
  labs(x = "Количество стимулов в пробе",
       y = "Время реакции (первый клик), с",
       color = "Тип пробы",
       shape = "Платформа")

# 7
share %>% 
  filter(trialtype != "both") %>% 
  ggplot(aes(as_factor(setsize), time1,
             color = trialtype,
             shape = platform,
             group = interaction(trialtype, platform))) +
  stat_summary(fun = mean, geom = "line",
               position = pd, linetype = "dashed", alpha = .7) +
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar",
               position = pd, width = .3) +
  stat_summary(fun = mean, geom = "point",
               position = pd, size = 3) +
  labs(x = "Количество стимулов в пробе",
       y = "Время реакции (первый клик), с",
       color = "Тип пробы",
       shape = "Платформа",
       title = "Время реакции при взаимодействии факторов",
       subtitle = "Тип пробы × Платформа × Количество стимулов в пробе",
       caption = "отображен 95% доверительный интервал")

# 8
share %>% 
  filter(trialtype != "both") %>% 
  ggplot(aes(as_factor(setsize), time1,
             color = trialtype,
             shape = platform,
             group = interaction(trialtype, platform))) +
  stat_summary(fun = mean, geom = "line",
               position = pd, linetype = "dashed", alpha = .7) +
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar",
               position = pd, width = .3) +
  stat_summary(fun = mean, geom = "point",
               position = pd, size = 3) +
  labs(x = "Количество стимулов в пробе",
       y = "Время реакции (первый клик), с",
       color = "Тип пробы",
       shape = "Платформа",
       title = "Время реакции при взаимодействии факторов",
       subtitle = "Тип пробы × Платформа × Количество стимулов в пробе",
       caption = "отображен 95% доверительный интервал") +
  scale_color_manual(values = c(dots = "gray50", tray = "black"),
                     labels = c(dots = "Three Dots", tray = "Outgoing Tray")) +
  scale_shape_discrete(labels = c(android = "Android", ios = "iOS"))

# 9
share %>% 
  filter(trialtype != "both") %>% 
  ggplot(aes(as_factor(setsize), time1,
             color = trialtype,
             shape = platform,
             group = interaction(trialtype, platform))) +
  stat_summary(fun = mean, geom = "line",
               position = pd, linetype = "dashed", alpha = .7) +
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar",
               position = pd, width = .3) +
  stat_summary(fun = mean, geom = "point",
               position = pd, size = 3) +
  labs(x = "Количество стимулов в пробе",
       y = "Время реакции (первый клик), с",
       color = "Тип пробы",
       shape = "Платформа",
       title = "Время реакции при взаимодействии факторов",
       subtitle = "Тип пробы × Платформа × Количество стимулов в пробе",
       caption = "отображен 95% доверительный интервал") +
  scale_color_manual(values = c(dots = "gray50", tray = "black"),
                     labels = c(dots = "Three Dots", tray = "Outgoing Tray")) +
  scale_shape_discrete(labels = c(android = "Android", ios = "iOS")) +
  theme_bw() +
  theme(legend.position = "bottom")

# 10
ggsave("test.jpg", width = 20, height = 18, units = "cm", dpi = 600)

# ADDITIONAL

# 1
share %>% 
  filter(trialtype != "both") %>% 
  ggplot(aes(as_factor(setsize), time1,
             color = trialtype,
             shape = platform,
             group = interaction(trialtype, platform))) +
  stat_summary(fun = mean, geom = "line",
               position = pd, linetype = "dashed", alpha = .7) +
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar",
               position = pd, width = .3) +
  stat_summary(fun = mean, geom = "point",
               position = pd, size = 3) +
  labs(x = "Количество стимулов в пробе",
       y = "Время реакции (первый клик), с",
       color = "Тип пробы",
       shape = "Платформа",
       title = "Время реакции при взаимодействии факторов",
       subtitle = "Тип пробы × Платформа × Количество стимулов в пробе",
       caption = "отображен 95% доверительный интервал") +
  scale_color_manual(values = c("gray50", "black"),
                     labels = c("Three Dots", "Outgoing Tray")) +
  scale_shape_discrete(labels = c("Android", "iOS")) +
  theme_bw() +
  theme(legend.position = "bottom",
        text = element_text(family = "Times New Roman"),
        plot.title = element_text(face = "bold"))

# 2
taia <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/hw5/taia_short.csv")

theme_set(theme_bw())

taia %>% 
  filter(id %in% 1:5) %>% 
  ggplot(aes(subscale, subscale_score, fill = subscale)) +
  geom_col() +
  geom_label(aes(label = subscale_score)) +
  facet_wrap(~ id) +
  labs(x = "Шкала опросника",
       y = "Балл по шкале") +
  guides(fill = "none")

# 3

taia %>% 
  filter(id %in% 22:24) %>% 
  ggplot(aes(subscale, subscale_score, fill = subscale)) +
  geom_col() +
  geom_label(aes(label = subscale_score)) +
  coord_polar() +
  facet_wrap(~ id) +
  labs(fill = "Шкала") +
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 0),
        axis.text.x = element_text(size = 0),
        axis.title.y = element_text(size = 0),
        axis.text.y = element_text(size = 0))


# 4
## install.packages("svglite")
ggsave("test.svg")

# 5
vowels <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/hw5/vowels.csv")

vowels %>% 
  ggplot(aes(f2, f1,
             label = phoneme, color = phoneme)) +
  geom_text(alpha = .5) +
  stat_ellipse(level = .8) +
  scale_x_reverse(position = "top") +
  scale_y_reverse(position="right") +
  facet_grid(reduction ~ .,
             labeller = labeller(reduction = c("1" = "Редукция\n отсутствует",
                                               "2" = "Первая\n степень редукции",
                                               "3" = "Вторая\n степень редукции"))) +
  guides(color = "none") +
  labs(x = "F2",
       y = "F1")
