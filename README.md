
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CENTSdata

The goal of CENTSdata is to tidy up data from the CENTS experiment so it
is easy to analyze

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
#>   eu_id      date2 exp_year   dm_type dm_gm2
#> 1 30502 2018-11-15       y1  grass_cl   5.82
#> 2 30502 2018-11-15       y1     weeds  14.37
#> 3 30502 2018-11-15       y1    radish     NA
#> 4 30502 2018-11-15       y1 volunteer 135.89
#> 5 30502 2019-11-13       y2  grass_cl  61.58
#> 6 30502 2019-11-13       y2     weeds  35.09
```
