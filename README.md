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

