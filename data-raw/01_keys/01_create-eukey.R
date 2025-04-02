## code to prepare cents_eu (the experimental unit, the unique piece of land that receives the system treatment)

# created 14 oct 2024
# modified 5 nov 2024 - made subplot id unique by plot, as subplot 02 in plot 1 shouldn't be related to subplot 02 in plot 2


library(readxl)
library(dplyr)
Sys.setenv(LANG = "en")
rm(list = ls())


# raw data ----------------------------------------------------------------

draw <- read_excel("data-raw/Bo/Data_Gina.xls")

#--5 cc treatments (3 = radish early, 4 = radish late, 2 = mix early, 5 = mix late, 6 = no cc)
#--3 tillage treatments (1=aggresive, 2=moderate, 4=zero)
#--two 'rotations', but they are actually straw removal treatments (R3 = straw removal, R4 = straw remains)
#--4 replicates
#--120 experimental units

#--parcels - I need a key to make this...waiting on Eugene 7/1/24, he told me and I forgot

# 1. figure out parcel treatments for each year ---------------------------

d1 <- 
  draw %>% 
  select(parc, block, till, rota, covercrop, yield_DM, date) %>% 
  filter(!is.na(yield_DM)) %>% 
  distinct() 

# 2. get crop harvest date --------------------------------------------------------

d2 <- 
  d1 %>% 
  mutate(date2 = lubridate::dmy(date),
         harv_year = lubridate::year(date2))



# 3. what is the parcel? --------------------------------------------------

#--what is the parc?

d3 <- 
  d2 %>% 
  mutate(parc1 = stringr::str_sub(parc, 1, 1),
         parc2 = stringr::str_sub(parc, 2, 3),
         parc3 = stringr::str_sub(parc, 4, 5))

#--I think parc2 is the plot, parc3 is the subplot, parc1 is just the 'cents' experiment

#--with block, plot, subplot, rot, till_id, cctrt_id, harv_year shouldn't matter
#--yes, 3 years of yield data for each parc
d3 %>% 
  filter(parc == 30502)



# 4. add cover crop trt id ------------------------------------------------

d4 <- 
  d3 %>% 
  distinct() %>% 
  mutate(
    cctrt_id = case_when(
      covercrop == "lolcl1" ~ "mix_E",
      covercrop == "lolcl2" ~ "mix_M",
      covercrop == "radish1" ~ "rad_M",
      covercrop == "radish2" ~ "rad_L",
      covercrop == "noCC" ~ "nocc",
      TRUE ~ "XXXX"))


# 5. add tillage id -------------------------------------------------------

d5 <- 
  d4 %>% 
  mutate(till_id = case_when(
    till == 1 ~ "inversion",
    till == 2 ~ "surface",
    till == 4 ~ "notill"))


# 6. add rotation and straw id --------------------------------------------

d6 <- 
  d5 %>% 
  mutate(straw_id = ifelse(rota == "R3", "removed", "retained")) %>% 
  rename(rot_id = rota)


# 7. create experimental unit ---------------------------------------------

d7 <- 
  d6 %>% 
  mutate(eu_id = parc,
         block_id = paste0("b", block),
         plot_id = paste0("p", parc2),
         subplot_id = paste0(plot_id, "_sp", parc3)) %>% 
  select(eu_id, block_id, plot_id, subplot_id, till_id, rot_id, straw_id, cctrt_id) %>% 
  distinct()

d7

# 5. write it -------------------------------------------------------------

cents_eukey <- d7

cents_eukey %>% 
    readr::write_csv("data-raw/01_keys/cents_eukey.csv")

usethis::use_data(cents_eukey, overwrite = TRUE)
