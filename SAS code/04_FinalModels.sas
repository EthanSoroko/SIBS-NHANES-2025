/*Questions:

What is our overall model based on these tests?
	HUQ030 =
	RXQ050 =
	
Do we want to look at interactions between HUQ030 and RXQ050? Too broad, could suggest this as a future area of research.

RACE vs RIDRETH3 variable? - Does using the RACE variable change the weights? (removed the other/ multiracial category)
AGE vs RIDAGEYR variable?

What is the interpretation of the Odds Ratio when we're stratifying?

*/

/* HUQ030 */

proc surveylogistic data=nhanes;
    domain AGE;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') RIAGENDR (ref="Male") RACE (ref='Non-Hispanic White') AGE (ref = '65+')/param=ref;
    model HUQ030 (ref='No') = FPL_LT200 RIAGENDR RACE;
run;

/*Interpretation: ? */

proc surveylogistic data=nhanes;
    domain RACE;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') RIAGENDR (ref="Male") RACE (ref='Non-Hispanic White') / param=ref;
    model HUQ030 (ref='No') = FPL_LT200 RIAGENDR RIDAGEYR;
run;

/*Interpretation: ? */

proc surveylogistic data=nhanes;
    domain RIAGENDR;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') RIAGENDR (ref="Male") RACE (ref='Non-Hispanic White') / param=ref;
    model HUQ030 (ref='No') = FPL_LT200 RIDAGEYR RACE;
run;

/*Interpretation: ? */

/* RXQ050 */

proc surveyreg data=nhanes;
    domain AGE;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') RIAGENDR (ref="Male") RACE (ref='Non-Hispanic White') AGE (ref = '65+');
    model RXQ050 = FPL_LT200 RACE RIAGENDR / solution clparm;
run;

/*Interpretation: ? */

proc surveyreg data=nhanes;
    domain RACE;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') RIAGENDR (ref="Male") RACE (ref='Non-Hispanic White') AGE (ref = '65+');
    model RXQ050 = RIDAGEYR FPL_LT200 RIAGENDR / solution clparm;
run;

/*Interpretation: ? */

proc surveyreg data=nhanes;
    domain RIAGENDR;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') RIAGENDR (ref="Male") RACE (ref='Non-Hispanic White') AGE (ref = '65+');
    model RXQ050 = RIDAGEYR FPL_LT200 RACE / solution clparm;
run;

/*Interpretation: ? */


/* RXQ050 with HUQ030 */

proc surveyreg data=nhanes;
    domain HUQ030;
    strata SDMVSTRA;
    cluster SDMVPSU;
    weight WTINT2YR;
    class FPL_LT200 (ref='At or Above 200% Federal Poverty Level') RIAGENDR (ref="Male") RACE (ref='Non-Hispanic White') AGE (ref = '65+');
    model RXQ050 = RIDAGEYR FPL_LT200 RACE RIAGENDR / solution clparm;
run;

/* makes statistic for Non-Hispanic Black more signficant? */

/*Interpretation: ? */
