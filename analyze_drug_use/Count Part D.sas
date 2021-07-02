/*********************************************************************************************/
title1 'Candidate Drug Class Exploration';

* Author: PF;
* Purpose: Get count/% of Medicare beneficiaries with Part D in 2016;
* Input: bene_status_year2016;
* Output:;

options compress=yes nocenter ls=150 ps=200 errors=5 errorcheck=strict mprint merror
	mergenoby=warn varlenchk=warn dkricond=error dkrocond=error msglevel=i;
/*********************************************************************************************/

proc freq data=SH051378.bene_status_year2016;
	table anyptD ptD_allyr;
	table anyHMO*anyptD / out=HMOany_ptDany2016;
	table enrHMO_allyr*anyptD / out=HMOallyr_ptDany2016;
	table enrHMO_allyr*ptD_allyr / out=HMOallyr_ptDallyr2016 outpct;
	table enrFFS_allyr*anyptD / out=FFSallyr_ptDany2016;
	table enrFFS_allyr*ptD_allyr / out=FFSallyr_ptDallyr2016;
run;