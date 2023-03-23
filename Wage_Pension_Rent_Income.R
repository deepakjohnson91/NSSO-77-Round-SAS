# =================== Wage, Rent, and Other Income SAS Data - 77th Round of NSSO =================== #
# Documentation on and data/readme files available at https://mospi.gov.in/web/mospi/download-tables-data/-/reports/view/templateFour/25302?q=TBDCAT
# One level - 3 - personal records deal with wages, pensions, and rental income. 
# The estimation in the NSSO report for reporting the total income (table 23-A) is done at the level of agricultural households. 
# The logic is to merge the level 3 with the list of agri HHs and then estimate using the weights for all agri HHs (weights given in Visit 2).
# The reported incomes are as follows:
# V 1 (per month): Wages = 3932; Lease-out = 113; Pension/remittance = 578
# V 2 (per month): Wages = 4190; Lease-out = 157; Pension/remittance = 641
# V 1 + 2 (per month): Wages = 4063; Lease-out = 134; Pension/remittance = 611

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
Level2 <- read_excel("Levels_Codes.xlsx", sheet = "Level2")
State_list <- read_excel("List_State.xlsx")

#### Visit 1 ####

# Read level 2 (output value)
Persons_2_V1 <-read.fwf(file = "~/Work/NSSO 77 SAS Data Work/Visit 1/r77s331v1L02.txt",
                    widths = Level2$Length,
                    col.names = Level2$Name)

# Create a common ID - as per the documentation
Persons_2_V1 <- Persons_2_V1 %>% 
  mutate(HH_ID = paste(FSU.Serial.No.,Second.stage.stratum.no.,Sample.hhld..No.,sep="0"))

# Take the total value of wages, rent, and other incomes per household (sum at HH level) 
HH_OthInc_V1 <- Persons_2_V1 %>% 
  group_by(HH_ID) %>% 
  summarise(Wages = sum(Wages...salary..earnings..Rs.., na.rm = TRUE), 
            Pensions = sum(Earning.from.pension.remittances..Rs.., na.rm = TRUE),
            Lease_Rent = sum(Income.from.rent.of.leased.out.land..Rs.., na.rm = TRUE))

# Join this dataset with the Agri_HH_Join
Agri_OInc_V1 <- left_join(Agri_HH_Join, HH_OthInc_V1, by = "HH_ID")

# Make a vector with the selected colnames and select only needed columns
colnames(Agri_OInc_V1)
Col_Need <- c("HH_ID", "State", "Weights", "Household.size", 
              "Religion.code", "Social.group.code", "Household.classification..code",
              "Wages", "Pensions", "Lease_Rent")
Agri_OInc_V1 <- Agri_OInc_V1[,names(Agri_OInc_V1) %in% Col_Need]

# Compute weighted mean of the Wages, Pensions, and Lease_Rent for checking with the report 
wtd.mean(Agri_OInc_V1$Wages, weights=Agri_OInc_V1$Weights)/6 # Since the income is for all six months covered under V 1, divide the total by 6
wtd.mean(Agri_OInc_V1$Pensions, weights=Agri_OInc_V1$Weights)/6 # Since the income is for all six months covered under V 1, divide the total by 6
wtd.mean(Agri_OInc_V1$Lease_Rent, weights=Agri_OInc_V1$Weights)/6 # Since the income is for all six months covered under V 1, divide the total by 6

# Output reported and figures from the report are as follows
# Output | Wages = 3935.742; Lease_Rent = 111.6962; Pensions = 581.8065
# Report | Wages = 3932; Lease_Rent = 113; Pensions = 578

#### Visit 2 ####

# Read level 2 (output value)
Persons_2_V2 <-read.fwf(file = "~/Work/NSSO 77 SAS Data Work/Visit 2/r77s331v2L02.txt",
                        widths = Level2$Length,
                        col.names = Level2$Name)

# Create a common ID - as per the documentation
Persons_2_V2 <- Persons_2_V2 %>% 
  mutate(HH_ID = paste(FSU.Serial.No.,Second.stage.stratum.no.,Sample.hhld..No.,sep="0"))

