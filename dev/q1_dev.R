x = 6
if (x > 5)  print(5) else print(1)


spisok <- list(sp = list(vc = seq(1, 3, by = 1.1),
                         ra = sample(1:30, 5)),
               ma = matrix(1:6, nrow = 2))
spisok

spisok$sp$ra
spisok[2]
spisok$sp$vc[1]
spisok[[2]][1, 3]

as.numeric(c(FALSE, "2", "s"))
