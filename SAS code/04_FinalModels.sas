/*========================================================*/
/* UsualCare: Routine Place to Go for Healthcare             */
/*========================================================*/

/*-------------------------------------*/
/* 1. Unadjusted Model - OLD                */
/* UsualCare predicted by PovertyUnder200 only  */
/*-------------------------------------*/
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class PovertyUnder200 (ref='At or Above 200% Federal Poverty Level') / param=ref;
    model UsualCare(ref='No routine place of care') = PovertyUnder200;
run;

/*-------------------------------------*/
/* 2. Adjusted without Interaction     */
/*-------------------------------------*/
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class 
        PovertyUnder200 (ref="At or Above 200% Federal Poverty Level")
        Gender (ref="Male")
        RaceCat (ref="Non-Hispanic White")
        EducationLevel (ref="Some college+") 
        InsuranceType (ref="Private")
        HealthCondition (ref="Neither")
        AgeCat (ref="65+")
        / param=ref;
    model UsualCare(ref="Has routine place of care") =
        PovertyUnder200
        AgeCat
        Gender
        RaceCat
        EducationLevel
        InsuranceType
        HealthCondition;
run;
/*-------------------------------------*/
/* 3. No Stratified Models (no interaction significant from file 03) */
/*-------------------------------------*/

/*========================================================*/
/* RXQ050: Number of Prescription Drugs Taken             */
/*========================================================*/

/*-------------------------------------*/
/* 1. Unadjusted Model - OLD                */
/*-------------------------------------*/
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class PovertyUnder200 (ref='At or Above 200% Federal Poverty Level');
    model RXQ050 = PovertyUnder200 / solution clparm;
run;

/*-------------------------------------*/
/* 2. Adjusted with Interaction     */
/*-------------------------------------*/
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class 
        PovertyUnder200 (ref="At or Above 200% Federal Poverty Level")
        Gender (ref="Male")
        AgeCat (ref='65+')
        RaceCat (ref="Non-Hispanic White")
        EducationLevel (ref="Some college+")
        InsuranceType (ref="Private")
        HealthCondition (ref="Neither");
    model PrescriptionCount =
        PovertyUnder200
        AgeCat
        Gender
        RaceCat
        EducationLevel
        InsuranceType
        HealthCondition
        InsuranceType*AgeCat
        InsuranceType*Gender
        / solution clparm; 
run;

/*-------------------------------------*/
/* 3. Stratified Models (only AGE and GENDER with InsuranceType were significant) */
/*-------------------------------------*/

proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class 
        PovertyUnder200 (ref="At or Above 200% Federal Poverty Level")
        Gender (ref="Male")
        AgeCat (ref="65+")
        RaceCat (ref="Non-Hispanic White")
        EducationLevel (ref="Some college+")
        InsuranceType (ref="Private")
        HealthCondition (ref="Neither");
    model PrescriptionCount =
        PovertyUnder200
        AgeCat
        Gender
        RaceCat
        EducationLevel
        InsuranceType
        HealthCondition
        InsuranceType*Gender
        InsuranceType*AgeCat
        / solution clparm;
    lsmeans InsuranceType*Gender/ adjust=tukey; 
    slice InsuranceType*Gender / sliceby=Gender;
    lsmeans InsuranceType*AgeCat/ adjust=tukey; 
    slice InsuranceType*AgeCat / sliceby=AgeCat;
run;
