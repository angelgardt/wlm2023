# HW14 // Solutions
# A. Angelgardt

# MAIN

library(tidyverse)
library(factoextra)
library(cluster)

# 1
emp <- read_csv("../data/hw14/emp.csv")
str(emp)
emp %>% select(contains("q")) -> empq


# 2
d <- dist(empq)
hc_c <- hclust(d, "complete")
hc_s <- hclust(d, "single")
hc_a <- hclust(d, "average")

plot(hc_c)
plot(hc_s)
plot(hc_a)


# 3
fviz_nbclust(x = empq, FUNcluster = kmeans, method = "silhouette", diss = d, k.max = 20)


# 4
km2 <- kmeans(d, 2)
fviz_cluster(object = list(data = d,
                           clusters = km2$cluster),
             geom = "point")


# 5
fviz_silhouette(silhouette(x = km2$cluster, 
                           dist = d))


# 6
km3 <- kmeans(d, 3)
fviz_cluster(object = list(data = d,
                           clusters = km3$cluster),
             geom = "point")
fviz_silhouette(silhouette(x = km3$cluster, 
                           dist = d))


# 7
fviz_nbclust(x = empq, 
             FUNcluster = fanny, 
             method = "silhouette", 
             diss = d, 
             k.max = 20, 
             memb.exp = 1.5)


# 8
fuzzy2 <- fanny(d, 2, memb.exp = 1.5)
fviz_cluster(object = list(data = d,
                           clusters = fuzzy2$clustering),
             geom = "point")
fviz_silhouette(silhouette(x = fuzzy2$clustering, 
                           dist = d))


# 9
empq %>% 
  mutate(cluster1 = fuzzy2$membership[, 1]) -> emp_1

lm1 <- lm(cluster1 ~ ., emp_1)
summary(lm1)

# 10
ques <- read_csv("../data/hw14/ques.csv")

summary(lm1)$coefficients %>% 
  as_tibble() %>% 
  set_names(c("est", "se", "t", "p")) %>% 
  mutate(question = rownames(summary(lm1)$coefficients)) %>% 
  right_join(ques) %>% 
  filter(p < .05) %>% View


# ADDITIONAL

# 1
emp %>% 
  mutate(cluster = fuzzy2$clustering) %>% 
  filter(cluster == 2) -> emp2


# 2
emp2 %>% select(contains("q")) -> empq2
d2 <- dist(empq2)


# 3
fviz_nbclust(x = empq2, FUNcluster = fanny, diss = d2, k.max = 10, memb.exp = 1.5)


# 4
fuzzy22 <- fanny(x = d2, k = 2, memb.exp = 1.5)
fviz_cluster(object = list(data = d2,
                           clusters = fuzzy22$clustering),
             geom = "point")
fviz_silhouette(silhouette(x = fuzzy22$clustering, 
                           dist = d2))

# 5
fuzzy22$membership
