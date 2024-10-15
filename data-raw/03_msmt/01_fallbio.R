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


#--moved to package 14 oct 2024

library(tidyverse)
library(readxl)

Sys.setenv(LANG = "en")
rm(list = ls())

#NOTE: M&M says there are two sub reps per plot
# no separation of weed types, just categorically 'weeds'
# NOTE: in 2018 it is barley volunteers, in 2019 it is oat volunteers (no data)


# raw data ----------------------------------------------------------------

draw <- read_excel("data-raw/Bo/Data_Gina.xls")

eukey <- read_csv("data-raw/01_keys/cents_eukey.csv")

# 1. preprocess ------------------------------------------------

d1 <- 
  draw %>% 
  mutate(date2 = lubridate::dmy(date),
         year = lubridate::year(date2)) %>% 
  filter(!is.na(DM))


# 2. fall biomass ---------------------------------------------------------


d2 <- 
  d1 %>% 
  select(eu_id = parc,
         date2, year, frac, DM)


# 3. add experimental year ------------------------------------------------

d3 <- 
  d2 %>% 
  mutate(exp_year = ifelse(year == 2018, "y1_fall", "y2_fall"))



# 4. rename cols, correct spellings -------------------------------------------------------------

d4 <- 
  d3 %>% 
  rename(dm_type = frac, dm_gm2 = DM) %>% 
  #--correct volunteer spelling
  mutate(dm_type = ifelse(dm_type == "voluntee", "volunteer", dm_type)) 


# 5. make NAs explicit ----------------------------------------------------
#--NOTE: 2019 had no volunteer biomass data, I'm not sure how reliable this data is 
# did it omit the volunteers? or did they get lumped in another cat?

d5 <- 
  d4 %>% 
  #--make NA values explicit, it isn't clear which are 0s and which are missing
  pivot_wider(names_from = dm_type, values_from = dm_gm2) %>%
  pivot_longer(grass_cl:volunteer) %>%
  rename(dm_type = name, dm_gm2 = value)


# 6. write it -------------------------------------------------------------

cents_fallbio <- 
  d5 %>% 
  select(-year) %>% 
  arrange(eu_id, date2)

cents_fallbio %>% 
  write_csv("data-raw/03_msmt/cents_fallbio.csv")

usethis::use_data(cents_fallbio, overwrite = TRUE)


# small exploration -------------------------------------------------------

cents_fallbio %>%
  filter(!is.na(dm_gm2)) %>% 
  ggplot(aes(dm_type)) + 
  geom_histogram(stat = "count") +
  labs(x = NULL,
       y = "number of observations",
       title = "No biomass for volunteers in 2019") +
  facet_grid(.~year)

#--just two sampling dates, I think
cents_fallbio %>% 
  mutate(dm_type2 = ifelse(dm_type %in% c("grass_cl", "radish"), "cover crop", dm_type)) %>% 
  ggplot(aes(eu_id, dm_gm2)) + 
  geom_col(aes(fill = dm_type2)) + 
  facet_grid(.~year) + 
  scale_fill_manual(values = c("green4", "gray80", "gray20"))


