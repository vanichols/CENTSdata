# created 8/4/2024
# purpose: process weather from AGRO weather station
# notes:

# added to package 15 oct 2024

library(tidyverse)
library(lubridate)

rm(list = ls())

# get data from
# https://agro-web11t.uni.au.dk/klimadb/

# agro climate data -------------------------------------------------------

#--1990-2012
wraw <- 
  read_csv("data-raw/04_wea/wea/1990-2013 AGRO-slagelse-US.csv") %>% 
  rename(prec = prec08) %>% 
  mutate(date2 = ymd(date),
         doy = yday(date),
         year = year(date),
         station = 613500)  %>% 
  filter(year != 2013) #--only have jan 1 for that year

summary(wraw)
#--why are things characters?
#--because there are a lot of 'null' cells. So it is fine to replace those with NA

tst <- 
  wraw %>% 
  mutate(minte2 = as.numeric(minte))

tst2 <- 
  tst %>% 
  filter(is.na(minte2))

#--are there more NAs in a given year?
#--hmmm maybe this data isn't worth it
#--could take averages of every other year and fill them in I guess
tst2 %>% 
  mutate(year = year(date)) %>% 
  ggplot(aes(year)) + 
  geom_histogram()


# 1. change char to numeric -----------------------------------------------

w1 <- 
  wraw %>% 
  mutate_if(is.character, as.numeric) 


# 2. replace NAs with averages from all other years -----------------------

w2 <- 
  w1 %>%
  group_by(doy) %>% 
  mutate(minte_avg = mean(minte, na.rm = T),
         maxte_avg = mean(maxte, na.rm = T),
         temp_avg = mean(temp, na.rm = T),
         prec_avg = mean(prec, na.rm = T)) %>% 
  pivot_longer(minte:prec) %>% 
  mutate(value = case_when(
    (is.na(value) & name == "minte") ~ minte_avg,
    (is.na(value) & name == "maxte") ~ maxte_avg,
    (is.na(value) & name == "temp") ~ temp_avg,
    (is.na(value) & name == "prec") ~ prec_avg,
    TRUE ~ value
  )) %>% 
  pivot_wider(names_from = name, values_from = value)

#--it worked, confirms
w2 %>% 
  filter(is.na(minte))


# write it ----------------------------------------------------------------
tmp.wea1 <- 
  w2 %>% 
  mutate(dataset = 1) %>% 
  select(dataset, station, date2, doy, year, minte, maxte, temp, prec)

tmp.wea1 %>% 
  write_csv("data-raw/04_wea/tmp.wea1.csv")
