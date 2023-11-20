# 1

-14^7 - 6 * 2^11
-14^7-6*2^11
sin(64)^2

exp(8 + pi)
# exp(1)
log(34, base = 12)
sqrt(5+2i)

# 2

x <- 3
y <- -1.44

log(17^(sin(4.8*pi)), 
    base = 24^(1/x))

exp()
?log

(exp(x + y^2)) / (1 + exp(x + y^2))

sqrt(log(cos(2/(3*x^2)) / (abs(y) + x)))
sin(pi / (4 * x)) + cos(2*pi / (sqrt(as.complex(y)) - 1))

class(y)

# 3

c(4, 8, 12)
1:10
10:-10
c(1:10, 9:1)


# 4
seq(from = 2, to = 30, by = 2)
seq(0, 10, by = .5)
seq(-3, 3, by = .25)

# 5

rep(c(4, 8, 12), times = 8)
c(rep(c(4, 8, 12), 8), 8, 12)

rep(c(4, 8, 12), times = c(10, 20, 30))

# c(rep(4, 10), rep(8, 20), rep(12, 30))

# 6

setsize <- rep(c(4, 8, 12), times = 8)
as.character(setsize)

rm(setzise)

# 7 

rep(c(1, 2, 3), each = 30)
paste("group", rep(c(1, 2, 3), each = 30))
rep(c("group 1", "group 2", "group 3"), each = 30)

paste("group", rep(c(1, 2, 3), each = 30)) == rep(c("group 1", "group 2", "group 3"), each = 30)

paste("group", rep(c(1, 2, 3), each = 30), sep = "")
paste0("group", 1)


# 8 
set.seed(16)
pop <- rnorm(10^5, mean = 4, sd = 5)
pop
pop[1:4]


# 9 
set.seed(16)
sam1 <- sample(pop, 100)
sam2 <- sample(pop, 100)
sam3 <- sample(pop, 100)
sam4 <- sample(pop, 100)
sam5 <- sample(pop, 100)


# 10

sum(sam1)
mean(sam2)
median(sam3)

# 11
sam4[1]
sam4[-1]
sam4[length(sam4)]
length(sam4)

sam4[20:45]
sam4[seq(3, length(sam4), by = 3)]


# 12
sam1[sam1 < 0]
length(sam1[sam1 < 0])
sum(sam1 < 0)
as.numeric(sam1 < 0)
as.logical(1); as.logical(0); as.logical(2); as.logical(-2)

# 13
sam3[sam3 > 3 & sam3 < 8]
sam3[sam3 < .5 | sam3 > 9.3]


# 14
max(sam1)
min(sam1)


# 15
which.max(sam1)
which.min(sam1)
which(sam1 > 5)
which(sam1 == max(sam1))


# 16
set.seed(5); sam5[sample(1:100, sample(100, 1))] <- NA

# sam5 == NA

sum(is.na(sam5))

which(is.na(sam5))


# 17

1:10 + 1:2

sam2[c(FALSE, TRUE)]


# 18

sam1 * 20
sam2 - mean(sam2)
log(sam3, base = 10)


# 19

sam5 * 20
sam5 - mean(sam5, na.rm = TRUE)
log(sam5, base = 10)


# 20

1:2 + 1:10
1:3 + 1:10


# additional
# 1

sam1[-1]
sam1[-length(sam1)]
sam1[-seq(5, length(sam1), by = 5)]

# 2
sam5[!is.na(sam5) & abs(sam5) <= mean(sam5, na.rm = TRUE)]

