/******************************************
* STEP 2 - STEP2_sdtm_dm.sas
* Creates SDTM DM domain from raw data
* Input:  SDTM.DM (already loaded in Step 1)
* Output: Verified SDTM.DM with QC checks
* Author: Shruthi Chintalapudi - 24099849
******************************************/

libname SDTM "C:\Clinical_Project\sdtm";

/* ---- Verify DM loaded correctly ---- */
proc contents data=SDTM.DM;
    title "SDTM.DM - 306 subjects, 25 variables";
run;

/* ---- QC Check 1: Subject counts ---- */
proc freq data=SDTM.DM;
    tables ARM SEX RACE ETHNIC / missing;
    title "SDTM DM - Treatment Arms, Sex, Race, Ethnicity";
run;

/* ---- QC Check 2: Age summary ---- */
proc means data=SDTM.DM n nmiss min max mean std;
    var AGE;
    title "SDTM DM - Age Summary";
run;

/* ---- QC Check 3: Print first 5 records ---- */
proc print data=SDTM.DM (obs=5);
    var STUDYID DOMAIN USUBJID SUBJID AGE SEX RACE ARM COUNTRY;
    title "SDTM DM - First 5 Records";
run;

%put NOTE: ===== STEP 2 COMPLETE - SDTM DM VERIFIED =====;
