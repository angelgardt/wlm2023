# 1
m <- matrix(1, nrow = 5, ncol = 5)

# 2
m[2:4, 2:4] <- 0
m

# 3
## a
m[2, ]
## b
m[ , 1]
## c
m[3:5, ]
## d
m[, 2:3]
# m[,c(2,3)]

m[c(3,5),]
m[seq(2, 5, by = 2), ]

# 4
m[2,] == m[, 3]

# 5
multab <- matrix(rep(1:9, times = 9) * rep(1:9, each = 9), ncol = 9)

# 6
## a
multab[71]

## b
multab[multab < 10] <- NA
multab

# 7
# sum(multab, na.rm = FALSE)
sum(multab, na.rm = TRUE)
mean(multab, na.rm = TRUE)
median(multab, na.rm = TRUE)

# 8.1
## a
apply(m, 1, sum)
## b
apply(m, 2, sum)

# 8.2
apply(multab, 2, sum, na.rm = TRUE)

# 9
first_list <- list(alphabet = letters,
                   logic = TRUE,
                   multab = multab)
first_list

# 10
## a
first_list[1]
first_list[[1]]

## b
first_list["multab"]
class(first_list["multab"])

## c
first_list$multab

class(first_list$multab)

## d
first_list$logic

# 11
## a
first_list$alphabet[1:5]

## b
first_list$multab[, 8:9]

## c
first_list$logic[3]


# 12
## a
mul <- function(x, y) {
  x * y
}

mul(2, 3)
mul(-4, -8)

## b
sqrtn <- function(x, n) {
  return(x ^ (1/n))
}

sqrtn(4, 2)
sqrtn(27, 3)
sqrtn(30, -5)
sqrtn(-2, 2)

# 13

sqrtn <- function(x, n) {
  if (x < 0) x <- as.complex(x)
  return(x ^ (1/n))
}

sqrtn(4, 2)
sqrtn(-2, 2)

# 14
sqrtn <- function(x, n, complex = FALSE) {
  if (x < 0 & complex) x <- as.complex(x)
  return(x ^ (1/n))
}

sqrtn(4, 2)
sqrtn(-2, 2)
sqrtn(-2, 2, complex = TRUE)

# 15

quad_cube <- function(x) {
  result <- numeric(length(x))
  
  for (i in 1:length(x)) {
    if (x[i] < 0) {
      result[i] <- 0
    } else if (x[i] > 1) {
      result[i] <- x[i]^3
    } else {
      result[i] <- x[i]^2
    }
  }
  
  return(result)
}

qcres <- quad_cube(seq(-5, 5, by = .1))

plot(qcres, type = "l")


# 16

mat_decs <- function(m) {
  sums <- apply(m, 2, sum)
  medians <- apply(m, 2, median)
  means <- apply(m, 2, mean)
  results <- rbind(sums, means, medians)
  rownames(results) <- c('sum', 'mean', 'median')
  return(results)
}

mat_decs(m)

# 17
ttests <- list(test1 = list(t = 1.33,
                            p = 0.1),
               test2 = list(t = 2.306,
                            p = 0.025),
               test3 = list(t = 3.527,
                            p = 0.001))
ttests
ttests[1]
ttests[[1]]

pvals <- numeric()
for(i in 1:length(ttests)) {
  pvals[i] <- ttests[[i]]$p
}
pvals


# 18
quad_cube2 <- function(x) {
  if (x < 0) return(0)
  else if (x > 1) return(x^3)
  else return(x^2)
}

vec <- seq(-5, 5, by = .1)

qcres2 <- unlist(Map(quad_cube2, vec))
plot(qcres2, type = "l")


# 19
(1:5)^2
unlist(Map(function(x) x^2, 1:5))

# 20
pvals <- unlist(Map(function(x) x$p, ttests))
pvals["test2"]

c(value1 = 3, value2 = 6, value3 = 4)


# 1
set.seed(123)
matrix(rnorm(5 * 30, mean = 10, sd = 20), ncol = 5)

set.seed(123)
matrix(rnorm(5 * 30, mean = 10, sd = 20), ncol = 5, byrow = TRUE)


