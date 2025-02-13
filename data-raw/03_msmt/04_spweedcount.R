# created 27/5/2024
# purpose: separate data into ind data sets, clean if necessary
# notes:
# 1. spring weed counts following year
# 2. fall plant biomass
# 3. fall plant cover
# 4. crop yields (2018 - spring barely, 2019 - oat, 2020 - faba bean)


library(tidyverse)
library(readxl)

Sys.setenv(LANG = "en")
rm(list = ls())

#--three subreps in each eu

# raw data ----------------------------------------------------------------

draw <- read_excel("data-raw/Bo/Data_Gina.xls")

#--for some reason, it reads in the dicot/monocot etc. as T/F, not as counts
d0 <- 
  draw %>% 
  filter(!is.na(dicot))

#--I manually filtered the raw dataset in Excel to save as it's own file

d1raw <- 
  read_excel("data-raw/Bo/Data_Gina-filtered-springweedcounts.xlsx") 

# 1. preprocess ------------------------------------------------

d1 <- 
  d1raw %>% 
  select(eu_id = parc, date, reg:equar)


# 2. pivot and date change ------------------------------------------------

d2 <-
  d1 %>% 
  pivot_longer(dicot:equar) %>% 
  mutate(date2 = lubridate::dmy(date),
         year = lubridate::year(date2)) %>% 
  select(eu_id, date2, subrep = reg, weed_type = name, count = value)


# write -------------------------------------------------------------------

cents_spweedcount <- d2

cents_spweedcount %>% 
  write_csv("data-raw/03_msmt/cents_spweedcount.csv")

usethis::use_data(cents_spweedcount, overwrite = TRUE)




