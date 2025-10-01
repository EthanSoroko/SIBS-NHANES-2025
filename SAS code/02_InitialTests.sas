/*----------------------------------------------------
 Define the library & reload the final dataset
----------------------------------------------------*/
libname outlib '/home/u64253021/Research Project/Datasets';

data nhanes;
    set outlib.nhanes_final_adults;
run;

/*----------------------------------------------------
 Logistic regression:
 Usual place for healthcare (UsualCare) predicted by PovertyUnder200
 + other covariates
----------------------------------------------------*/
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
        / param=ref;
    model UsualCare(ref="Doctor's office / health center") =
        PovertyUnder200
        AgeCat
        Gender
        RaceCat
        EducationLevel
        InsuranceType
        PrescriptionCount
        HealthCondition;
run;

/*----------------------------------------------------
 Linear regression:
 PrescriptionCount predicted by PovertyUnder200
 + other covariates
----------------------------------------------------*/
proc surveyreg data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class 
        PovertyUnder200 (ref="At or Above 200% Federal Poverty Level")
        Gender (ref="Male")
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
        / solution clparm;
run;
