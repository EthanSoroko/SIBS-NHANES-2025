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
proc freq data=nhanes;
    tables AgeCat Gender RaceCat EducationLevel InsuranceType 
           UsualCare PrescriptionCount PovertyUnder200 HealthCondition / missing;
run;