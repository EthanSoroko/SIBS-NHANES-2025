/*----------------------------------------------------
 Set file paths
----------------------------------------------------*/
libname demo_xpt xport '/home/u64253021/Research Project/Datasets/DEMO_L.xpt';
libname inq_xpt  xport '/home/u64253021/Research Project/Datasets/INQ_L.xpt';
libname rxq_xpt  xport '/home/u64253021/Research Project/Datasets/RXQ_RX_L.xpt';
libname huq_xpt  xport '/home/u64253021/Research Project/Datasets/HUQ_L.xpt';
libname hiq_xpt  xport '/home/u64253021/Research Project/Datasets/HIQ_L.xpt';
libname diq_xpt  xport '/home/u64253021/Research Project/Datasets/DIQ_L.xpt';
libname mcq_xpt  xport '/home/u64253021/Research Project/Datasets/MCQ_L.xpt';

/*----------------------------------------------------
 Create SAS datasets from XPT files
----------------------------------------------------*/
data demographics;   set demo_xpt.DEMO_L;   run;
data income;         set inq_xpt.INQ_L;     run;
data prescriptions;  set rxq_xpt.RXQ_RX_L;  run;
data healthcare;     set huq_xpt.HUQ_L;     run;
data insurance;      set hiq_xpt.HIQ_L;     run;
data diabetes;       set diq_xpt.DIQ_L;     run;
data conditions;     set mcq_xpt.MCQ_L;     run;

/*----------------------------------------------------
 Sort datasets by participant ID
----------------------------------------------------*/
%macro sort_dataset(ds);
    proc sort data=&ds out=&ds._sorted; 
        by SEQN; 
    run;
%mend;

%sort_dataset(demographics);
%sort_dataset(income);
%sort_dataset(prescriptions);
%sort_dataset(healthcare);
%sort_dataset(insurance);
%sort_dataset(diabetes);
%sort_dataset(conditions);

/*----------------------------------------------------
 Merge into one master dataset
----------------------------------------------------*/
data nhanes;
    merge demographics_sorted income_sorted prescriptions_sorted healthcare_sorted 
          insurance_sorted diabetes_sorted conditions_sorted;
    by SEQN;
run;

/* Remove participants under age 18 */
data nhanes;
    set nhanes;
    if RIDAGEYR >= 18;
run;

/*----------------------------------------------------
 Define formats
----------------------------------------------------*/
proc format;
    value FPL_fmt
        1 = "Below 200% Federal Poverty Level"
        0 = "At or Above 200% Federal Poverty Level"
        . = "Missing";

    value HealthPlace_fmt
        1 = "Doctor's office / health center"
        2 = "Urgent care / retail clinic"
        3 = "Emergency room"
        4 = "VA medical center / VA clinic"
        5 = "Other place"
        6 = "No usual place"
        . = "Missing";

    value Prescrip_fmt
        0 = "0 (None)"
        1 = "1"
        2 = "2"
        3 = "3"
        4 = "4"
        5 = "5 or more"
        . = "Missing";

    value Race_fmt
        1 = "Hispanic"
        3 = "Non-Hispanic White"
        4 = "Non-Hispanic Black"
        6 = "Non-Hispanic Asian"
        . = "Missing";

    value Age_fmt
        1 = "18-34"
        2 = "35-54"
        3 = "55-64"
        4 = "65+"
        . = "Missing";

    value Gender_fmt
        1 = "Male"
        2 = "Female"
        . = "Missing";

    value Insurance_fmt
        1 = "Private"
        2 = "Public"
        3 = "Uninsured"
        . = "Missing";

    value Condition_fmt
        1 = "Diabetes only"
        2 = "Heart disease only"
        3 = "Both diabetes + heart disease"
        4 = "Neither"
        . = "Missing";

    value Educ_fmt
        1 = "HS or less"
        2 = "Some college+"
        . = "Missing";
run;

/*----------------------------------------------------
 Recode / create variables
----------------------------------------------------*/

