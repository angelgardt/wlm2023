### P1 // Solutions
### A. Angelgardt

### MAIN

# 1 
## a
(-14)^7 - 6 * 2^11
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
log(17^sin(4.8*pi), base = 24^(1/x))
## b
(exp(x + y^2)) / (1 + exp(x + y^2))
## c
sqrt(log(cos(2/3*x^2) / (abs(y) + x)))
sqrt(as.complex(log(cos(2/3*x^2) / (abs(y) + x)))) ## fix to calculate
## d
sin(pi / 4 * x) + cos(2*pi / sqrt(y) - 1)
sin(pi / 4 * x) + cos(2*pi / sqrt(y+0i) - 1) ## fix y as complex to calculate


# 3
## a
c(4, 8, 12)
## b
1:10
## c
10:-10
## d
c(1:10, 9:9)


# 4
## a
seq(2, 30, by = 2)
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
vec6 <- rep(c(4, 8, 12), times = 8)
as.character(vec6)

# 7
## first option
rep(c("group 1", "group 2", "group 3"), each = 30)
## second option
rep(c("group 1", "group 2", "group 3"), times = 30)
## third option
paste("group", rep(1:3, each = 30))
## fourth option
paste("group", rep(1:3, times = 30))

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

# 14

# 15

# 16

# 17

# 18

# 19

# 20


### ADDITIONAL

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


