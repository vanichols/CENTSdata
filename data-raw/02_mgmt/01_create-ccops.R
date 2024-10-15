# created 15 oct 2024
# purpose: figure out mgmt


library(tidyverse)
library(lubridate)
library(readxl)

rm(list = ls())

# notes: est_year is the year the cc is established

# data --------------------------------------------------------------------

draw1 <- read_excel("data-raw/Eugene/byhand_cover-crop-planting-dates.xlsx",
                     sheet = "ccplanting", skip = 5) 

draw2 <- read_excel("data-raw/Eugene/byhand_cover-crop-planting-dates.xlsx",
                     sheet = "ccterminating", skip = 5) %>% 
  select(-xx)

draw3 <- read_excel("data-raw/Eugene/byhand_cover-crop-planting-dates.xlsx",
                    sheet = "ccsampling", skip = 5) 

#--to attach the cc planting dates to an eu
eu <- read_csv("data-raw/01_keys/cents_eukey.csv")

tmp.cctrt_id <- eu %>% pull(cctrt_id) %>% unique()

# 1. planting -------------------------------------------------------------

p1 <- 
  draw1 %>% 
  mutate(date = paste(year, month, day, sep = "-"),
         date2 = as_date(date),
         doy = yday(date2),
         year = year(date2),
         ccest_year = as.numeric(est_year)) %>% 
  select(date2, ccest_year, year, doy, cctrt_id)


# 2. planting eus ---------------------------------------------------------

p2.tmp <- 
  eu %>% 
  select(eu_id, cctrt_id)

#--each eu will have two years of cc planting data

p2 <-
  p2.tmp %>% 
  left_join(p1, relationship = "many-to-many") %>% 
  rename(cc_planting = date2) %>% 
  select(eu_id, ccest_year, cc_planting)


# 3. termination ----------------------------------------------------------

t3 <- 
  draw2 %>% 
  mutate(date = paste(year, month, day, sep = "-"),
         date2 = as_date(date),
         doy = yday(date2),
         year = year(date2),
         ccest_year = est_year) %>% 
  select(date2, ccest_year, year, doy, till_id)


# 4. termination eus ------------------------------------------------------

#--termination applied to all ccs within a tillage id equally

#--omit the nocc trt
t4.tmp1 <- 
  eu %>% 
  select(eu_id, till_id, cctrt_id) %>% 
  filter(cctrt_id != "nocc")

#--nocc eus to bind back on
t4.tmp2 <- 
  eu %>% 
  select(eu_id, till_id, cctrt_id) %>% 
  filter(cctrt_id == "nocc")

#--each eu will have two years of cc termination data, nocc should have NA

t4 <- 
  t4.tmp1 %>% 
  left_join(t3, relationship = "many-to-many") %>% 
    bind_rows(t4.tmp2) %>% 
    arrange(eu_id) %>% 
  rename(cc_termination = date2) %>% 
  select(eu_id, ccest_year, cc_termination)

# 5. sampling -------------------------------------------------------------

s5 <- 
  draw3 %>% 
  mutate(date = paste(year, month, day, sep = "-"),
         cc_sampling = as_date(date)) %>% 
  select(cc_sampling) %>% 
  expand_grid(., tmp.cctrt_id) %>% 
  rename(cctrt_id = tmp.cctrt_id) %>% 
  mutate(ccest_year = year(cc_sampling))


# 6. sampling eus ---------------------------------------------------------
s6 <- 
  eu %>% 
  left_join(s5) %>% 
  select(eu_id, ccest_year, cc_sampling)
  

# 7. combine --------------------------------------------------------------

d7 <- 
  p2 %>% 
  left_join(t4) %>%
  left_join(s6) %>% 
  select(eu_id, ccest_year, cc_planting, cc_termination)

# write it ----------------------------------------------------------------

cents_ccops <- d7

cents_ccops %>% 
  write_csv("data-raw/02_mgmt/cents_ccops.csv")

usethis::use_data(cents_ccops, overwrite = TRUE)
