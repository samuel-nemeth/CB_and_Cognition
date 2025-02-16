capture log close
log using CB&C.Drops, replace text
/* 

Program:	CB&C.Missing_Data_Drops.do

Task: 		Handling Missing Data do file 

Project: 	Racial and ethnic differences in community belonging and its impact 
			on cognitive function in older adults.

Author: 		Sam Nemeth (Created on: 4/25/24)

Last updated:	12/12/2024 (Sam Nemeth) 
	
Project description: 

Examining the effect of sense of community belonging at various time points
across the life course on cognitive function in later life. 

*/

******************************************************
// 0: Set working Directory and Load Data 
******************************************************

cd "/Users/samnemeth/Desktop/Papers/Final Papers/B&C Project/R&R/DATA"

use CB&C_Cleaned_Final

******************************************************
// 1: Dropping to get analysis sample  
******************************************************

*1. Dropping for 0 weights in 2014/2016 Half Sample

drop if weight1416m == 1 | mi(OWGTR)
dis _N

*2. Dropping if did not do LHMS Survey 

drop if lhpart==0
dis _N

*3. Dropping based on Cognition at baseline 

drop if Cog16<=6
dis _N

*4. Dropping if not White, Black, or Hispanic

drop if rce==.
dis _N

*5. Dropping if missing on Belonging variables 

drop if B10==.
drop if B40==.
drop if CurAgeB==.
dis _N

*Dropping if missing on 2018 cognition

drop if Cog18==.
dis _N

******************************************************
// 2: Performing Listwise Deletion 
******************************************************

drop if Cog16==.
drop if age==.
drop if fem==.
drop if region==.
drop if married==.
drop if educ==.
drop if wlth==.
drop if depress==.
drop if web2018==.

*			Final Analysis Sample Size

dis _N 

******************************************************
// 3: Dropping variables unneeded for analysis 
******************************************************

drop OWGTR weight1416m lhpart 

******************************************************
// 4: Saving final data set for analysis 
******************************************************

compress
label data "HRS | CB&C | analysis | 12/12/24 | CB&C_analysis"
datasignature set, reset

************************************
save "CB&C_Analysis_Final", replace
************************************

log close
exit
NOTES: 

It was discovered that after publication (2/16/2025), 5 observations were not 
coded as missing leading to them not being dropped from the analysis sample. 
As such,the published sample size of 3,307 should have been 3,302. This was 
due to an error in the coding of the variables depress and region. SN reran 
the analysis with the corrected dataset, and the significance and direction 
of the results did not change from what was published. There were small 
small differences in the size of the point estimates. However, because the 
change in the effect size was very small, the publication was not amended to 
reflect this change. The author, SN, takes full responsiblity for this mistake.
Our commitment to transparancy in research leads us to note this here. 
Additionally, this change was not made to this file nor the analysis file to 
facilitate replication. 

	
	Citation: 

	Nemeth, S. R., Thomas, P. A., Stoddart, C. M., & Ferraro, K. F. (2025).
	Racial and ethnic differences in community belonging and its impact on 
	cognitive function in older adults. The Journals of Gerontology: Series B, 
	gbaf028. https://doi.org/10.1093/geronb/gbaf028
