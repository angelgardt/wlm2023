# 1
m <- matrix(1, nrow = 5, ncol = 5)

# 2
m[2:4, 2:4] <- 0
m

# 3
# a
m[2, ]
# b
m[, 1]
# c
m[3:5, ]
# d
m[, 2:3]

# 4
m[2, ] == m[, 3]

# 5
multab <- matrix(rep(1:9, each = 9) * rep(1:9, times = 9), nrow = 9)
multab

# 6
## a
multab[71]
## b
multab[multab < 10] <- NA
multab

# 7
sum(multab, na.rm = TRUE)
mean(multab, na.rm = TRUE)
median(multab, na.rm = TRUE)


# 8
m
## 8.1 a
apply(m, 1, sum)
## 8.1 b
apply(m, 2, sum)
## 8.2
apply(multab, 2, sum, na.rm = TRUE)


# 9
letters
LETTERS

first_list <- list(alphabet = letters,
                   logic = TRUE,
                   multab = multab)

# 10
first_list[1]
first_list["multab"]
first_list$multab
first_list$logic
first_list[[3]]

# 11
## a
first_list$alphabet[1:5]
## b
first_list$multab[, (ncol(first_list$multab)-1):ncol(first_list$multab)]
## c
first_list$logic[3]


# 12
## a
mul <- function(x, y) {
  x * y
}
mul(2, 3)
mul(0, 5)
mul(-3, .5)

## b
sqrtn <- function(x, n = 2) {
  x^(1/n)
}

sqrtn(4)

sqrtn(9, 2)
sqrtn(9)
sqrtn(27, 3)
sqrtn(16, 4)
sqrtn(143, 23)

# 13
sqrt(-2)

sqrt2 <- function(x) {
  
  if (x < 0) {
    message("x coerced to complex")
    # warning()
    sqrt(as.complex(x)) # x + 0i
  } else {
    sqrt(x)
  }

}

# sqrt(4+0i)
sqrt2(4)
sqrt2(3)
sqrt2(-2)


# 14
myfun <- function(x) {
  result <- numeric(length = length(x))
  for (i in 1:length(x)) {
    
    if (x[i] < 0) {
      
      result[i] <- 0
      
    } else if (x[i] < 1) {
      
      result[i] <- x[i]^2
      
    } else {
      
      result[i] <- x[i]
      
    }
    
  }
  return(result)
}

x <- seq(-3, 3, by = .05)
r <- myfun(x)
plot(x, r, type = "l")


ttests <- list(test1 = list(t = 2, p = .4),
               test2 = list(t = 0.5, p = .7),
               test3 = list(t = 4.1, p = .003))
ttests

get_p <- function(x) {
  # get p value from list 
  x$p
}

unlist(Map(get_p, ttests)) #< .05

unlist(Map(function(x) x$p, ttests)) # get p values from t-tests

# 100 samples
# 350 obs
# norm dist


matrix(rnorm(100 * 350, mean = 20, sd = 3), nrow = 350, byrow = FALSE)

gen_sam <- function(sample_size, n_samples, mean = 0, sd = 1) {
  
  matrix(rnorm(n_samples * sample_size, 
               mean = mean, sd = sd), 
         nrow = sample_size, byrow = FALSE)
  
}

set.seed(123)
generation <- gen_sam(1500, 5000, mean = 5, sd = 3.2)

apply(generation, 2, mean)


