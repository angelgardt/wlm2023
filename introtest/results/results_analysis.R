library(tidyverse)

test <- read_csv("results/testing.csv")
head(test)
str(test)

test |> 
    rename_with(str_replace_all, pattern = "-", replacement = "_") |> 
    slice(-1) |> 
    select(1:17) |>
    mutate(q0_1 = ifelse(
                str_detect(q0_1_ans, "меняет знак с «минуса» на «плюс»"), 1, 0),
           q0_2 = ifelse(
               str_detect(q0_2_ans, "3×6"), 1, 0),
           q0_3 = ifelse(
               str_detect(q0_3_ans, "отношений"), 1, 0),
           q0_4 = ifelse(
               str_detect(q0_4_ans, "равна 0"), 1, 0),
           q0_5 = ifelse(
               str_detect(q0_5_ans, "0.597") | str_detect(q0_5_ans, "0,597")
           ),
           q0_6 = ifelse(
               str_detect(q0_6_ans, "стремится к единице"), 1, 0
           ),
           q0_7 = ifelse(
               str_detect(q0_7_ans, "это квадрат единицы измерения исходной переменной"), 1, 0
               ),
           q0_8 = ifelse(
               str_detect(q0_8_ans, "направление связи между переменными") & 
                   !str_detect(q0_8_ans, "силу связи между переменными"), 1, 0
           ),
           q0_9 = ifelse(
               str_detect(q0_9_ans, "красная") & str_detect(q0_9_ans, "черная") &
                   !str_detect(q0_9_ans, "синяя") & !str_detect(q0_9_ans, "зеленая"), 1, 0
           ),
           q0_10
           q0_11
           q0_12
           q0_13
           q0_14
           q0_15) |> View()
           