### P1 // Solutions
### A. Angelgardt

# 1 
## a
(-14)^7 - 6 * 2^11
## b
sin(64)^2
## c
exp(8+pi)
## d
log(34, 12)
## e
sqrt(5 + 2i)


# 2
x <- 3
y <- -1.44
## a
log(17^sin(4.8*pi), base = 24^(1/x))
## b
(exp(x + y^2)) / (1 + exp(x + y^2))
## c
sqrt(log(cos(2/(3*x^2)) / (abs(y) + x)))
## d
(log(sin(3 * cos(y / 2))^2, base = exp(x)))^abs(y-x)
## e
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
paste("group", rep(1:3, each = 30))
## second option
paste("group", rep(1:3, times = 30))

# 8























