# =================== Animal Income (only paid-out costs) SAS Data - 77th Round of NSSO =================== #
# Documentation on and data/readme files available at https://mospi.gov.in/web/mospi/download-tables-data/-/reports/view/templateFour/25302?q=TBDCAT
# The report gives the animal income for V1 as Rs 1,598 per month and V2 as Rs 1,552 per month.
# The blocks associated with animal resources - expenditure and income - are 9 and 10 (from the schedule).
# NSSO collects data for the last 30 days. 
# Block 9 serial no. is 16 and block 10 serial no. is 18 to be checked - total value and costs. 
# The layout file shows that Level 11 and 12 correspond to the information needed from these blocks. 

# ============================================= #

# Load packages
library(foreign) # for reading fixed width files
library(Hmisc) # for weighted mean, etc.
library(tidyr) # tidyverse package for cleaning
library(dplyr) # tidyverse package for data manipulation
library(readxl) # for reading excel files

## Visit 1 ##

# Load agri household data
load("Agri_HH_Join.RData")

# Read Excel files with col names and bit length for reading the fixed width file + State code
Level11 <- read_excel("Levels_Codes.xlsx", sheet = "Level11")
Level12 <- read_excel("Levels_Codes.xlsx", sheet = "Level12")
State_list <- read_excel("List_State.xlsx")

# Read level 11 data from Visit 1
An_Val_V1 <-read.fwf(file = "~/Work/NSSO 77 SAS Data Work/Visit 1/r77s331v1L11.txt",
                     widths = Level11$Length,
                     col.names = Level11$Name)

# Create a common ID - as per the documentation
An_Val_V1 <- An_Val_V1 %>% 
  mutate(HH_ID = paste(FSU.Serial.No.,Second.stage.stratum.no.,Sample.hhld..No.,sep="0"))

# Take only the total value of all crops, i.e. with one observation per household (Sl. no. 16 in the questionnaire block) 
An_Val_V1 <- subset(An_Val_V1, An_Val_V1$Serial.no. == 16)

# Join this collapsed dataset with the Agri_HH dataset for the common HHs
An_Val_V1 <- left_join(Agri_HH_Join, An_Val_V1, by = "HH_ID")

# Convert all NA into 0
An_Val_V1[is.na(An_Val_V1)] = 0

# Find out the useful columns and keep them
colnames(An_Val_V1)
Col_Val_Need <- c("HH_ID", "State", "Weights", "Household.size", 
              "Religion.code", "Social.group.code", "Household.classification..code",
              "total.produce..value.Rs.")
An_Val_V1 <- An_Val_V1[,names(An_Val_V1) %in% Col_Val_Need]

# Read level 12 data from Visit 1
An_Cos_V1 <-read.fwf(file = "~/Work/NSSO 77 SAS Data Work/Visit 1/r77s331v1L12.txt",
                     widths = Level12$Length,
                     col.names = Level12$Name)

# Create a common ID - as per the documentation
An_Cos_V1 <- An_Cos_V1 %>% 
  mutate(HH_ID = paste(FSU.Serial.No.,Second.stage.stratum.no.,Sample.hhld..No.,sep="0"))

# Take only the total costs of all crops, i.e. with one observation per household (Sl. no. 18 in the questionnaire block) 
An_Cos_V1 <- subset(An_Cos_V1, An_Cos_V1$Serial.no. == 18)

# Join this collapsed dataset with the Agri_HH dataset for the common HHs
An_Cos_V1 <- left_join(Agri_HH_Join, An_Cos_V1, by = "HH_ID")

# Convert all NA into 0
An_Cos_V1[is.na(An_Cos_V1)] = 0

# Find out the useful columns and keep them
colnames(An_Cos_V1)
Col_Cost_Need <- c("HH_ID", "State", "Weights", "Household.size", 
              "Religion.code", "Social.group.code", "Household.classification..code",
              "paid.out.expenses")
An_Cos_V1 <- An_Cos_V1[,names(An_Cos_V1) %in% Col_Cost_Need]

# Bring together both costs and values of V 1
An_Inc_V1 <- left_join(An_Cos_V1, An_Val_V1, by = "HH_ID")

# Convert all NA into 0
An_Inc_V1[is.na(An_Inc_V1)] = 0

# Find out income from animal sources
An_Inc_V1 <- An_Inc_V1 %>% 
  mutate(An_Inc = total.produce..value.Rs. - paid.out.expenses, na.rm = TRUE)

## Visit 2 ##

# Read level 11 data from Visit 2
An_Val_V2 <-read.fwf(file = "~/Work/NSSO 77 SAS Data Work/Visit 2/r77s331v2L11.txt",
                     widths = Level11$Length,
                     col.names = Level11$Name)

