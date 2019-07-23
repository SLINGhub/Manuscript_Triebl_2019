# R scripts used in Manuscript Triebl et al, 2019:
THE QUANTITATIVE BIAS OF LIPIDOMIC METHODS AND HARMONIZATION OF PLASMA LIPID QUANTITATION

Authors: *Alexander Triebl, Bo Burla, Jayashree Selvalatchmanan, Jeongah Oh, Sock Hwee Tan, Mark Chan, Natalie A. Mellet, Peter J. Meikle, Federico Torta, Markus R. Wenk* 
Affiliations: *Singapore Lipidomics Incubator, Life Sciences Institute; Department of Biochemistry Yong Loo Lin School of Medicine; National University of Singapore*

## Summary
This repository contains the R scripts that were used to read the Thermo Xcalibur Export file (XLS, i.e. containing peak areas) from the HILIC LC/MS analysis and to perform correction for M+2 isotopic interference. 

## Getting the Code
All R code and datasets are provided as an [RStudio](https://www.rstudio.com/products/RStudio) project. The easiest way to download and run this code is to clone this repository within RStudio (https://github.com/SLINGhub/Manuscript_Triebl_2019.git). Alternatively, you can also download the Github Repository and open the Rstudio project. 

## Setting up the Code
By default, the dependencies for this project are managed using [renv](https://rstudio.github.io/renv/) to improve reproducibility and facilitate installation of required packages. After cloning, the required packages can be automatically installed by typing following command in the console: 
```r
renv::restore()
```
Should you prefer to use your local R library instead, you can turn packrat off via following command: 
```r
renv::deactivate() 
```

## Directory Structure

* `Root` Contains script Triebl_2019_HILIC_Data_Convert_IsotopeCorrection.R that performs the analysis using functions defined in scripts located in subfolder R/
* `R/` Contains R scripts with functions for import of Xcalibur XLS result export files, isotopic correction and helper functions
* `data/` Contains the original Xcalibur XLS export (`HILIC_QE_analysis_Xcalib-ShortFormatExport.XLS`) 
* `output/`  Contain the output of script Triebl_2019_HILIC_Data_Convert_IsotopeCorrection.R
* `renv/`  Contains copies of the packages used by this project and other renv related files 

## Running the Analysis
* Open and run the R script `Triebl_2019_HILIC_Data_Convert_IsotopeCorrection.R` 
* The script outputs a csv file containing M+2 isotope corrected peak areas in the subfolder `output/`  


## Contact
* Code and Data Analysis:  *Bo Burla* (lsibjb@nus.edu.sg) or submit a Github Issue/Pull request 
* Manuscript:  *Alexander Triebl* (alexander.triebl@nus.edu.sg) and *Federico Torta* (bchfdtt@nus.edu.sg)
            

License
----
The code in this analysis is covered by the `MIT` license 


## sessionInfo used for processed of the dataset  
```r
R version 3.6.0 (2019-04-26)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 10 x64 (build 17763)

Matrix products: default

locale:
[1] LC_COLLATE=English_United States.1252  LC_CTYPE=English_United States.1252    LC_MONETARY=English_United States.1252 LC_NUMERIC=C                          
[5] LC_TIME=English_United States.1252    

attached base packages:
[1] stats     graphics  grDevices datasets  utils     methods   base     

other attached packages:
[1] enviPat_2.4   stringr_1.4.0 readr_1.3.1   purrr_0.3.2   readxl_1.3.1  tidyr_0.8.3   dplyr_0.8.1   here_0.1     

loaded via a namespace (and not attached):
 [1] Rcpp_1.0.1       magrittr_1.5     hms_0.4.2        tidyselect_0.2.5 R6_2.4.0         rlang_0.3.4      rematch_1.0.1    tools_3.6.0      cli_1.1.0        assertthat_0.2.1 rprojroot_1.3-2 
[12] tibble_2.1.1     crayon_1.3.4     glue_1.3.1       stringi_1.4.3    compiler_3.6.0   pillar_1.3.1     cellranger_1.1.0 backports_1.1.4  renv_0.5.0-120   pkgconfig_2.0.2 
```