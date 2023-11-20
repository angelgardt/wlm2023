### P1 // Solutions
### A. Angelgardt

### MAIN

# 1 
## a
-14^7 - 6 * 2^11
## b
sin(64)^2
## c
exp(8 + pi)
## d
log(34, 12)
## e
sqrt(5+2i)


# 2
x <- 3
y <- -1.44
## a
log(17^sin(4.8*pi), 
    base = 24^(1/x))
## b
(exp(x + y^2)) / (1 + exp(x + y^2))
## c
sqrt(log(cos(2/(3*x^2)) / (abs(y) + x)))
sqrt(as.complex(log(cos(2/(3*x^2)) / (abs(y) + x)))) ## fix complex to calculate
## d
sin(pi / (4 * x)) + cos(2*pi / (sqrt(y) - 1))
sin(pi / (4 * x)) + cos(2*pi / (sqrt(y+0i) - 1)) ## fix y as complex to calculate


# 3
## a
c(4, 8, 12)
## b
1:10
## c
10:-10
## d
c(1:10, 9:1)


# 4
## a
seq(from = 2, to = 30, by = 2)
## b
seq(0, 10, by = .5)
## c
seq(-3, 3, by = .25)


# 5
## a
rep(c(4, 8, 12), times = 8)
## b
c(rep(c(4, 8, 12), times = 8), 8, 12)
## c
rep(c(4, 8, 12), times = c(10, 20, 30))

# 6
setsize <- rep(c(4, 8, 12), times = 8)
as.character(setsize)

# 7
## a
### first option
rep(c("group 1", "group 2", "group 3"), each = 30)
### second option
rep(c("group 1", "group 2", "group 3"), times = 30)
### third option
paste("group", rep(1:3, each = 30))
### fourth option
paste("group", rep(1:3, times = 30))

## b
### first option
rep(c("group1", "group2", "group3"), each = 30)
### second option
rep(c("group1", "group2", "group3"), times = 30)
### third option
paste0("group", rep(1:3, each = 30))
### fourth option
paste0("group", rep(1:3, times = 30))


# 8
set.seed(123)
pop <- rnorm(10^5, mean = 4, sd = 5)


# 9
sam1 <- sample(pop, 100)
sam2 <- sample(pop, 100)
sam3 <- sample(pop, 100)
sam4 <- sample(pop, 100)
sam5 <- sample(pop, 100)


# 10
## a
sum(sam1)
## b
mean(sam2)
## c
median(sam3)


# 11
## a
sam4[1]
## b
sam4[length(sam4)]
## c
sam4[20:45]
## d
sam4[seq(2, length(sam4), by = 2)]


# 12
## a
sam1[sam1 < 0]
## b
length(sam1[sam1 < 0])
## c
sum(sam2 > mean(sam2))


# 13
## a
sam3[sam3 > 3 & sam3 < 8]
## b
sam3[sam3 < .5 | sam3 > 9.3]


# 14
## a
max(sam1)
## b
min(sam1)


# 15
## a
which.max(sam1)
## b
which.min(sam1)


# 16
set.seed(5); sam5[sample(1:100, sample(100, 1))] <- NA
## a
sum(is.na(sam5))
## b
which(is.na(sam5))


# 17
sam2[c(FALSE, TRUE)]


# 18
## a
sam1 * 20
## b
sam2 - mean(sam2)
## c
log10(sam3)


# 19
sam5 * 20
sam5 - mean(sam5)
## fix NA to calculate
sam5 - mean(sam5, na.rm = TRUE)
log10(sam5)


# 20
1:2 + 1:10 # ok, just recycling
1:3 + 1:10 # warning, problem with recycling


### ADDITIONAL

# 1
## a
sam1[-1]
## b
sam1[-length(sam1)]
## c
sam1[-seq(5, length(sam1), by = 5)]


# 2
sam5[!is.na(sam5) & abs(sam5) <= mean(sam5, na.rm = TRUE)]


# 3
abs(sam3 - mean(sam3))


# 4
## a
set.seed(616)
cond <- sample(c("positive", "negative", "control"), 
               120, replace = TRUE)
## b
cond <- as.factor(cond)


# 5
cond <- factor(cond, 
               ordered = TRUE, 
               levels = c("negative", "control", "positive"))


# 6
table(cond)


# 7
x1 <- read.csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr1-27.csv")$x1
x2 <- read.csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr1-27.csv")$x2
x1/x2 # Inf and -Inf introduced since division by zero


# 8
(1:30)[((1:30) %% 2 & (1:30) %% 3)]


# 9
(1:30)^c(1, .5, 1/3)


# 10
sam1 %*% sam2
