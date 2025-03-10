#' Crop yields of barley (2018), oats (2019), and faba bean (2020)
#'
#' The data set with yields.
#'  The variables are as follows:
#'
#' @format A data frame with 360 rows and 6 variables
#' \describe{
#'   \item{eu_id}{A unique identifier for a block, straw trt, till trt, and cover crop (cc) trt}
#'   \item{date2}{The date of yield measurement (yyyy-mm-dd)}
#'   \item{crop}{The crop harvested}
#'   \item{yield_dry_Mgha}{Weight of crop yield on a dry basis in mega-grams (Mg) per hectare (ha), as provided by Bo's dataset}
#'   \item{yield_15p_tonha}{Weight of crop yield at 15% moisture basis in tons (same as a Mg) per ha, as provided by Bo's dataset}
#'   \item{calc_yield_15p_tonha}{Back calculated yield at 15% moisture to check conversion math}
#' }
#'
"cents_cropyields"

#' Fall cover as percentages of various weeds, cover crops, soil
#'
#' Percentages were assigned post hoc using pictures taken in the field. 
#' The variables are as follows:
#'
#' @format A data frame with 10800 rows and 6 variables
#' \describe{
#'   \item{eu_id}{A unique identifier for a block, straw trt, till trt, and cover crop (cc) trt}
#'   \item{date2}{The date the pictures were taken (yyyy-mm-dd)}
#'   \item{subrep}{The sub-sample identifer (1, 2, 3)}
#'   \item{cover_cat}{Categories of vegetation (covercrop, other, soil)}
#'   \item{eppo_code}{The EPPO code for the species (except for soil)}
#'   \item{cover_pct}{The percentage of cover attributed to a given EPPO code (0-100)}
#' }
#'
"cents_fallpctcover"

#' Counts of spring weeds per m2 in 2019 (one week after herbicide app in oats) 
#' and in 2020 (one week after second herbicide app in faba bean)
#'
#' The variables are as follows:
#'
#' @format A data frame with 2880 rows and 5 variables
#' \describe{
#'   \item{eu_id}{A unique identifier for a block, straw trt, till trt, and cover crop (cc) trt}
#'   \item{date2}{The date of counting (yyyy-mm-dd)}
#'   \item{subrep}{The sub-sample identifer (1, 2, 3)}
#'   \item{weed_type}{The type of weed with two species identified specifically (Dicot, monocot, cirar, equar)}
#'   \item{count}{The number of weeds counted in a 1 m2 area(0-600))}
#' }
#'
"cents_spweedcount"

#' Data from Middeldatabasen on herbicides used in CENTS 2018-2020
#'
#' The variables are as follows:
#'
#' @format A data frame with 40 rows and 6 variables
#' \describe{
#'   \item{product}{The product name as reported in the methods and materials}
#'   \item{load_cat}{PLI category (health, env behavior, env impact, total)}
#'   \item{load_area}{The amount of product you have to apply per unit area to achieve a load of 1}
#'   \item{load_area_units}{Units of the product application rate to achieve a load of 1 (liters/hectare, grams/hectare)}
#'   \item{load_unit}{Load assigned to a unit of herbicide}
#'   \item{load_unit_units}{B is the Danish letter for load, load per unit of herbicide (liter or gram)}
#' }
#'
"cents_pliherbs"

#' Data from Bo on herbicide usage, needs confirmed
#'
#' The variables are as follows:
#'
#' @format A data frame with 52 rows and 6 variables
#' \describe{
#'   \item{date2}{The date of the application (yyyy-mm-dd)}
#'   \item{till_id}{Tillage treatment id (notill, noninversion, inversion)}
#'   \item{cctrt_id}{Cover crop treatment id (mix_E, mix_M, rad_M, rad_L, nocc)}
#'   \item{product}{Commerical herbicide product name}
#'   \item{amount}{Amount of herbicide applied per unit area}
#'   \item{amount_units}{Units of amount (liters per hectare, grams per hectare)}
#' }
#'
"cents_herbops"