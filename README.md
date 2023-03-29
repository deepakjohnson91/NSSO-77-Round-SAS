# Working on NSS 77th Round SAS Data using R

This documentation pertains to my experiments with the unit-level data of the Situation Assessment Survey (SAS). My friend [C. A. Sethu](https://github.com/s7u512) has greatly improved this work and resolved the issues that I had found in my work. His repository (with all the scripts) can be found [here](https://github.com/s7u512/NSSO-77-SAS) (I am also keeping a fork of his repository). I have made my codes consistent with the estimates obtained by him (except for Visit 1). But if you would like to work on the unit-level data, please follow his steps.

Here are some tips on how to use R (or RStudio) in analysing the latest unit-level from the Situation Assessment Survey of the NSS. 
India's National Sample Survey conducted its 77th Round of surveys in 2018-19. Among different topics covered in this round was the assessment of farming conditions in India. A brief review of the surveys and some results from the past can be found in the two links given below. 
1. [Situation Assessment Survey of Agricultural Households 2019: A Statistical Note by Aparajita Bakshi](http://ras.org.in/situation_assessment_survey_of_agricultural_households_2019_a_statistical_note)
2. [The Situation Assessment Surveys: An Evaluation by Biplab Sarkar](http://ras.org.in/index.php?Article=the_situation_assessment_surveys&q=biplab&keys=biplab)

The full list of unit-level datasets and documentation associated with NSS 77th Round Situation Assessment Survey this can be found [here](https://mospi.gov.in/web/mospi/download-tables-data/-/reports/view/templateFour/25302?q=TBDCAT). 
In this workbook, I use the information given in the documentation to calculate the monthly income of agricultural households using the unit-level data.

## 1. Data Extraction
The data are provided in fixed-width text files by the NSS. 
Each line in the text file ("level" files) is an observation and widths (length of the variables) are used for generating the dataset. 
After generating the datasets, they are combined for visit 1 and 2 at the household level to get the combined year-long estimates. 

## 2. Analysis
Calculations are performed after applying sample weights (provided by the NSSO). 
Each component income (income from crop production, animal resources, etc.) is computed separately. 
These component datasets are combined together to obtain the household income. 

## 3. Files for extraction and analysis

The six R files contain the script and comments for basic analysis of the unit-level data. All these files use data from both the visits. 
I followed the below order in running my analysis. 
1. Common_Agri_HH.R - for identifying the agricultural households that are common across two visits
2. Crop_Income.R - calculating crop income at paid-out approach
3. Animal_Income.R - animal income at paid-out approach
4. Wage_Pension_Rent_Income.R 
5. Non-Farm_Business_Income.R
6. HH_Income.R - combines crop income, animal income, wage, rent, and non-farm business income to calculate household incomes

There are five supporting files for different purposes. 
1. Levels_Codes.xlsx - the widths specified by NSS for data extraction; as given in the "NSS_77th_Layout_Sch_33.1_mult_post.xls" file given in the NSS website link
2. List_State.xlsx - codes for States
3. List_Social_Group.xlsx - codes for social groups
4. List_HH_Classification.xlsx - codes for household classification (self-employed in crop production, etc.)
5. List_Religion.xlsx - codes for religion

## 4. Working with R files
The codes contained in the file have extensive documentation. 
Please change the file path while running the codes.
There are some inconsistencies with the reported numbers in Visit 1.
That is because the report has used Visit 1 weights for estimation. 
I have used Visit 2 weights throughout in my estimation. 
In other words, combined estimates and Visit 2 estimates from my analysis would match the report's numbers. 
There were some inconsistencies in the earlier version. But with the help of Sethu's documentation, those issues have been now fixed. 
To the extent possible, a uniform format is used for writing codes. 
But a thorough check for consistency has not been performed. In case of any doubts/errors, please let me know. 

Finally, I have started working on R very recently. So there could be errors in my approach and method. Kindly let me know where improvements are required. 

## 5. License

This work is licensed under the [GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.html) license. This work is free: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This work is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

## Acknowledgement
Thanks to Arindam Das, Soham Bhattacharya, and other colleagues from the [Foundation for Agrarian Studies](https://fas.org.in/) for all their help. And many thanks to C. A. Sethu for writing better codes and resolving the pending issues. 
