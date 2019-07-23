#########################################################################################################
#  Function to correct (substract) M+2 isotopic interference in MS1 datasets 
#  ================================================================================
#
#  Bo Burla, Singapore Lipidomics Incubator, National University of Singapore, 2019
#
#########################################################################################################

library(here)
library(readr)
library(dplyr)
library(purrr)
library(enviPat)

data("isotopes")
data("adducts")
data("resolution_list")
source(here("R/lipidname_functions.R"))


# database to a vector of lipid chain sum formula
lipidclass_list <- read_csv(here("R/lipidclass_HG_formula.csv")) 

# Adds a head group sum formula retrieved from the database to a vector of lipid chain sum formula
get_formula <- function(lipid_class, C, DB) {
  enviPat::mergeform(str_c("C", C, "H", C*2 - 2*DB),
                     lipidclass_list %>% filter(LIPID_CLASS == unique(lipid_class)) %>% .$CHEMICAL_FORMULA_HG)
}

# Calculates the isotope distributions (masses and relative abundances) of given sum formaulas. 
# Uses the 'envipat' package (https://www.envipat.eawag.ch/)
get_isotope_distributions <- function(molecule_formula){
  checked_formula <- check_chemform(isotopes, molecule_formula)
  centro <- isowrap(
    isotopes,
    checked_formula,
    resmass=resolution_list[[7]],
    resolution=FALSE,
    nknots=4,
    spar=0.2,
    threshold=0.01,
    charge=1,
    emass=0.00054858,
    algo=2,
    ppm=FALSE,
    dmz="get",   # retrieve dm from R=m/dm
    frac=1/4,
    env="Gaussian",
    detect="centroid",
    plotit=FALSE
  )
  return(centro)
}

# Extracts specific relative isotope abundances (M2, M4) from the one list element of the envipat output (data.frames)
# Calculates the relative abudnance of the monoisotopic isotope comapred to the sum of all isotopes (Han's isotope correction type II)
get_isotope_abundances <- function(isotope_list) {
  M2 <- isotope_list[2 + 1, 2]
  return(as_tibble(list(M2 = M2)))
}

# Obtain a list with isotope abundances for all lipid transitions (compounds) in the dataset

get_isotope_info <- function(d){
  # get a list of all transitions
  d_compounds <- tibble(Compound = unique(d$Compound)) %>% filter(!str_detect(Compound, "\\(IS")) %>% add_lipidclass_names() %>% add_chains_sum() %>% ungroup()
  # add sum formula for each transition. enviPat::mergeform only accepts one paramater only as single value, therefore the groupby lipidClass
  d_compounds <- d_compounds %>% group_by(lipidClass) %>% mutate(formula = get_formula(lipidClass, chain_length_total, chain_doublebonds_total))
  # Calculate isotope distributions for all transitions/formula
  envipat_result_isotope_list <- get_isotope_distributions(d_compounds$formula)
  # Extract specific isotope abudnances (e.g. M2, M4, overall MO) from envipat output and add to the transition/compound list
  d_isotopes_rel_abundances <- envipat_result_isotope_list %>% map(.f = get_isotope_abundances) %>% bind_rows(.id = "formula")
  d_compounds <- d_compounds %>% bind_cols(d_isotopes_rel_abundances)
  return(d_compounds)
}


# Isotope correction function
# Assumes one "correction block" series of lipid species of same class, same total carbon length and differing saturations
# Interates from highest DB number to lowest. 
isotope_correct <- function(Area, DB_count, M2){
  Area_Corr <-  Area 
  for (DB_i in sort(DB_count,decreasing = TRUE)){
    is_M0 <- (DB_count == DB_i)
    is_M2 <- (DB_count == DB_i-1)
    Area_M0 <- Area_Corr[is_M0]
    #Area_M0 <- ifelse(is.na(Area_M0), 0, Area_M0)
    #Area_Corr[is_M2] <- ifelse(is.na(Area_Corr[is_M2]), 0, Area_Corr[is_M2])
    Area_Corr[is_M2] <- Area_Corr[is_M2] - Area_M0 * M2[is_M0, drop=T]/100
  }
  return(Area_Corr)
}

 # Main function (to be called)

lipid_deisotoper <- function(d_long){
  # Obtain rel. isotope abundances and add to data

  d_isotope_info <- get_isotope_info(d_long) 
  d_long <-  d_long %>% inner_join(d_isotope_info)

  # Correct peak areas for isotope interferences (M2) 
  d_long <- d_long %>% group_by(AnalysisID, lipidClass, chain_length_total) %>% mutate(Area_Corrected = isotope_correct(Area, chain_doublebonds_total, M2))
  
  # Calculate %change from isotope correction (should be <= 0)
  d_long <- d_long %>% mutate(corr_diff_percent = (Area_Corrected-Area)/Area*100)
  return(d_long %>% ungroup())
}
