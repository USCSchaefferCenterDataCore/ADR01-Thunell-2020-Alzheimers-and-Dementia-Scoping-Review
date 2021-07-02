/*********************************************************************************************/
title1 'Candidate Drug Class Exploration';

* Author: PF;
* Purpose: Pulling Unique Persons within each Drug Class;
* Input: fdb_ndc_extract;
* Output: ndc_list;

options compress=yes nocenter ls=150 ps=200 errors=5 errorcheck=strict mprint merror
	mergenoby=warn varlenchk=warn dkricond=error dkrocond=error msglevel=i;
/*********************************************************************************************/

***** Pulling certain classes from First Databank - creating macro variables of relevant drug class names, separated into combo and solo;

***** Min & max years;
			%let minyear=2016;
			%let maxyear=2016;
			
***** List of all conditions;
			%let classes=ace arb beta calc diuretics renin amylinagonist biguanides dpp4 glp1 insulins ppi maoi snri ssri sari tricy nsaid atyp nonbarb antihist1st antihist2nd incontinence sulf thia antimanic antiplate;
			%let otherclasses=otherbenzo otherstathydro otherstatlipo otherstroke otherdmard;

* Creating macro variables out of conditions;
	%macro createmvar(list,var);
	data _null_;
		%global max;
		str="&list";
		call symput('max',countw(str));
	run;
		
	data _null_;
		str="&list";
		do i=1 to &max; 
			v=scan(str,i,"");
			call symput(compress('var'||"&var"||i),strip(v));
		end;
	%mend;
	
	%createmvar(&classes);run;

***** Hyperlipidemia;
%let g_otherstathydro=%nrstr(if gnn60 in("PRAVASTATIN SODIUM","ROSUVASTATIN CALCIUM"));
%let g_otherstatlipo=%nrstr(if gnn60 in("SIMVASTATIN","ATORVASTATIN CALCIUM","LOVASTATIN","FLUVASTATIN SODIUM","PITAVASTATIN CALCIUM") 
					 or hic3_desc in("ANTIHYPERLIP - HMG-COA&CALCIUM CHANNEL BLOCKER CB","ANTIHYPERGLY.DPP-4 INHIBITORS &HMG COA RI(STATINS)",
					"ANTIHYPERLIP.HMG COA REDUCT INHIB&CHOLEST.AB.INHIB","ANTIHYPERLIPIDEMIC-HMG COA REDUCTASE INHIB.&NIACIN"));

***** Hypertension;
%let g_ace=%nrstr("ANTIHYPERTENSIVES, ACE INHIBITORS","ACE INHIBITOR-CALCIUM CHANNEL BLOCKER COMBINATION","ACE INHIBITOR-THIAZIDE OR THIAZIDE-LIKE DIURETIC");
%let g_arb=%nrstr("ANTIHYPERTENSIVES, ANGIOTENSIN RECEPTOR ANTAGONIST","ANGIOTEN.RECEPTR ANTAG./CAL.CHANL BLKR/THIAZIDE CB","ANGIOTENSIN RECEPTOR BLOCKR-CALCIUM CHANNEL BLOCKR"
,"RENIN INHIBITOR,DIRECT & ANGIOTENSIN RECEPT ANTAG.","ANGIOTENSIN RECEPTOR ANTAG.-THIAZIDE DIURETIC COMB");
%let g_beta=%nrstr("BETA-ADRENERGIC BLOCKING AGENTS","ALPHA/BETA-ADRENERGIC BLOCKING AGENTS","BETA-ADRENERGIC BLOCKING AGENTS/THIAZIDE & RELATED");
%let g_calc=%nrstr("CALCIUM CHANNEL BLOCKING AGENTS","ANGIOTEN.RECEPTR ANTAG./CAL.CHANL BLKR/THIAZIDE CB","ANGIOTENSIN RECEPTOR BLOCKR-CALCIUM CHANNEL BLOCKR",
"ANTIHYPERLIP - HMG-COA&CALCIUM CHANNEL BLOCKER CB","RENIN INHIB, DIRECT& CALC.CHANNEL BLKR & THIAZIDE","RENIN INHIBITOR, DIRECT & CALCIUM CHANNEL BLOCKER",
"ACE INHIBITOR-CALCIUM CHANNEL BLOCKER COMBINATION");
%let g_diuretics=%nrstr("LOOP DIURETICS","THIAZIDE AND RELATED DIURETICS","ACE INHIBITOR-THIAZIDE OR THIAZIDE-LIKE DIURETIC","ANGIOTEN.RECEPTR ANTAG./CAL.CHANL BLKR/THIAZIDE CB",
"BETA-ADRENERGIC BLOCKING AGENTS/THIAZIDE & RELATED","RENIN INHIB, DIRECT& CALC.CHANNEL BLKR & THIAZIDE","RENIN INHIBITOR,DIRECT AND THIAZIDE DIURETIC COMB",
"ANGIOTENSIN RECEPTOR ANTAG.-THIAZIDE DIURETIC COMB");
%let g_renin=%nrstr("RENIN INHIB, DIRECT& CALC.CHANNEL BLKR & THIAZIDE","RENIN INHIBITOR, DIRECT & CALCIUM CHANNEL BLOCKER","RENIN INHIBITOR,DIRECT & ANGIOTENSIN RECEPT ANTAG.",
"RENIN INHIBITOR,DIRECT AND THIAZIDE DIURETIC COMB");