/* Poverty <200% FPL */
data nhanes;
    set nhanes;
    if INDFMMPC in (1,2) then PovertyUnder200 = 1;
    else if INDFMMPC = 3 then do;
        if INDFMMPI < 2 then PovertyUnder200 = 1;
        else if INDFMMPI >= 2 then PovertyUnder200 = 0;
        else PovertyUnder200 = .;
    end;
    else PovertyUnder200 = .;
    label PovertyUnder200 = "Income <200% Federal Poverty Level";
    format PovertyUnder200 FPL_fmt.;
run;

/* Usual healthcare place */
data nhanes;
    set nhanes;
    if HUQ030 = 2 and (HUQ042 in (77,99) or missing(HUQ042)) then UsualCare = 6;
    else if HUQ042 in (77,99) then UsualCare = .;
    else UsualCare = HUQ042;
    label UsualCare = "Usual place for healthcare";
    format UsualCare HealthPlace_fmt.;
run;

/* Prescription count */
data nhanes;
    set nhanes;
    if RXQ033 = 2 and (RXQ050 in (7,9) or missing(RXQ050)) then PrescriptionCount = 0;
    else if RXQ050 in (7,9) then PrescriptionCount = .;
    else PrescriptionCount = RXQ050;
    label PrescriptionCount = "Prescription drug count";
    format PrescriptionCount Prescrip_fmt.;
run;

/* Insurance */
data nhanes;
    set nhanes;
    if HIQ011 = 1 and HIQ032A = 1 then InsuranceType = 1;
    else if HIQ011 = 1 and HIQ032A ne 1 then InsuranceType = 2;
    else if HIQ011 = 2 then InsuranceType = 3;
    else InsuranceType = .;
    label InsuranceType = "Insurance coverage type";
    format InsuranceType Insurance_fmt.;
run;

/* EducationLevel (numeric) */
data nhanes;
    set nhanes;
    if DMDEDUC2 in (1,2,3) then EducationLevel = 1;
    else if DMDEDUC2 in (4,5) then EducationLevel = 2;
    else EducationLevel = .;
    label EducationLevel = "Education (1=HS or less, 2=Some college+)";
    format EducationLevel Educ_fmt.;
run;

/* Health condition: Diabetes + Heart disease */
data nhanes;
    set nhanes;
    if DIQ010 = 1 and (MCQ160b=1 or MCQ160c=1 or MCQ160d=1 or MCQ160e=1) then HealthCondition = 3;
    else if DIQ010 = 1 and (MCQ160b=2 and MCQ160c=2 and MCQ160d=2 and MCQ160e=2) then HealthCondition = 1;
    else if (MCQ160b=1 or MCQ160c=1 or MCQ160d=1 or MCQ160e=1) then HealthCondition = 2;
    else if DIQ010 in (2,3) and (MCQ160b=2 and MCQ160c=2 and MCQ160d=2 and MCQ160e=2) then HealthCondition = 4;
    else HealthCondition = .;
    label HealthCondition = "Diabetes / Heart disease condition";
    format HealthCondition Condition_fmt.;
run;

/* Collapsed Race */
data nhanes;
    set nhanes;
    if RIDRETH3 in (1,2) then RaceCat = 1;
    else if RIDRETH3 in (3,4,6) then RaceCat = RIDRETH3;
    else RaceCat = .;
    label RaceCat = "Race/Ethnicity (Collapsed)";
    format RaceCat Race_fmt.;
run;

/* Age categories */
data nhanes;
    set nhanes;
    if 18 <= RIDAGEYR <= 34 then AgeCat = 1;
    else if 35 <= RIDAGEYR <= 54 then AgeCat = 2;
    else if 55 <= RIDAGEYR <= 64 then AgeCat = 3;
    else if RIDAGEYR >= 65 then AgeCat = 4;
    else AgeCat = .;
    label AgeCat = "Age (Categorized)";
    format AgeCat Age_fmt.;
run;

/* Gender */
data nhanes;
    set nhanes;
    Gender = RIAGENDR;
    label Gender = "Gender";
    format Gender Gender_fmt.;
run;

/*----------------------------------------------------
 Save final dataset
----------------------------------------------------*/
libname outlib '/home/u64253021/Research Project/Datasets';

data outlib.nhanes_final_adults (label="NHANES Final Combined Dataset (Adults Only)");
    set nhanes;
run;