## code to create cents_ccdesc

# created 14 oct

library(readxl)
library(readr)
library(dplyr)
Sys.setenv(LANG = "en")
rm(list = ls())

# raw data ----------------------------------------------------------------

draw <- read_excel("data-raw/Bo/Data_Gina.xls")

tmp.cents_eukey <- read_csv("data-raw/01_keys/cents_eukey.csv")


# 1. clean it up for processing -------------------------------------------

d1 <- 
  draw %>% 
  select(eu_id = parc, 
         Bo_covercrop = covercrop,
         Bo_estab = estab,
         Bo_species = species) %>% 
  distinct()


# 2. merge with eukey -----------------------------------------------------

d2 <- 
  d1 %>% 
  left_join(tmp.cents_eukey) %>% 
  select(cctrt_id, Bo_covercrop, Bo_estab, Bo_species)

# 3. clean up --------------------------------------------------------

d3 <- 
  d2 %>% 
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
  ) 


# 4. write ----------------------------------------------------------------

cents_ccdesc <- 
  d3 %>% 
  distinct() %>% 
  arrange(cctrt_id) %>% 
  select(cctrt_id, cctrt_desc, species_desc, estab_desc, everything())

cents_ccdesc %>% 
  readr::write_csv("data-raw/01_keys/cents_ccdesc.csv")

usethis::use_data(cents_ccdesc, overwrite = TRUE)
