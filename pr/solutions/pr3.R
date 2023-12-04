### P3 // Solutions
### A. Angelgardt

# MAIN

# 1

## no code


# 2

## read.csv() can read file from link
## fs cos fast search
fs <- read.csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr3/des_fs.csv")
## Error in read.table(file = file, header = header, sep = sep, quote = quote,  : 
## duplicate 'row.names' are not allowed

## let's check some lines to understand the structure
readLines("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr3/des_fs.csv")
## ok, semicolon

## load with read.csv2()
fs <- read.csv2("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr3/des_fs.csv")


# 3
## a
head(fs, n = 10)
## b
tail(fs, n = 5)


# 4
str(fs)
## also
nrow(fs)
ncol(fs)


# 5
summary(fs)


# 6
## a
class(fs)
## b
colnames(fs)
## c
rownames(fs) # wow that's just numbers


# 7
## a
fs$time
## b
fs[[1]] # class(fs[[1]]), wow works like list
## c
fs[1] # class(fs[1]), wow works like list
## d
fs['cond'] # class(fs['cond']), wow works like list


# 8
## a
fs[, 1:3]
## b
fs[1:30, ]
## c
fs[1:10, 3:4]
## d
fs[340, 2]


# 9
## a
sapply(fs, class)
## b
sum(is.na(fs))
### or this one
sapply(fs, function(x) sum(is.na(x)))


# 10
## a
dir("p3-data")
## b
length(dir("p3-data"))


# 11
fs5 <- data.frame()
files <- paste0("p3-data/", dir("p3-data/"))
for (i in 1:length(files)) {
  fs5 <- rbind(read.csv2(files[i]), fs5)
}
fs5


# 12
## a
length(unique(fs5$cond))
## b
table(fs5$cond)
## c
fs5[fs5 == "f3_p", ]
## d
fs5[sapply(fs5, is.numeric)]


# 13
## a
class(fs5$date)
### or
is.character(fs5$date)
## b
library(lubridate)
fs5$date <- as_datetime(fs5$date)


# 14
## a
unique(year(fs5$date))
## b
unique(month(fs5$date))
### or
unique(month(fs5$date, label = TRUE))
## c
unique(day(fs5$date))


# 15
fs_dates <- fs5[!duplicated(fs5[c("id", "date")]), c("id", "date")]


# 16
file.info("p3-data/des_fs_1.csv")


# 17
fs_meta <- data.frame()
for (i in 1:length(files)) {
  fs_meta <- rbind(file.info(files[i]), fs_meta)
}


# 18
fs_dates <- cbind(fs_dates, fs_meta["mtime"])


# 19
fs_dates$duration <- difftime(fs_dates$mtime, fs_dates$date, units = "mins") + 3 * 60
fs_dates$duration < 30


# 20
write.csv(fs_dates, "fs_dates.csv")



# ADDITIONAL

# 1
View(fs)


# 2
foreign::read.spss("../data/pr3/depress.sav", 
                   to.data.frame = TRUE)
haven::read_sav("../data/pr3/depress.sav")

# 3
fs_map <- data.frame()
Map(function(x) fs_map <<- rbind(read.csv2(x), fs_map), files)
fs_map


# 4

fs_dates$start <- as.numeric(fs_dates$date)
fs_dates$end <- as.numeric(fs_dates$mtime)
(fs_dates$end - fs_dates$start + 3*3600) / 60


# 5
jsonlite::read_json("../data/pr3/pr3.json", simplifyVector = TRUE)
jsonlite::read_json("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr3/des_fs.json", simplifyVector = TRUE)

# 6
XML::xmlToDataFrame("../data/pr3/pr3.xml")


# 7
dir.create()


# 8
file.remove()


# 9
getwd()

# 10

## no code
