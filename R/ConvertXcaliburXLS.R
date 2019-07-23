#########################################################################################################
#  Converter for Thermo Xcalibur XLS data export
#  ================================================================================
#
#  Reads Thermo Xcalibur XLS data files (each compound is a separte sheet) and 
#     convers data as long-format CSV or wide CSV files with either peak areas and/or rentention time 
#
#  SLING (Singapore Lipidomics Incubator), Bo Burla, 2019
#
#########################################################################################################

library(here)
library(dplyr)
library(tidyr)
library(readxl)
library(purrr)
library(readr)

source(here("/R/lipidname_functions.R"))

convert_XcaliburXLS <- function(XcalibXLS_filepath, saveCSV_Area, saveCSV_RT, NA_to_Zero, cmpd_exclude){

  data_filepath <- XcalibXLS_filepath  
  
  # get names of all sheets in the EXCEL file
  data_sheets <- excel_sheets(data_filepath) %>% setdiff(c("Component","mdlCalcs")) 
  
  # Read first sheet to obtain numberof samples, to allow subsequent easier/faster import of data (by ignoring additional annotations rows at the end  of each table)
  df_sheet1 <- read_excel(path = data_filepath,sheet = data_sheets[1] ,trim_ws = TRUE,skip = 4,col_names = FALSE, na = c("NF"),col_types = "text")
  sample_rows_count <- which(is.na(df_sheet1[,1]), arr.ind = TRUE)[1] - 1
  
  # function called by map_dfr bnlow
  read_xlx_sheet <- function(xl_sheet, xl_file, nrows){
    df <- read_excel(path = xl_file,sheet = xl_sheet,trim_ws = TRUE,skip = 4,col_names = TRUE, na = c("NA", "NF","INF","-INF"), n_max = nrows)
    #  read component name  from the sheet and add as column to each sheet (creating long format) 
    df_cmpd_name <- read_excel(path = xl_file,sheet = xl_sheet,trim_ws = TRUE, skip = 2, progress = TRUE, col_names = FALSE, na = c("NF"),range = "A3",col_types = "text")[[1,1]]
    df <-  df %>% mutate(compoundname_original = df_cmpd_name)
    return(df)
  }
  # Interate through the list of sheets and combine them into one data frame (tibble), columns do not need be in same order and can be missing in sheets
  d_all <- map_dfr(.x = data_sheets, .f = read_xlx_sheet, data_filepath, sample_rows_count)   
  d_all <- if ("Area...5" %in% names(d_all)) d_all %>% rename(Area = Area...5, NormArea = Area...7)    # rename column in short format (has 2 columes named "Area")
  d_all <- d_all %>% mutate(Compound = compoundname_original) %>% clean_lipidnames()
  
  d_all <- d_all %>% rename(AnalysisID = Filename)
  
  d_all <- d_all %>% filter(!str_detect(compoundname_original, cmpd_exclude))
  
  if (NA_to_Zero)
    d_all <- d_all %>% mutate(Area = replace_na(Area, 0))
  
  return(d_all  %>% ungroup())
}