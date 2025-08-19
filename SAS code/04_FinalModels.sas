/*========================================================*/
/* HUQ030: Routine Place to Go for Healthcare             */
/*========================================================*/

/*-------------------------------------*/
/* 1. Unadjusted Model                 */
/* HUQ030 predicted by FPL_LT200 only  */
/*-------------------------------------*/
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') / param=ref;
    model HUQ030(ref='No') = FPL_LT200;
run;

/*-------------------------------------*/
/* 2. Adjusted without Interaction     */
/* Covariates: AGE, RACE, RIAGENDR     */
/*-------------------------------------*/
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level')
          AGE (ref="65+")
          RACE (ref='Non-Hispanic White')
          RIAGENDR (ref='Male') / param=ref;
    model HUQ030(ref='No') = FPL_LT200 AGE RACE RIAGENDR;
run;

/*-------------------------------------*/
/* 3. No Stratified Models (no interaction significant from file 03) */
/*-------------------------------------*/

/*========================================================*/
/* RXQ050: Number of Prescription Drugs Taken             */
/*========================================================*/

/*-------------------------------------*/
/* 1. Unadjusted Model                 */
/*-------------------------------------*/
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level');
    model RXQ050 = FPL_LT200 / solution clparm;
run;

/*-------------------------------------*/
/* 2. Adjusted without Interaction     */
/* Covariates: AGE, RACE, RIAGENDR     */
/*-------------------------------------*/
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level')
          RACE (ref='Non-Hispanic White')
          RIAGENDR (ref='Male');
    model RXQ050 = FPL_LT200 AGE RACE RIAGENDR / solution clparm;
run;

/*-------------------------------------*/
/* 3. Stratified Models (only AGE and RACE which were significant) */
/*-------------------------------------*/

/* Stratify by AGE */
proc surveyreg data=nhanes;
    domain AGE;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level')
          RACE (ref='Non-Hispanic White')
          RIAGENDR (ref='Male');
    model RXQ050 = FPL_LT200 RACE RIAGENDR / solution clparm;
run;

/* Stratify by RACE */
proc surveyreg data=nhanes;
    domain RACE;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level')
          AGE (ref='65+')
          RIAGENDR (ref='Male');
    model RXQ050 = FPL_LT200 AGE RIAGENDR / solution clparm;
run;