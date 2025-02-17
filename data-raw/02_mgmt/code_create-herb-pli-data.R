# created 17 feb 2025
# purpose: clean up herbicide PLI data taken by hand from https://middeldatabasen.dk/Middelvalg.asp?oko=false
#--some products (mainly surfactants) had no information, those were assigned values of 0

library(tidyverse)
library(lubridate)
library(readxl)

rm(list = ls())


# data --------------------------------------------------------------------

d0 <- read_excel("data-raw/02_mgmt/byhand_herbicide-PLI-values.xlsx",
                    skip = 5, na = ".")

# 1. separate numbers -------------------------------------------------------------

p1 <- 
  d0 %>% 
  fill(product) %>% 
  separate(load_area, into = c("load_area", "crap"), sep = " ") %>%
  separate(load_unit, into = c("load_unit", "crap2"), sep = " ") 



# 2. make numeric ---------------------------------------------------------

p2 <- 
  p1 %>% 
  mutate(
    load_area = str_remove_all(load_area, ","),
    load_unit = str_remove_all(load_unit, ","),
    load_area = as.numeric(load_area),
         load_unit= as.numeric(load_unit))
  


# 3. clean ----------------------------------------------------------------

p3 <- 
  p2 %>% 
  select(-crap, -crap2)


# write it ----------------------------------------------------------------
cents_pliherbs <- p3

cents_pliherbs %>% 
  write_csv("data-raw/02_mgmt/cents_pliherbs.csv")

usethis::use_data(cents_pliherbs, overwrite = TRUE)
