# created 17 feb 2025
# purpose: clean up herbicide application data

library(tidyverse)
library(lubridate)
library(readxl)

rm(list = ls())


# data --------------------------------------------------------------------

d18 <- read_excel("data-raw/02_mgmt/byhand_herbicide-ops.xlsx",
                  sheet = "2018",
                    skip = 5)

d19 <- read_excel("data-raw/02_mgmt/byhand_herbicide-ops.xlsx",
                  sheet = "2019",
                  skip = 5)

d20 <- read_excel("data-raw/02_mgmt/byhand_herbicide-ops.xlsx",
                  sheet = "2020",
                  skip = 5)



# 0. combine --------------------------------------------------------------

d0 <- 
  bind_rows(d18, d19, d20)

# 1. fill dates and trts -------------------------------------------------------------

p1 <- 
  d0 %>% 
  fill(date, till_id, cctrt_id) %>% 
  mutate(date2 = ymd(date)) %>% 
  select(date2, till_id, cctrt_id, product, amount, amount_units)


# 2. expand trts ---------------------------------------------------------

p2 <- 
  p1 %>% 
  separate_rows(cctrt_id, sep = ",") %>% 
  separate_rows(till_id, sep = ",") %>% 
  mutate_at(.vars = c("till_id", "cctrt_id"), str_squish)
  
  

# write it ----------------------------------------------------------------
cents_herbops <- p2

cents_pliherbs %>% 
  write_csv("data-raw/02_mgmt/cents_herbops.csv")

usethis::use_data(cents_herbops, overwrite = TRUE)
