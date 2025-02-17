# created 13 dec 2024
# purpose: summarise crop planting and harv dates


library(tidyverse)
library(lubridate)
library(readxl)

rm(list = ls())

# notes: est_year is the year the cc is established

# data --------------------------------------------------------------------

draw1 <- read_excel("data-raw/Eugene/byhand_crop-mgmt-dates.xlsx",
                    skip = 5)

# 1. clean up dates -------------------------------------------------------------

p1 <- 
  draw1 %>% 
  mutate(plant_date = as_date(plant_date),
         plant_doy = yday(plant_date),
         plant_year = year(plant_date)) %>%
  mutate(harvest_date = as_date(harvest_date),
         harvest_doy = yday(harvest_date),
         harvest_year = year(harvest_date)) %>% 
  mutate(crop = ifelse(crop == "oats", "oat", crop))


# write it ----------------------------------------------------------------
cents_cropops <- p1

cents_cropops %>% 
  write_csv("data-raw/02_mgmt/cents_cropops.csv")

usethis::use_data(cents_cropops, overwrite = TRUE)
