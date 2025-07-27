/* Set YOUR OWN path to XPT files */
libname demo_xpt xport '/home/u64253021/Research Project/Datasets/DEMO_L.xpt';
libname inq_xpt  xport '/home/u64253021/Research Project/Datasets/INQ_L.xpt';
libname rxq_xpt  xport '/home/u64253021/Research Project/Datasets/RXQ_RX_L.xpt';
libname huq_xpt  xport '/home/u64253021/Research Project/Datasets/HUQ_L.xpt';

/* Create SAS datasets from the XPT files and merge them */
data demographics; set demo_xpt.DEMO_L; run;
data income;  set inq_xpt.INQ_L;  run;
data prescriptions;  set rxq_xpt.RXQ_RX_L; run;
data healthcare;  set huq_xpt.HUQ_L;  run;

proc sort data=demographics out=demographics_sorted; by SEQN; run;

proc sort data=income out=income_sorted; by SEQN; run;

proc sort data=prescriptions out=prescriptions_sorted; by SEQN; run;

proc sort data=healthcare out=healthcare_sorted; by SEQN; run;

data nhanes_combined;
    merge demographics_sorted income_sorted prescriptions_sorted healthcare_sorted;
    by SEQN;
run;

/* Removing anyone under age 18 */
data nhanes_combined;
    set nhanes_combined;

    /* Keep only participants who are 18 years or older */
    if RIDAGEYR >= 18;
run;

/* Create binary Below 200% Federal Poverty Level variable */
proc format;
    value FPL_fmt
        1 = "Below 200% Federal Poverty Level"
        0 = "At or Above 200% Federal Poverty Level"
        . = "Missing";
run;

data nhanes_combined;
    set nhanes_combined;

    /* Create binary Below 200% Federal Poverty Level variable */
    if INDFMMPC in (1, 2) then FPL_LT200 = 1;
    else if INDFMMPC = 3 then do;
        if INDFMMPI ne . then do;
            if INDFMMPI < 2 then FPL_LT200 = 1;
            else if INDFMMPI >= 2 then FPL_LT200 = 0;
            else FPL_LT200 = .;
        end;
        else FPL_LT200 = .; /* Missing continuous value, cannot infer */
    end;
    else if INDFMMPC in (7, 9) then FPL_LT200 = .; /* Refused or Don't know */
    else FPL_LT200 = .; /* Missing or other */

    /* Assign descriptive label and format */
    label FPL_LT200 = "Binary indicator for income < 200% Federal Poverty Level";
    format FPL_LT200 FPL_fmt.;
run;

/* Modifying Missing Data */

/* 
   Step 1: If the respondent reports that there is no usual place they go for healthcare (HUQ030 = 2),
   and their response for the type of place most often used for care (HUQ042) is missing (.), 
   refused (77), or don't know (99), then recode HUQ042 to 6, which corresponds to 
   "Doesn't go to one place most often" for consistency.

   Step 2: For all other respondents, recode any remaining 77 (Refused) or 99 (Don't know) in HUQ042 to missing (.)
*/
data nhanes_combined;
    set nhanes_combined;

    /* Step 1: Targeted recode to 6 */
    if HUQ030 = 2 and (HUQ042 in (77, 99) or missing(HUQ042)) then HUQ042 = 6;

    /* Step 2: Recode remaining 77 or 99 to missing */
    else if HUQ042 in (77, 99) then HUQ042 = .;
run;

/* 
   Step 1: If the participant reports NOT taking any prescription medication in the past 30 days (RXQ033 = 2)
   and their RXQ050 (number of prescription meds taken) is Refused (7), Don't know (9), or Missing (.),
   then recode RXQ050 to 0 to reflect no medications taken.

   Step 2: For all other cases, recode any remaining values of 7 (Refused) or 9 (Don't know) in RXQ050 to missing (.)
*/
data nhanes_combined;
    set nhanes_combined;

    /* Step 1: Impute 0 for known non-users with unknown med count */
    if RXQ033 = 2 and (RXQ050 in (7, 9) or missing(RXQ050)) then RXQ050 = 0;

    /* Step 2: Clean remaining invalid responses */
    else if RXQ050 in (7, 9) then RXQ050 = .;
run;

/* Adding labels */
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

data nhanes_combined;
    set nhanes_combined;
    format HUQ042 HUQ042_fmt.;
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

data nhanes_combined;
    set nhanes_combined;
    format RXQ050 RXQ050_fmt.;
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

data nhanes_combined;
    set nhanes_combined;
    format RIDRETH3 RIDRETH3_fmt.;
run;

proc format;
    value RIAGENDR_fmt
        1 = "Male"
        2 = "Female"
        . = "Missing";
run;

data nhanes_combined;
    set nhanes_combined;
    format RIAGENDR RIAGENDR_fmt.;
run;

proc format;
    value INDFMMPC_fmt
        1 = "Monthly poverty level index <= 1.30"
        2 = "1.30 < Monthly poverty level index <= 1.85"
        3 = "Monthly poverty level index > 1.85"
        7 = "Refused"
        9 = "Don't know"
        . = "Missing";
run;

data nhanes_combined;
    set nhanes_combined;
    format INDFMMPC INDFMMPC_fmt.;
run;

/* Descriptive Statistics */
proc freq data=nhanes_combined;
    tables RIAGENDR RIDRETH3 INDFMMPC HUQ042 RXQ050 FPL_LT200 / missing;
run;

proc means data=nhanes_combined n mean std min max;
    var RIDAGEYR;
run;

/* Downloading combined NHANES dataset */

/* Set your PERSONAL output directory */
libname outlib '/home/u64253021/Research Project/Datasets';

/* Create and label the combined NHANES adult dataset */
data outlib.nhanes_combined_adults (label="NHANES Combined Dataset (Adults Only)");
    set nhanes_combined;
run;