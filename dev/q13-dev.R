library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")
library(ggdendro)

pizza <- read_csv('https://raw.githubusercontent.com/angelgardt/hseuxlab-andan/master/Pizza.csv')
pizza %>% select(-id, -brand) -> pizza_efa

fan <- factanal(pizza_efa, 
                 factors = 2, 
                 scores = 'regression')

fan$scores

# k4 <- kmeans(fan$scores, 4)
# 
# k4$tot.withinss
# k4$betweenss
# k4$cluster
# 
# wss <- function(x, k) {
#   wss <- numeric(k)
#   names(wss) <- 1:k
#   for (i in 2:k) {
#     wss[i] <- kmeans(x, i)$tot.withinss
#   }
#   return(wss[-1])
# }
# 
# bss <- function(x, k) {
#   bss <- numeric(k)
#   names(bss) <- 1:k
#   for (i in 2:k) {
#     bss[i] <- kmeans(x, i)$betweenss
#   }
#   return(bss[-1])
# }
# 
# clusters <- function(x, k) {
#   cls <- list()
#   for (i in 2:k) {
#     cls[[i]] <- kmeans(x, i)$cluster
#   }
#   names(cls) <- 1:k
#   return(cls[-1])
# }
# 
# wss(fan$scores, 10)
# bss(fan$scores, 10)
# cls <- clusters(fan$scores, 10)
# 
# tibble(wss = wss(fan$scores, 10),
#        bss = bss(fan$scores, 10),
#        n_cls = 2:10) %>% 
#   pivot_longer(-n_cls) %>% 
#   ggplot(aes(n_cls, value)) +
#   geom_point() +
#   geom_line() +
#   facet_wrap(~ name, ncol = 1)

cls_list <- list()

set.seed(314)

for (i in 2:10) {
  cls_list[[i]] <- kmeans(fan$scores, i)
}

map(cls_list, function(x) x$cluster)


tibble(wss = map(cls_list, function(x) x$tot.withinss) %>% unlist(),
       bss = map(cls_list, function(x) x$betweenss) %>% unlist(),
       n_cls = 2:10) %>% 
  pivot_longer(-n_cls) %>% 
  ggplot(aes(n_cls, value)) +
  geom_point() +
  geom_line() +
  facet_wrap(~ name, ncol = 1)


fan$scores %>% 
  as_tibble() %>% 
  bind_cols(
    map(cls_list, function(x) x$cluster)[-1] %>% 
      as_tibble(.name_repair = "universal") %>% 
      set_names(paste0("n", 2:10))
  ) %>% 
  mutate_at(vars(-1, -2), as.character) %>% # print()
  ggplot(aes(Factor1, Factor2,
             color = n2, shape = n2)) + 
  geom_point() +
  labs(x = "Variable 1",
       y = "Variable 2",
       color = "Clusters",
       shape = "Clusters")

fan$scores %>% 
  as_tibble() %>% 
  bind_cols(
    map(cls_list, function(x) x$cluster)[-1] %>% 
      as_tibble(.name_repair = "universal") %>% 
      set_names(paste0("n", 2:10))
  ) %>% 
  mutate_at(vars(-1, -2), as.character) %>% # print()
  ggplot(aes(Factor1, Factor2,
             color = n3, shape = n3)) + 
  geom_point() +
  labs(x = "Variable 1",
       y = "Variable 2",
       color = "Clusters",
       shape = "Clusters")

fan$scores %>% 
  as_tibble() %>% 
  bind_cols(
    map(cls_list, function(x) x$cluster)[-1] %>% 
      as_tibble(.name_repair = "universal") %>% 
      set_names(paste0("n", 2:10))
  ) %>% 
  mutate_at(vars(-1, -2), as.character) %>% # print()
  ggplot(aes(Factor1, Factor2,
             color = n4, shape = n4)) + 
  geom_point() +
  labs(x = "Variable 1",
       y = "Variable 2",
       color = "Clusters",
       shape = "Clusters")

fan$scores %>% 
  as_tibble() %>% 
  bind_cols(
    map(cls_list, function(x) x$cluster)[-1] %>% 
      as_tibble(.name_repair = "universal") %>% 
      set_names(paste0("n", 2:10))
  ) %>% 
  mutate_at(vars(-1, -2), as.character) %>% # print()
  ggplot(aes(Factor1, Factor2,
             color = n5, shape = n5)) + 
  geom_point() +
  labs(x = "Variable 1",
       y = "Variable 2",
       color = "Clusters",
       shape = "Clusters")

fan$scores %>% 
  as_tibble() %>% 
  bind_cols(
    map(cls_list, function(x) x$cluster)[-1] %>% 
      as_tibble(.name_repair = "universal") %>% 
      set_names(paste0("n", 2:10))
  ) %>% 
  mutate_at(vars(-1, -2), as.character) %>% # print()
  ggplot(aes(Factor1, Factor2,
             color = n6, shape = n6)) + 
  geom_point() +
  labs(x = "Variable 1",
       y = "Variable 2",
       color = "Clusters",
       shape = "Clusters")


fan$scores %>% 
  as_tibble() %>% 
  bind_cols(
    map(cls_list, function(x) x$cluster)[-1] %>% 
      as_tibble(.name_repair = "universal") %>% 
      set_names(paste0("n", 2:10))
  ) %>% 
  mutate_at(vars(-1, -2), as.character) %>% # print()
  ggplot(aes(Factor1, Factor2,
             color = n7, shape = n7)) + 
  geom_point() +
  scale_shape_manual(values = c(16, 15, 7, 17, 3, 8, 9)) +
  labs(x = "Variable 1",
       y = "Variable 2",
       color = "Clusters",
       shape = "Clusters")



nrow(fan$scores)
set.seed(555)
ind <- sample(1:300, 30)

hc_50 <- hclust(dist(fan$scores[ind, ]), method = "ave")

plot(hc_50)

ggplot(NULL,
       aes(1:(length(ind)-1), hc_50$height)) +
  geom_point() +
  geom_line() +
  scale_x_continuous(breaks = 1:29) +
  labs(x = "Step", y = "Distance")
#scale_x_reverse()




# d <- dist(fan$scores[ind, ])
d <- dist(fan$scores)
hc_complete <- hclust(d, method = "complete")
hc_single <- hclust(d, method = "single")
hc_average <- hclust(d, method = "average")

plot(hc_complete)
plot(hc_single)
plot(hc_average)


set.seed(111)
tibble(x = rnorm(300, sd = .1),
       y = rnorm(300), sd = .1) -> rand
plot(rand$x, rand$y)
hc_rand <- hclust(dist(rand), "complete")
plot(hc_rand)

dhc <- as.dendrogram(hc_complete)
dhc <- as.dendrogram(hc_average)
dhc <- as.dendrogram(hc_single)
# Rectangular lines
ddata <- dendro_data(dhc, type = "rectangle")
ggplot(segment(ddata)) + 
  geom_segment(aes(x = x, y = y, xend = xend, yend = yend)) + 
  coord_flip() + 
  scale_y_reverse(expand = c(0.2, 0)) +
  guides(y = "none") +
  labs(y = "Distance", x = "")

dhc <- as.dendrogram(hc_rand)
# Rectangular lines
ddata <- dendro_data(dhc, type = "rectangle")
ggplot(segment(ddata)) + 
  geom_segment(aes(x = x, y = y, xend = xend, yend = yend)) + 
  coord_flip() + 
  scale_y_reverse(expand = c(0.2, 0)) +
  guides(y = "none") +
  labs(y = "Distance", x = "")

