# HW1 // Solutions
# A. Angelgardt

# MAIN

# 1
length(dir("hw3"))

# 2
set1 <- read.csv("hw3/set1.csv")
nrow(set1)

# 3
str(set1)

# 4
head(set1, n = 15)
tail(set1)

# 5
summary(set1)

# 6
files <- dir("hw3", full.names = TRUE)
dd <- data.frame()
for (i in 1:length(files)) {
  dd <- rbind(dd, read.csv(files[i]))
}

# 7
library(lubridate)
dd$dt <- as_datetime(dd$date)
unique(year(dd$dt))

# 8
dd_fall <- dd[8 < month(dd$dt) & month(dd$dt) < 12, ]
nrow(dd_fall)

# 9
dir.create("hw3-prepdata")

# 10
write.csv(dd_fall, "hw3-prepdata/dd_fall.csv", 
          row.names = FALSE)


# ADDITIONAL

# 1
dir.create("data")
dir.create("scripts")
dir.create("graphs")

# 2
bind_data <- function(path) {
  data <- data.frame()
  files <- dir(path, full.names = TRUE)
  for (i in 1:length(files)) {
    file <- read.csv(files[i])
    data <- rbind(data, file)
  }
  return(data)
}

# 3
read.table("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/hw3-13.csv")

read.table("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/hw3-13.csv", 
           fileEncoding = "Windows-1251")

# 4
bind_data <- function(path, encoding = "UTF-8") {
  data <- data.frame()
  files <- dir(path, full.names = TRUE)
  for (i in 1:length(files)) {
    file <- read.csv(files[i], 
                     fileEncoding = encoding)
    data <- rbind(data, file)
  }
  return(data)
}

# 5

## no code
