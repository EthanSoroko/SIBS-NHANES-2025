/* Define the library */
libname outlib '/home/u64253021/Research Project/Datasets';

data nhanes;
    set outlib.nhanes_combined_adults;
    if RIAGENDR=. or RIDRETH3=. or RIDAGEYR=. then domainvar=.;
    else domainvar=1;
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

/* Basic Model with just FPL_LT200 */
proc surveylogistic data=nhanes;
    domain domainvar;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') RIAGENDR (ref="Male") RIDRETH3 (ref='Non-Hispanic White') / param=ref;
    model HUQ030 (ref='2') = FPL_LT200;
run;

proc surveyreg data=nhanes;
    domain domainvar;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') RIAGENDR (ref="Male") RIDRETH3 (ref='Non-Hispanic White');
    model RXQ050 = FPL_LT200 RIDAGEYR RIAGENDR RIDRETH3 / solution clparm;
run;




