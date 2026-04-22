/******************************************
* STEP 7 - STEP7_tlf_teae.sas
* Table 14.3.1 - Treatment-Emergent AE Summary
* Input:  ADAM.ADAE + ADAM.ADSL
* Output: C:\Clinical_Project\tlf\t1431_teae.rtf
* Author: Shruthi Chintalapudi - 24099849
******************************************/

libname ADAM "C:\Clinical_Project\adam";
libname TLF  "C:\Clinical_Project\tlf";

/* Merge treatment group onto ADAE */
proc sort data=ADAM.ADSL out=adsl_s; by USUBJID; run;
proc sort data=ADAM.ADAE out=adae_s; by USUBJID; run;

data teae;
    merge adae_s (in=inAE)
          adsl_s (keep=USUBJID TRT01P SAFFL);
    by USUBJID;
    if inAE and TRTEMFL="Y" and SAFFL="Y";
run;

ods rtf file="C:\Clinical_Project\tlf\t1431_teae.rtf"
        style=journal;
ods noproctitle;

title1 "Table 14.3.1";
title2 "Summary of Treatment-Emergent Adverse Events";
title3 "Safety Analysis Set (SAFFL=Y) | Treatment-Emergent (TRTEMFL=Y)";
footnote1 "TEAE = onset on or after first dose date (TRTSDT)";
footnote2 "Source: ADAM.ADAE | Program: STEP7_tlf_teae.sas";

/* Overall counts */
proc freq data=teae;
    tables TRT01P / nocum;
    title4 "Number of Treatment-Emergent AEs by Group";
run;

/* By Severity */
proc freq data=teae;
    tables TRT01P * AESEV / nocol nopercent;
    title4 "TEAEs by Severity";
run;

/* Serious AEs */
proc freq data=teae;
    where AESER="Y";
    tables TRT01P / nocum;
    title4 "Serious Adverse Events (AESER=Y)";
run;

/* By SOC and PT */
proc freq data=teae;
    tables TRT01P * AEBODSYS * AEDECOD / nocol nopercent list;
    title4 "TEAEs by System Organ Class and Preferred Term";
run;

ods rtf close;
title; footnote;

%put NOTE: ===== STEP 7 COMPLETE - TABLE 14.3.1 CREATED =====;
%put NOTE: Open C:\Clinical_Project\tlf\t1431_teae.rtf;
