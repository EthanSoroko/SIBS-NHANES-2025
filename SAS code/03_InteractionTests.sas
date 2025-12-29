/*----------------------------------------------------
 Reload dataset
----------------------------------------------------*/
libname outlib '/home/u64253021/Research Project/Datasets';

data nhanes;
    set outlib.nhanes_final_adults;
run;

/*----------------------------------------------------
 Logistic regressions: UsualCare with FPL_200 Interactions
----------------------------------------------------*/

/* Poverty × Age */
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class UsualCare (ref='No routine place of care')
          PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither')
          / param=ref;

    model UsualCare(ref='No routine place of care') =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          PovertyUnder200*AgeCat;
run;

/* Poverty × Race */
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class UsualCare (ref='No routine place of care')
          PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither')
          / param=ref;

    model UsualCare(ref='No routine place of care') =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          PovertyUnder200*RaceCat;
run;

/* Poverty × Gender */
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class UsualCare (ref='No routine place of care')
          PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither')
          / param=ref;

    model UsualCare(ref='No routine place of care') =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          PovertyUnder200*Gender;
run;

/* Poverty × Education */
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class UsualCare (ref='No routine place of care')
          PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither')
          / param=ref;

    model UsualCare(ref='No routine place of care') =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          PovertyUnder200*EducationLevel;
run;

/* Poverty × Insurance */
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class UsualCare (ref='No routine place of care')
          PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither')
          / param=ref;

    model UsualCare(ref='No routine place of care') =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          PovertyUnder200*InsuranceType;
run;

/* Poverty × HealthCondition */
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class UsualCare (ref='No routine place of care')
          PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither')
          / param=ref;

    model UsualCare(ref='No routine place of care') =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          PovertyUnder200*HealthCondition;
run;

/*----------------------------------------------------
 Linear regressions: PrescriptionCount with FPL_200 Interactions
----------------------------------------------------*/

/* Poverty × Age */
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither');

    model PrescriptionCount =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          PovertyUnder200*AgeCat / solution;
run;

/* Poverty × Race */
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither');

    model PrescriptionCount =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          PovertyUnder200*RaceCat / solution;
run;

/* Poverty × Gender */
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither');

    model PrescriptionCount =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          PovertyUnder200*Gender / solution;
run;

/* Poverty × Education */
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither');

    model PrescriptionCount =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          PovertyUnder200*EducationLevel / solution;
run;

/* Poverty × Insurance */
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither');

    model PrescriptionCount =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          PovertyUnder200*InsuranceType / solution;
run;

/* Poverty × HealthCondition */
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither');

    model PrescriptionCount =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          PovertyUnder200*HealthCondition / solution;
run;


/*----------------------------------------------------
 Logistic regressions: UsualCare - InsuranceType Interactions
----------------------------------------------------*/

/* Insurance × Age */
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class UsualCare (ref='No routine place of care')
          PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither')
          / param=ref;

    model UsualCare(ref='No routine place of care') =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          InsuranceType*AgeCat /df = INFINITY;
run;

/* Insurance × Race */
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class UsualCare (ref='No routine place of care')
          PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither')
          / param=ref;

    model UsualCare(ref='No routine place of care') =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          InsuranceType*RaceCat /df = INFINITY;
run;

/* Insurance × Gender */
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class UsualCare (ref='No routine place of care')
          PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither')
          / param=ref;

    model UsualCare(ref='No routine place of care') =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          InsuranceType*Gender;
run;

/* Insurance × Education */
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class UsualCare (ref='No routine place of care')
          PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither')
          / param=ref;

    model UsualCare(ref='No routine place of care') =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          InsuranceType*EducationLevel;
run;

/* Insurance × Poverty */
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class UsualCare (ref='No routine place of care')
          PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither')
          / param=ref;

    model UsualCare(ref='No routine place of care') =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          PovertyUnder200*InsuranceType;
run;

/* Insurance × HealthCondition */
proc surveylogistic data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class UsualCare (ref='No routine place of care')
          PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither')
          / param=ref;

    model UsualCare(ref='No routine place of care') =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          InsuranceType*HealthCondition;
run;


/*----------------------------------------------------
 Linear regressions: PrescriptionCount - InsuranceType Interactions
----------------------------------------------------*/

/* Insurance × Age */
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither');

    model PrescriptionCount =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          InsuranceType*AgeCat / solution;
run;

/* Insurance × Race */
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither');

    model PrescriptionCount =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          InsuranceType*RaceCat / solution;
run;

/* Insurance × Gender */
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither');

    model PrescriptionCount =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          InsuranceType*Gender / solution;
run;

/* Insurance × Education */
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither');

    model PrescriptionCount =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          InsuranceType*EducationLevel / solution;
run;

/* Insurance × Poverty */
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither');

    model PrescriptionCount =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          PovertyUnder200*InsuranceType / solution;
run;

/* Insurance × HealthCondition */
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    class PovertyUnder200 (ref='At or Above 200% Federal Poverty Level')
          AgeCat (ref='65+')
          RaceCat (ref='Non-Hispanic White')
          Gender (ref='Male')
          EducationLevel (ref='Some college+')
          InsuranceType (ref='Private')
          HealthCondition (ref='Neither');

    model PrescriptionCount =
          PovertyUnder200 AgeCat RaceCat Gender EducationLevel InsuranceType HealthCondition
          InsuranceType*HealthCondition / solution;
run;

/*----------------------------------------------------
 Linear regressions: PrescriptionCount - Confirming Significant Interactions + LSMeans
----------------------------------------------------*/
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
