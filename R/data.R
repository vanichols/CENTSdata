#' Crop yields of barley (2018), oats (2019), and faba bean (2020)
#'
#' A dataset containing the prices and other attributes of almost 54,000
#'  diamonds. The variables are as follows:
#'
#' @format A data frame with 360 rows and 6 variables
#' \describe{
#'   \item {eu_id}{A unique identifier for a block, straw trt, till trt, and cover crop (cc) trt}
#'   \item {date2}{The date of yield measurement (yyyy-mm-dd)}
#'   \item {crop}{The crop harvested}
#'   \item {yield_dry_Mgha}{Weight of crop yield on a dry basis in mega-grams (Mg) per hectare (ha), as provided by Bo's dataset}
#'   \item {yield_15p_tonha}{Weight of crop yield at 15% moisture basis in tons (same as a Mg) per ha, as provided by Bo's dataset}
#'   \item {calc_yield_15p_tonha}{Back calculated yield at 15% moisture to check conversion math}
#' }
#'
"cents_cropyields"