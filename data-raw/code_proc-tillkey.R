## code to prepare cents_tillkey

# created 14 oct 2024


library(readxl)
library(dplyr)
Sys.setenv(LANG = "en")
rm(list = ls())


# raw data ----------------------------------------------------------------

draw <- read_excel("data-raw/Bo/Data_Gina.xls")


# make keys ---------------------------------------------------------------

#--3 tillage treatments (1=aggresive, 2=moderate, 4=zero)

# get rid of observed variables -------------------------------------------

d1 <- 
  draw %>% 
  select(parc, block, till, rota, covercrop, estab, species, date) %>% 
  distinct()


# make tillkey --------------------------------------------------------------

tillkey <- 
  d1 %>% 
  mutate(till_id = case_when(
    till == 1 ~ "inversion",
    till == 2 ~ "noninversion",
    till == 4 ~ "notill"),
    till_desc = case_when(
      till == 1 ~ "moldboard plowing",
      till == 2 ~ "8-10 cm depth tillage (harrowing, chiseling)",
      till == 4 ~ "direct seeding since exp establishment")
  ) %>%  
  select(till_id, till_desc, Bo_till = till) %>% 
  distinct() %>% 
  arrange(-Bo_till) %>% 
  mutate(till_intens_numeric = c(1, 2, 3))

tillkey


# clean it up -------------------------------------------------------------

cents_tillkey <- tillkey 

cents_tillkey %>% 
  readr::write_csv("data-raw/cents_tillkey.csv")

usethis::use_data(cents_tillkey, overwrite = TRUE)
