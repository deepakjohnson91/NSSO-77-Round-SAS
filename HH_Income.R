# =================== Household Income of Agri HHs SAS Data - 77th Round of NSSO =================== #
# Documentation on and data/readme files available at https://mospi.gov.in/web/mospi/download-tables-data/-/reports/view/templateFour/25302?q=TBDCAT
# Combine all incomes - crop, animal, rent+, and non-farm business. 
# The estimation in the NSSO report for reporting the total income (table 23-A) is done at the level of agricultural households. 
# The plan is to load all the pre-arranged datasets and then combine them. 
# The reported HH income for all agri HHs is Rs 10,218 per month  (V 1 + V 2).

# Load packages
library(Hmisc) # for weighted mean, etc.
library(tidyr) # tidyverse package for cleaning
library(dplyr) # tidyverse package for data manipulation

# Set working directory
setwd("~/Work/NSSO 77 SAS Data Work/Work Files")

# Load income datasets - prepared in the earlier files.
load("Crop_Income.RData")
load("Animal_Income.RData")
load("Wage_Rent_Pension_Income.RData")
load("Non-Farm_Business_Income.RData")

#### Combine datasets one by one ####

Agri_HH_Income <- left_join(Agri_CropInc, Agri_AnInc, by = "HH_ID")
Agri_HH_Income <- left_join(Agri_HH_Income, Agri_OInc, by = "HH_ID")
Agri_HH_Income <- left_join(Agri_HH_Income, Agri_NBInc, by = "HH_ID")

# Find the column names and remove extra ones
colnames(Agri_HH_Income)
Final_Col <- c("HH_ID", "State.x", "Weights.x", "Religion.x",
               "Social_group.x", "HH_classification.x", 
               "FBI", "HH_Size.x", "An_Inc", "Wages", "Pensions", "Lease_Rent", 
               "NBI")
Agri_HH_Income <- Agri_HH_Income[,names(Agri_HH_Income) %in% Final_Col]
colnames(Agri_HH_Income) <- c("HH_ID", "State", "Weights", "Religion",
                          "Social_group", "HH_classification", 
                          "FBI", "HH_Size", "Animal Income", "Wages", "Pensions/Remittances", 
                          "Rent from leased-out land", "Non-farm Income")

# Convert all NA into 0
Agri_HH_Income[is.na(Agri_HH_Income)] = 0

# Standardise all column for monthly data (except for animal incomes and non-farm business income, which were already done in the files)
Agri_HH_Income$FBI <- Agri_HH_Income$FBI/12
Agri_HH_Income$Wages <- Agri_HH_Income$Wages/12
Agri_HH_Income$`Pensions/Remittances` <- Agri_HH_Income$`Pensions/Remittances`/12
Agri_HH_Income$`Rent from leased-out land` <- Agri_HH_Income$`Rent from leased-out land`/12

# Compute a new column for HH total income
Agri_HH_Income <- Agri_HH_Income %>% 
  mutate(HH_Inc = FBI + `Animal Income` + 
           Wages + `Rent from leased-out land` + 
           `Non-farm Income`)

# Check if the HH_income is similar with the report
wtd.mean(Agri_HH_Income$FBI, weights=Agri_HH_Income$Weights)
wtd.mean(Agri_HH_Income$`Animal Income`, weights=Agri_HH_Income$Weights)
wtd.mean(Agri_HH_Income$Wages, weights=Agri_HH_Income$Weights)
wtd.mean(Agri_HH_Income$`Rent from leased-out land`, weights=Agri_HH_Income$Weights)
wtd.mean(Agri_HH_Income$`Non-farm Income`, weights=Agri_HH_Income$Weights)
wtd.mean(Agri_HH_Income$HH_Inc, weights = Agri_HH_Income$Weights)

# The output is Rs 10218.18 ~ report gives the figure of Rs 10,218

# Save the dataset
save(Agri_HH_Income, file = "Agri_Household_Income.RData")
