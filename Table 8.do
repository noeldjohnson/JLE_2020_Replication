** Replication File for Table 8 in Finley, Frank, and Johnson, ``The Effects of Land Redistribution: Evidence from the French Revolution'' published in the Journal of Law and Economics.
* Author: Noel Johnson
* Last Edited: 9/16/20

use "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/base wheat yield panel 1841_1929.dta"

log using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Table 8.log", replace

keep if sample==1

*Merge in new MA measures including own district and non-French cities
merge m:m id using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/Market Access with District different costs.dta"
keep if _merge==3
drop if id==.
count
drop _merge

*generate logs of MA variables
gen ln_ma_1789_bo_own_dist_default = ln(ma_1789_bo_own_dist_default)
gen ln_ma_1789_ba_own_dist_default = ln(ma_1789_ba_own_dist_default)
gen ln_ma_1789_ca_own_dist_default = ln(ma_1789_ca_own_dist_default)
gen ln_ma_1789_ma_own_dist_default = ln(ma_1789_ma_own_dist_default)

merge m:m id using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/France_Bishop_Near.dta"
drop if _merge==2
drop _merge

*Begin Analysis

*Table 8: Percent Land Confiscated in District and Wheat Yields Over Time
*Column 1: Using the district level RHS variables, but department level LHS variables
xi: reg lwheatyield i.year*super1adj i.year*wheatsuit i.year*ln_ma_1789_ba_own_dist_default i.year*i.FE13, cluster(deptid)
lincom super1adj
lincom super1adj + _IyeaXsup_1852
lincom super1adj + _IyeaXsup_1875
lincom super1adj + _IyeaXsup_1892
lincom super1adj + _IyeaXsup_1912
lincom super1adj + _IyeaXsup_1929
ereturn list

*Table 8: Percent Land Confiscated in District and Wheat Yields Over Time
*Column 2: Using the district level RHS variables, but department level LHS variables, robust regression
xi: rreg lwheatyield i.year*super1adj i.year*wheatsuit i.year*ln_ma_1789_ba_own_dist_default i.year*i.FE13,
lincom super1adj
lincom super1adj + _IyeaXsup_1852
lincom super1adj + _IyeaXsup_1875
lincom super1adj + _IyeaXsup_1892
lincom super1adj + _IyeaXsup_1912
lincom super1adj + _IyeaXsup_1929
ereturn list

*The difference between Column 1 and Column 2 is being driven by Cambrai and Arles...
*drop Cambrai and Arles (not reported in paper)
xi: reg lwheatyield i.year*super1adj i.year*wheatsuit i.year*ln_ma_1789_ba_own_dist_default i.year*i.FE13 if id~=1059003 & id~=1013003, cluster(deptid)
lincom super1adj
lincom super1adj + _IyeaXsup_1852
lincom super1adj + _IyeaXsup_1875
lincom super1adj + _IyeaXsup_1892
lincom super1adj + _IyeaXsup_1912
lincom super1adj + _IyeaXsup_1929
ereturn list

log close


******************************************
*** Material below for ref report.... ****
******************************************

****** For JLE Referee Report Comment 6. Wants everything (LHS and RHS variables) to be aggregated to the department level. Will do it aggregating to both the mean and the median. *******

**** Mean Aggregation *****

*recode Beaucaire to be in FEid 5 to rectify mismatch due to it being placed in department with districts in different ids
*replace FE13=5 if id==1030002

*Using department level variables
sort deptid
collapse lwheatyield super1adj wheatsuit ln_ma_1789_ba_own_dist_default fr_bishop_dist FE13 sample, by(deptid year)

xi: reg lwheatyield i.year*super1adj i.year*wheatsuit i.year*ln_ma_1789_ba_own_dist_default i.year*i.FE13, robust
lincom super1adj
lincom super1adj + _IyeaXsup_1852
lincom super1adj + _IyeaXsup_1875
lincom super1adj + _IyeaXsup_1892
lincom super1adj + _IyeaXsup_1912
lincom super1adj + _IyeaXsup_1929
ereturn list

*Clear the environment
clear

*Reload the preliminaries
use "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Data/wheat yield panel/base wheat yield panel 1841_1929.dta"

*log using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Analysis/Convergence Analysis 5-31-17.log", replace

keep if sample==1

*Merge in new MA measures including own district and non-French cities
merge m:m id using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Data/New Market Access/Market Access with District different costs.dta"
keep if _merge==3
drop if id==.
count
drop _merge

*generate logs of MA variables
gen ln_ma_1789_bo_own_dist_default = ln(ma_1789_bo_own_dist_default)
gen ln_ma_1789_ba_own_dist_default = ln(ma_1789_ba_own_dist_default)
gen ln_ma_1789_ca_own_dist_default = ln(ma_1789_ca_own_dist_default)
gen ln_ma_1789_ma_own_dist_default = ln(ma_1789_ma_own_dist_default)

merge m:m id using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Data/Bishoprics/France_Bishop_Near.dta"
drop if _merge==2
drop _merge

**** Median Aggregation *****

*recode Beaucaire to be in FEid 5 to rectify mismatch due to it being placed in department with districts in different ids
*replace FE13=5 if id==1030002

*Using department level variables
sort deptid
collapse (median) lwheatyield super1adj wheatsuit ln_ma_1789_ba_own_dist_default fr_bishop_dist FE13 sample, by(deptid year)

xi: reg lwheatyield i.year*super1adj i.year*wheatsuit i.year*ln_ma_1789_ba_own_dist_default i.year*i.FE13, robust
lincom super1adj
lincom super1adj + _IyeaXsup_1852
lincom super1adj + _IyeaXsup_1875
lincom super1adj + _IyeaXsup_1892
lincom super1adj + _IyeaXsup_1912
lincom super1adj + _IyeaXsup_1929
ereturn list
