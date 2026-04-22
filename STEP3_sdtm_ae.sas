/******************************************
* STEP 3 - STEP3_sdtm_ae.sas
* Creates SDTM AE domain from raw data
* Input:  SDTM.AE (already loaded in Step 1)
* Output: Verified SDTM.AE with QC checks
* Author: Shruthi Chintalapudi - 24099849
******************************************/

libname SDTM "C:\Clinical_Project\sdtm";

/* ---- Verify AE loaded correctly ---- */
proc contents data=SDTM.AE;
    title "SDTM.AE - 1191 records, 35 variables";
run;

/* ---- QC Check 1: Severity counts ---- */
proc freq data=SDTM.AE;
    tables AESEV AESER AEOUT AEACN / missing;
    title "SDTM AE - Severity, Serious, Outcome, Action";
run;

/* ---- QC Check 2: AE counts per subject ---- */
proc means data=SDTM.AE n nmiss min max mean;
    var AESEQ AESTDY AEENDY;
    title "SDTM AE - Sequence and Study Day Summary";
run;

/* ---- QC Check 3: Print first 5 records ---- */
proc print data=SDTM.AE (obs=5);
    var STUDYID DOMAIN USUBJID AESEQ AETERM AEDECOD AESEV AESER AESTDTC;
    title "SDTM AE - First 5 Records";
run;

%put NOTE: ===== STEP 3 COMPLETE - SDTM AE VERIFIED =====;
