/******************************************
* Shows pipeline running live in front of audience
* Author: Shruthi Chintalapudi - 24099849
******************************************/

libname SDTM "C:\Clinical_Project\sdtm";
libname ADAM "C:\Clinical_Project\adam";
libname TLF  "C:\Clinical_Project\tlf";

/* Merge treatment onto ADAE */
proc sort data=ADAM.ADSL out=adsl_s; by USUBJID; run;
proc sort data=ADAM.ADAE out=adae_s; by USUBJID; run;

data adae_merged;
    merge adae_s (in=inAE)
          adsl_s (keep=USUBJID TRT01P SAFFL);
    by USUBJID;
    if inAE;
run;

/* ============================================
   DEMO PART 1 - Show real patients
 "Here are real patients from the trial"
   ============================================ */
title "DEMO 1: Real Patients - High Dose Group (5 of 84)";
proc print data=ADAM.ADSL (obs=5);
    where TRT01P="Xanomeline High Dose";
    var USUBJID AGE SEX RACE TRT01P SAFFL ITTFL;
run;

/* ============================================
   DEMO PART 2 - Show their side effects
   "These are their treatment-emergent side effects"
   ============================================ */
title "DEMO 2: Their Side Effects After Treatment";
proc print data=adae_merged (obs=8);
    where TRT01P="Xanomeline High Dose" and TRTEMFL="Y";
    var USUBJID AETERM AESEV ASTDY TRTEMFL;
run;

/* ============================================
   DEMO PART 3 - Show counts by group
  "More drug = more side effects"
   ============================================ */
title "DEMO 3: Side Effect Counts by Treatment Group";
proc freq data=adae_merged;
    where TRTEMFL="Y";
    tables TRT01P / nocum;
run;

/* ============================================
   DEMO PART 4 - Generate live TLF output
   "Now I generate the regulatory table live"
   ============================================ */
ods rtf file="C:\Clinical_Project\tlf\LIVE_DEMO_output.rtf"
        style=journal;

title1 "Table 14.1.1 - Demographics Summary";
title2 "Safety Analysis Set (N=254) - Generated LIVE";

proc means data=ADAM.ADSL (where=(SAFFL="Y"))
           n mean std min max maxdec=1;
    class TRT01P;
    var AGE;
    title3 "Age (Years) by Treatment Group";
run;

proc freq data=ADAM.ADSL (where=(SAFFL="Y"));
    tables TRT01P * SEX / nocol nopercent;
    title3 "Sex - n (%)";
run;

proc freq data=ADAM.ADSL (where=(SAFFL="Y"));
    tables TRT01P * RACE / nocol nopercent;
    title3 "Race - n (%)";
run;

ods rtf close;

%put NOTE: ===== LIVE DEMO COMPLETE =====;
%put NOTE: Open C:\Clinical_Project\tlf\LIVE_DEMO_output.rtf to show audience;
