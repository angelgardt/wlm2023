pkgs <- c("EFAtools","ggcorrplot", "factoextra", "psych")
install.packages(pkgs[!pkgs %in% installed.packages()])



library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")
library(factoextra)
library(GPArotation)

pizza <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr16/pizza.csv")
str(pizza)
unique(pizza$brand)

pizza %>% select(-brand, -id) -> pizza2
pizza %>% mutate(brand = as_factor(brand)) -> pizza

summary(pizza2)
sapply(pizza2, sd)

round(cor(pizza2), 2)
cor(pizza2) %>% ggcorrplot::ggcorrplot(colors = c("red3", "white", "blue3"),
                                       lab = TRUE)
GGally::ggpairs(pizza2)


pca <- prcomp(pizza2, scale. = TRUE)
pca

summary(pca)


ggplot(NULL,
       aes(x = names(summary(pca)$importance[1, ]),
           y = summary(pca)$importance[1, ])) +
  geom_hline(yintercept = 1, linetype = "dashed") +
  geom_line(aes(group = 1)) +
  geom_point() +
  labs(x = "Principal Components",
       y = "Standard Deviation")


ggplot(NULL,
       aes(names(summary(pca)$importance[2, ]),
           summary(pca)$importance[2, ])) +
  geom_line(aes(group = 1)) +
  geom_point(size = 2) +
  labs(x = "Principal components",
       y = "Variance Proportion")


ggplot(NULL,
       aes(names(summary(pca)$importance[3, ]),
           summary(pca)$importance[3, ])) +
  geom_hline(yintercept = .8, linetype = "dashed") +
  geom_line(aes(group = 1)) +
  geom_point(size = 2) +
  labs(x = "Principal components",
       y = "Cumulative Variance Proportion")


pca$rotation[, 1:2]


fviz_pca_var(pca,
             col.var = "contrib",
             gradient.cols = c("red3", "yellow3", "blue3"),
             repel = TRUE)


fviz_pca_biplot(pca,
                col.var = "blue3",
                col.ind = "gray30",
                repel = TRUE,
                geom.ind = "point")

fviz_pca_ind(pca,
             geom.ind = "point",
             col.ind = pizza$brand)


pca$x[, 1:2]


EFAtools::BARTLETT(pizza2)
EFAtools::KMO(pizza2)


factanal(pizza2, factors = 5)
factanal(pizza2, factors = 4)
factanal(pizza2, factors = 3)
factanal(pizza2, factors = 2)


psych::fa.parallel(pizza2, fa = "fa", fm = "ml")
psych::fa.parallel(pizza2, fa = "both", fm = "ml")


fan <- factanal(pizza2, 
         factors = 2, 
         scores = "regression")

fan$loadings
fan$scores


pizza %>% 
  bind_cols(fan$scores) %>% 
  ggplot(aes(Factor1, Factor2,
             color = brand)) +
  geom_point()


tolunc <- read_csv2("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr16/tolerance_uncertainty.csv")
str(tolunc)

tolunc %>% select(-sex, -age) -> tu

cor(tu) %>% 
  ggcorrplot::ggcorrplot(color = c("red3", "white", "blue3"),
                         lab = TRUE)

EFAtools::BARTLETT(tu)
EFAtools::KMO(tu)


psych::fa.parallel(tu, fa = "fa", fm = 'ml')


factanal(tu, factors = 1)
factanal(tu, factors = 2)
factanal(tu, factors = 3)
factanal(tu, factors = 4)


factanal(tu, factors = 4, rotation = "promax")
factanal(tu, factors = 4, rotation = "oblimin")