***** Diabetes - amylinagonist biguanides dpp4 dlp1 insulins other_megl other_sulf stat_dpp4 dpp4_big other_thia;
%let g_amylinagonist=%nrstr("ANTIHYPERGLYCEMIC, AMYLIN ANALOG-TYPE");
%let g_biguanides=%nrstr("ANTIHYPERGLYCEMIC, BIGUANIDE TYPE","ANTIHYPERGLYCEMIC,DPP-4 INHIBITOR & BIGUANIDE COMB",
"ANTIHYPERGLYCEMIC,THIAZOLIDINEDIONE & BIGUANIDE","ANTIHYPERGLYCEMIC,INSULIN-REL STIM.& BIGUANIDE CMB");
%let g_dpp4=%nrstr("ANTIHYPERGLYCEMIC, DPP-4 INHIBITORS","ANTIHYPERGLY.DPP-4 INHIBITORS &HMG COA RI(STATINS)","ANTIHYPERGLYCEMIC,DPP-4 INHIBITOR & BIGUANIDE COMB",
"ANTIHYPERGLY,DPP-4 ENZYME INHIB &THIAZOLIDINEDIONE");
%let g_glp1=%nrstr("ANTIHYPERGLY,INCRETIN MIMETIC(GLP-1 RECEP.AGONIST)");
%let g_insulins=%nrstr("INSULINS");
%let g_sulf=%nrstr("ANTIHYPERGLYCEMIC, INSULIN-RELEASE STIMULANT TYPE","ANTIHYPERGLYCEMIC,INSULIN-REL STIM.& BIGUANIDE CMB",
"ANTIHYPERGLYCEMIC,THIAZOLIDINEDIONE & SULFONYLUREA");
%let g_thia=%nrstr("ANTIHYPERGLY,DPP-4 ENZYME INHIB &THIAZOLIDINEDIONE","ANTIHYPERGLYCEMIC,THIAZOLIDINEDIONE & BIGUANIDE",
"ANTIHYPERGLYCEMIC,THIAZOLIDINEDIONE & SULFONYLUREA","ANTIHYPERGLYCEMIC,THIAZOLIDINEDIONE(PPARG AGONIST)"); 

***** Gerd - hist2 ppi;
%let g_ppi=%nrstr("PROTON-PUMP INHIBITORS","NSAID, COX INHIBITOR-TYPE & PROTON PUMP INHIB COMB");

***** Stroke - otherstroke;
%let g_otherstroke=%nrstr(if tc_desc="ANTICOAGULANTS");
     
***** Depression -maoi snri ssri sari tricy alpha2 depr_comb;
%let g_maoi=%nrstr("MAOIS - NON-SELECTIVE & IRREVERSIBLE");
%let g_snri=%nrstr("SEROTONIN-NOREPINEPHRINE REUPTAKE-INHIB (SNRIS)");
%let g_ssri=%nrstr("SELECTIVE SEROTONIN REUPTAKE INHIBITOR (SSRIS)","SSRI & 5HT1A PARTIAL AGONIST ANTIDEPRESSANT",
"SSRI & ANTIPSYCH,ATYP,DOPAMINE&SEROTONIN ANTAG CMB");
%let g_sari=%nrstr("SEROTONIN-2 ANTAGONIST/REUPTAKE INHIBITORS (SARIS)");
%let g_tricy=%nrstr("TRICYCLIC ANTIDEPRESSANTS & REL. NON-SEL. RU-INHIB","TRICYCLIC ANTIDEPRESSANT/BENZODIAZEPINE COMBINATNS",
"TRICYCLIC ANTIDEPRESSANT/PHENOTHIAZINE COMBINATNS"); 

