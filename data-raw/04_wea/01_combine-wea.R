# created 8/4/2024
# purpose: process weather from AGRO weather station
# notes:


library(tidyverse)
library(lubridate)

rm(list = ls())


# data --------------------------------------------------------------------

draw1 <- read_csv("data-raw/04_wea/tmp.wea1.csv")
summary(draw1) #--doesn't include 2013...

draw2 <- read_csv("data-raw/04_wea/tmp.wea2.csv")
summary(draw2)

# 1. combine --------------------------------------------------------------

d1 <- 
  draw1 %>% 
  bind_rows(draw2) %>% 
  rename(avgte = temp, prec_mm = prec)


# 2. calc long term values ------------------------------------------------

airtempLT <- 
  d1 %>% 
  group_by(doy) %>% 
  summarise(LTavgte = mean(avgte))

precLT <- 
  d1 %>% 
  group_by(year) %>% 
  mutate(cprec_mm = cumsum(prec_mm)) %>% 
  group_by(doy) %>% 
  summarise(LTcprec_mm = mean(cprec_mm))


d2 <- 
  d1 %>% 
  left_join(airtempLT) %>% 
  left_join(precLT) 



# 3. tidy it up -----------------------------------------------------------

d3 <- 
  d2 %>% 
  ungroup() %>% 
  select(-dataset, -station)


# write it ----------------------------------------------------------------

cents_wea <- d3

cents_wea %>% 
  write_csv("data-raw/04_wea/cents_wea.csv")

usethis::use_data(cents_wea, overwrite = TRUE)
