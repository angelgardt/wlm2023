library(tidyverse)
theme_set(theme_bw())

tibble(
    x = c(0, 5, 0, 5, 0, 5, 0, 5),
    y = c(5, 7, 5, 9, 6, 10, 4, 5),
    line = c(1, 1, 2, 2, 3, 3, 4, 4) |> as.character()
) |> 
    ggplot(aes(x, y, color = line, linetype = line)) +
    geom_line(size = 1.5) +
    scale_color_manual(values = c("1" = "black", "2" = "red3", "3" = "blue3", "4" = "green3")) +
    scale_linetype_manual(values = c("1" = "solid", "2" = "longdash", "3" = "dashed", "4" = "dotdash")) +
    guides(color = "none", linetype = "none") +
    labs(x = NULL, y = NULL)
ggsave("lm_pic.png")


tibble(x = c("A", "B", "C", "D", "E"),
       y = c(10, 13, 8, 3, 9)) |> 
    ggplot(aes(x, y)) +
    geom_col() +
    labs(x = "Group", y = "Count") +
    theme(axis.text = element_text(size = 15),
          axis.title = element_text(size = 20))
ggsave("graph1.png")

tibble(x = rep(c("A", "B", "C", "D", "E"), times = 3),
       col = rep(c("R", "L", "C"), each = 5),
       y = c(10, 13, 8, 3, 9, 11, 9, 7, 1, 3, 4, 5, 8, 5, 6)) |> 
    ggplot(aes(x, y, fill = col)) +
    geom_col(position = position_dodge()) +
    labs(x = "Group", y = "Count", fill = "Side") +
    scale_fill_manual(values = c("seagreen1", "seagreen2", "seagreen3")) +
    theme(axis.text = element_text(size = 15),
          axis.title = element_text(size = 20),
          legend.text = element_text(size = 15),
          legend.title = element_text(size = 20))
ggsave("graph2.png")

tibble(x = c("A", "B", "C", "D", "E"),
       y = c(10, 13, 11, 12, 9) - 8) |> 
    ggplot(aes(x, y)) +
    geom_col() +
    labs(x = "Group", y = "Count") +
    theme(axis.text = element_text(size = 15),
          axis.title = element_text(size = 20)) +
    scale_y_continuous(breaks = seq(0, 15, by = 2), labels = (seq(0, 15, by = 2) + 8) |> as.character())
ggsave("graph3.png")

tibble(x = c("A", "B", "C", "D", "E"),
       y = c(10, 13, 11, 12, 9) - 8) |> 
    ggplot(aes(x, y, fill = x)) +
    geom_col() +
    labs(x = "Group", y = "Count", fill = "Group") +
    theme(axis.text = element_text(size = 15),
          axis.title = element_text(size = 20),
          legend.text = element_text(size = 15),
          legend.title = element_text(size = 20),
          legend.position = "bottom")
ggsave("graph4.png")




