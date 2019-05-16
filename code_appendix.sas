'Import Excel file as: ‘hepatitis’ into SAS';

proc print data=hepatitis;
run;
quit;

*take out protime variable since 67/155 are missing values;
data hep2;
set hepatitis;
drop prot;
run;
quit;
proc print data=hep2;
run;
quit;

* Correlation Matrix ;
proc corr data=hep2
rank;
run;
quit;

title 'Frequncy tables';
proc freq data=hep2;
tables ld sex steoid antiv fatigue malai anor livb livf spleen spid asc vari hist;
run;

title 'Correlation of continuous variables';
proc corr data=hep2
plots=matrix(histogram)
rank;
var age bili alk sgot albu ;
run;

Title 'Forward selection for logistic regression model testing alpha=0.05 or 0.1';
proc logistic data=hep2;
class sex steoid antiv fatigue malai anor livb livf spleen spid asc vari hist
/ param=ref;
model LD = sex steoid antiv fatigue malai anor livb livf spleen spid
asc vari hist age bili alk sgot albu
/ selection=forward
slentry=0.1
details;
run;

proc logistic data=hep2;
class sex steoid antiv fatigue malai anor livb livf spleen spid asc vari hist
/ param=ref;
model LD = sex steoid antiv fatigue malai anor livb livf spleen spid
asc vari hist age bili alk sgot albu
/ selection=forward
slentry=0.05
details ctable;
run;

*Creating new data set to test spid*asc;
title 'Data set with spid*asc';
data hep3;
set hep2;
spidasc=spid*asc;
run;
proc print data=hep3;
run;
quit;

Title 'Forward selection for logistic regression model-with spid*asc';
proc logistic data=hep3;
class sex steoid antiv fatigue malai anor livb livf spleen spid asc vari hist spidasc
/ param=ref;
model LD = sex steoid antiv fatigue malai anor livb livf spleen spid
asc vari hist age bili alk sgot albu spidasc
/ selection=forward
slentry=0.05
details ctable;
run;

Title 'table with cutoff probability=0.5 for our final model: spid, asc, spid*asc';
proc logistic data=hep3;
model LD= asc spidasc spid/
ctable pprob=0.5 ;
run;
