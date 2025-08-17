/*-------------------------------------*/
/* HUQ030 and RXQ050 Unadjusted Models */
/*-------------------------------------*/

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

/*-------------------------*/
/* RXQ050 Stratified Models */
/*-------------------------*/

/* Stratify by AGE (domain = AGE)
   AGE excluded from CLASS and MODEL */
proc surveyreg data=nhanes;
    domain AGE;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') 
          RACE (ref='Non-Hispanic White');

    model RXQ050 = FPL_LT200 RACE / solution clparm;
run;

/* Stratify by RACE (domain = RACE)
   RACE excluded from CLASS and MODEL */
proc surveyreg data=nhanes;
    domain RACE;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') 
          AGE (ref='65+');

    model RXQ050 = FPL_LT200 RIDAGEYR / solution clparm;
run;