# Create a common ID - as per the documentation
An_Val_V2 <- An_Val_V2 %>% 
  mutate(HH_ID = paste(FSU.Serial.No.,Second.stage.stratum.no.,Sample.hhld..No.,sep="0"))

# Take only the total value of all crops, i.e. with one observation per household (Sl. no. 16 in the questionnaire block) 
An_Val_V2 <- subset(An_Val_V2, An_Val_V2$Serial.no. == 16)

# Join this collapsed dataset with the Agri_HH dataset for the common HHs
An_Val_V2 <- left_join(Agri_HH_Join, An_Val_V2, by = "HH_ID")

# Convert all NA into 0
An_Val_V2[is.na(An_Val_V2)] = 0

# Find out the useful columns and keep them
colnames(An_Val_V2)
Col_Val_Need <- c("HH_ID", "State", "Weights", "Household.size", 
                  "Religion.code", "Social.group.code", "Household.classification..code",
                  "total.produce..value.Rs.")
An_Val_V1 <- An_Val_V2[,names(An_Val_V2) %in% Col_Val_Need]

# Read level 12 data from Visit 2
An_Cos_V2 <-read.fwf(file = "~/Work/NSSO 77 SAS Data Work/Visit 2/r77s331v2L12.txt",
                     widths = Level12$Length,
                     col.names = Level12$Name)

# Create a common ID - as per the documentation
An_Cos_V2 <- An_Cos_V2 %>% 
  mutate(HH_ID = paste(FSU.Serial.No.,Second.stage.stratum.no.,Sample.hhld..No.,sep="0"))

# Take only the total costs of all crops, i.e. with one observation per household (Sl. no. 18 in the questionnaire block) 
An_Cos_V2 <- subset(An_Cos_V2, An_Cos_V2$Serial.no. == 18)

# Join this collapsed dataset with the Agri_HH dataset for the common HHs
An_Cos_V2 <- left_join(Agri_HH_Join, An_Cos_V2, by = "HH_ID")

# Convert all NA into 0
An_Cos_V2[is.na(An_Cos_V2)] = 0

# Find out the useful columns and keep them
colnames(An_Cos_V2)
Col_Cost_Need <- c("HH_ID", "State", "Weights", "Household.size", 
                   "Religion.code", "Social.group.code", "Household.classification..code",
                   "paid.out.expenses")
An_Cos_V2 <- An_Cos_V2[,names(An_Cos_V2) %in% Col_Cost_Need]

# Bring together both costs and values of V 2
An_Inc_V2 <- left_join(An_Cos_V2, An_Val_V2, by = "HH_ID")

# Convert all NA into 0
An_Inc_V2[is.na(An_Inc_V2)] = 0

# Find out income from animal sources
An_Inc_V2 <- An_Inc_V2 %>% 
  mutate(An_Inc = total.produce..value.Rs. - paid.out.expenses, na.rm = TRUE)

## Join Visit 1 and Visit 2 Animal Incomes ##
An_In_V1_V2 <- left_join(An_Inc_V1, An_Inc_V2, by ="HH_ID")

# Save Animal Income after removing additional variables
names(An_In_V1_V2)
Need_Col <- c("HH_ID", "State.x.x", "Weights.x.x", "Household.size.x.x",                                                        
              "Religion.code.x.x", "Social.group.code.x.x", 
              "Household.classification..code.x.x", "An_Inc.x", "An_Inc.y")
An_In_V1_V2 <- An_In_V1_V2[,names(An_In_V1_V2) %in% Need_Col]
colnames(An_In_V1_V2) <- c("HH_ID", "State", "Weights", "HH_Size",                                                        
                           "Religion", "Social_group", 
                           "HH_classification", "An_Inc_V1", "An_Inc_V2")

# Check for animal incomes - whether it is correct
wtd.mean(An_In_V1_V2$An_Inc_V1, weights=An_In_V1_V2$Weights) # The output is Rs 1599.371 ~ very similar to the report's value (Rs 1,598 per month)
wtd.mean(An_In_V1_V2$An_Inc_V2, weights=An_In_V1_V2$Weights) # The output is Rs 1548.685 ~ very similar to the report's value (Rs 1,552 per month)

# The actual calculation for combining animal income is to take 8/12 of visit 1 and 4/12 of visit 2 (thanks to the researchers from FAS).

# Create a new column summing up incomes from V1 and V2
An_In_V1_V2 <- An_In_V1_V2 %>% 
  mutate(An_Inc = (An_Inc_V1*8/12) + (An_Inc_V2*4/12))

wtd.mean(An_In_V1_V2$An_Inc, weights = An_In_V1_V2$Weights)
# The output is Rs 1582.476 ~ very similar to the report's value (Rs 1582 per month)

# Change the filename (by creating a new file) for consistency
Agri_AnInc <- An_In_V1_V2

# Save the RData File
save(Agri_AnInc, file = "Animal_Income.RData")
