/******************************************
* STEP 5 - STEP5_adam_adae.sas
* Verifies ADaM ADAE dataset + TRTEMFL flag
* Input:  ADAM.ADAE + ADAM.ADSL
* Output: Verified ADAE with treatment flags
* Author: Shruthi Chintalapudi - 24099849
******************************************/

libname ADAM "C:\Clinical_Project\adam";

/* ---- Merge ADAE with ADSL to get TRT01P ---- */
proc sort data=ADAM.ADSL out=adsl_s; by USUBJID; run;
proc sort data=ADAM.ADAE out=adae_s; by USUBJID; run;

data adae_merged;
    merge adae_s (in=inAE)
          adsl_s (keep=USUBJID TRT01P TRT01PN SAFFL);
    by USUBJID;
    if inAE;
run;

/* ---- QC Check 1: TEAE flag counts ---- */
proc freq data=adae_merged;
    tables TRTEMFL AESEV AESER / missing;
    title "ADAE - TEAE Flag, Severity, Serious AE";
run;

/* ---- QC Check 2: TEAEs by treatment group ---- */
proc freq data=adae_merged;
    where TRTEMFL = "Y";
    tables TRT01P / nocum;
    title "ADAE - Treatment-Emergent AEs by Group";
run;

/* ---- QC Check 3: Print first 5 TEAEs ---- */
proc print data=adae_merged (obs=5);
    where TRTEMFL = "Y";
    var USUBJID TRT01P AETERM AESEV ASTDT ASTDY TRTEMFL;
    title "ADAE - First 5 Treatment-Emergent AEs";
run;

%put NOTE: ===== STEP 5 COMPLETE - ADAM ADAE VERIFIED =====;
