pkgs <- c("GGally", "fpc", "factoextra", "cluster")
install.packages(pkgs[!pkgs %in% installed.packages()])


library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")
library(factoextra)
library(cluster)

# 1
iris
unique(iris$Species)


# 2
pairs(iris[, 1:4], col = iris[, 5])
GGally::ggpairs(iris, columns = 1:4, aes(color = Species))


# 3
d <- dist(iris[1:4], method = "eucl")
d %>% as.matrix()

hc_complete <- hclust(d, method = "complete")
plot(hc_complete)


# 4
## a
hc_complete_cl2 <- cutree(hc_complete, k = 2)

GGally::ggpairs(iris, 
                columns = 1:4, 
                aes(color = Species,
                    shape = as.character(hc_complete_cl2)),
                upper = NULL, diag = NULL)

table(iris$Species, hc_complete_cl2)

## b
hc_complete_cl3 <- cutree(hc_complete, k = 3)

GGally::ggpairs(iris, 
                columns = 1:4, 
                aes(color = Species,
                    shape = as.character(hc_complete_cl3)),
                upper = NULL, diag = NULL)

table(iris$Species, hc_complete_cl3)

hc_complete_cl4 <- cutree(hc_complete, k = 4)

GGally::ggpairs(iris, 
                columns = 1:4, 
                aes(color = Species,
                    shape = as.character(hc_complete_cl4)),
                upper = NULL, diag = NULL)

table(iris$Species, hc_complete_cl4)


# 5
## a
hc_single <- hclust(d, method = "single")
plot(hc_single)

## b
hc_single_cl2 <- cutree(hc_single, k = 2)
GGally::ggpairs(iris, 
                columns = 1:4, 
                aes(color = Species,
                    shape = as.character(hc_single_cl2)),
                upper = NULL, diag = NULL)

table(iris$Species, hc_single_cl2)


# 6
## a
hc_average <- hclust(d, method = "average")
plot(hc_average)

## b
hc_average_cl2 <- cutree(hc_average, k = 2)
GGally::ggpairs(iris, 
                columns = 1:4, 
                aes(color = Species,
                    shape = as.character(hc_average_cl2)),
                upper = NULL, diag = NULL)

table(iris$Species, hc_average_cl2)


# 7
cstats.table <- function(dist, tree, k) {
  library(fpc)
  clust.assess <-
    c(
      "cluster.number",
      "n",
      "within.cluster.ss",
      "average.within",
      "average.between",
      "wb.ratio",
      "dunn2",
      "avg.silwidth"
    )
  clust.size <- c("cluster.size")
  stats.names <- c()
  row.clust <- c()
  output.stats <- matrix(ncol = k, nrow = length(clust.assess))
  cluster.sizes <- matrix(ncol = k, nrow = k)
  for (i in c(1:k)) {
    row.clust[i] <- paste("Cluster-", i, " size")
  }
  for (i in c(2:k)) {
    stats.names[i] <- paste("Test", i - 1)
    
    for (j in seq_along(clust.assess)) {
      output.stats[j, i] <-
        unlist(cluster.stats(d = dist, clustering = cutree(tree, k = i))[clust.assess])[j]
      
    }
    
    for (d in 1:k) {
      cluster.sizes[d, i] <-
        unlist(cluster.stats(d = dist, clustering = cutree(tree, k = i))[clust.size])[d]
      dim(cluster.sizes[d, i]) <- c(length(cluster.sizes[i]), 1)
      cluster.sizes[d, i]
      
    }
  }
  output.stats.df <- data.frame(output.stats)
  cluster.sizes <- data.frame(cluster.sizes)
  cluster.sizes[is.na(cluster.sizes)] <- 0
  rows.all <- c(clust.assess, row.clust)
  # rownames(output.stats.df) <- clust.assess
  output <- rbind(output.stats.df, cluster.sizes)[, -1]
  colnames(output) <- stats.names[2:k]
  rownames(output) <- rows.all
  is.num <- sapply(output, is.numeric)
  output[is.num] <- lapply(output[is.num], round, 2)
  output
}

clust_stats <- cstats.table(d, hc_complete, 10)

ggplot(data.frame(t(clust_stats)), 
       aes(cluster.number,
           within.cluster.ss)) +
  geom_point() +
  geom_line() +
  labs(y = "WSS", x = "Clusters")


# 8
## a
km2 <- kmeans(iris[1:4], centers = 2)

## b
str(km2)

## c
GGally::ggpairs(iris, 
                columns = 1:4, 
                aes(color = Species,
                    shape = as.character(km2$cluster)),
                upper = NULL, diag = NULL)


# 9
km3 <- kmeans(iris[1:4], centers = 3)

GGally::ggpairs(iris, 
                columns = 1:4, 
                aes(color = Species,
                    shape = as.character(km3$cluster)),
                upper = NULL, diag = NULL)

km4 <- kmeans(iris[1:4], centers = 4)

