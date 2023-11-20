library(tidyverse)
# ----
hap <- read_csv("data/j-form2/2019.csv")
hap2015 <- read_csv("data/j-form2/2015.csv")


hap2015 %>% View
hap %>% View

hap$`Country or region` %>% unique() -> countries2019
hap2015$Country %>% unique() -> countries2015

countries2019[!countries2019 %in% countries2015]

countries2015 %>% sort()

hap %>% 
  mutate(`Country or region` = str_replace_all(`Country or region`, "&", "and")) -> hap

hap$`Country or region` %>% unique() -> countries2019
# hap2015$Country %>% unique() -> countries2015

hap %>% filter(`Country or region` != "Namibia" &
                 `Country or region` != "Gambia" &
                 `Country or region` != "South Sudan" &
                 `Country or region` != "Somalia") -> hap2

tibble(Country = c("North Macedonia", "Northern Cyprus"),
       Region = c(
         "Central and Eastern Europe",
         "Western Europe"
       )) %>% 
  bind_rows(regions) -> regions

hap2015 %>% select(Region, Country) -> regions
regions$Region %>% unique()
regions %>% filter(Country == "Cyprus")

hap2 %>% 
  rename(Country = `Country or region`) %>% 
  left_join(regions) -> happ

happ %>% View()

happ$Region %>% is.na() %>% sum()


# ----

hap2 %>% write_csv("data/j-form2/countries.csv")
regions %>% write_csv("data/j-form2/regions.csv")
rm(list = ls())

### ------------

hap <- read_csv("data/j-form2/countries.csv")
regions <- read_csv("data/j-form2/regions.csv")

hap %>% 
  rename(Country = `Country or region`) %>% 
  mutate(Country = str_replace_all(Country, "&", "and")) %>% 
  left_join(
    tibble(Country = c("North Macedonia", "Northern Cyprus"),
           Region = c(
             "Central and Eastern Europe",
             "Western Europe"
           )) %>% 
      bind_rows(regions)
  ) -> hap

hap$Region %>% is.na() %>% sum()
hap %>% colnames()

hap %>% 
  filter(str_detect(Region, "Europe")) %>% 
  ggplot(aes(Country, Score)) +
  geom_col() +
  facet_wrap(~ Region, scales = "free_x") +
  theme(axis.text.x = element_text(angle = 90))

hap %>% 
  filter(str_detect(Region, "Africa")) %>% 
  ggplot() +
  geom_point(aes(`GDP per capita`, Score, color = Region)) +
  geom_smooth(aes(`GDP per capita`, Score), method = "lm")

summary(hap)
