# created 15 oct 2024
# purpose: calculate GDDs for each cc trt
# notes:

library(tidyverse)
library(lubridate)

rm(list = ls())


# data --------------------------------------------------------------------

w <- read_csv("data-raw/04_wea/cents_wea.csv")

eu <- read_csv("data-raw/01_keys/cents_eukey.csv") %>% 
  select(eu_id, cctrt_id, till_id)

ccops <- 
  read_csv("data-raw/02_mgmt/cents_ccops.csv") %>% 
  left_join(eu) %>% 
  select(-eu_id) %>% 
  distinct() %>% 
  select(cctrt_id, till_id, everything()) %>% 
  arrange(cctrt_id, till_id, ccest_year) %>% 
  unite(cctrt_id, till_id, col = "tmp.id", remove = F) %>% 
  unite(tmp.id, ccest_year, col = "tmp.id2", remove = F) %>% 
  select(-tmp.id)


tmp.id.lst <- 
  ccops %>% 
  pull(tmp.id2) %>% 
  unique()


# 1. get pl and term dates -----------------------------------------------------

d1 <- NULL


for (i in 1:2){
  #for (i in 1:length(tmp.id.lst)){
  
  tmp.thing <- tmp.id.lst[i]
  
  ops.tmp <- ccops %>% filter(tmp.id2 == tmp.thing)
  
  #--weather merging
  d.tmp <- 
    w %>%
    select(date2, avgte) %>% 
    #--create a col to merge by
    mutate(tmp.id2 = tmp.thing) %>%
    left_join(ops.tmp) %>% 
    filter(date2 >= cc_planting,
           date2 <= cc_termination) %>% 
  #--no negative gdds
    mutate(avgte2 = ifelse(avgte < 0, 0, avgte)) %>% 
    group_by(tmp.id2) %>% 
    summarise(gdd = sum(avgte))

  d1 <- 
    d1 %>% 
    bind_rows(d.tmp)
  
  print(i)
}

d1
