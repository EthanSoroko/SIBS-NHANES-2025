/* Define the library */
libname outlib '/home/u64245345/NHANES_2';

/* Data importing and formatting */

data nhanes;
    set outlib.nhanes_combined_adults;
run;

proc format;
    value RIAGENDR_fmt
        1 = "Male"
        2 = "Female"
        . = "Missing";
run;

proc format;
    value FPL_fmt
        1 = "Below 200% Federal Poverty Level"
        0 = "At or Above 200% Federal Poverty Level"
        . = "Missing";
run;

proc format;
    value RACE_fmt
        1 = "Hispanic"
        3 = "Non-Hispanic White"
        4 = "Non-Hispanic Black"
        6 = "Non-Hispanic Asian"
        . = "Missing";
run;

proc format;
    value HUQ042_fmt
        1 = "A doctor's office or health center"
        2 = "Urgent care center or clinic in a drug store or grocery store"
        3 = "Emergency room"
        4 = "A VA medical center or VA outpatient clinic"
        5 = "Some other place"
        6 = "Doesn't go to one place most often"
        . = "Missing";
run;


proc format;
    value RXQ050_fmt
        0 = "0 (None)"
        1 = "1"
        2 = "2"
        3 = "3"
        4 = "4"
        5 = "5 or more"
        . = "Missing";
run;

proc format;
	value HUQ030_fmt
		1 = 'Yes'
		2 = 'No'
		. = 'Missing';
run;

proc format;
    value RIDRETH3_fmt
        1 = "Mexican American"
        2 = "Other Hispanic"
        3 = "Non-Hispanic White"
        4 = "Non-Hispanic Black"
        6 = "Non-Hispanic Asian"
        7 = "Other Race - Including Multi-Racial"
        . = "Missing";
run;

proc format;
    value AGE_fmt
        1 = "18-34"
        2 = "35-54"
        3 = "55-64"
        4 = "65+"
        . = "Missing";
run;

data nhanes;
	set nhanes;
    format RIAGENDR RIAGENDR_fmt.;
    format FPL_LT200 FPL_fmt.;
    format RXQ050 RXQ050_fmt.;
    format HUQ042 HUQ042_fmt.;
    format HUQ030 HUQ030_fmt.;
    format RIDRETH3 RIDRETH3_fmt.;
run;

*/ Create a collapsed race variable; 

data nhanes;
    set nhanes;
	RACE = RIDRETH3;
    if RIDRETH3 in (1, 2) then RACE = 1;
    else if RIDRETH3 = 7 then RACE = .;
    /* Assign descriptive label and format */
    label RACE = "Race/Ethnicity (Collapsed)";
    format RACE RACE_fmt.;
run;

*/ Create an age variable by category; 

data nhanes;
    set nhanes;
	AGE = RIDAGEYR;
    if 18 <= RIDAGEYR <= 34 then AGE = 1;
    else if 35 <= RIDAGEYR <= 54 then AGE = 2;
    else if 55 <= RIDAGEYR <= 64 then AGE = 3;
    else if 65 <= RIDAGEYR then AGE = 4;  
    /* Assign descriptive label and format */
    label AGE = "Age (Categorized)";
    format AGE AGE_fmt.;
run;

proc freq data = nhanes;
tables AGE;
run;


/* Full Logistic Model */
proc surveylogistic data=nhanes;
    domain domainvar;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') RIAGENDR (ref="Male") RIDRETH3 (ref='Non-Hispanic White') / param=ref;
    model HUQ030 (ref='2') = FPL_LT200 RIDAGEYR RIAGENDR RIDRETH3;
run;


/* modify HUQ030 
Step 1: Convert 3 - there is more than one place to 1 - Yes there is a routine place of healthcare
Step 2: Convert 7 and 9 (refused and don't know) to missing */

data nhanes;
    set nhanes;
    /* Step 1: Targeted recode to 3 */
    if HUQ030 = 3 then HUQ030 = 1;
    /* Step 2: Recode remaining 7 or 9 to missing */
    else if HUQ030 in (7, 9) then HUQ030 = .;
run;


data nhanes;
    set nhanes;
    if RIAGENDR=. or RIDRETH3=. or RIDAGEYR=. then domainvar=.;
    else domainvar=1;
run;

/* Full Logistic Models */

proc surveylogistic data=nhanes;
    domain domainvar;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') RIAGENDR (ref="Male") RACE (ref='Non-Hispanic White') / param=ref;
    model HUQ030 (ref='No') = FPL_LT200 RIDAGEYR RIAGENDR RACE;
run;


proc surveyreg data=nhanes;
    domain domainvar;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') RIAGENDR (ref="Male") RACE (ref='Non-Hispanic White');
    model RXQ050 = FPL_LT200 RIDAGEYR RIAGENDR RACE / solution clparm;
run;

/* Basic Models */

/* Basic Model with just FPL_LT200 - HUQ030 */
proc surveylogistic data=nhanes;
    domain domainvar;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') RIAGENDR (ref="Male") RACE (ref='Non-Hispanic White') / param=ref;
    model HUQ030 (ref='No') = FPL_LT200;
run;


proc surveyreg data=nhanes;
    domain domainvar;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') RIAGENDR (ref="Male") RACE (ref='Non-Hispanic White');
    model RXQ050 = FPL_LT200 / solution clparm;
run;





