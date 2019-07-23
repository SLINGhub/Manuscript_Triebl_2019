#########################################################################################################
#  Functions to reformat lipid names and extract chain length and doube bond number
#
#  Bo Burla, Singapore Lipidomics Incubator, National University of Singapore, 2019
#
#########################################################################################################

library(here)
library(dplyr)
library(stringr)
library(tidyr)

clean_lipidnames <- function(datLong){
  datLong_clean <- datLong %>% 
    mutate(Compound= str_replace(Compound, "\\/C(?=\\d)","\\/")) %>% 
    mutate(Compound= str_replace(Compound, "[:space:]C"," ")) %>% 
    mutate(Compound= str_replace(Compound, "(?<=[A-z])_(?=[0-9])"," ")) %>%
    mutate(Compound= str_replace(Compound, "(?<=[A-z])_(?=d[0-9])"," "))%>%
    mutate(Compound= str_replace(Compound, "\\(IS\\)"," (IS)")) %>%
    mutate(Compound= str_replace(Compound, "d7"," d7")) %>%
    mutate(Compound= str_replace(Compound, "d9"," d9"))%>%
    mutate(Compound= str_replace(Compound, "PC-O ","PC O-")) %>%
    mutate(Compound= str_replace(Compound, "PC-P ","PC P-")) %>%
    mutate(Compound= str_replace(Compound, "PE-O ","PE O-")) %>%
    mutate(Compound= str_replace(Compound, "PE-P ","PE P-")) %>%
    mutate(Compound= str_replace(Compound, "SM d","SM ")) %>%
    mutate(Compound= str_replace(Compound, "Cer d","Cer ")) %>%
    mutate(Compound= str_replace(Compound, "SM 36-2","SM 36:2"))
  return(datLong_clean)  
}

# Retreive lipid class from lipid name
add_lipidclass_names <- function(datLong){
  datLong_temp <- clean_lipidnames(datLong)
  datLong_temp <- datLong_temp %>%  
    mutate(lipidClassBase = str_trim(str_extract(Compound, "[A-z0-9]+[[:blank:]]*")),
           lipidClass = str_trim(str_extract(Compound, "[A-z0-9]+[[:blank:]]*([A-Z]{1}|[d|t|m][0-9]{2}[:]{1}[0-9]{1})")))
  
  datLong_temp <- datLong_temp %>% 
    mutate(lipidClass = str_replace(lipidClass, "([[:blank:]]+)([^d|t|m]{1})", "-\\2"),
           isPUFA = ifelse(str_detect(Compound, "\\:0|\\:1|\\:2|\\:3"),FALSE,TRUE)) 
  
  datLong_temp <- datLong_temp %>% mutate(lipidClass = ifelse(lipidClassBase=="Cer", "Cer", lipidClass))
  datLong_temp <- datLong_temp %>% mutate(lipidClass = ifelse(lipidClassBase=="HexCer", "HexCer", lipidClass))
  datLong_temp <- datLong_temp %>% mutate_at(.vars = c("lipidClass", "lipidClassBase"), as.factor)
  
  
  return(datLong_temp)
}



add_chains_sum <- function(datLong){
  
  get_chain_composition <- function(Compound){
    chain_description = str_extract(Compound, "(?<=\\s).*?(?=(?:\\s|$))")
    chain_description = str_replace(chain_description, "O\\-|P\\-|d|t|m","")
    chains <- str_split(chain_description,"/|_")
    chain_details = str_split(unlist(chains),":", simplify = TRUE)
    class(chain_details) <- "numeric"
    comp_sum <- colSums(chain_details)
    return(tibble(chain_length_total = comp_sum[1],
                  chain_doublebonds_total = comp_sum[2]))
    
  }
  
  datLong_temp <- datLong %>%  mutate(chain_info = map(Compound, get_chain_composition))  %>% unnest(chain_info)
  return(datLong_temp)
}

