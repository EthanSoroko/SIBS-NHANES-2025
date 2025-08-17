/* Define the library */
libname outlib '/home/u64253021/Research Project/Datasets';

data nhanes;
    set outlib.nhanes_combined_adults;
run;

/* Logistic regression: HUQ030 predicted by FPL_LT200 only */
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') / param=ref;
    model HUQ030(ref='No') = FPL_LT200;
run;

/* Linear regression: RXQ050 predicted by FPL_LT200 only */
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level');
    model RXQ050 = FPL_LT200 / solution clparm;
run;