GGally::ggpairs(iris, 
                columns = 1:4, 
                aes(color = Species,
                    shape = as.character(km4$cluster)),
                upper = NULL, diag = NULL)

# 10
set.seed(394)

kms <- list()
for (i in 2:10) {
  kms[[i]] <- kmeans(iris[1:4], i)
}

tibble(wss = map(kms, function(x) x$tot.withinss) %>% unlist(),
       bss = map(kms, function(x) x$betweenss) %>% unlist(),
       ncl = 2:10) %>% 
  pivot_longer(-ncl) %>% 
  ggplot(aes(ncl, value)) +
  geom_point() +
  geom_line() +
  facet_wrap(~ name, 
             ncol = 1,
             scales = "free_y")

# tibble(wss = map(kms, function(x) x$tot.withinss) %>% unlist(),
#        bss = map(kms, function(x) x$tot.betweenss) %>% unlist(),
#        ncl = 2:10) %>% 
#   pivot_longer(-ncl) %>% 
#   ggplot(aes(ncl, value)) +
#   geom_point() +
#   geom_line() +
#   facet_wrap(~ name,
#              ncol = 1,
#              scales = 'free_y')

# 11
fviz_nbclust(x = iris[1:4],
             FUNcluster = kmeans,
             diss = d,
             method = "silhouette",
             k.max = 10)
fviz_silhouette(silhouette(x = km2$cluster,
                           dist = d))
fviz_cluster(object = list(data = iris[1:4],
                           clusters = km2$cluster),
             geom = "point")


# 12
cpi <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr15/cpi.csv")
str(cpi)
cpi

# 13
d_cpi <- dist(cpi[1:10], method = "manh")

hc_cpi_complete <- hclust(d_cpi, method = "complete")
hc_cpi_single <- hclust(d_cpi, method = "single")
hc_cpi_average <- hclust(d_cpi, method = "average")

plot(hc_cpi_complete)
plot(hc_cpi_single)
plot(hc_cpi_average)


# 14
fviz_nbclust(x = cpi[1:10],
             FUNcluster = fanny,
             diss = d_cpi,
             method = "silhouette",
             k.max = 15,
             memb.exp = 1.5)
warnings()

fviz_nbclust(x = cpi[1:10],
             FUNcluster = fanny,
             diss = d_cpi,
             method = "silhouette",
             k.max = 15,
             memb.exp = 1.3)

# 15
cpi_fuzzy <- fanny(x = d_cpi, k = 2, memb.exp = 1.5)

fviz_cluster(object = list(data = d_cpi,
                           clusters = cpi_fuzzy$clustering),
             geom = "point")

# 16
fviz_silhouette(
  silhouette(x = cpi_fuzzy$clustering,
             dist = d_cpi)
  )

# 17
cpi_fuzzy2 <- fanny(x = d_cpi, k = 3, memb.exp = 1.3)
fviz_cluster(object = list(data = d_cpi,
                           clusters = cpi_fuzzy2$clustering),
             geom = "point")

cpi_fuzzy2$clustering %>% unique()
cpi_fuzzy2$membership


# 18
## k = 2
fviz_nbclust(x = iris[1:4], 
             FUNcluster = fanny, 
             diss = d, 
             method = "silhouette", 
             k.max = 10, 
             memb.exp = 1.5)
iris_fuzzy <- fanny(x = d, k = 2, memb.exp = 1.5)
fviz_cluster(object = list(data = d,
                           clusters = iris_fuzzy$clustering),
             geom = "point")
fviz_silhouette(silhouette(x = iris_fuzzy$clustering,
                           dist = d))

iris_fuzzy2 <- fanny(x = d, k = 3, memb.exp = 1.5)
fviz_cluster(object = list(data = d,
                           clusters = iris_fuzzy2$clustering),
             geom = "point")
fviz_silhouette(silhouette(x = iris_fuzzy2$clustering,
                           dist = d))

GGally::ggpairs(iris, 
                columns = 1:4, 
                aes(color = Species,
                    shape = as.character(iris_fuzzy$clustering)),
                upper = NULL, diag = NULL)

GGally::ggpairs(iris, 
                columns = 1:4, 
                aes(color = Species,
                    shape = as.character(iris_fuzzy2$clustering)),
                upper = NULL, diag = NULL)


# 19
iris %>% 
  bind_cols(iris_fuzzy$membership) %>% 
  rename(cluster1 = ...6,
         cluster2 = ...7) -> iris_memb

lm1 <- lm(cluster1 ~ ., iris_memb %>% select(Petal.Length,
                                             Petal.Width,
                                             Sepal.Length,
                                             Sepal.Width,
                                             cluster1))
summary(lm1)


# 20

lm2 <- lm(cluster2 ~ ., iris_memb %>% select(Petal.Length,
                                             Petal.Width,
                                             Sepal.Length,
                                             Sepal.Width,
                                             cluster2))
summary(lm2)

