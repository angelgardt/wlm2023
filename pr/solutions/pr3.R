### P3 // Solutions
### A. Angelgardt

# MAIN

# 1

## no code

# 2

## read.csv() can read file from link
## fs cos fast search
fs <- read.csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr3/des_fs_1.csv")
## Error in read.table(file = file, header = header, sep = sep, quote = quote,  : 
## duplicate 'row.names' are not allowed

## let's check some lines to understand the structure
readLines("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr3/des_fs_1.csv")
## ok, semicoolon

## load with read.csv2()
fs <- read.csv2("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/pr3/des_fs_1.csv")

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



# 10

# 11

# 12

# 13

# 14

# 15

# 16

# 17

# 18

# 19

# 20



# ADDITIONAL

# 1

# 2

# 3

# 4

# 5

# 6

# 7

# 8

# 9

# 10
