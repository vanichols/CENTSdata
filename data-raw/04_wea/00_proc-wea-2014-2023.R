# created 8/4/2024
# purpose: process weather from AGRO weather station
# notes:

#-- added to r package 15 oct 2024

library(tidyverse)
library(lubridate)

rm(list = ls())

# get data from
# https://agro-web11t.uni.au.dk/klimadb/

# NOTe: I don't know why I have separate datasets.
# I think the downloading is separated (pre 2013, post 2013)

# NOTE that is an internal server, not very repeatable. 
# DMI API data could also be used


# weather data ------------------------------------------------------------

draw <- 
  read_csv("data-raw/04_wea/wea/AGRO-slagelse-US.csv") %>% 
  mutate(date2 = dmy(date),
         year = year(date2),
         doy = yday(date2)) %>% 
  filter(year != 2024) # only have 1 jan for 2024

summary(draw)
#--10 years


# write it ----------------------------------------------------------------

tmp.wea2 <- 
  draw %>% 
  mutate(dataset = 2) %>% 
  select(dataset, station, date2, doy, year, minte, maxte, temp, prec)

tmp.wea2 %>% 
  write_csv("data-raw/04_wea/tmp.wea2.csv")
