/******************** Homework 7 - Proc SQL********************/
libname class7 "C:/Irene Hsueh's Documents\MS Applied Biostatistics/BS 803 - Statistical Programming for Biostatisticians/Class 7 - Proc SQL/Lecture";

/* Question 1 */
title "Hospital 2 Admissions";
proc sql feedback;
	create table hospital2 as 
	select pt_id, hosp, admdate, disdate 
	from class7.admissions
	where hosp=2;
run;

proc print data=hospital2;
run;
title;



/* Question 2 */
title "Length of Stay Over 3 Weeks"; 
proc sql feedback;
	create table length_of_stay21 as 
	select pt_id, hosp, admdate, disdate,  
		(disdate - admdate) + 1 as length_of_stay
	from class7.admissions
	where calculated length_of_stay >= 21 
	order by length_of_stay;
run;

proc print data=length_of_stay21;
run;
title;



/* Question 3 */
title "List of Unique Patients Who Visited ER";
proc sql feedback;
	create table distinct_patients_er as 
	select distinct pt_id
	from class7.ervisits;
run;

proc print data=distinct_patients_er;
run;
title;



/* Question 4a */
title "Left Join to Add Information About Admitted Patients";
proc sql feedback;
	create table admissions_info as 
	select a.*, b.sex, b.dob format=date9., b.primmd
	from class7.admissions as a
		left join class7.patients as b
		on a.pt_id = b.id
	order by pt_id;
run;

proc print data=admissions_info;
run;
title;



/* Question 4b */
title "Left Joins to Add Information About Admitted Patients";
proc sql feedback;
	create table admissions_info2 as 
	select a.*, b.sex, b.dob format=date9., b.primmd, c.lastname as primmd_name
	from class7.admissions as a
		left join class7.patients as b
		on a.pt_id = b.id
			left join (select distinct md_id, lastname from class7.doctors) as c
			on b.primmd = c.md_id;
run;

proc print data=admissions_info2;
run;
title;



ODS HTML close;
ODS HTML;



/* Question 5 */
title "Full Outer Join of Admissions and ER Visits";
proc sql feedback;
	create table all_hospital_visits as
	select coalesce(a.pt_id, b.pt_id) as pt_id format=z3.,
		a.admdate as hospital_admit_date format=date9., a.hosp, 
		b.visitdate as er_visit_date format=date9., b.er 
	from class7.admissions as a
		full outer join class7.ervisits as b
		on a.pt_id = b.pt_id;
run;

proc print data=all_hospital_visits;
run;
title;



/* Question 6a */
title "ER Visits Summary";
proc sql feedback;
	select 
		n(distinct pt_id)	as n_patients,
		min(visitdate)		as first_er_visit 	format=date9., 
		max(visitdate)		as last_er_visit	format=date9.
	from class7.ervisits;
run;
title;



/* Question 6b */
title "ER Visits Summary by Hospital";
proc sql feedback;
	select 
		er,
		n(distinct pt_id)	as n_patients,
		min(visitdate)		as first_er_visit 	format=date9., 
		max(visitdate)		as last_er_visit	format=date9.
	from class7.ervisits
	group by er;
run;
title;



/* Question 6c */
title "ER Visits Summary by Hospitals with More than 4 Patients";
proc sql feedback;
	select 
		er,
		n(distinct pt_id)	as n_patients,
		min(visitdate)		as first_er_visit 	format=date9., 
		max(visitdate)		as last_er_visit	format=date9.
	from class7.ervisits
	group by er
	having n_patients >= 4;
run;
title;



/* Question 7 */
title "Subquery to Select Patients only in Fake Dataset";
proc sql feedback;
	create table unique_fake_subjects as 
	select * from class7.fake
	where id not in 
		(select sub_id from class7.subjects);
run;

proc print data=unique_fake_subjects;
run;
title;



/* Question 8a */
title "Macro Variables for Admissions Data";
proc sql feedback;
	select put(n(pt_id), 3.), put(n(distinct pt_id), 3.)
	into :n_admissions, :n_patients
	from class7.admissions;
run;
title;



/* Question 8b */
%put Number of Admissions from 2010 to 2011 in Six Hospitals = &n_admissions;
%put Number of Unique Patients with Admissions from 2010 to 2011 in Six Hospitals = &n_patients;



/* Question 8c */
title "Creating List of Macro Variables";
proc sql feedback;
	select distinct pt_id 
	into :id1 through :id20
	from class7.ervisits;
run;
%put &id1., &id2., &id3., &id4., &id5., &id6., &id7., &id8., &id9., &id10., 
	&id11., &id12., &id13., &id14., &id15., &id16., , &id17., , &id18., , &id19., &id20.;
title;


%put _user_;







