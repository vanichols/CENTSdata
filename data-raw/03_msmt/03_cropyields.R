# created 27/5/2024
# purpose: separate data into ind data sets, clean if necessary
# notes:
# 1. spring weed counts following year
# 2. fall plant biomass
# 3. fall plant cover
# 4. crop yields (2018 - spring barely, 2019 - oat, 2020 - faba bean)

#--there are essentially two crop years of data
# 2018 spring and fall, plus 2019 spring before planting of next crop
# 2019 spring and fall, plus 2020 spring before planting of next crop
# 2020 crop yields are also included

#--I added an 'experimental year'
# 2019 spring msmts (weed counts) are connected to previous year's treatments
# exp_year y1_fall, y1_nxtsp, y2_fall, y2_nxtsp
# crop yields will be harder, no experimental year for them I think


#--moved to package 15 oct 2024

library(tidyverse)
library(readxl)

Sys.setenv(LANG = "en")
rm(list = ls())



# raw data ----------------------------------------------------------------

draw <- read_excel("data-raw/Bo/Data_Gina.xls")

eukey <- read_csv("data-raw/01_keys/cents_eukey.csv")

# 1. preprocess ------------------------------------------------

d1 <- 
  draw %>% 
  select(eu_id = parc, date, yield_DM, yield15) %>% 
  filter(!is.na(yield_DM))

  
# 2. add years/dates ----------------------------------------------------------
#--this one is a bit difficult, year wise, and I'm not sure experimental year is helpful

d2 <-
  d1 %>% 
  mutate(date2 = lubridate::dmy(date),
         year = lubridate::year(date2))
 
d2
  
  

# 3. add crops ------------------------------------------------------------

  d3 <-
    d2 %>%   
    mutate(crop = case_when(
    year == 2018 ~ "spring barley",
    year == 2019 ~ "oat",
    year == 2020 ~ "faba bean")) 
  

# 4. rename ---------------------------------------------------------------

  
  # the wet yields don't match that which would be calculated based on the 
  # dry yield then converting to 15% moisture, but
  # I think Iøm doing the calc wrong
  d4 <-
    d3 %>% 
    mutate(yield_dry_Mgha = yield_DM/100,
           yield_15p_tonha = yield15,
           calc_yield_15p_tonha = yield_dry_Mgha *1.15) %>% 
    select(eu_id, date2, crop, yield_dry_Mgha, yield_15p_tonha, calc_yield_15p_tonha)

  

# write it ----------------------------------------------------------------

cents_cropyields <- 
  d4 %>% 
  arrange(eu_id, date2)

cents_cropyields %>% 
  write_csv("data-raw/03_msmt/cents_cropyields.csv")

usethis::use_data(cents_cropyields, overwrite = TRUE)


