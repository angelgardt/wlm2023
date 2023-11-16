dir.create("data")

# .csv, .tsv, .txt
# .xls, .xlsx,
# .sav
#.json, .xlm

fs <- read.csv("data/design_fastsearch.csv")
# fs1 <- read.csv("https://raw.githubusercontent.com/angelgardt/da-2023-ranepa/master/data/design_fastsearch.csv")
rm(fs1)

class(fs)
View(fs)
str(fs)

# 3 row, 2 col
fs[3, 2]
fs[3, ]
fs[, 2]

class(fs[3, ])
class(fs[, 2])

fs[2:4, 1:3]

fs[1:3]
class(fs[1:3])

fs[3]; class(fs[3])
fs[[3]]; class(fs[[3]])

fs$time[3:5]

ds <- data.frame(id = 1:5,
                 value = rnorm(5),
                 cond = paste0("type", 1:5))

head(fs)
tail(fs, n = 10)


## ASCII, UTF-8

fs <- read.csv("data/design_fastsearch.csv", encoding = "UTF-8")

summary(fs)

# as.*()

sapply(X = fs, FUN = is.numeric)
sapply(X = fs, FUN = function(x) sum(is.na(x)))

length(unique(fs$cond))
sort(fs$time)



library(lubridate)

today()
now()

ymd("2023.10.23")
mdy("January 21st, 2023")

hms("15:34:28")
ms("5:48")

dt <- as_datetime("2007-06-10 10:20:30 UTC")

year(dt); month(dt); day(dt)

ymd("2020-12-13") - ymd("2020-12-14")
hm("21:00") - hm("18:10")

ymd_hm("2020-12-13 21:00") - ymd_hm("2020-12-13 18:10")


difftime(ymd_hm("2020-12-13 21:00"), ymd_hm("2020-12-13 18:10"), units = "secs")

file_info <- file.info("data/design_fastsearch.csv")

file_info$mtime
file_info$atime

write.csv(ds, file = "data/ds.csv", fileEncoding = "UTF-8", row.names = FALSE)


