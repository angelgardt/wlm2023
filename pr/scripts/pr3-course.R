fs <- read.csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr3/des_fs.csv")

fs <- read.csv2("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr3/des_fs.csv")
head(fs)

sapply(fs, class)

sum(is.na(fs))

apply(fs, 2, function (x) sum(is.na(x)))
sapply(fs, function(x) sum(is.na(x)))

# 10

dir("p3-data")
length(dir("p3-data"))

# 11
files <- paste0("p3-data/", dir("p3-data"))
fs5 <- data.frame()

## "p3-data/des_fs_1.csv"
## getwd()

for (i in 1:length(files)) {
  fs5 <- rbind(read.csv2(files[i]), fs5)
}

# 12
## a
length(unique(fs5$cond))
## b 
table(fs5$cond)
## c
fs5[fs5$cond == "f3_p", ]
## d
fs5[sapply(fs5, is.numeric)]
# numeric()
# as.numeric()
# is.numeric()

# 13

# 23:23:60

# install.packages("tidyverse")

library(lubridate)

is.character(fs5$date)
head(fs5$date)

# 12.03.2012
# 12/03/2012

fs5$date <- as_datetime(fs5$date)
head(fs5$date)
class(fs5$date)

# 14
now()
year(now())
month(now(), label = TRUE)
day(now())

unique(year(fs5$date))
unique(month(fs5$date))
unique(day(fs5$date))

unique(year(fs5$date))
unique(c("a", "a", "b", "c", "b"))

# 15
fs_dates <- fs5[!duplicated(fs5[c('id', 'date')]), c('id', 'date')]
fs_dates

# 16
file.info("p3-data/des_fs_1.csv")

# 17
fs_meta <- data.frame()
for (i in 1:length(files)) {
  fs_meta <- rbind(file.info(files[i]), fs_meta)
}
fs_meta

# 18
fs_dates <- cbind(fs_meta["mtime"], fs_dates)
class(fs_dates$mtime)
class(fs_dates$date)

# 19
fs_dates$duration <- difftime(fs_dates$mtime, fs_dates$date, 
                              tz = "Europe/Moscow",
                              units = "mins") #+ 3 * 60
fs_dates$duration

# 20
write.csv(fs_dates, file = "p3-data/des_fs_dur.csv")


