### P2 // Solutions
### A. Angelgardt

# MAIN

# 1
m <- matrix(1, nrow = 5, ncol = 5)

# 2
m[2:4, 2:4] <- 0

# 3
## a
m[2,]

## b
m[, 1]

## c
m[3:5, ]

## d
m[, 2:3]

# 4
m[2, ] == m[, 3]

# 5
multab <- matrix(
  rep(1:9, each = 9) * 
    rep(1:9, times = 9), 
  ncol = 9)

# 6
## a
multab[71]

## b
multab[multab < 10] <- NA

# 7
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

# 10
## a
first_list[1]
## b
first_list["multab"]
## c
first_list$multab
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
  return(x * y)
}
## b
sqrtn <- function(x, n) {
  # message("n is negative\n")
  x^(1/n)
}

# 13
sqrtn <- function(x, n) {
  if (x < 0) x <- as.complex(x)
  x^(1/n)
}

# 14
sqrtn <- function(x, n, complex = FALSE) {
  if (x < 0 & complex) x <- as.complex(x)
  x^(1/n)
}

# 15
quad_cube <- function(x) {
  result <- numeric(length(x))
  
  for (i in 1:length(x)) {
    if (x[i] < 0) {
      result[i] <- 0 
    } else if (x[i] > 1) {
      result[i] <- x[i]^3 
    }
    else {
      result[i] <- x[i]^2
    }
  }
  
  return(result)
}
qcres <- quad_cube(seq(-5, 5, by = .1))
plot(qcres, type = "l")

# 16
mat_desc <- function(m) {
  sums <- apply(m, 2, sum)
  means <- apply(m, 2, mean)
  medians <- apply(m, 2, median)
  result <- rbind(sums, means, medians)
  rownames(result) <- c("sum", "mean", "median")
  return(result)
}

# 17
ttests <- list(test1 = list(t = 1.33,
                            p = 0.1),
               test2 = list(t = 2.306,
                            p = 0.025),
               test3 = list(t = 3.527,
                            p = 0.001))
ttests

pvals <- numeric()
for (i in 1:length(ttests)) {
  pvals[i] <- ttests[[i]]$p
}
pvals

# 18
quad_cube2 <- function(x) {
  if (x < 0) return(0)
  else if (x > 1) return(x^3)
  else return(x^2)
}
qcres2 <- unlist(Map(quad_cube2, seq(-5, 5, by = .1)))

# 19
unlist(Map(function(x) x^2, 1:5))

# 20
unlist(Map(function(x) x$p, ttests))



# ADDITIONAL

# 1
set.seed(24)
sim <- matrix(rnorm(30*5, mean = 10, sd = 20),
              nrow = 30)
sim

# 2
apply(sim, 2, mean)
apply(sim, 2, sd)

# 3
sqrtn <- function(x, n, complex = FALSE) {
  if (x < 0) {
    if (complex) {
      x <- as.complex(x)
    } else {
      warning("x has negative value\n")
    }
  }
  return(x^(1/n))
}

# 4
sqrtn <- function(x, n, complex = FALSE) {
  if (x < 0) {
    if (complex) {
      x <- as.complex(x)
      message("x coerced to complex")
    } else {
      warning("x has negative value\n")
    }
  }
  return(x^(1/n))
}

# 5
sqrtn <- function(x, n, complex = FALSE) {
  
  if(!is.logical(complex)) stop("argument `complex` must be a logical constant")
  
  if (x < 0) {
    if (complex) {
      x <- as.complex(x)
      message("x coerced to complex")
    } else {
      warning("x has negative value\n")
    }
  }
  return(x^(1/n))
}

# 6
## a
mat_desc(multab)
## b
mat_desc <- function(m, ...) {
  sums <- apply(m, 2, sum, ...)
  means <- apply(m, 2, mean, ...)
  medians <- apply(m, 2, median, ...)
  result <- rbind(sums, means, medians)
  rownames(result) <- c("sum", "mean", "median")
  return(result)
}

# 7
gen_dist <- function(n_samples, n_obs, fun = rnorm, ...) {
  matrix(fun(n_obs*n_samples, ...),
         nrow = n_obs)
}

# 8
## a
sum((1:30)^4) / sum(1 + (1:10))
## b
sum((1:30)^4) / sum(outer(1:30, 1:10, "+"))

# 9
## a
sum(outer(1:10, 3:6, "*")) / sum(outer(1:10, 2:8, "-"))
## b
sum(outer(1:10, 1:10, 
          function(i, j) { (i >= j) * i^4 / (3 + i * j) }))

# 10
fib <- function(n) {
  fib <- numeric(20)
  fib[1] <- 0
  fib[2] <- 1
  for (i in 3:n) {
    fib[i] <- fib[i-1] + fib[i-2]
  }
  return(fib)
}
fib(20)