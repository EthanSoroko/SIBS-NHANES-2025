/* Define the library */
libname outlib '/home/u64253021/Research Project/Datasets';

data nhanes;
    set outlib.nhanes_combined_adults;
run;

proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='0') HUQ042 (ref='6') RIAGENDR (ref='1') RIDRETH3 (ref='3');
    model HUQ042 (ref='6') = FPL_LT200 RIDAGEYR RIAGENDR RIDRETH3;
run;

proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='0') RIAGENDR (ref='1') RIDRETH3 (ref='3');
    model RXQ050 = FPL_LT200 RIDAGEYR RIAGENDR RIDRETH3 / solution;
run;




