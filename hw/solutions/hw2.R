# HW2 // Solutions
# A. Angelgardt

# MAIN

# 1
set.seed(420)
sim1 <- matrix(rnorm(50*70, mean = 20.5, sd = 3.48), ncol = 50)
sim2 <- matrix(rnorm(50*70, mean = 20.5, sd = 3.48), ncol = 50)
sim1[1]; sim2[1]

# 2
mean_sd <- function(m) {
  result <- matrix(
    c(
      apply(m, 2, mean),
      apply(m, 2, sd)
    ),
    byrow = TRUE,
    ncol = ncol(m)
  )
  return(result)
}
mean_sd(matrix(1:9, ncol = 3))

# 3
mean_sd(sim1)
round(mean_sd(sim1)[, 1:3], 2)

# 4
ttest_res <- t.test(sim1[, 1], sim2[, 1])
# class(ttest_res)
round(ttest_res$statistic, 2)

# 5
ttest_res$estimate
ttest_res$statistic
ttest_res$p.value

# 6
list(estimate = ttest_res$estimate,
     statistic = ttest_res$statistic,
     p.value = ttest_res$p.value)

# 7
stat_testing <- function(m1, m2) {
  results <- list()
  for (i in 1:ncol(m1)) {
    test <- t.test(m1[, i], m2[, i])
    results[[i]] <- list(estimate = test$estimate,
                         statistic = test$statistic,
                         p.value = test$p.value)
  }
  return(results)
}

A <- matrix(1:9, ncol = 3); B <- matrix(1:9 * 10, ncol = 3)
stat_testing(A, B)

# 8
stat_testing_res <- stat_testing(sim1, sim2)
stat_testing_res[[30]]$estimate[2]

# 9
unlist(Map(function(x) x$p.value, stat_testing_res))
pvals <- unlist(Map(function(x) x$p.value, stat_testing_res))
unlist(Map(function(x) x$p.value, stat_testing_res))[10]

# 10
sum(unlist(Map(function(x) x$p.value, stat_testing_res)) < 0.05)
sum(pvals < .05)


# ADDITIONAL

# 1
mean_sd_1 <- function(m) {
  result <- matrix(
    c(
      apply(m, 2, mean),
      apply(m, 2, sd)
    ),
    byrow = TRUE,
    ncol = ncol(m)
  )
  rownames(result) <- c("mean", "sd")
  return(result)
}
mean_sd_1(A)

# 2
mean_sd_2 <- function(m) {
  result <- matrix(
    c(
      apply(m, 2, mean),
      apply(m, 2, sd)
    ),
    byrow = TRUE,
    ncol = ncol(m)
  )
  rownames(result) <- c("mean", "sd")
  colnames(result) <- colnames(m)
  return(result)
}
colnames(A) <- paste0("col", 1:3)
mean_sd_2(A)

# 3
stat_testing_1 <- function(m1, m2, paired = FALSE) {
  if (ncol(m1) != ncol(m2)) {
    stop("Number of columns does not match")
  }
  
  results <- list()
  for (i in 1:ncol(m1)) {
    test <- t.test(m1[, i], m2[, i], paired = paired)
    results[[i]] <- list(estimate = test$estimate,
                         statistic = test$statistic,
                         p.value = test$p.value)
  }
  return(results)
}

stat_testing_1(
  matrix(1:12, ncol=3),
  matrix(1:12, ncol=4)
)

stat_testing_1(
  matrix(1:12, ncol=3),
  matrix(1:12 * 10, ncol=3), paired = TRUE
)

# 4
stat_testing_2 <- function(m1, m2, fun, ...) {
  if (ncol(m1) != ncol(m2)) {
    stop("Number of columns does not match")
  }
  
  results <- list()
  for (i in 1:ncol(m1)) {
    test <- fun(m1[, i], m2[, i], ...)
    results[[i]] <- list(estimate = test$estimate,
                         statistic = test$statistic,
                         p.value = test$p.value)
  }
  return(results)
}

stat_testing_2(
  matrix(1:12, ncol=3),
  matrix(1:12, ncol=4)
)

stat_testing_2(
  matrix(1:12, ncol=3),
  matrix(1:12 * 10, ncol=3),
  wilcox.test, paired = TRUE
)

# 5
quadeqsolve <- function(a, b = 0, c = 0,
                        complex = FALSE) {
  if (a == 0) stop("The equation is not quadratic")
  D = b^2 - 4 * a * c
  
  if (D == 0) {
    return(c(x = -b / (2*a)))
  } else if (D < 0) {
    if (complex) {
      D <- as.complex(D)
      x1 <- (-b - sqrt(D)) / (2*a)
      x2 <- (-b + sqrt(D)) / (2*a)
    } else {
      message("No solutions")
      return(NA)
    }
  } else {
    x1 <- (-b - sqrt(D)) / (2*a)
    x2 <- (-b + sqrt(D)) / (2*a)
  }
  return(c(x1 = x1, x2 = x2))
}

quadeqsolve(a = 1, b = -5, c = 4)
quadeqsolve(b = -3, c = 2)
quadeqsolve(a = 0, b = -3, c = 2)
quadeqsolve(a = -4, c = 2)
quadeqsolve(a = 3, c = 2)
quadeqsolve(a = 3, c = 2, complex = TRUE)
