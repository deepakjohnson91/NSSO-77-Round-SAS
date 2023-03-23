# =================== Crop Income (only paid-out costs) SAS Data - 77th Round of NSSO =================== #
# Documentation on and data/readme files available at https://mospi.gov.in/web/mospi/download-tables-data/-/reports/view/templateFour/25302?q=TBDCAT
# Two levels - 7 and 8 - deal with total value crop production. 
# Level 7 - total value and Level 8 - costs of inputs. 
# The estimation in the NSSO report for reporting the total income (table 23-A) is done at the level of agricultural households. 
# The logic is to merge the two levels with the list of agri HHs and then estimate using the weights for all agri HHs (weights given in Visit 2).
# The reported crop income for V 1 is Rs 4,001 per month and Rs 3,584 per month for V 2. 

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
Level7 <- read_excel("Levels_Codes.xlsx", sheet = "Level7")
Level8 <- read_excel("Levels_Codes.xlsx", sheet = "Level8")
State_list <- read_excel("List_State.xlsx")

#### Visit 1 ####

# Read level 7 (output value)
GVO_7_V1 <-read.fwf(file = "~/Work/NSSO 77 SAS Data Work/Visit 1/r77s331v1L07.txt",
                     widths = Level7$Length,
                     col.names = Level7$Name)

# Create a common ID - as per the documentation
GVO_7_V1 <- GVO_7_V1 %>% 
  mutate(HH_ID = paste(FSU.Serial.No.,Second.stage.stratum.no.,Sample.hhld..No.,sep="0"))

# Take only the total value of all crops, i.e. with one observation per household (Sl. no. 9 in the questionnaire block) 
GVO_7_V1 <- subset(GVO_7_V1, GVO_7_V1$Srl.No. == 9)

# Convert all NA into 0
GVO_7_V1[is.na(GVO_7_V1)] = 0

# Take output and join it with Agri_HH_Join and select only HH_ID, other characteristics, and GVO
Agri_GVO_V1 <- left_join(Agri_HH_Join, GVO_7_V1, by = "HH_ID")

# Make a vector with the selected colnames and select only needed columns
colnames(Agri_GVO_V1)
GVO_Need <- c("HH_ID", "State", "Weights", "Household.size", 
              "Religion.code", "Social.group.code", "Household.classification..code",
              "total.value..Rs..")
Agri_GVO_V1 <- Agri_GVO_V1[,names(Agri_GVO_V1) %in% GVO_Need]

# Read level 8 (costs)

# Read text file using the above vector
Cost_8_V1 <-read.fwf(file = "~/Work/NSSO 77 SAS Data Work/Visit 1/r77s331v1L08.txt",
                  widths = Level8$Length,
                  col.names = Level8$Name)

# Create a common ID - as per the documentation
Cost_8_V1 <- Cost_8_V1 %>% 
  mutate(HH_ID = paste(FSU.Serial.No.,Second.stage.stratum.no.,Sample.hhld..No.,sep="0"))

# Take only the total paid-out costs, i.e. one observation per household (Sl. no. 22 as per the block in the questionnaire)
Cost_8_V1 <- subset(Cost_8_V1, Cost_8_V1$Serial.no. == 22)

# Convert all NAs into 0
Cost_8_V1[is.na(Cost_8_V1)] = 0

# Left join the Costs data with Agri_GVO_V1 for computing incomes
Agri_CropInc_V1 <- left_join(Agri_GVO_V1, Cost_8_V1, by = "HH_ID")

# Make a vector with the selected colnames and select only needed columns
colnames(Agri_CropInc_V1)
CropInc_Need <- c("HH_ID", "State", "Weights", "Household.size", 
              "Religion.code", "Social.group.code", "Household.classification..code",
              "total.value..Rs..", "Inputs.paid.out.expenses")
Agri_CropInc_V1 <- Agri_CropInc_V1[,names(Agri_CropInc_V1) %in% CropInc_Need]

# Convert all NAs into 0
Agri_CropInc_V1[is.na(Agri_CropInc_V1)] = 0

# Add one column for net income (FBI) - paid-out approach
Agri_CropInc_V1 <- Agri_CropInc_V1 %>%
  mutate(FBI = total.value..Rs.. - Inputs.paid.out.expenses)

# Compute weighted mean of the FBI for checking with the report - functions from Hmisc package
wtd.mean(Agri_CropInc_V1$FBI, weights=Agri_CropInc_V1$Weights)/6 # Since the income is for all six months covered under V 1, divide the total by 6

# The FBI is Rs 4012.725 ~ close to Rs 4001 from the report. 
# I am not very sure of the difference. 

#### Visit 2 ####

