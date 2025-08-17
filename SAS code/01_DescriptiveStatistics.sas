/* Set YOUR OWN path to XPT files */
libname demo_xpt xport '/home/u64253021/Research Project/Datasets/DEMO_L.xpt';
libname inq_xpt  xport '/home/u64253021/Research Project/Datasets/INQ_L.xpt';
libname rxq_xpt  xport '/home/u64253021/Research Project/Datasets/RXQ_RX_L.xpt';
libname huq_xpt  xport '/home/u64253021/Research Project/Datasets/HUQ_L.xpt';

/* Create SAS datasets from the XPT files and merge them */
data demographics; set demo_xpt.DEMO_L; run;
data income;       set inq_xpt.INQ_L;  run;
data prescriptions;set rxq_xpt.RXQ_RX_L; run;
data healthcare;   set huq_xpt.HUQ_L;  run;

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
    if RIDAGEYR >= 18;
run;

/*---------------------------------------------*/
/* FORMATS                                     */
/*---------------------------------------------*/
proc format;
    value FPL_fmt
        1 = "Below 200% Federal Poverty Level"
        0 = "At or Above 200% Federal Poverty Level"
        . = "Missing";

    value HUQ042_fmt
        1 = "A doctor's office or health center"
        2 = "Urgent care center or clinic in a drug store or grocery store"
        3 = "Emergency room"
        4 = "A VA medical center or VA outpatient clinic"
        5 = "Some other place"
        6 = "Doesn't go to one place most often"
        . = "Missing";

    value RXQ050_fmt
        0 = "0 (None)"
        1 = "1"
        2 = "2"
        3 = "3"
        4 = "4"
        5 = "5 or more"
        . = "Missing";

    value RIDRETH3_fmt
        1 = "Mexican American"
        2 = "Other Hispanic"
        3 = "Non-Hispanic White"
        4 = "Non-Hispanic Black"
        6 = "Non-Hispanic Asian"
        7 = "Other Race - Including Multi-Racial"
        . = "Missing";

    value RIAGENDR_fmt
        1 = "Male"
        2 = "Female"
        . = "Missing";

    value INDFMMPC_fmt
        1 = "Monthly poverty level index <= 1.30"
        2 = "1.30 < Monthly poverty level index <= 1.85"
        3 = "Monthly poverty level index > 1.85"
        7 = "Refused"
        9 = "Don't know"
        . = "Missing";

    value HUQ030_fmt
        1 = 'Yes'
        2 = 'No'
        . = 'Missing';

    value RACE_fmt
        1 = "Hispanic"
        3 = "Non-Hispanic White"
        4 = "Non-Hispanic Black"
        6 = "Non-Hispanic Asian"
        . = "Missing";

    value AGE_fmt
        1 = "18-34"
        2 = "35-54"
        3 = "55-64"
        4 = "65+"
        . = "Missing";
run;

/*---------------------------------------------*/
/* Create new/recoded variables                */
/*---------------------------------------------*/

/* Poverty <200% FPL indicator */
data nhanes_combined;
    set nhanes_combined;
    if INDFMMPC in (1, 2) then FPL_LT200 = 1;
    else if INDFMMPC = 3 then do;
        if INDFMMPI ne . then do;
            if INDFMMPI < 2 then FPL_LT200 = 1;
            else if INDFMMPI >= 2 then FPL_LT200 = 0;
            else FPL_LT200 = .;
        end;
        else FPL_LT200 = .;
    end;
    else if INDFMMPC in (7, 9) then FPL_LT200 = .;
    else FPL_LT200 = .;

    label FPL_LT200 = "Binary indicator for income < 200% Federal Poverty Level";
    format FPL_LT200 FPL_fmt.;
run;

/* Recode HUQ042 (usual healthcare place) */
data nhanes_combined;
    set nhanes_combined;
    if HUQ030 = 2 and (HUQ042 in (77, 99) or missing(HUQ042)) then HUQ042 = 6;
    else if HUQ042 in (77, 99) then HUQ042 = .;
    format HUQ042 HUQ042_fmt.;
run;

/* Recode RXQ050 (prescription drug count) */
data nhanes_combined;
    set nhanes_combined;
    if RXQ033 = 2 and (RXQ050 in (7, 9) or missing(RXQ050)) then RXQ050 = 0;
    else if RXQ050 in (7, 9) then RXQ050 = .;
    format RXQ050 RXQ050_fmt.;
run;

/* Recode HUQ030 */
data nhanes_combined;
    set nhanes_combined;
    if HUQ030 = 3 then HUQ030 = 1;
    if HUQ030 in (7, 9) then HUQ030 = .;
    format HUQ030 HUQ030_fmt.;
run;

/* Collapsed RACE variable */
data nhanes_combined;
    set nhanes_combined;
    RACE = RIDRETH3;
    if RIDRETH3 in (1, 2) then RACE = 1;
    else if RIDRETH3 = 7 then RACE = .;
    label RACE = "Race/Ethnicity (Collapsed)";
    format RACE RACE_fmt.;
run;

/* Categorized AGE variable */
data nhanes_combined;
    set nhanes_combined;
    if 18 <= RIDAGEYR <= 34 then AGE = 1;
    else if 35 <= RIDAGEYR <= 54 then AGE = 2;
    else if 55 <= RIDAGEYR <= 64 then AGE = 3;
    else if RIDAGEYR >= 65 then AGE = 4;
    else AGE = .;
    label AGE = "Age (Categorized)";
    format AGE AGE_fmt.;
run;

/* Apply demographic formats */
data nhanes_combined;
    set nhanes_combined;
    format RIAGENDR RIAGENDR_fmt. 
           RIDRETH3 RIDRETH3_fmt.
           INDFMMPC INDFMMPC_fmt.;
run;

/*---------------------------------------------*/
/* Descriptive Statistics                      */
/*---------------------------------------------*/
proc freq data=nhanes_combined;
    tables AGE RIAGENDR RACE HUQ030 RXQ050 FPL_LT200 / missing;
run;

/*---------------------------------------------*/
/* Save final dataset                          */
/*---------------------------------------------*/
libname outlib '/home/u64253021/Research Project/Datasets';

data outlib.nhanes_combined_adults (label="NHANES Combined Dataset (Adults Only)");
    set nhanes_combined;
run;
