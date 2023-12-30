# 1 
## a
(-14)^7 - 6 * 2^11
## b
sin(64)^2
## c
exp(8 + pi)
## d
log(34, base = 12)
## e
sqrt(5+2i)

# 2
x <- 3
y <- -1.44

## a
log(17^sin(4.8*pi), base = 24^(1/x))
## b
sqrt(log(cos(2/(3*x^2)) / (abs(y) + x)))
sqrt(y+0i)

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
seq(2, 30, by = 2)
## b
seq(0, 10, by = .5)
## c
seq(-3, 3, by = 0.25)

# 5
## a
rep(c(4, 8, 12), times = 8)
## b
c(rep(c(4, 8, 12), times = 4), 8, 12)
## c
rep(c(4, 8, 12), times = c(10, 20, 30))

# 6
as.character(rep(c(4, 8, 12), times = 8))

# 7
paste("group", rep(1:3, each = 30), sep = "")
paste0("group", rep(1:3, each = 30))

# 8
### n = 100 000
### mean = 4, sd = 5
set.seed(345)
pop <- rnorm(10^5, mean = 4, sd = 5)

# 9
sam1 <- sample(pop, 100)
sam2 <- sample(pop, 100)
sam3 <- sample(pop, 100)
sam4 <- sample(pop, 100)
sam5 <- sample(pop, 100)

# 10
sum(sam1)
log(sam1)
mean(sam2)
median(sam2)

# 11
sam1[1]
length(sam1)
sam1[length(sam1)]
sam1[-1]
sam1[-(1:10)]
sam2[20:45]
sam3[seq(2, length(sam3), by = 2)]

# 12
sam1[sam1 < 0]
sam2[sam2 > 0.5 & sam2 < 4]
sam2[sam2 < .5 | sam2 > 4]

max(sam5)
min(sam5)

sam5[1:5] <- NA
sam5
sam4[6] <- NaN

mean(sam5, na.rm = TRUE)
sum(sam4)

c(1, 3) + 1:10
c(1, 3, 5) + 1:10

1 + 1:10

5:6 * 1:20


cond <- sample(c("negative", "positive", "control"), 30, replace = TRUE)
cond

as.factor(cond)

factor(cond, ordered = TRUE,
       levels = c("negative", "control", "positive"))

1:10 %*% 21:30
