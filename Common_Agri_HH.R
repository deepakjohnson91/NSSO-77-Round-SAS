# =================== Finding and Making a List of Agricultural Households - SAS Data - 77th Round of NSSO =================== #

# The crop production and all other data are given for common households from 1 & 2 visits. 
# In this workbook, we select the common households from both the visits, and combine some basic features. 
# The report gives the number of common no. of agri. households in the sample as 44,740.
# For Visit 1 it was 45,714 and for Visit 2 it was	44,770. 
# The weights of Visit 2 have to be used while combining data from both visits. 
# Issues: While the report says the number of HHs is 44,770, the actual number is 44,775. 
# Issues: The discrepancy in number of HHs comes from the number total number of HHs. 
# Issues: The report gives the total HHs as 58,035 (Visit 1) but the unit-level data gives 58,040 HH records. 
# Issues: The additional five HHs has been accounted for in all calculations - one probable reason for why the figures do not match exactly with the report. 
# Aside: Excel tables can be downloaded from page 175 of the report by clicking on the hyperlinks. 

# Load packages
library(foreign) # for reading fixed width files
library(Hmisc) # for weighted mean, etc.
library(tidyr) # tidyverse package for cleaning
library(dplyr) # tidyverse package for data manipulation
library(readxl) # for reading excel files

# For the first part, we take the Level 3 of Visit 1. This will give us the number of agri HHs from Visit 1.

# Set working directory
setwd("~/Work/NSSO 77 SAS Data Work/Work Files")

# Read Excel files with col names and bit length for reading the fixed width file + State code
Level3 <- read_excel("Levels_Codes.xlsx", sheet = "Level3")
State_list <- read_excel("List_State.xlsx")

# Read text file using the above vectors
Level_3_V1 <-read.fwf(file = "~/Work/NSSO 77 SAS Data Work/Visit 1/r77s331v1L03.txt",
                     widths = Level3$Length,
                     col.names = Level3$Name)

# Make a new column for weights (formula from Documentation)
Level_3_V1 <- Level_3_V1 %>%
  mutate(Weights = Multiplier/100)

# Round off weights
Level_3_V1$Weights <- round(Level_3_V1$Weights, digits = 1)

# For getting States from NSS regions
Level_3_V1 <- Level_3_V1 %>%
  mutate(State = trunc(NSS.Region/10))

# Applying State codes and label for each State
Level_3_V1$State <- factor (Level_3_V1$State, 
                           levels = State_list$CODE,
                           labels= State_list$STATE)

# Groupby and show the number of agri and non-agri households
Level_3_V1 %>% 
  group_by(Social.group.code, value.of.agricultural.production.from.self.employment.activities.during.the.last.365.days.code.) %>% 
  summarise(Sample = n(), Estimated_number = sum(Weights)/100)
# This is a basic check of data. The output obtained is checked with Table 3 (Excel Sheets) of the Report.
# Output: Sample number of non-agri ST = 2215; estimated number: 79205. 
# Report: Sample number of non-agri ST = 2215; estimated number: 79205. 

# Get the common ID for all HHs
Level_3_V1 <- Level_3_V1 %>% 
  mutate(HH_ID = paste(FSU.Serial.No.,Second.stage.stratum.no.,Sample.hhld..No.,sep="0"))

# Subset Agricultural HHs including only HH_ID that reported production
Agri_HH_V1 <- subset(Level_3_V1, Level_3_V1$value.of.agricultural.production.from.self.employment.activities.during.the.last.365.days.code. == 2)

# Get the common ID for all HHs
Agri_HH_V1 <- Agri_HH_V1 %>% 
  mutate(HH_ID = paste(FSU.Serial.No.,Second.stage.stratum.no.,Sample.hhld..No.,sep="0"))

# For the second part, we take the Level 1 (all HHs) of Visit 2. 
# This, along with the agri HHs from Visit 1, will give us the number of agri HHs from Visit 2.

# Read Excel files with col names and bit length for reading the fixed width file
Level1 <- read_excel("Levels_Codes.xlsx", sheet = "Level1")

# Read text file using the above vectors
Level_1_V2 <-read.fwf(file = "~/Work/NSSO 77 SAS Data Work/Visit 2/r77s331v2L01.txt",
                     widths = Level1$Length,
                     col.names = Level1$Name)