# Read level 7 (output value)
GVO_7_V2 <-read.fwf(file = "~/Work/NSSO 77 SAS Data Work/Visit 2/r77s331v2L07.txt",
                    widths = Level7$Length,
                    col.names = Level7$Name)

# Create a common ID - as per the documentation
GVO_7_V2 <- GVO_7_V2 %>% 
  mutate(HH_ID = paste(FSU.Serial.No.,Second.stage.stratum.no.,Sample.hhld..No.,sep="0"))

# Take only the total value of all crops, i.e. with one observation per household (Sl. no. 9 in the questionnaire block) 
GVO_7_V2 <- subset(GVO_7_V2, GVO_7_V2$Srl.No. == 9)

# Convert all NA into 0
GVO_7_V2[is.na(GVO_7_V2)] = 0

# Take output and join it with Agri_HH_Join and select only HH_ID, other characteristics, and GVO
Agri_GVO_V2 <- left_join(Agri_HH_Join, GVO_7_V2, by = "HH_ID")

# Make a vector with the selected colnames and select only needed columns
colnames(Agri_GVO_V2)
GVO_Need <- c("HH_ID", "State", "Weights", "Household.size", 
              "Religion.code", "Social.group.code", "Household.classification..code",
              "total.value..Rs..")
Agri_GVO_V2 <- Agri_GVO_V2[,names(Agri_GVO_V2) %in% GVO_Need]

# Read level 8 (costs)

# Read text file using the above vector
Cost_8_V2 <-read.fwf(file = "~/Work/NSSO 77 SAS Data Work/Visit 2/r77s331v2L08.txt",
                     widths = Level8$Length,
                     col.names = Level8$Name)

# Create a common ID - as per the documentation
Cost_8_V2 <- Cost_8_V2 %>% 
  mutate(HH_ID = paste(FSU.Serial.No.,Second.stage.stratum.no.,Sample.hhld..No.,sep="0"))

# Take only the total paid-out costs, i.e. one observation per household (Sl. no. 22 as per the block in the questionnaire)
Cost_8_V2 <- subset(Cost_8_V2, Cost_8_V2$Serial.no. == 22)

# Convert all NAs into 0
Cost_8_V2[is.na(Cost_8_V2)] = 0

# Left join the Costs data with Agri_GVO_V2 for computing incomes
Agri_CropInc_V2 <- left_join(Agri_GVO_V2, Cost_8_V2, by = "HH_ID")

# Make a vector with the selected colnames and select only needed columns
colnames(Agri_CropInc_V2)
CropInc_Need <- c("HH_ID", "State", "Weights", "Household.size", 
                  "Religion.code", "Social.group.code", "Household.classification..code",
                  "total.value..Rs..", "Inputs.paid.out.expenses")
Agri_CropInc_V2 <- Agri_CropInc_V2[,names(Agri_CropInc_V2) %in% CropInc_Need]

# Convert all NAs into 0
Agri_CropInc_V2[is.na(Agri_CropInc_V2)] = 0

# Add one column for net income (FBI) - paid-out approach
Agri_CropInc_V2 <- Agri_CropInc_V2 %>%
  mutate(FBI = total.value..Rs.. - Inputs.paid.out.expenses)

# Compute weighted mean of the FBI for checking with the report - functions from Hmisc package
wtd.mean(Agri_CropInc_V2$FBI, weights=Agri_CropInc_V2$Weights)/6 # Since the income is for all six months covered under V 2, divide the total by 6

# The FBI is Rs 3583.748 ~ same as Rs 3584 from the report. 

#### Combine Visits 1 & 2 ####

# Left join CropInc 1 and 2 files and remove additional columns, rename others
Agri_CropInc <- left_join(Agri_CropInc_V1, Agri_CropInc_V2, by = "HH_ID")
colnames(Agri_CropInc)
Crop_Inc_Final_Col <- c("HH_ID", "State.x", "Weights.x", "Religion.code.x",
                        "Social.group.code.x", "Household.classification..code.x", 
                        "FBI.x", "FBI.y")
Agri_CropInc <- Agri_CropInc[,names(Agri_CropInc) %in% Crop_Inc_Final_Col]
colnames(Agri_CropInc) <- c("HH_ID", "State", "Weights", "Religion",
                        "Social_group", "HH_classification", 
                        "FBI_V1", "FBI_V2")

# Create a column for combined crop income
Agri_CropInc <- Agri_CropInc %>% 
  mutate(FBI = FBI_V1 + FBI_V2)

# Check if the crop incomes are similar with the report
wtd.mean(Agri_CropInc$FBI, weights=Agri_CropInc$Weights)/12 # By 12 because it combines both V 1 and V 2

# The value is Rs 3798.236 ~ report shows the value as Rs 3798, which is the same. 

# Save the dataset
save(Agri_CropInc, file = "Crop_Income.RData")
