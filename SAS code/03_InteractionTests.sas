/*----------------------------------------------------
 Reload dataset
----------------------------------------------------*/
libname outlib '/home/u64253021/Research Project/Datasets';

data nhanes;
    set outlib.nhanes_final_adults;
run;

/*----------------------------------------------------
 Logistic regressions: UsualCare
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
 Linear regressions: PrescriptionCount
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
