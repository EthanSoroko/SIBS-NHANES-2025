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

/* Descriptive Statistics */
proc freq data=nhanes_combined;
    tables RIAGENDR RIDRETH3 INDFMMPC HUQ030 RXQ050 / missing;
run;

proc means data=nhanes_combined n mean std min max;
    var RIDAGEYR;
run;

/* Create binary Below 200% Federal Poverty Level variable */
data nhanes_combined;
    set nhanes_combined;

    if 0 <= INDFMMPI < 2 then FPL_LT200 = 1;
    else if 2 <= INDFMMPI <= 5 then FPL_LT200 = 0;
    else FPL_LT200 = .;
run;

proc freq data=nhanes_combined;
	table FPL_LT200 / missing;
run;