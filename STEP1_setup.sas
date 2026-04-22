/******************************************
* STEP 1 - 000_setup.sas
* RUN THIS FIRST - Always run before anything else
* Author: Shruthi Chintalapudi - 24099849
******************************************/

%let xpt_path = C:\Clinical_Project\rawdata;

libname SDTM "C:\Clinical_Project\sdtm";
libname ADAM "C:\Clinical_Project\adam";
libname TLF  "C:\Clinical_Project\tlf";

libname xdm   xport "&xpt_path.\dm.xpt";
libname xae   xport "&xpt_path.\ae.xpt";
libname xlb   xport "&xpt_path.\lb.xpt";
libname xvs   xport "&xpt_path.\vs.xpt";
libname xex   xport "&xpt_path.\ex.xpt";
libname xadsl xport "&xpt_path.\adsl.xpt";
libname xadae xport "&xpt_path.\adae.xpt";
libname xadvs xport "&xpt_path.\advs.xpt";
libname xadlb xport "&xpt_path.\adlbc.xpt";

proc copy in=xdm   out=SDTM; select DM;    run;
proc copy in=xae   out=SDTM; select AE;    run;
proc copy in=xlb   out=SDTM; select LB;    run;
proc copy in=xvs   out=SDTM; select VS;    run;
proc copy in=xex   out=SDTM; select EX;    run;
proc copy in=xadsl out=ADAM; select ADSL;  run;
proc copy in=xadae out=ADAM; select ADAE;  run;
proc copy in=xadvs out=ADAM; select ADVS;  run;
proc copy in=xadlb out=ADAM; select ADLBC; run;

%let studyid = CDISCPILOT01;
options nofmterr;

%put NOTE: ===== STEP 1 COMPLETE - ALL DATA LOADED =====;
%put NOTE: DM=306, AE=1191, ADSL=254, ADAE=1191;
