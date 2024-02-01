# HW8 // Solutions
# A. Angelgardt

# MAIN

# 1

library(tidyverse)
theme_set(theme_bw())
library(ggmosaic) ## for 3d additional

stud <- read_csv("https://raw.githubusercontent.com/angelgardt/wlm2023/master/data/hw8/StudentsPerformance.csv")
str(stud)


# 2
stud %>% apply(2, is.na) %>% apply(2, sum)
stud$gender %>% table()
stud$`parental level of education` %>% table()
stud$lunch %>% table()
stud$`test preparation course` %>% table()


# 3
stud %>% 
  select(`math score`, `reading score`, `writing score`) %>% 
  pivot_longer(cols = everything()) %>% 
  ggplot(aes(value)) + 
  geom_histogram() +
  facet_wrap(~name)

stud %>% 
  select(`math score`, `reading score`, `writing score`, `test preparation course`) %>% 
  pivot_longer(cols = -`test preparation course`) %>% 
  ggplot(aes(value)) + 
  geom_histogram() +
  facet_grid(`test preparation course` ~ name)


# 4
stud %>% 
  select(`reading score`, `writing score`, `math score`) %>% 
  psych::describe()

stud %>% 
  select(`reading score`, `writing score`, `math score`) %>% 
  psych::describeBy(group = stud$`test preparation course`)


# 5
stud %>% 
  select(`math score`, `reading score`, `writing score`) %>% 
  cor() -> stud_cor


# 6
# apaTables::apa.cor.table(stud_cor, filename = "stud_cor.doc") ## should works but dont
apaTables::apa.cor.table(stud %>% 
                           select(`math score`, `reading score`, `writing score`), 
                         filename = "stud_cor.doc")

# 7
stud_cor %>% 
  ggcorrplot::ggcorrplot(
    show.legend = FALSE,
    lab = TRUE,
    colors = c("red", "white", "blue")
  )

# ggsave("cor_graph.png")


# 8
cor.test(stud$`reading score`, stud$`writing score`)


# 9
cor_res <- cor.test(stud$`reading score`, stud$`writing score`)
report::report(cor_res)


# 10
pwr::pwr.r.test(r = .2,
                sig.level = .05,
                power = .8)



# ADDITIONAL

# 1
chisq.test(stud$lunch, stud$`test preparation course`)


# 2
sqrt(chisq.test(stud$lunch, stud$`test preparation course`)$statistic / nrow(stud))


# 3
ggplot(data = stud) +
  geom_mosaic(aes(x = product(gender, lunch)))


# 4
stud %>% mutate(test = ifelse(`test preparation course` == "completed", 1, 0)) -> s_
cor.test(s_$`math score`, s_$test)
ltm::biserial.cor(stud$`math score`, stud$`test preparation course`)


# 5
stud %>% 
  ggplot(aes(lunch, `math score`)) +
  geom_boxplot()
