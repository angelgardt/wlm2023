# install.packages("verification")

library(verification)
data.frame(x = c(0,0,0,1,1,1),
           y = c(.1, .7, 0, 1, 0.5,.6)) -> data
names(data)<-c("yes","no")

set.seed(123)
data.frame(yes = sample(0:1, 100, replace = TRUE),
           no = runif(100)) -> data1

set.seed(568)
data.frame(yes = sample(0:1, 100, replace = TRUE, prob = c(3, 7)) %>% sort(),
           no = c(runif(50, max = .7), runif(50, min = .6))) -> data2

set.seed(496)
data.frame(yes = sample(0:1, 100, replace = TRUE, prob = c(3, 7)) %>% sort(),
           no = c(runif(50, max = .9), runif(50, min = .4))) -> data3

set.seed(285)
data.frame(yes = sample(0:1, 100, replace = TRUE, prob = c(3, 7)) %>% sort(),
           no = c(runif(50, max = .8), runif(50, min = .5))) -> data4



roc.plot(data1$yes, data1$no, plot.thres = NULL, main = "Model 1")
roc.plot(data2$yes, data2$no, plot.thres = NULL, main = "Model 2")
roc.plot(data3$yes, data3$no, plot.thres = NULL, main = "Model 3")
roc.plot(data4$yes, data4$no, plot.thres = NULL, main = "Model 4")


set.seed(2)
data.frame(yes = sample(0:1, 10, replace = TRUE) %>% sort(),
           no = c(runif(4), runif(6, min = .4))) -> data5

roc.plot(data5$yes, data5$no,
         #plot.thres = NULL
         )

