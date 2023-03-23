# =================== Non-farm business Income SAS Data - 77th Round of NSSO =================== #
# Documentation on and data/readme files available at https://mospi.gov.in/web/mospi/download-tables-data/-/reports/view/templateFour/25302?q=TBDCAT
# One level - 13 - deals with the non-farm business income. 
# The estimation in the NSSO report for reporting the total income (table 23-A) is done at the level of agricultural households. 
# The logic is to merge the level with the list of agri HHs and then estimate using the weights for all agri HHs (weights given in Visit 2).
# The reported crop income for V 1 is Rs 641 per month and Rs 638 per month for V 2. 

# Load packages
library(foreign) # for reading fixed width files
library(Hmisc) # for weighted mean, etc.
library(tidyr) # tidyverse package for cleaning
library(dplyr) # tidyverse package for data manipulation
library(readxl) # for reading excel files

# Set working directory
setwd("~/Work/NSSO 77 SAS Data Work/Work Files")

# Load agricultural HHs dataset - prepared from level 3 (refer Exercise_Joining_Datasets.R)
load("Agri_HH_Join.RData")

# Read Excel files with col names and bit length for reading the fixed width file + State code
Level13 <- read_excel("Levels_Codes.xlsx", sheet = "Level13")
State_list <- read_excel("List_State.xlsx")

#### Visit 1 ####

# Read level 13 (non-farm business income)
NBI_13_V1 <-read.fwf(file = "~/Work/NSSO 77 SAS Data Work/Visit 1/r77s331v1L13.txt",
                    widths = Level13$Length,
                    col.names = Level13$Name)

# Create a common ID - as per the documentation
NBI_13_V1 <- NBI_13_V1 %>% 
  mutate(HH_ID = paste(FSU.Serial.No.,Second.stage.stratum.no.,Sample.hhld..No.,sep="0"))

# Take only the total value of all business, i.e. with one observation per household (Sl. no. 99 in the questionnaire block) 
NBI_13_V1 <- subset(NBI_13_V1, NBI_13_V1$Serial.no. == 99)

# Take output and join it with Agri_HH_Join and select only HH_ID, other characteristics, and GVO
NBI_13_V1 <- left_join(Agri_HH_Join, NBI_13_V1, by = "HH_ID")

# Convert all NA into 0
NBI_13_V1[is.na(NBI_13_V1)] = 0

# Make a vector with the selected colnames and select only needed columns
colnames(NBI_13_V1)
Col_Need <- c("HH_ID", "State", "Weights", "Household.size", 
              "Religion.code", "Social.group.code", "Household.classification..code",
              "Net.receipts.col.5...col.4.")
NBI_13_V1 <- NBI_13_V1[,names(NBI_13_V1) %in% Col_Need]

# Estimate the non-farm business income per household
wtd.mean(NBI_13_V1$Net.receipts.col.5...col.4., weights = NBI_13_V1$Weights) # Since it collected for 30 days, not dividing it by any value

# Output is Rs 641.9292 ~ close to Rs 641 in the report. 

#### Visit 2 ####

# Read level 13 (non-farm business income)
NBI_13_V2 <-read.fwf(file = "~/Work/NSSO 77 SAS Data Work/Visit 2/r77s331v2L13.txt",
                     widths = Level13$Length,
                     col.names = Level13$Name)

# Create a common ID - as per the documentation
NBI_13_V2 <- NBI_13_V2 %>% 
  mutate(HH_ID = paste(FSU.Serial.No.,Second.stage.stratum.no.,Sample.hhld..No.,sep="0"))

# Take only the total value of all business, i.e. with one observation per household (Sl. no. 99 in the questionnaire block) 
NBI_13_V2 <- subset(NBI_13_V2, NBI_13_V2$Serial.no. == 99)

# Take output and join it with Agri_HH_Join and select only HH_ID, other characteristics, and GVO
NBI_13_V2 <- left_join(Agri_HH_Join, NBI_13_V2, by = "HH_ID")

# Convert all NA into 0
NBI_13_V2[is.na(NBI_13_V2)] = 0

# Make a vector with the selected colnames and select only needed columns
colnames(NBI_13_V2)
Col_Need <- c("HH_ID", "State", "Weights", "Household.size", 
              "Religion.code", "Social.group.code", "Household.classification..code",
              "Net.receipts.col.5...col.4.")
NBI_13_V2 <- NBI_13_V2[,names(NBI_13_V2) %in% Col_Need]

# Estimate the non-farm business income per household
wtd.mean(NBI_13_V2$Net.receipts.col.5...col.4., weights = NBI_13_V2$Weights) # Since it collected for 30 days, not dividing it by any value

# Output is Rs 637.7606 ~ close to Rs 638 in the report. 

#### Combine Visits 1 & 2 ####

# Left join NBI_13_V 1 and 2 files and remove additional columns, rename others
Agri_NBInc <- left_join(NBI_13_V1, NBI_13_V2, by = "HH_ID")
colnames(Agri_NBInc)
NB_Inc_Final_Col <- c("HH_ID", "State.x", "Weights.x","Household.size.x", "Religion.code.x",
                        "Social.group.code.x", "Household.classification..code.x", 
                        "Net.receipts.col.5...col.4..x", "Net.receipts.col.5...col.4..y")
Agri_NBInc <- Agri_NBInc[,names(Agri_NBInc) %in% NB_Inc_Final_Col]
colnames(Agri_NBInc) <- c("HH_ID", "State", "Weights","HH_Size", "Religion",
                            "Social_group", "HH_classification", 
                            "NBI_V1", "NBI_V2")

# Convert all NA into 0
Agri_NBInc[is.na(Agri_NBInc)] = 0

# Create a column for combined crop income; same as how animal income was combined
Agri_NBInc <- Agri_NBInc %>% 
  mutate(NBI = (NBI_V1*8/12) + (NBI_V2*4/12))

# Check if the crop incomes are similar with the report
wtd.mean(Agri_NBInc$NBI, weights=Agri_NBInc$Weights)

# The value is Rs 640.5397 ~ report shows the value as Rs 641. 

# Save the dataset
save(Agri_NBInc, file = "Non-Farm_Business_Income.RData")
