
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CENTSdata

The goal of CENTSdata is to tidy up data from the CENTS experiment so it
is easy to analyze

## Collected data

1.  crop yields (2018 - spring barely, 2019 - oat, 2020 - faba bean)
2.  fall plant biomass (NOT separated by species, 2018, 2019)
3.  fall plant cover (YES separated by species, 2018, 2019)
4.  spring weed counts (dicot, monocot, cirar, equar) following fall
    cover crop treatment (2019 and 2020)

## Installation

You can install the development version of CENTSdata from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("vanichols/CENTSdata")
```

## Example

This is a basic example of the package’s utility:

``` r
library(CENTSdata)

#-You can easily access treatments, yields, weed counts, weed biomass, etc.
head(cents_fallbio)
#>   eu_id      date2   dm_type dm_gm2
#> 1 30502 2018-11-15  grass_cl   5.82
#> 2 30502 2018-11-15     weeds  14.37
#> 3 30502 2018-11-15    radish     NA
#> 4 30502 2018-11-15 volunteer 135.89
#> 5 30502 2019-11-13  grass_cl  61.58
#> 6 30502 2019-11-13     weeds  35.09
```
