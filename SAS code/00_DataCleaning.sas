/* Set YOUR OWN path to XPT files */
libname demo_xpt xport '/home/u64245345/NHANES/DEMO_L.xpt';
libname inq_xpt  xport '/home/u64245345/NHANES/INQ_L.xpt';
libname rxq_xpt  xport '/home/u64245345/NHANES/RXQ_RX_L.xpt';
libname huq_xpt  xport '/home/u64245345/NHANES/HUQ_L.xpt';
libname diq_xpt xport '/home/u64245345/NHANES/DIQ_L.xpt';
libname hiq_xpt xport '/home/u64245345/NHANES/HIQ_L.xpt';
libname med_xpt xport '/home/u64245345/NHANES/MCQ_L.xpt';

/* Create SAS datasets from the XPT files and merge them */
data demographics; set demo_xpt.DEMO_L; run;
data income;  set inq_xpt.INQ_L;  run;
data prescriptions;  set rxq_xpt.RXQ_RX_L; run;
data healthcare;  set huq_xpt.HUQ_L;  run;
data insurance; set hiq_xpt.HIQ_L; run;
data diabetes; set diq_xpt.DIQ_L; run;
data heartdisease; set med_xpt.MCQ_L; run;

proc sort data=demographics out=demographics_sorted; by SEQN; run;

proc sort data=income out=income_sorted; by SEQN; run;

proc sort data=prescriptions out=prescriptions_sorted; by SEQN; run;

proc sort data=healthcare out=healthcare_sorted; by SEQN; run;

proc sort data=insurance out=insurance_sorted; by SEQN; run;

proc sort data=diabetes out=diabetes_sorted; by SEQN; run;

proc sort data=heartdisease out=heartdisease_sorted; by SEQN; run;

data nhanes;
    merge demographics_sorted income_sorted prescriptions_sorted healthcare_sorted 
    insurance_sorted diabetes_sorted heartdisease_sorted;
    by SEQN;
run;
 
/*Cleaning education variable:
EDU has options high school (with GED) or below (1), some college or above (2), or missing (.) */

data nhanes;
	set nhanes;
	if DMDEDUC2 in (1, 2, 3) then EDU = 1;
	if DMDEDUC2 in (4, 5) then EDU = 2;
	if DMDEDUC2 in (7, 9, .) then EDU = .;


/*Cleaning insurance variable:
INSU has options private insurance (1), public insurance (2), no insurance (3), or missing (.) */

data nhanes;
	set nhanes;
	if HIQ011 = 1 and HIQ032A = 1 then INSU = 1;
	else if HIQ011 = 1 and (HIQ032B = 2 or HIQ032C = 3 or HIQ032D = 4 or HIQ032E = 5 or HIQ032F = 6 or HIQ032H = 8 or HIQ032I = 9) then INSU = 2;
	else if HIQ011 = 2 then INSU = 3;
	else INSU = .;
	
/*Cleaning diabetes and heart disease variable 
CONDITION has options diabetic (1), heart disease (2), diabetic and heart disease (3), no diabetes or heart disease (4), missing (.)

Some considerations:
Diabetes questionnaire also has information on prediabetes (DIQ160) -- right now, we're only counting diabetes if 'Yes' to diabetes (DIQ010)
Right now, heart disease coding includes congestive heart failure, coronary heart disease, angina/ angina pectoris, and heart attacks as heart disease. 
Stroke (MCQ160f) and thryoid problems (MCQ160m) are not currently included in heart disease category. */

data nhanes;
	set nhanes;
	if DIQ010 = 1 and (MCQ160b = 1 or MCQ160c = 1 or MCQ160d = 1 or MCQ160e = 1) then CONDITION = 3;
	else if DIQ010 = 1 and MCQ160b = 2 and MCQ160c = 2 and MCQ160d = 2 and MCQ160e = 2 then CONDITION = 1;
	else if (MCQ160b = 1 or MCQ160c = 1 or MCQ160d = 1 or MCQ160e = 1) then CONDITION = 2;
	else if DIQ010 in (2, 3) and MCQ160b = 2 and MCQ160c = 2 and MCQ160d = 2 and MCQ160e = 2 then CONDITION = 4;
	else CONDITION = .;





