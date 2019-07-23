#########################################################################################################
#
#  Processing of HILIC-LC/MS dataset. Used in Manuscript Triebl et al. 2019
#
#  Import/conversion of Xcalibur export data file (XLS format)
#  M+2 isotopic interference correction used in Manuscript Triebl et al, 2019  
#  
#  Bo Burla and Alex Triebl, Singapore Lipidomics Incubator, National University of Singapore, 2019
#
#########################################################################################################


library(here)
source(here("R/ConvertXcaliburXLS.R"))
source(here("R/isotope_interference_correction.R"))

data_filepath <- here("data/HILIC_QE_analysis_Xcalib-ShortFormatExport.XLS")  

d_QE <- convert_XcaliburXLS(XcalibXLS_filepath = data_filepath, NA_to_Zero = TRUE, cmpd_exclude = "SM_d36-2")
d_QE_withIsoCor <- lipid_deisotoper(d_QE)

d_QE_isocor_Area_wide <- d_QE_withIsoCor %>% select(AnalysisID, Compound, Area_Corrected) %>% spread(key = Compound, value = Area_Corrected)
write_csv(d_QE_isocor_Area_wide,path = here("output//HILIC_QE_analysis_M2Corrected_Area-8.csv"))