# Take the total value of wages, rent, and other incomes per household (sum at HH level) 
HH_OthInc_V2 <- Persons_2_V2 %>% 
  group_by(HH_ID) %>% 
  summarise(Wages = sum(Wages...salary..earnings..Rs.., na.rm = TRUE), 
            Pensions = sum(Earning.from.pension.remittances..Rs.., na.rm = TRUE),
            Lease_Rent = sum(Income.from.rent.of.leased.out.land..Rs.., na.rm = TRUE))

# Join this dataset with the Agri_HH_Join
Agri_OInc_V2 <- left_join(Agri_HH_Join, HH_OthInc_V2, by = "HH_ID")

# Make a vector with the selected colnames and select only needed columns
colnames(Agri_OInc_V2)
Col_Need <- c("HH_ID", "State", "Weights", "Household.size", 
              "Religion.code", "Social.group.code", "Household.classification..code",
              "Wages", "Pensions", "Lease_Rent")
Agri_OInc_V2 <- Agri_OInc_V2[,names(Agri_OInc_V2) %in% Col_Need]

# Compute weighted mean of the Wages, Pensions, and Lease_Rent for checking with the report 
wtd.mean(Agri_OInc_V2$Wages, weights=Agri_OInc_V2$Weights)/6 # Since the income is for all six months covered under V 1, divide the total by 6
wtd.mean(Agri_OInc_V2$Pensions, weights=Agri_OInc_V2$Weights)/6 # Since the income is for all six months covered under V 1, divide the total by 6
wtd.mean(Agri_OInc_V2$Lease_Rent, weights=Agri_OInc_V2$Weights)/6 # Since the income is for all six months covered under V 1, divide the total by 6

# Output reported and figures from the report are as follows
# Output | Wages = 4189.501; Lease_Rent = 156.9131; Pensions = 640.5086
# Report | Wages = 4190; Lease_Rent = 157; Pensions = 641

#### Combine Visits 1 & 2 ####

# Left join Agri_OInc_V1 and 2 files and remove additional columns, rename others
Agri_OInc <- left_join(Agri_OInc_V1, Agri_OInc_V2, by = "HH_ID")
colnames(Agri_OInc)
O_Inc_Final_Col <- c("HH_ID", "State.x", "Weights.x",  "Household.size.x", "Religion.code.x",
                        "Social.group.code.x", "Household.classification..code.x", 
                        "Wages.x", "Pensions.x", "Lease_Rent.x", 
                        "Wages.y", "Pensions.y", "Lease_Rent.y")
Agri_OInc <- Agri_OInc[,names(Agri_OInc) %in% O_Inc_Final_Col]
colnames(Agri_OInc) <- c("HH_ID", "State", "Weights", "HH_Size", "Religion",
                         "Social_group", "HH_classification", 
                         "Wages_V1", "Pensions_V1", "Lease_Rent_V1",
                         "Wages_V2", "Pensions_V2", "Lease_Rent_V2")

# Create columns for combined others incomes
Agri_OInc <- Agri_OInc %>% 
  mutate(Wages = Wages_V1 + Wages_V2,
         Pensions = Pensions_V1 + Pensions_V2, 
         Lease_Rent = Lease_Rent_V1 + Lease_Rent_V2)

# Check if the incomes are similar with the report
wtd.mean(Agri_OInc$Wages, weights=Agri_OInc$Weights)/12 # By 12 because it combines both V 1 and V 2
wtd.mean(Agri_OInc$Pensions, weights=Agri_OInc$Weights)/12 # By 12 because it combines both V 1 and V 2
wtd.mean(Agri_OInc$Lease_Rent, weights=Agri_OInc$Weights)/12 # By 12 because it combines both V 1 and V 2

# Output reported and figures from the report are as follows
# Output | Wages = 4062.621; Lease_Rent = 134.3046; Pensions = 611.1576
# Report | Wages = 4063; Lease_Rent = 134; Pensions = 611

# Save the dataset
save(Agri_OInc, file = "Wage_Rent_Pension_Income.RData")
