# Working on NSS 77th Round SAS Data using R

This is some tips on how to use R (or RStudio) in analysing the latest unit-level from the Situation Assessment Survey of the NSS. 
India's National Sample Survey conducted its 77th Round of surveys in 2018-19. Among different topics surveyed was the assessment of farming conditions in India. 
A brief review of the surveys and some results from the past can be found in the two links given below. 
1. [Situation Assessment Survey of Agricultural Households 2019: A Statistical Note by Aparajita Bakshi](http://ras.org.in/situation_assessment_survey_of_agricultural_households_2019_a_statistical_note)
2. [The Situation Assessment Surveys: An Evaluation by Biplab Sarkar](http://ras.org.in/index.php?Article=the_situation_assessment_surveys&q=biplab&keys=biplab)

The full list of unit-level datasets and documentation associated with NSS 77th Round Situation Assessment Survey this can be found [here](https://mospi.gov.in/web/mospi/download-tables-data/-/reports/view/templateFour/25302?q=TBDCAT). 
In this workbook, I use the information given in the documentation to calculate the monthly income of agricultural households using the unit-level data.

## 1. Data Extraction
The data are provided in fixed-width text files by the NSS. 
Each line in the text file ("level" files) is an observation and widths (length of the variables) are used for generating the dataset. 
After generating the datasets, they are combined for visit 1 and 2 at the household level to get the combined year-long estimates. 

## 2. Analysis
The datasets are applied weights and each component income (income from crop production, animal resources, etc.) is computed separately. 
These component datasets are combined together to obtain the household income. 

## 3. Files for extraction and analysis

The six R files contain the script and comments for basic analysis of the unit-level data. All these files use data from both the visits.
1. Common_Agri_HH.R - for identifying the agricultural households that are common across two visits
2. Crop_Income.R - calculating crop income at paid-out approach
3. Animal_Income.R - animal income at paid-out approach
4. Wage_Pension_Rent_Income.R 
5. Non-Farm_Business_Income.R
6. HH_Income.R - combines crop income, animal income, wage, rent, and non-farm business income to calculate household incomes

There are supporting files also for different purposes. 
1. Levels_Codes.xlsx - the widths specified by NSS for data extraction; as given in the "NSS_77th_Layout_Sch_33.1_mult_post.xls" file given in the NSS website link
2. List_State.xlsx - codes for States
3. List_Social_Group.xlsx - codes for social groups
4. List_HH_Classification.xlsx - codes for household classification (self-employed in crop production, etc.)
5. List_Religion.xlsx - codes for religion

## 4. Working with R files
The codes contained in the file have extensive documentation. 
Please change the file path while running the codes.
There are many inconsistencies with the figures estimated as per the R files and those obtained from the NSS. 
These inconsistencies are addressed in a separate file - ISSUES.md.
To the extent possible, a uniform format is used for writing codes. 
But a thorough check for consistency has not been performed. In case of any doubts/errors, please let me know. 

## Acknowledgement
Thanks to Arindam Das, Soham Bhattacharya, and other colleagues from the [Foundation for Agrarian Studies](https://fas.org.in/) for all their help. 
