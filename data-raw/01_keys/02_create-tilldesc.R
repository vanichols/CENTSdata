## creates cents_tilldesc that has more indepth description of tillage treatments

# created 14 oct 2024

library(readxl)
library(readr)
library(dplyr)
library(readr)
Sys.setenv(LANG = "en")
rm(list = ls())


# raw data ----------------------------------------------------------------

draw <- read_excel("data-raw/Bo/Data_Gina.xls")

tmp.cents_eukey <- read_csv("data-raw/01_keys/cents_eukey.csv")

# make keys ---------------------------------------------------------------

#--3 tillage treatments (1=aggresive, 2=moderate, 4=zero)
#--two 'rotations', but they are actually straw removal treatments (R3 = straw removal, R4 = straw remains)


# 1. clean it up for processing -------------------------------------------

d1 <- 
  draw %>% 
  select(eu_id = parc, 
         Bo_till = till) %>% 
  left_join(tmp.cents_eukey)


# 2. describe tillage ----------------------------------------------------------

d2 <- 
  d1 %>% 
  select(till_id, Bo_till) %>% 
  mutate(
    till_desc = case_when(
      Bo_till == 1 ~ "moldboard plowing",
      Bo_till == 2 ~ "8-10 cm depth tillage (harrowing, chiseling)",
      Bo_till == 4 ~ "direct seeding since exp establishment")) %>% 
  distinct()

d2

# 3. write it -------------------------------------------------------------

cents_tilldesc <- d2

cents_tilldesc %>% 
  write_csv("data-raw/01_keys/cents_tilldesc.csv")

usethis::use_data(cents_tilldesc, overwrite = TRUE)

