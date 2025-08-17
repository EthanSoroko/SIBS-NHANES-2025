/* HUQ030 main effects + FPL × Age interaction */
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') 
          RIAGENDR (ref='Male')
          RACE (ref='Non-Hispanic White')
          AGE (ref='65+') / param=ref;

    model HUQ030(ref='No') = FPL_LT200 RIAGENDR RACE AGE
                              FPL_LT200*AGE;
run;

/* HUQ030 with FPL × Race */
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') 
          RIAGENDR (ref='Male')
          RACE (ref='Non-Hispanic White')
          AGE (ref='65+') / param=ref;

    model HUQ030(ref='No') = FPL_LT200 RIAGENDR RACE AGE
                              FPL_LT200*RACE;
run;

/* HUQ030 with FPL × Gender */
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') 
          RIAGENDR (ref='Male')
          RACE (ref='Non-Hispanic White')
          AGE (ref='65+') / param=ref;

    model HUQ030(ref='No') = FPL_LT200 RIAGENDR RACE AGE
                              FPL_LT200*RIAGENDR;
run;

/* RXQ050 with FPL × Age */
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') 
          RIAGENDR (ref='Male')
          RACE (ref='Non-Hispanic White')
          AGE (ref='65+');

    model RXQ050 = FPL_LT200 RIAGENDR RACE AGE
                   FPL_LT200*AGE / solution;
run;

/* RXQ050 with FPL × Race */
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') 
          RIAGENDR (ref='Male')
          RACE (ref='Non-Hispanic White')
          AGE (ref='65+');

    model RXQ050 = FPL_LT200 RIAGENDR RACE AGE
                   FPL_LT200*RACE / solution;
run;

/* RXQ050 with FPL × Gender */
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') 
          RIAGENDR (ref='Male')
          RACE (ref='Non-Hispanic White')
          AGE (ref='65+');

    model RXQ050 = FPL_LT200 RIAGENDR RACE AGE
                   FPL_LT200*RIAGENDR / solution;
run;