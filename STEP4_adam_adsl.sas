/******************************************
* STEP 4 - STEP4_adam_adsl.sas
* Verifies ADaM ADSL dataset
* Input:  ADAM.ADSL (already loaded in Step 1)
* Output: Verified ADAM.ADSL with QC checks
* Author: Shruthi Chintalapudi - 24099849
******************************************/

libname ADAM "C:\Clinical_Project\adam";

/* ---- Verify ADSL loaded correctly ---- */
proc contents data=ADAM.ADSL;
    title "ADAM.ADSL - 254 subjects, 48 variables";
run;

/* ---- QC Check 1: Population flags ---- */
proc freq data=ADAM.ADSL;
    tables TRT01P SAFFL ITTFL EFFFL / missing;
    title "ADSL - Treatment Groups and Population Flags";
run;

/* ---- QC Check 2: Treatment dates ---- */
proc means data=ADAM.ADSL n nmiss min max;
    var TRTSDT TRTEDT TRTDUR AGE;
    format TRTSDT TRTEDT date9.;
    title "ADSL - Treatment Dates and Age";
run;

/* ---- QC Check 3: Age by treatment ---- */
proc means data=ADAM.ADSL (where=(SAFFL="Y"))
           n mean std min max maxdec=1;
    class TRT01P;
    var AGE;
    title "ADSL - Age by Treatment Group (Safety Set)";
run;

/* ---- QC Check 4: Print first 5 records ---- */
proc print data=ADAM.ADSL (obs=5);
    var USUBJID AGE SEX RACE TRT01P TRT01PN TRTSDT TRTEDT SAFFL ITTFL;
    title "ADSL - First 5 Records";
run;

%put NOTE: ===== STEP 4 COMPLETE - ADAM ADSL VERIFIED =====;
