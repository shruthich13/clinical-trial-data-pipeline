/******************************************
* STEP 6 - STEP6_tlf_demographics.sas
* Table 14.1.1 - Demographics Summary
* Input:  ADAM.ADSL
* Output: C:\Clinical_Project\tlf\t1411_demographics.rtf
* Author: Shruthi Chintalapudi - 24099849
******************************************/

libname ADAM "C:\Clinical_Project\adam";
libname TLF  "C:\Clinical_Project\tlf";

ods rtf file="C:\Clinical_Project\tlf\t1411_demographics.rtf"
        style=journal;
ods noproctitle;

title1 "Table 14.1.1";
title2 "Summary of Demographics and Baseline Characteristics";
title3 "Safety Analysis Set (SAFFL=Y, N=254)";
footnote1 "Source: ADAM.ADSL | Program: STEP6_tlf_demographics.sas";
footnote2 "Study: CDISCPILOT01 | Date: &sysdate";

/* Age */
proc means data=ADAM.ADSL (where=(SAFFL="Y"))
           n mean std min max maxdec=1;
    class TRT01P;
    var AGE;
    title4 "Age (Years)";
run;

/* Age Group */
data adsl_ag;
    set ADAM.ADSL;
    where SAFFL="Y";
    if      AGE < 65        then AGEGR="<65";
    else if 65 <= AGE <= 80 then AGEGR="65-80";
    else                         AGEGR=">80";
run;

proc freq data=adsl_ag;
    tables TRT01P * AGEGR / nocol nopercent;
    title4 "Age Group - n (%)";
run;

/* Sex */
proc freq data=ADAM.ADSL (where=(SAFFL="Y"));
    tables TRT01P * SEX / nocol nopercent;
    title4 "Sex - n (%)";
run;

/* Race */
proc freq data=ADAM.ADSL (where=(SAFFL="Y"));
    tables TRT01P * RACE / nocol nopercent;
    title4 "Race - n (%)";
run;

/* Ethnicity */
proc freq data=ADAM.ADSL (where=(SAFFL="Y"));
    tables TRT01P * ETHNIC / nocol nopercent;
    title4 "Ethnicity - n (%)";
run;

ods rtf close;
title; footnote;

%put NOTE: ===== STEP 6 COMPLETE - TABLE 14.1.1 CREATED =====;
%put NOTE: Open C:\Clinical_Project\tlf\t1411_demographics.rtf;
