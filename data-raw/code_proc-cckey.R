## code to prepare cents_cckey

# created 14 oct 2024
# purpose: make data keys to simplify data manipulation
# notes: Ideally I want all the actual data to be linked to a parcel, then I can just merge things

library(readxl)
library(dplyr)
Sys.setenv(LANG = "en")
rm(list = ls())


# raw data ----------------------------------------------------------------

draw <- read_excel("data-raw/Bo/Data_Gina.xls")


# make keys ---------------------------------------------------------------

#--5 cc treatments (3 = radish early, 4 = radish late, 2 = mix early, 5 = mix late, 6 = no cc)

# get rid of observed variables -------------------------------------------

d1 <- 
  draw %>% 
  select(parc, block, till, rota, covercrop, estab, species, date) %>% 
  distinct()


# make cckey --------------------------------------------------------------

cckey <- 
  d1 %>% 
  select(covercrop, estab, species) %>% 
  distinct() %>% 
  mutate(
    cctrt_id = case_when(
      covercrop == "lolcl1" ~ "mix_E",
      covercrop == "lolcl2" ~ "mix_M",
      covercrop == "radish1" ~ "rad_M",
      covercrop == "radish2" ~ "rad_L",
      covercrop == "noCC" ~ "nocc",
      TRUE ~ "XXXX")) %>% 
  rename(Bo_covercrop = covercrop,
         Bo_estab = estab,
         Bo_species = species) %>%
  mutate(
    estab_desc = case_when(
      cctrt_id == "mix_E" ~ "at crop sowing",
      cctrt_id == "mix_M" ~ "2 weeks before crop harvest",
      cctrt_id == "rad_M" ~ "2 weeks before crop harvest",
      cctrt_id == "rad_L" ~ "after crop harvest",
      TRUE ~ "no cover crop established"
    ),
    species_desc = case_when(
      Bo_species == "lol_tri" ~ "Lolium X and Trifolium pratense (ryegrass and red clover)",
      Bo_species == "raphanu" ~ "Raphanus sativus (forage radish)",
      TRUE ~ "none"
    )
  ) %>% 
  mutate(cctrt_desc = case_when(
    cctrt_id == "mix_E" ~ "Gr/cl at sowing",
    cctrt_id == "mix_M" ~ "Gr/cl pre-harvest",
    cctrt_id == "rad_M" ~ "Rad pre-harvest",
    cctrt_id == "rad_L" ~ "Rad post-harvest",
    TRUE ~ "Control")
  ) %>% 
  mutate(subplot = case_when(
    cctrt_id == "mix_E" ~ "sp2",
    cctrt_id == "mix_M" ~ "sp5",
    cctrt_id == "rad_M" ~ "sp3",
    cctrt_id == "rad_L" ~ "sp4",
    cctrt_id == "nocc" ~ "sp6")
    )


# clean it up -------------------------------------------------------------

cents_cckey <- 
  cckey %>% 
  select(subplot, cctrt_id, species_desc, cctrt_desc, everything()) 

cents_cckey %>% 
  readr::write_csv("data-raw/cents_cckey.csv")

usethis::use_data(cents_cckey, overwrite = TRUE)