# Make a new column for weights (formula from Documentation)
Level_1_V2 <- Level_1_V2 %>%
  mutate(Weights = Multiplier/100)

# Round off weights
Level_1_V2$Weights <- round(Level_1_V2$Weights, digits = 1)

# For getting States from NSS regions
Level_1_V2 <- Level_1_V2 %>%
  mutate(State = trunc(NSS.Region/10))

# Applying State codes and label for each State
Level_1_V2$State <- factor (Level_1_V2$State, 
                           levels = State_list$CODE,
                           labels= State_list$STATE)

# Get the common ID for all HHs
Level_1_V2 <- Level_1_V2 %>% 
  mutate(HH_ID = paste(FSU.Serial.No.,Second.stage.stratum.no.,Sample.hhld..No.,sep="0"))

# Making datasets with the common observations
Agri_HH_V2 <- subset(Level_1_V2, Level_1_V2$HH_ID %in% Agri_HH_V1$HH_ID)

# Estimate the number of HHs in the visit 2
Agri_HH_V2 %>% 
  summarise(Estimated_HHs = sum(Weights)/100)

# The HH_IDs in Agri_HH_V2 are the ones common between the two visits. 
# Assign Agri_HH_V2 to Agri_HH
Agri_HH <- Agri_HH_V2

# Save Agri_HH as RData object for future use
save(Agri_HH, file = "Agri_HH.RData")

# Take Level 3 from Visit 1 once again to add the other characteristics of the HHs
# Before that import codes for religion and social group
Religion_list <- read_excel("List_Religion.xlsx")
Social_Group_list <- read_excel("List_Social_Group.xlsx")
HH_Classification <- read_excel("List_HH_Classification.xlsx")

# Applying religion, social group, and HH classification codes and labels
Level_3_V1$Religion.code <- factor (Level_3_V1$Religion.code, 
                           levels = Religion_list$CODE,
                           labels= Religion_list$RELIGION)

Level_3_V1$Social.group.code <- factor (Level_3_V1$Social.group.code, 
                                   levels = Social_Group_list$CODE,
                                   labels= Social_Group_list$SOCIAL_GROUP)

Level_3_V1$Household.classification..code <- factor (Level_3_V1$Household.classification..code, 
                                       levels = HH_Classification$CODE,
                                       labels= HH_Classification$MAJOR_SOURCE)

# Join these with Agri_HH dataset
Agri_HH_Join <- left_join(Agri_HH, Level_3_V1, by = "HH_ID")

# Make a new dataset only with selected columns
colnames(Agri_HH_Join)
Col_Join <- c("HH_ID", "State.x", "Weights.x", "Household.size", 
              "Religion.code", "Social.group.code", "Household.classification..code",
              "usual.consumer.expenditure.in.a.month.for.household.purposes.out.of.purchase..A.", 
              "dwelling.unit.code", "type.of.structure", "whether.any.of.the.household.member.has.bank.account",
              "whether.any.of.the.household.member.possesses.MGNREG.job.card",
              "Whether.undertook.any.work.under.MGNREG.during.the.last.365.days",
              "Whether.any.of.the.household.member.is.a.member.of.registered.farmers..organisation",
              "Whether.the.household.possesses.any.Kisan.Credit.Card",
              "Whether.the.household.possess.Soil.Health.Card",
              "whether.fertilizer..etc..applied.to.field.as.per.recommendations.of.Soil.Health.Card",
              "whether.the.household.possess.Animal.Health.Card..Nakul.Swasthya.Patra",
              "whether.the.household.insured.any.crop.under.PM.Fasal.Bima.Yojana.during.last.365.days" )

# Subset the Agri_HH_Join to exclude this list of columns
Agri_HH_Join <- Agri_HH_Join %>% 
  select(Col_Join)

# Rename column names
colnames(Agri_HH_Join)[2] <- "State"
colnames(Agri_HH_Join)[3] <- "Weights"

# Save Agri_HH_Join Dataset both as RData and csv
save(Agri_HH_Join, file = "Agri_HH_Join.RData")
write.csv(Agri_HH_Join, file = "Agri_HH_Join.csv")