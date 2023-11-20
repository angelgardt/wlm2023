# HW1 || Solutions
# A. Angelgardt

# MAIN

# 1
set.seed(420)
pop <- rnorm(350000, 80, 21)

# 2
set.seed(420)
first_banch <- sample(pop, 150)

# 3
first_banch <- sort(first_banch)[-c(1:5, (length(first_banch)-4):length(first_banch))]

# 4
second_banch <- read.csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/hw1-second_banch.csv")$x
obs <- c(first_banch, second_banch)

# 5
class(obs)
sum(is.na(obs))

# 6
obs <- as.numeric(obs)
obs <- obs[!is.na(obs)]

# 7
min(obs); max(obs); mean(obs); median(obs)

# 8
## a
sort(obs)
## b
median(sort(obs)[1:round(length(obs)/2)])
## c
median(sort(obs)[round(length(obs)/2):length(obs)])

# 9
condition <- sample(c("gr1", "gr2", "gr3", "gr4", "gr5"), length(obs), replace = TRUE)

# 10
table(condition)


# ADDITIONAL

# 1
names(obs) <- condition

# 2
c(min = min(obs),
  max = max(obs),
  mean = mean(obs),
  median = median(obs))

# 3
set.seed(420)
indices <- sample(1:length(obs), length(obs)/2)
length(indices)
sam1 <- obs[indices]
sam2 <- obs[-indices]

# 4
table(names(sam1))
table(names(sam2))

# 5
(1:10)^(1:10) / (1:10)^(1/(1:10))