***** Inflammation -nsaid nsaid_comb;
%let g_nsaid=%nrstr("1ST GEN ANTIHIST-DECON-NSAID,COX NONSPEC","NASAL NSAIDS, COX NON-SELECTIVE,SYSTEMIC ANALGESIC","NSAIDS, CYCLOOXYGENASE INHIBITOR - TYPE ANALGESICS",
"NSAIDS,COX-2 SEL.INHIB.(SYST)-TOP.IRRITANT CTR-IRR","NSAIDS,CYCLOOXYGENASE-2(COX-2) SELECTIVE INHIBITOR","TOPICAL ANTI-INFLAMMATORY, NSAIDS",
"ANALGESIC,NSAID-1ST GEN.ANTIHISTAMINE,SEDATIVE CMB","ANALGESICS, NARCOTIC AGONIST AND NSAID COMBINATION","DECONGESTANT-NSAID, COX NON-SPEC COMB.",
"NSAID & HISTAMINE H2 RECEPTOR ANTAGONIST COMB.","NSAID, COX INHIBITOR-TYPE & PROTON PUMP INHIB COMB","NSAIDS (COX NON-SPECIFIC INHIB)& PROSTAGLANDIN CMB",
"NSAIDS/DIETARY SUPPLEMENT COMBINATIONS","PATENT DUCTUS ARTERIOSUS TREAT. AGENTS, NSAID-TYPE"); 

***** Insomnia- atyp otherbenzo nonbarb insom_comb;
%let g_atyp=%nrstr("ANTIPSYCHOTIC,ATYPICAL,DOPAMINE,SEROTONIN ANTAGNST","ANTIPSYCHOTICS, ATYP, D2 PARTIAL AGONIST/5HT MIXED",
"ANTIPSYCHOTIC-ATYPICAL,D3/D2 PARTIAL AG-5HT MIXED","SSRI & ANTIPSYCH,ATYP,DOPAMINE&SEROTONIN ANTAG CMB");
%let g_otherbenzo=%nrstr(if (find(ahfs_desc,"BENZODIAZEPINES") and hic3_desc not in("SEDATIVE-HYPNOTICS,NON-BARBITURATE","GENERAL ANESTHETICS,INJECTABLE","BULK CHEMICALS")) or 
(hic3_desc in ("TRICYCLIC ANTIDEPRESSANT/BENZODIAZEPINE COMBINATNS")));
%let g_nonbarb=%nrstr("SEDATIVE-HYPNOTICS,NON-BARBITURATE","SEDATIVE-HYPNOTICS,NON-BARBITURATE/DIETARY SUPP.",
"HYPNOTICS, MELATONIN MT1/MT2 RECEPTOR AGONISTS","HYPNOTICS, MELATONIN AND HERBAL COMBINATIONS","HYPNOTICS, MELATONIN COMBINATIONS OTHER");

***** Allergies - antihist1st antihist2nd antihist1st_analg antihist1st_decon antihist1st_narc antihist1st_nonnarc antihist2nd_comb;
%let g_antihist1st=%nrstr("ANTIHISTAMINES - 1ST GENERATION","ANALGESIC,NSAID-1ST GEN.ANTIHISTAMINE,SEDATIVE CMB","ANALGESIC, NON-SAL.- 1ST GENERATION ANTIHISTAMINE",
"ANALGESICS, MIXED-1ST GEN ANTIHISTAMINE-XANTHINE","1ST GEN ANTIHISTAMINE & DECONGESTANT COMBINATIONS","1ST GEN ANTIHISTAMINE-DECONGESTANT WITH ZINC COMB","1ST GEN ANTIHISTAMINE-DECONGESTANT-ANALGESIC COMB",
"1ST GEN ANTIHISTAMINE-DECONGESTANT-EXPECTORANT CMB","1ST GEN ANTIHISTAMINE-EXPECTORANT COMBINATIONS","1ST GENERATION ANTIHISTAMINE-ANTICHOLINERGIC COMB.","1ST GEN ANTIHIST-DECON-ANALGESIC, SALICYLATE",
"NON-NARC ANTITUSS-1ST GEN. ANTIHISTAMINE-DECONGEST","NON-NARC ANTITUSSIVE-1ST GEN ANTIHISTAMINE COMB.","N-NARC ATUS-GEN1 ANTIHIST-DECON-SALICYLT",
"NARC ANTITUSS-1ST GEN ANTIHISTAMINE-ANALG,N-SAL CB","NARCOTIC ANTITUSS-1ST GEN. ANTIHISTAMINE-DECONGEST","NARCOTIC ANTITUSSIVE-1ST GENERATION ANTIHISTAMINE"); 
%let g_antihist2nd=%nrstr("ANTIHISTAMINES - 2ND GENERATION","2ND GEN ANTIHISTAMINE & DECONGESTANT COMBINATIONS","2ND GEN ANTIHISTAMINE & DECONGESTANT COMBINATIONS");

