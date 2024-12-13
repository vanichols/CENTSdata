# created 9 dec 2024
# purpose: get a list of the weed species identified in this trial
# notes:

library(tidyverse)
library(readxl)

Sys.setenv(LANG = "en")
rm(list = ls())

#--where would species data appear?


# 0. eppo codes with latin names ------------------------------------------

d <- 
  read_excel("data-raw/WSSA_Composite-List-of-Weeds_2023.xlsx") %>% 
  janitor::clean_names() %>% 
  select(latin_name, eppo_code = code1, family, wssa2023) %>% 
  mutate_if(is.character, str_to_lower)

# 1. fall biomass msmts ---------------------------------------------------

d1 <- 
  read_csv("data-raw/03_msmt/cents_fallpctcover.csv") %>% 
  select(cover_type) %>% 
  distinct() %>% 
  filter(!(cover_type %in% c("soil", "volunteer")))

#--remove clover, radish (do they have eppo acronyms?)
#--deal with them separately
fcov_sp <- 
  d1 %>% 
  mutate(cover_type = case_when(
    cover_type == "radish" ~ "rapsr",
    cover_type == "clover" ~ "trfre",
    #cover_type == "cirss" ~ "cirar", #--in the spring this is what is recorded
    TRUE ~ cover_type
  )) %>% 
  rename(eppo_code = cover_type)


# 2. spring weed counts ---------------------------------------------------

#--weird that neither cirar nor equar appear in the fall pct cover
swc <- 
  read_csv("data-raw/03_msmt/cents_spweedcount.csv") %>% 
  select(weed_type) %>% 
  distinct() %>% 
  filter(!(weed_type %in% c("dicot", "monocot")))

swc_sp <-
  swc %>% 
  select(eppo_code = weed_type)


# 3. all species ----------------------------------------------------------

res1 <- 
  swc_sp %>% 
  bind_rows(fcov_sp) %>% 
  arrange(eppo_code) %>% 
  distinct() %>% 
  left_join(d)

#--remove lines telling you to look at another line
res2 <- 
  res1 %>% 
  filter(!grepl("see", wssa2023))

res3 <-
  res2 %>% 
  mutate(
    family = case_when(
      eppo_code == "cirss" ~ "asteraceae",
      eppo_code == "gerss" ~ "geraniaceae",
      eppo_code == "lamss" ~ "lamiaceae",
      eppo_code == "senss" ~ "asteraceae",
      eppo_code == "verss" ~ "plantaginaceae",
      #--unsure why missing from us database
      eppo_code == "ephex" ~ "euphorbia exigua l.",
      TRUE ~ family),
    latin_name = case_when(
      eppo_code == "cirss" ~ "cirsium species",
      eppo_code == "gerss" ~ "geranium species",
      eppo_code == "lamss" ~ "lamium species",
      eppo_code == "senss" ~ "senecio species",
      eppo_code == "verss" ~ "veronica species",
      #--unsure why missing from us database
      eppo_code == "ephex" ~ "euphorbiaceae",
      TRUE ~ latin_name),
  )

res3


# 4. write it ----------------------------------------------------------------

cents_species <- res3

cents_species %>% 
  write_csv("data-raw/03_msmt/cents_species.csv")

usethis::use_data(cents_species, overwrite = TRUE)

