capture log close
log using CB&C.analysis, replace text
/* 

Program:	CB&C.Analysis.do

Task: 		Analysis do file 

Project: 	Racial and ethnic differences in community belonging and its impact 
			on cognitive function in older adults.

Author: 		Sam Nemeth (Created on: 12/12/24)

Last updated:	4/25/2024 (Sam Nemeth) 
	
Project description: 

Examining the effect of sense of community belonging at various time points
across the life course on cognitive function in later life. 

*/

******************************************************
// 0: Set working Directory and Load Data 
******************************************************

cd "/Users/samnemeth/Desktop/Papers/Final/Papers/B&C Project"
use CB&C_Analysis_Final

***************************************************************
// #1 - Table 1: Summary Statistics 
***************************************************************

foreach var in Cog18 Cog16 B10 B40 CurAgeB age educ wlth depress {
	summarize `var'
	by rce, sort : summarize `rce'
	ttest `var', by(Black)
	ttest `var', by(Hispanic)
	ttest `var', by(BH)
}

foreach var in fem region married web2018 {
	tab `var' rce, col row 
	tab `var' Black, chi
	tab `var' Hispanic, chi
	tab `var' BH, chi 
}

********************************************************************
// #2 - Supplementary Table   
********************************************************************

reg Cog18 B10, vce(robust)
est store A1

reg Cog18 B10 age i.fem i.rce married wlth educ web2018 c.depress i.region, ///
	vce(robust) 
est store A2

reg Cog18 B10 age i.fem married wlth educ web2018 c.depress i.region ///
	c.B10##i.rce, vce(robust)
est store A3

reg Cog18 B10 Cog16, vce(robust)
est store A4
 
reg Cog18 B10 Cog16 age i.fem i.rce married wlth educ web2018 c.depress ///
	i.region, vce(robust) 
est store A5

reg Cog18 B10 Cog16 age i.fem married wlth educ web2018 c.depress i.region ///
	c.B10##i.rce, vce(robust) 
est store A6

esttab A1 A2 A3 A4 A5 A6, se r2 ///
	star(* 0.05 ** 0.01 *** 0.001) noobs ///
	label title("Panel A: Age 10 Community Belonging") ///
	mtitles("Model 1a" "Model 2a" "Model3a" "Model 4a" "Model 5a" ///
			"Model 6a") replace

********************************************************************************

reg Cog18 B40, vce(robust)
est store B1

reg Cog18 B40 age i.fem i.rce married wlth educ web2018 c.depress i.region, ///
	vce(robust) 
est store B2

reg Cog18 B40 age i.fem married wlth educ web2018 c.depress i.region ///
	c.B40##i.rce, vce(robust)
est store B3

reg Cog18 B40 Cog16, vce(robust)
est store B4

reg Cog18 B40 Cog16 age i.fem i.rce married wlth educ web2018 c.depress ///
	i.region, vce(robust) 
est store B5

reg Cog18 B40 Cog16 age i.fem married wlth educ web2018 c.B40##i.rce ///
	c.depress i.region, vce(robust) 
est store B6

esttab B1 B2 B3 B4 B5 B6, se r2 ///
	star(* 0.05 ** 0.01 *** 0.001) noobs ///
	label title("Panel B: Age 40 Community Belonging") ///
	mtitles("Model 1b" "Model 2b" "Model3b" "Model 4b" "Model 5b" ///
			"Model 6b") replace

********************************************************************************

reg Cog18 CurAgeB, vce(robust)
est store C1

reg Cog18 CurAgeB age i.fem i.rce married wlth educ web2018 c.depress ///
	i.region, vce(robust) 
est store C2

reg Cog18 CurAgeB age i.fem married wlth educ web2018 c.depress i.region ///
	c.CurAgeB##i.rce, vce(robust)
est store C3

reg Cog18 CurAgeB Cog16, vce(robust)
est store C4

reg Cog18 CurAgeB age Cog16 i.fem i.rce married wlth educ web2018 c.depress ///
	i.region, vce(robust) 
est store C5

reg Cog18 CurAgeB age Cog16 i.fem married wlth educ web2018 c.depress ///
	i.region c.CurAgeB##i.rce, vce(robust) 
est store C6

esttab C1 C2 C3 C4 C5 C6, se r2 ///
	star(* 0.05 ** 0.01 *** 0.001) noobs ///
	label title("Panel C: Current Age Community Belonging") ///
	mtitles("Model 1c" "Model 2c" "Model3c" "Model 4c" "Model 5c" ///
			"Model 6c") replace
	
********************************************************************
// #2A - Table 2 
********************************************************************

*Model 1 no controls 

reg Cog18 B10 B40 CurAgeB, vce(robust) 
estimates store D1

*Model 2 with controls 

reg Cog18 B10 B40 CurAgeB age i.fem i.rce married wlth educ web2018 ///
	c.depress i.region, vce(robust) 
estimates store D2

*Interaction Belonging age 10*race/ethnicity

reg Cog18 B10 B40 CurAgeB age i.fem i.rce married wlth educ web2018 ///
	c.depress i.region c.B10##i.rce, vce(robust) 
estimates store D3

*Interaction Belonging age 40*race/ethnicity

reg Cog18 B10 B40 CurAgeB age i.fem i.rce married wlth educ web2018 ///
	c.depress i.region c.B40##i.rce, vce(robust) 
estimates store D4

*Interaction belonging current age*race/ethnicity

reg Cog18 B10 B40 CurAgeB age i.fem i.rce married wlth educ web2018 ///
	c.depress i.region c.CurAgeB##i.rce, vce(robust) 
estimates store D5

esttab D1 D2 D3 D4 D5, se r2 ///
	star(* 0.05 ** 0.01 *** 0.001) noobs ///
	label title("OLS Regression of the Impact of Community Belonging on 2018 Cognitive Function") ///
	mtitles("Model 1" "Model 2" "Model 3" "Model 4" "Model 5") nonumbers replace 

********************************************************************
// #3A - Table 4 OLS Interactions using 2016 cognition as a control 
********************************************************************

*Model 1 no controls 

reg Cog18 B10 B40 CurAgeB Cog16, vce(robust) 
estimates store E1

*Model 2 with controls 

reg Cog18 B10 B40 CurAgeB Cog16 age fem i.rce married wlth educ web2018 ///
	c.depress i.region, vce(robust) 
estimates store E2

*Interaction Belonging age 10*race/ethnicity

reg Cog18 B10 B40 CurAgeB Cog16 age fem i.rce married wlth educ web2018 ///
	c.depress i.region c.B10##i.rce, vce(robust) 
estimates store E3

*Interaction Belonging age 40*race/ethnicity

reg Cog18 B10 B40 CurAgeB Cog16 age fem i.rce married wlth educ web2018 ///
	c.depress i.region c.B40##i.rce, vce(robust) 
estimates store E4

*Interaction belonging current age*race/ethnicity

reg Cog18 B10 B40 CurAgeB Cog16 age fem i.rce married wlth educ web2018 ///
	c.depress i.region c.CurAgeB##i.rce, vce(robust) 
estimates store E5

esttab E1 E2 E3 E4 E5, se r2 ///
	star(* 0.05 ** 0.01 *** 0.001) noobs ///
	label title("Table 3. OLS Regression of the Impact of Community Belonging on the Change in Cognitive Function from 2016 to 2018") ///
	mtitles("Model 1" "Model 2" "Model 3" "Model 4" "Model 5") nonumbers ///
	replace 

********************************************************************
// #4 - Figure 1 Interactions graph by race/ethnicity with 2016 
// cognition as a control
********************************************************************
	
reg Cog18 B10 B40 CurAgeB age fem i.rce married wlth educ web2018 ///
	c.depress i.region c.B10##i.rce, vce(robust) 
margins i.rce, at(B10=(0 1 2 3 4 5 6))
marginsplot,  ///
	noci ///
	title("Panel A", size(large) position(11)) ///
	ylab(12(1)17) ///
	ytitle("Cognitive Function", size(medium large)) ///
	xtitle("Community Belonging at Age 10", size(medium large))  ///
	legend(off)
graph save figure1.gph, replace
graph export figure1.pdf, replace


*Age 10 Belonging by Race 

reg Cog18 B10 B40 CurAgeB age fem educ married wlth web2018 Cog16 ///
	c.depress i.region i.rce##c.B10, vce(robust) 
margins i.rce, at(B10=(0 1 2 3 4 5 6))
marginsplot, ///
	 noci ///
	 title("Panel B", size(large) position(11)) ///
	ylab(12(1)17) ///
	ytitle("Cognitive Function", size(medium large)) ///
	xtitle("Community Belonging at Age 10", size(medium large)) ///
	legend(off)
graph save figure2.gph, replace
graph export figure2.pdf, replace

graph combine figure1.gph figure2.gph, ///
	title("") 
	
graph export figure1.pdf, replace


log close
exit
NOTES: 
