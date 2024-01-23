library(tidyverse)
theme_set(theme_bw())

tibble(x = seq(0, 5, .01),
       y = df(x, df1 = 3, df2 = 104)) -> f_quantile

f_quantile %>% 
  ggplot(aes(x, y)) +
  geom_line() +
  geom_area(data = f_quantile %>% filter(x > qf(.95, df1 = 3, df2 = 104)),
            fill = "blue3", alpha = .5) +
  geom_vline(xintercept = qf(.95, df1 = 3, df2 = 104)) +
  annotate(geom = "text", label = "0.05",
           x = 3, y = .02, color = "darkblue")

