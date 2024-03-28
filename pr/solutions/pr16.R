### P16 // Solutions
### A. Angelgardt

# MAIN
pkgs <- c("EFAtools","ggcorrplot", "factoextra", "psych")

install.packages(pkgs[!pkgs %in% installed.packages()])

library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")
library(factoextra)


# 1
pizza <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr16/pizza.csv")
str(pizza)

pizza %>% mutate(brand = as_factor(brand),
                 id = as_factor(id)) -> pizza
pizza %>% select(-brand, -id) -> pizza2


# 2
summary(pizza2)
sapply(pizza2, sd)

# 3
round(cor(pizza2), 2)
cor(pizza2) %>% ggcorrplot::ggcorrplot(colors = c("red3", "white", "blue3"),
                                       lab = TRUE)
GGally::ggpairs(pizza2)

# 4
pca <- prcomp(pizza2, scale. = TRUE) # standattized vars
pca

# 5
summary(pca)

# 6
## a
ggplot(NULL,
       aes(names(summary(pca)$importance[1, ]),
           summary(pca)$importance[1, ])) +
  geom_hline(yintercept = 1, linetype = "dashed") +
  geom_line(aes(group = 1)) +
  geom_point(size = 2) +
  labs(x = "Principal components",
       y = "Standard Deviation")

## b
ggplot(NULL,
       aes(names(summary(pca)$importance[2, ]),
           summary(pca)$importance[2, ])) +
  geom_line(aes(group = 1)) +
  geom_point(size = 2) +
  labs(x = "Principal components",
       y = "Variance Proportion")

## c
ggplot(NULL,
       aes(names(summary(pca)$importance[3, ]),
           summary(pca)$importance[3, ])) +
  geom_hline(yintercept = .8, linetype = "dashed") +
  geom_line(aes(group = 1)) +
  geom_point(size = 2) +
  labs(x = "Principal components",
       y = "Cumulative Variance Proportion")


# 7
fviz_pca_var(pca,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

# 8
fviz_pca_biplot(pca, repel = TRUE,
                col.var = "#2E9FDF", # Variables color
                col.ind = "#696969",  # Individuals color
                geom.ind = "point"
)

# 9
pca$rotation
pca$x[, 1:2]


# 10
fviz_pca_ind(pca,
             geom.ind = "point",
             col.ind = pizza$brand)


# 11
EFAtools::BARTLETT(pizza2)
EFAtools::KMO(pizza2)


# 12
factanal(pizza2, factors = 5)
factanal(pizza2, factors = 4)
factanal(pizza2, factors = 3)
factanal(pizza2, factors = 2)


# 13
psych::fa.parallel(pizza2, fa = "fa", fm = "ml")
psych::fa.parallel(pizza2, fa = "both", fm = "ml")

# 14
factanal(pizza2, factors = 3)
factanal(pizza2, factors = 2)

# 15

# 16

# 17

# 18

# 19

# 20



# ADDITIONAL

# 1

# 2

# 3

# 4

# 5

# 6

# 7

# 8

# 9

# 10
