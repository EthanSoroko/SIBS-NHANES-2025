/*----------------------------------------------------
 Reload NHANES dataset
----------------------------------------------------*/

/* Define the library again (must be run every new session) */
libname outlib '/home/u64253021/Research Project/Datasets';

/* Load the saved dataset back into WORK for analysis */
data nhanes;
    set outlib.nhanes_final_adults;
run;

/*----------------------------------------------------
 Descriptive Statistics
----------------------------------------------------*/
proc surveyfreq data=nhanes;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;

    tables AgeCat Gender RaceCat EducationLevel InsuranceType
           UsualCare PrescriptionCount PovertyUnder200 HealthCondition
           PovertyUnder200*AgeCat
           / row;
run;

