# created 27/5/2024
# purpose: separate data into ind data sets, clean if necessary
# notes:

# 3. fall plant cover (separated by species, kind of)

#--there are essentially two crop years of data
# 2018 fall, 2019 fall

library(tidyverse)
library(readxl)

Sys.setenv(LANG = "en")
rm(list = ls())

#--there are 3 subreps w/in each eu

# raw data ----------------------------------------------------------------

draw <- read_excel("data-raw/Bo/Data_Gina.xls")

eukey <- read_csv("data-raw/01_keys/cents_eukey.csv")

# 1. preprocess ------------------------------------------------

#--am doing nothing with dates at this point, see section 3
#--individual weeds add up to weed cover
#--2018 volunteers are barley (HORVW Hordeum vulgare)
#--2019 volunteers are oats (AVESA Avena sativa)

d1 <- 
  draw %>% 
  select(eu_id = parc, date, reg, soil:lamss) %>% 
  pivot_longer(soil:lamss) 


# 2. classify categories --------------------------------------------------

d2 <-
  d1 %>% 
  mutate(cover_cat = case_when(
    name %in% c("clover", "lolpe", "radish") ~ "covercrop",
    name %in% c("soil") ~ "soil",
    TRUE ~ "other"))


# 3. add years and harvest year -------------------------------------------

#--something is up with the dates
d3a <-
  d2 %>% 
  mutate(date2 = lubridate::dmy(date))

d3a %>% 
  select(date2) %>% 
  unique() %>% 
  arrange(date2)

d3a %>% 
  filter(date2 == "2019-05-22")

d3a %>% 
  filter(is.na(value)) %>% 
  select(date2) %>% 
  unique() %>% 
  arrange(date2)

#--they all appear on two dates only
library(plotly)
ggplotly(
d3a %>% 
  ggplot(aes(date2, value)) +
  geom_point())

d3a %>% 
  filter(date2 %in% c("2018-11-09", "2019-11-01")) %>% 
  ggplot(aes(date2, value)) +
  geom_point()

d3a %>% 
  filter(!(date2 %in% c("2018-11-09", "2019-11-01"))) %>% 
  ggplot(aes(date2, value)) +
  geom_point()

#--ok, those are the two sample dates
#--I don't know what the other ones are
d3b <- 
  d3a %>% 
  filter(date2 %in% c("2018-11-09", "2019-11-01"))

d3 <- 
  d3b %>% 
  mutate(year = lubridate::year(date2))
  
d3  


# 4. fiddle ---------------------------------------------------------------

d4 <-
  d3 %>% 
  mutate(value = ifelse(is.na(value), 0, value)) %>% 
  rename(cover_type = name, 
         cover_pct = value) 


d4 %>% 
  ggplot(aes(cover_type, cover_pct)) +
  geom_point() +
  facet_grid(.~year) +
  coord_flip()



# 5. make into eppo codes -------------------------------------------------

d5 <- 
  d4 %>% 
  mutate(eppo_code = case_when(
    (cover_type == "volunteer" & year == 2018) ~ "horvw",
    (cover_type == "volunteer" & year == 2019) ~ "avesa",
    (cover_type == "clover") ~ "trfre",
    (cover_type == "radish") ~ "rapsr",
    TRUE ~ cover_type)
    ) %>% 
  select(-cover_type) 

# write it ----------------------------------------------------------------

cents_fallpctcover <- 
  d5 %>% 
  select(eu_id, date2, subrep = reg, cover_cat, eppo_code, cover_pct) %>% 
  arrange(eu_id, date2)

cents_fallpctcover %>% 
  write_csv("data-raw/03_msmt/cents_fallpctcover.csv")

usethis::use_data(cents_fallpctcover, overwrite = TRUE)