***** Incontinence - incontinence;
%let g_incontinence=%nrstr("ANTICHOLINERGICS/ANTISPASMODICS","ANTISPASMODIC AGENTS","URINARY TRACT ANTISPASMODIC, M(3) SELECTIVE ANTAG.","URINARY TRACT ANTISPASMODIC/ANTIINCONTINENCE AGENT");

***** DMARD;
%let g_otherdmard=%nrstr(if ahfs_desc="DISEASE-MODIFYING ANTIRHEUMATIC AGENTS");

***** Antimanic agents;
%let g_antimanic=%nrstr("BIPOLAR DISORDER DRUGS");

***** Antiplatelets;
%let g_antiplate=%nrstr("PLATELET AGGREGATION INHIBITORS");

***** Flagging NDCs of interest in first data bank, creating a new hic3 definition grouping together combinations;
%macro fdb_pull;
data &tempwork..fdb;
	set fdb.fdb_ndc_extract;
	%do i=1 %to &max;
		%let condition=%scan(&classes,&i);
		if hic3_desc in(&&g_&condition) then &condition=1; else &condition=0;
	%end;
	%let o=1;
	%let other=%scan(&otherclasses,&o);
	%put &other;
	%do %while(%length(&other)>0);
		&&g_&other then &other=1; else &other=0;
		%let o=%eval(&o+1);
		%let other=%scan(&otherclasses,&o);
	%end;
	* adjusting antidepressants;
	tetra=0;
	if find(hic3_desc,'TRICYCLIC') then tricy=1;
	if hic3_desc='ALPHA-2 RECEPTOR ANTAGONIST ANTIDEPRESSANTS' then alpha2=1;
	if find(gnn,'MIRTAZAPINE') or find(gnn,'MAPROTILINE') or find(gnn,'MIANSERIN') or find(gnn,'SETIPTILINE') then do;
		tricy=0;
		alpha2=0;
		tetra=1;
	end;
	if max(of ace--tetra)=1;
	keep ndc ace--tetra;
run;
%mend;

%fdb_pull;

***** Counting how many unique beneficiaries in each condition;

%macro pde;

%do year=&minyear %to &maxyear;
data &tempwork..pde_&year;
	set pde&year..pde_demo_&year._01-pde&year..pde_demo_&year._12;
run;

proc sql;
	create table &tempwork..pde_&year.bene as
	select x.bene_id, y.*
	from &tempwork..pde_&year. as x inner join &tempwork..fdb as y
	on x.prod_srvc_id=y.ndc;
quit;

proc sql;
	create table &tempwork..pde_&year.benesum as
	select bene_id, max(ace) as ace, max(arb) as arb, max(beta) as beta, max(calc) as calc, max(diuretics) as diuretics, 
	max(renin) as renin, max(amylinagonist) as amylinagonist, max(biguanides) as biguanides, max(dpp4) as dpp4, 
	max(glp1) as glp1, max(insulins) as insulins, max(ppi) as ppi, max(maoi) as maoi, max(snri) as snri, max(ssri) as ssri, max(sari) as sari,
	max(tricy) as tricy, max(nsaid) as nsaid, max(atyp) as atyp, max(nonbarb) as nonbarb, max(antihist1st) as antihist1st,
	max(antihist2nd) as antihist2nd, max(incontinence) as incontinence, max(sulf) as sulf, max(thia) as thia,
	max(otherbenzo) as otherbenzo, max(otherstathydro) as otherstathydro, max(otherstatlipo) as otherstatlipo, max(otherstroke) as otherstroke,
	max(tetra) as tetra, max(otherdmard) as otherdmard, max(antimanic) as antimanic, max(antiplate) as antiplate
	from &tempwork..pde_&year.bene
	group by bene_id;
quit;

proc means data=&tempwork..pde_&year.benesum noprint nway;
	var ace--antiplate;
	output out=by_class&year. sum()=;
run;

proc export data=by_class&year.
	outfile="&rootpath./AD/ProjPgm/ptd_summaries/2016count_clean.xlsx"
	dbms=xlsx
	replace;
	sheet="&year.";
run;

data &tempwork..benecount&year.;
	merge &tempwork..pde_&year.benesum (in=a) SH051378.bene_status_year2016 (in=b keep=bene_id anyptd where=(anyptd='Y'));
	by bene_id;
	rxuser=(max(of ace--antiplate)=1);
	pde=a;
	ptd=b;
run;

proc freq data=&tempwork..benecount&year.;
	table pde*ptd / out=&tempwork..freq_benecount&year.;
run;
%end;
%mend;

%pde;


options obs=max;
