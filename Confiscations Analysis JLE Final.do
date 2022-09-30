* Replication File for Finley, Frank, and Johnson, ``The Effects of Land Redistribution: Evidence from the French Revolution'' published in the Journal of Law and Economics.
* Author: Noel Johnson
* Last Edited: 10/5/20

* To run on your local computer, search for "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files" and replace with your local path to the Replication Files folder.

use "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/Base District Data Final.dta"

log using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Confiscations Analysis JLE Final.log", replace

*fix the auction plot variables to get rid of mechanical zeroes (the original source listed 0 for missing values)
replace avg_acre_p=. if num_plots==0
replace avg_price_ =. if num_plots==0

*generate logs of some variables used in the analysis
gen ln_ma_1789_ba=ln(ma_1789_ba)
gen ln_ma_1789_bo=ln(ma_1789_bo)
gen ln_ma_1789_ca=ln(ma_1789_ca)
gen ln_ma_1789_ma=ln(ma_1789_ma)
gen lwheatyield=ln(wheat_yiel)
gen lwheat_hect=ln(wheat_hect)
gen lpotatoyield=ln(potato_yie)
gen lpotato_hect=ln(potato_hec)

*One of the districts has a mis-coded value for wheat yields, exclude it from sample
gen sample=1
*replace sample=0 if id==1017007
*define the sample as including only districts with data on area of church land confiscated
replace sample=0 if super1adj==.

*Consolidate 22 region FE's into the currently used by the French government (since 1 July 2016) 13 (minus corsica = 12).

gen FE13=0

replace FE13=7 if region22id == 1010
replace FE13=4 if region22id == 989
replace FE13=2 if region22id ==990
replace FE13=7 if region22id ==991
replace FE13=3 if region22id == 992
replace FE13=1 if region22id ==993
replace FE13= 8 if region22id ==994
replace FE13=9 if region22id == 995
replace FE13=4 if region22id ==996
replace FE13=1 if region22id ==998
replace FE13=3 if region22id ==999
replace FE13=5 if region22id ==1001
replace FE13=2 if region22id ==1002
replace FE13=4 if region22id ==1003
replace FE13=5 if region22id ==1004
replace FE13=6 if region22id ==1005
replace FE13=11 if region22id ==1006
replace FE13=6 if region22id ==1007
replace FE13=2 if region22id ==1008
replace FE13=12 if region22id ==1009
replace FE13=10 if region22id == 1000
replace FE13=4 if id==1057008
replace region22id=1003 if id==1057008

*Import the 1852 Agricultural Survey Data (non-crop data)
merge 1:1 id using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/Variables Matched 1852.dta"
drop _merge

*Import the 1852 Agricultural Survey Data (crop data)
merge m:1 MatchedArr1852 using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/Matched 1852 Crops.dta"
drop if _merge==2
drop _merge

*Import the 1852 Agricultural Survey Data (cultures diverses)
merge m:1 MatchedArr1852 using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/Matched cultures_diverses.dta"
drop if _merge==2
drop _merge

*replace missing variable code of -1 with missing == . in the 1852 data
foreach var of varlist v315-v314 {
replace `var'=. if `var'==-1
}

*Generate some variables from the 1852 census

*wheat yields
label var v3 "1852 average wheat (froment) yield per hectare (hectoliters)"
gen lwheatyield1852=ln(v3)
label var lwheatyield1852 "log 1852 average wheat (froment) yield per hectare (hectoliters)"
*wheat hectares
label var v1 "1852 number of hectares of wheat cultivation"
gen lwheathectares1852 = ln(v1)
label var lwheathectares1852 "log 1852 number of hectares of wheat cultivation"
*straw yields
label var v4 "1852 average wheat straw (paille) yield per hectare (quintaux m'e9triques)"
gen lwheatstraw1852 = ln(v4)
label var lwheatstraw1852 "log 1852 average wheat straw (paille) yield per hectare (quintaux m'e9triques)"
*potato yields
label var v150 "1852 average potato yield per hectare (hectoliters)"
gen lpotatoyield1852 = ln(v150)
label var lpotatoyield1852 "log 1852 average potato yield per hectare (hectoliters)"
*potato hectares
label var v148 "1852 number of hectares of potato cultivation"
gen lpotatohectares1852 = ln(v148)
label var lpotatohectares1852 "log 1852 number of hectares of potato cultivation"
*rye yields
label var v45 "1852 average rye (seigle) yield per hectare (hectoliters)"
gen lryeyield1852 = ln(v45)
label var lryeyield1852 "log 1852 average rye (seigle) yield per hectare (hectoliters)"
*rye hectares
label var v43 "1852 number of hectares of rye cultivation"
gen lryehectares1852 = ln(v43)
label var lryehectares1852 "log 1852 number of hectares of rye cultivation"
*rye straw
label var v46 "1852 average rye straw (paille) yield per hectare (quintaux m'e9triques)"
gen lryestraw1852 = ln(v46)
label var lryestraw1852 "log 1852 average rye straw (paille) yield per hectare (quintaux m'e9triques)"

*marais (use v326--overall land to make percentages)
label var v326 "1852 superficie totale"
label var v320 "1852 terres labourable"
label var v327 "1852 marais susceptible to being drained (hectares)"
gen potentialdrainage1852 = (v327/v326)
gen ALTpotentialdrainage1852 = (v327/v320)
label var potentialdrainage1852 "1852 marais susceptible to being drained (percent)"
*prairies artificielles
label var v318 "1852 prairies artificielles (planted with legumineuses) (hectares)"
gen prairies1852=(v318/v326)
gen ALTprairies1852=(v318/v320)
label var prairies1852 "1852 prairies artificielles (planted with legumineuses) (percent)"
label var ALTprairies1852 "1852 prairies artificielles (percent of workable land)"
*jachere
label var v319 "1852 fallow land (hectares)"
gen jacheres1852 = (v319/v326)
gen ALTjacheres1852=(v319/v320)
label var jacheres1852 "1852 fallow land (percent)"
label var ALTjacheres1852 "1852 fallow land (percent of workable land)"

*share owners
label var v500 "1852 nombre owners ayant des propri'e9t'e9s sur le territoire sans y demeurer"
label var v501 "1852 nombre owners demeurant sur le territoire sans cultiver eux-m'eames"
label var v502 "1852 nombre owners ne cultivant que pour eux-m'eames"
label var v503 "1852 nombre owners cultivant pour eux-m'eames et pour autrui (journaliers)"
label var v504 "1852 nombre des fermiers (payant un fermage fixe en argent)"
label var v505 "1852 nombre des m'e9tayers ou colons, etc. (donnant au propri'e9taire une part des produits)"

gen shareowners1852=(v500+v501+v502+v503)/(v500+v501+v502+v503+v504+v505)
label var shareowners1852 "1852 shareowners"
gen owneroperator1852=(v502+v503)/(v500+v501+v502+v503)
label var owneroperator1852 "1852 owner operators"

*share absentee landlords
gen shareabsentee1852=(v500)/(v500+v501+v502+v503)
label var shareabsentee1852 "1852 share landlords not living on lands"

*sharecroppers
gen sharemetayer1852=(v505)/(v504+v505)
label var sharemetayer1852 "1852 share farmers that are metayers"

*clean up by dropping 1852 variables not used
drop v315-v317
drop v321-v325
drop v506-v598
drop v2
drop v5-v42
drop v44
drop v47-v147
drop v149
drop v151-v314

*create department level yields for 1841 and 1852
*dept wheat yields 1841
sort deptid
by deptid: egen deptwheatyield1841 = mean(lwheatyield)
label var deptwheatyield1841 "1841 log department wheat yields"
*dept wheat yields 1852
sort deptid
by deptid: egen deptwheatyield1852 = mean(lwheatyield1852)
label var deptwheatyield1852 "1852 log department wheat yields"

*import the department level yields from 1892 and 1929
merge m:m deptid using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/wheat1892_1929.dta"
drop if _merge==1
drop if _merge==2
drop _merge

*dept wheat yields1892
gen lwheatyield1892 = ln(wheatyield1892)
label var lwheatyield1892 "log wheat yields in 1892 (hectoliters)"
*dept wheat yields1929
gen lwheatyield1929 = ln(wheatyieldwinter1929)
label var lwheatyield1929 "log winter wheat yields in 1929 (hectoliters)"
gen lspringyield1929 = ln(wheatyieldspring1929)
label var lspringyield1929 "log spring wheat yields in 1929 (hectoliters)"

*Merge in the Bishoprics data (Source: Bosker, Maarten, Eltjo Buringh, and Jan Luiten Van Zanden. "From baghdad to london: Unraveling urban development in europe, the middle east, and north africa, 800–1800." Review of Economics and Statistics 95, no. 4 (2013): 1418-1437.)
merge 1:1 id using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/Bishop_Near.dta"
drop _merge

merge 1:1 id using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/France_Bishop_Near.dta"
drop _merge

*Merge in archbishopric data
merge 1:1 id using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/archbishop_dist_full.dta"
drop _merge

*Merge in data from 1862 agricultural survey
merge m:m deptid using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/Ag Survey 1862.dta"
drop if _merge==2
drop _merge

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

*merge in data on department revenues in 1880
merge m:m deptid using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/revenus communes.dta"
drop if _merge==2
drop _merge

*merge in data on district credit in 1840
merge m:m id using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/credit1840.dta"
drop if _merge==2
count
drop _merge

*The four data sets below were generated using the R code and data contained in the folder "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/Cities_Bins_Comment_10" The commented code file is "R_Code_Cities_Bins.R".
*Merge in distance to city bins for r&r point 10
merge 1:1 id using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/Cities_Bins_Comment_10/districts_Q1234.dta"
drop _merge

*Merge in distance to small_bishoprics (below 4th quartile) for r&r point 10
merge 1:1 id using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/Cities_Bins_Comment_10/dist_small_bishops.dta"
drop _merge

*Merge in distance to very_small_bishoprics (below median) for r&r point 10
merge 1:1 id using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/Cities_Bins_Comment_10/dist_very_small_bishops.dta"
drop _merge

*Merge in distance to first_quartile_bishops (in 1st quartile of pop) for r&r point 10
merge 1:1 id using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/Cities_Bins_Comment_10/dist_first_quartile_bishops.dta"
drop _merge


*BEGIN THE ANALYSIS

*Figure for presentations: Lpoly of bivariate relationship between wheatyield and confiscations
*lpoly lwheatyield super1adj if sample==1,

*Table 1: Auction plot value per hectare in 1790 and distance from nearest Bishopric
*This table is reproduced using the .do file "Table1.do" contained in the top-level Replication Files folder.

*Table 2: Percent Land Confiscated in District and Wheat Production
*Panel A: Wheat Yields
*Regression 1: bivariate
eststo: quietly: reg lwheatyield super1adj if sample==1, robust
*Regression 2: control for wheat suit
eststo: quietly: reg lwheatyield super1adj wheatsuit if sample==1, robust
*Regression 3: control for wheat suit and market access
eststo: quietly: reg lwheatyield super1adj wheatsuit ln_ma_1789_ba_own_dist_default if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
*Regression 4: bivariate, FE13
eststo: quietly: reg lwheatyield super1adj i.FE13 if sample==1, robust
*Regression 5: control for wheat suit, FE13
eststo: quietly: reg lwheatyield super1adj wheatsuit i.FE13 if sample==1, robust
*Regression 6: control for wheat suit and market access, FE13
eststo: quietly: reg lwheatyield super1adj wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
*Panel A: Wheat Hectares
*Regression 1: bivariate
eststo: quietly: reg lwheat_hect super1adj if sample==1, robust
*Regression 2: control for wheat suit
eststo: quietly: reg lwheat_hect super1adj wheatsuit if sample==1, robust
*Regression 3: control for wheat suit and market access
eststo: quietly: reg lwheat_hect super1adj wheatsuit ln_ma_1789_ba_own_dist_default if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
*Regression 4: bivariate, FE13
eststo: quietly: reg lwheat_hect super1adj i.FE13 if sample==1, robust
*Regression 5: control for wheat suit, FE13
eststo: quietly: reg lwheat_hect super1adj wheatsuit i.FE13 if sample==1, robust
*Regression 6: control for wheat suit and market access, FE13
eststo: quietly: reg lwheat_hect super1adj wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*Table 3: Percent Land Confiscated in District and Land Usage
*Panel A: Percent of Arable Land Laying Fallow in 1852
*Regression 1: bivariate
eststo: quietly: reg ALTjacheres1852 super1adj if sample==1, robust
*Regression 2: control for wheat suit
eststo: quietly: reg ALTjacheres1852 super1adj wheatsuit if sample==1, robust
*Regression 3: control for wheat suit and market access
eststo: quietly: reg ALTjacheres1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
*Regression 4: bivariate, FE13
eststo: quietly: reg ALTjacheres1852 super1adj i.FE13 if sample==1, robust
*Regression 5: control for wheat suit, FE13
eststo: quietly: reg ALTjacheres1852 super1adj wheatsuit i.FE13 if sample==1, robust
*Regression 6: control for wheat suit and market access, FE13
eststo: quietly: reg ALTjacheres1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
*Panel B: Percent of Arable Used as "Prairies Artificielles" (seeded with alfalfa, clover, rye-grass, etc... Suggests 4 field rotation or "Norfolk System")
*Regression 1: bivariate
eststo: quietly: reg ALTprairies1852 super1adj if sample==1, robust
*Regression 2: control for wheat suit
eststo: quietly: reg ALTprairies1852 super1adj wheatsuit if sample==1, robust
*Regression 3: control for wheat suit and market access
eststo: quietly: reg ALTprairies1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
*Regression 4: bivariate, FE13
eststo: quietly: reg ALTprairies1852 super1adj i.FE13 if sample==1, robust
*Regression 5: control for wheat suit, FE13
eststo: quietly: reg ALTprairies1852 super1adj wheatsuit i.FE13 if sample==1, robust
*Regression 6: control for wheat suit and market access, FE13
eststo: quietly: reg ALTprairies1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*Table 4: Percent Land Confiscated in District and Number of Pipe Manufacturers
*Regression 1: bivariate
eststo: quietly: reg fabriques_25kbuffer super1adj if sample==1, robust
*Regression 2: control for elevation range
eststo: quietly: reg fabriques_25kbuffer super1adj elevation_range if sample==1, robust
*Regression 3: control for elevation range and market access
eststo: quietly: reg fabriques_25kbuffer super1adj elevation_range ln_ma_1789_ba_own_dist_default  if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
*Regression 4: bivariate, FE13
eststo: quietly: reg fabriques_25kbuffer super1adj i.FE13 if sample==1, robust
*Regression 5: control for elevation range, FE13
eststo: quietly: reg fabriques_25kbuffer super1adj elevation_range i.FE13 if sample==1, robust
*Regression 6: control for elevation range and market access, FE13
eststo: quietly: reg fabriques_25kbuffer super1adj elevation_range ln_ma_1789_ba_own_dist_default i.FE13  if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*Table 5: IV Regressions and Robustness (for space considerations, notes in footnote 25)
*Table 5: Column 1: IV reg using bishop_dist
eststo: ivreg2 lwheatyield (super1adj=fr_bishop_dist) wheatsuit ln_ma_1789_ba_own_dist_default  if sample==1, robust ffirst
eststo: xi: ivreg2 lwheatyield (super1adj=fr_bishop_dist) wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 if sample==1, robust ffirst
eststo: ivreg2 fabriques_25kbuffer (super1adj=fr_bishop_dist) elevation_range ln_ma_1789_ba_own_dist_default   if sample==1, robust ffirst
eststo: xi: ivreg2 fabriques_25kbuffer (super1adj=fr_bishop_dist) elevation_range ln_ma_1789_ba_own_dist_default  i.FE13 if sample==1, robust ffirst
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
eststo: ivreg2 ALTjacheres1852 (super1adj=fr_bishop_dist) wheatsuit ln_ma_1789_ba_own_dist_default  if sample==1, robust ffirst
eststo: xi: ivreg2 ALTjacheres1852 (super1adj=fr_bishop_dist) wheatsuit ln_ma_1789_ba_own_dist_default i.FE13  if sample==1, robust ffirst
eststo: ivreg2 ALTprairies1852 (super1adj=fr_bishop_dist) wheatsuit ln_ma_1789_ba_own_dist_default  if sample==1, robust ffirst
eststo: xi: ivreg2 ALTprairies1852 (super1adj=fr_bishop_dist) wheatsuit ln_ma_1789_ba_own_dist_default i.FE13  if sample==1, robust ffirst
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*  Table 5: Column 2: IV (Just smallest quartile bishoprics)
**** lwheatsuit ******
* (1) wheat no FE's
eststo: ivreg2 lwheatyield (super1adj=dist_bishop_first_quartile) wheatsuit ln_ma_1789_ba_own_dist_default if sample==1, robust ffirst
* wheat, yes FE's
eststo: ivreg2 lwheatyield (super1adj=dist_bishop_first_quartile) wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 if sample==1, robust ffirst
esttab, replace se k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
**** fabriques_25kbuffer ******
* (3) fabriques, no FE's
eststo: ivreg2 fabriques_25kbuffer (super1adj=dist_bishop_first_quartile) elevation_range ln_ma_1789_ba_own_dist_default  if sample==1, robust ffirst
* (4) fabriques, yes FE's
eststo: ivreg2 fabriques_25kbuffer (super1adj=dist_bishop_first_quartile) elevation_range ln_ma_1789_ba_own_dist_default i.FE13  if sample==1, robust ffirst
esttab, replace se k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
**** Fallow1852 ******
* (5) fallow, no FE's
eststo: ivreg2 ALTjacheres1852 (super1adj=dist_bishop_first_quartile) wheatsuit ln_ma_1789_ba_own_dist_default if sample==1, robust ffirst
* (6) fallow, yes FE's
eststo: ivreg2 ALTjacheres1852 (super1adj=dist_bishop_first_quartile) wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 if sample==1, robust ffirst
esttab, replace se k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
**** prairies ******
* (7) prairies, no FE's
eststo: ivreg2 ALTprairies1852 (super1adj=dist_bishop_first_quartile) wheatsuit ln_ma_1789_ba_own_dist_default if sample==1, robust ffirst
* (8) prairies, yes FE's
eststo: ivreg2 ALTprairies1852 (super1adj=dist_bishop_first_quartile) wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 if sample==1, robust ffirst
esttab, replace se k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*Table 5: Column 3: Conley Standard Errors (using http://www.fight-entropy.com/2010/06/standard-error-adjustment-ols-for.html)
*create a constant and a year variable
gen const = 1
gen year = 1800
*run the regressions using various spatial cut-offs
*Conley SE's with cut-off at 100km for robustness table in text
*lwheatyield 100km
ols_spatial_HAC lwheatyield super1adj wheatsuit ln_ma_1789_ba_own_dist_default const  const if sample==1, lat(latitude) lon(longitude) t(year) p(id) dist(100) lag(0) dropvar
*lwheatyield FE's 100km
xi: ols_spatial_HAC lwheatyield super1adj wheatsuit ln_ma_1789_ba_own_dist_default const i.FE13 const if sample==1, lat(latitude) lon(longitude) t(year) p(id) dist(100) lag(0) dropvar
*fabriques_25kbuffer 100km
ols_spatial_HAC fabriques_25kbuffer super1adj elevation_range ln_ma_1789_ba_own_dist_default const if sample==1, lat(latitude) lon(longitude) t(year) p(id) dist(100) lag(0) dropvar
*fabriques_25kbuffer FE's 100km
xi: ols_spatial_HAC fabriques_25kbuffer super1adj elevation_range ln_ma_1789_ba_own_dist_default i.FE13 const if sample==1, lat(latitude) lon(longitude) t(year) p(id) dist(100) lag(0) dropvar
*ALTjacheres1852 100km
ols_spatial_HAC ALTjacheres1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default const if sample==1, lat(latitude) lon(longitude) t(year) p(id) dist(100) lag(0) dropvar
*ALTjacheres1852 FE's 100km
xi: ols_spatial_HAC ALTjacheres1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 const if sample==1, lat(latitude) lon(longitude) t(year) p(id) dist(100) lag(0) dropvar
*ALTprairies1852 100km
ols_spatial_HAC ALTprairies1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default const if sample==1, lat(latitude) lon(longitude) t(year) p(id) dist(100) lag(0) dropvar
*ALTprairies1852 FE's 100km
xi: ols_spatial_HAC ALTprairies1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 const if sample==1, lat(latitude) lon(longitude) t(year) p(id) dist(100) lag(0) dropvar

*Table 5: Column 4: Super2Adj (Including confiscations of Emigres)
eststo: quietly: reg lwheatyield super1adj super2adj wheatsuit ln_ma_1789_ba_own_dist_default if sample==1, robust
eststo: quietly: reg lwheatyield super1adj super2adj wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 if sample==1, robust
eststo: quietly: reg fabriques_25kbuffer super1adj  super2adj elevation_range ln_ma_1789_ba_own_dist_default if sample==1, robust
eststo: quietly: reg fabriques_25kbuffer super1adj  super2adj elevation_range ln_ma_1789_ba_own_dist_default i.FE13  if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
eststo: quietly: reg ALTjacheres1852 super1adj super2adj wheatsuit ln_ma_1789_ba_own_dist_default if sample==1, robust
eststo: quietly: reg ALTjacheres1852 super1adj super2adj wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 if sample==1, robust
eststo: quietly: reg ALTprairies1852 super1adj super2adj wheatsuit ln_ma_1789_ba_own_dist_default if sample==1, robust
eststo: quietly: reg ALTprairies1852 super1adj super2adj wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*Correlation between church confiscations and emigre confiscations is small and aggresively statistically insignificant.
pwcorr super1adj super2adj if sample==1, sig


*Table 5: Column 5: Trim top and bottom 5%
sum super1adj if sample==1, detail
*5% is <0.6 or >17.4
eststo: quietly: reg lwheatyield super1adj wheatsuit ln_ma_1789_ba_own_dist_default if sample==1 & super1adj>0.6 & super1adj<17.4, robust
eststo: quietly: reg lwheatyield super1adj wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 if sample==1 & super1adj>0.6 & super1adj<17.4, robust
eststo: quietly: reg fabriques_25kbuffer super1adj elevation_range ln_ma_1789_ba_own_dist_default if sample==1 & super1adj>0.6 & super1adj<17.4, robust
eststo: quietly: reg fabriques_25kbuffer super1adj elevation_range ln_ma_1789_ba_own_dist_default i.FE13  if sample==1 & super1adj>0.6 & super1adj<17.4, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
eststo: quietly: reg ALTjacheres1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default if sample==1 & super1adj>0.6 & super1adj<17.4, robust
eststo: quietly: reg ALTjacheres1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 if sample==1 & super1adj>0.6 & super1adj<17.4, robust
eststo: quietly: reg ALTprairies1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default if sample==1 & super1adj>0.6 & super1adj<17.4, robust
eststo: quietly: reg ALTprairies1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 if sample==1 & super1adj>0.6 & super1adj<17.4, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*Table 5: Column 6: MA_bo
eststo: quietly: reg lwheatyield super1adj wheatsuit ln_ma_1789_bo_own_dist_default if sample==1, robust
eststo: quietly: reg lwheatyield super1adj wheatsuit ln_ma_1789_bo_own_dist_default i.FE13 if sample==1, robust
eststo: quietly: reg fabriques_25kbuffer super1adj elevation_range ln_ma_1789_bo_own_dist_default if sample==1, robust
eststo: quietly: reg fabriques_25kbuffer super1adj elevation_range ln_ma_1789_bo_own_dist_default i.FE13  if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
eststo: quietly: reg ALTjacheres1852 super1adj wheatsuit ln_ma_1789_bo_own_dist_default if sample==1, robust
eststo: quietly: reg ALTjacheres1852 super1adj wheatsuit ln_ma_1789_bo_own_dist_default i.FE13 if sample==1, robust
eststo: quietly: reg ALTprairies1852 super1adj wheatsuit ln_ma_1789_bo_own_dist_default if sample==1, robust
eststo: quietly: reg ALTprairies1852 super1adj wheatsuit ln_ma_1789_bo_own_dist_default i.FE13 if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*Table 5: Column 7: MA_ca
eststo: quietly: reg lwheatyield super1adj wheatsuit ln_ma_1789_ca_own_dist_default if sample==1, robust
eststo: quietly: reg lwheatyield super1adj wheatsuit ln_ma_1789_ca_own_dist_default i.FE13 if sample==1, robust
eststo: quietly: reg fabriques_25kbuffer super1adj elevation_range ln_ma_1789_ca_own_dist_default  if sample==1, robust
eststo: quietly: reg fabriques_25kbuffer super1adj elevation_range ln_ma_1789_ca_own_dist_default i.FE13  if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
eststo: quietly: reg ALTjacheres1852 super1adj wheatsuit ln_ma_1789_ca_own_dist_default if sample==1, robust
eststo: quietly: reg ALTjacheres1852 super1adj wheatsuit ln_ma_1789_ca_own_dist_default i.FE13 if sample==1, robust
eststo: quietly: reg ALTprairies1852 super1adj wheatsuit ln_ma_1789_ca_own_dist_default if sample==1, robust
eststo: quietly: reg ALTprairies1852 super1adj wheatsuit ln_ma_1789_ca_own_dist_default i.FE13 if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*Table 5: Column 8: Credit
eststo: quietly: reg lwheatyield super1adj wheatsuit livrets solde_restant ln_ma_1789_ba_own_dist_default if sample==1, robust
eststo: quietly: reg lwheatyield super1adj wheatsuit livrets solde_restant ln_ma_1789_ba_own_dist_default i.FE13 if sample==1, robust
eststo: quietly: reg fabriques_25kbuffer super1adj elevation_range livrets solde_restant wheatsuit ln_ma_1789_ba_own_dist_default if sample==1, robust
eststo: quietly: reg fabriques_25kbuffer super1adj elevation_range livrets solde_restant wheatsuit ln_ma_1789_ba_own_dist_default i.FE13  if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
eststo: quietly: reg ALTjacheres1852 super1adj wheatsuit livrets solde_restant ln_ma_1789_ba_own_dist_default if sample==1, robust
eststo: quietly: reg ALTjacheres1852 super1adj wheatsuit livrets solde_restant ln_ma_1789_ba_own_dist_default i.FE13 if sample==1, robust
eststo: quietly: reg ALTprairies1852 super1adj wheatsuit livrets solde_restant ln_ma_1789_ba_own_dist_default if sample==1, robust
eststo: quietly: reg ALTprairies1852 super1adj wheatsuit livrets solde_restant ln_ma_1789_ba_own_dist_default i.FE13 if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*Table 5: Column 9: Condition on Average Auction Plot Price (from Big 4 regions)
eststo: quietly: reg lwheatyield super1adj wheatsuit ln_ma_1789_ba_own_dist_default avg_pric_1 if big4sample==1 & avg_pric_1~=0, robust
eststo: quietly: reg fabriques_25kbuffer super1adj elevation_range ln_ma_1789_ba_own_dist_default  avg_pric_1  if big4sample==1 & avg_pric_1~=0, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
eststo: quietly: reg ALTjacheres1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default avg_pric_1 if big4sample==1 & avg_pric_1~=0, robust
eststo: quietly: reg ALTprairies1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default avg_pric_1 if big4sample==1 & avg_pric_1~=0, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*Table 5: Column 10: Condition on Average Size of Church Plots (from Big 4 regions)
eststo: quietly: reg lwheatyield super1adj wheatsuit ln_ma_1789_ba_own_dist_default  avg_total_ if big4sample==1 & avg_total_~=0, robust
eststo: quietly: reg fabriques_25kbuffer super1adj elevation_range ln_ma_1789_ba_own_dist_default  avg_total_  if big4sample==1 & avg_total_~=0, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
eststo: quietly: reg ALTjacheres1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default  avg_total_ if big4sample==1 & avg_total_~=0, robust
eststo: quietly: reg ALTprairies1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default  avg_total_ if big4sample==1 & avg_total_~=0, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*Table 6: Percent Land Confiscated in District and Average Farm Size
*Land Inequality: Average Farm Size in 1862
sum avg_farm_size_1862 if sample==1
*Regression 1: 10% Quantile
qreg2 avg_farm_size_1862 super1adj wheatsuit ln_ma_1789_ba_own_dist_default if sample==1,  cluster(deptid) q(.1)
*Regression 2: 25% Quantile
qreg2 avg_farm_size_1862 super1adj wheatsuit ln_ma_1789_ba_own_dist_default if sample==1,  cluster(deptid) q(.25)
*Regression 3: 50% Quantile
qreg2 avg_farm_size_1862 super1adj wheatsuit ln_ma_1789_ba_own_dist_default if sample==1,  cluster(deptid) q(.50)
*Regression 4: 75% Quantile
qreg2 avg_farm_size_1862 super1adj wheatsuit ln_ma_1789_ba_own_dist_default if sample==1,  cluster(deptid) q(.75)
*Regression 5: 90% Quantile
qreg2 avg_farm_size_1862 super1adj wheatsuit ln_ma_1789_ba_own_dist_default if sample==1,  cluster(deptid) q(.90)
*Regression 6: OLS
reg avg_farm_size_1862 super1adj wheatsuit ln_ma_1789_ba_own_dist_default if sample==1,  cluster(deptid)

*Table 7: Percent Land Confiscated in District and Share Cropping
*Land Inequality: Percent Sharecroppers in 1852
*Regression 1: bivariate
eststo: quietly: reg sharemetayer1852 super1adj if sample==1, robust
*Regression 2: control for wheat suit
eststo: quietly: reg sharemetayer1852 super1adj wheatsuit if sample==1, robust
*Regression 3: control for wheat suit and market access
eststo: quietly: reg sharemetayer1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
*Regression 4: bivariate, FE13
eststo: quietly: reg sharemetayer1852 super1adj i.FE13 if sample==1, robust
*Regression 5: control for wheat suit, FE13
eststo: quietly: reg sharemetayer1852 super1adj wheatsuit i.FE13 if sample==1, robust
*Regression 6: control for wheat suit and market access, FE13
eststo: quietly: reg sharemetayer1852 super1adj wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*Table 8: Percent Land Confiscated in District and Wheat Yields Over Time
*This table is replicated using the .do file "Table 8.do" located at the top level of the Replication Files folder.


*Appendix Tables and Figures

*Table A1: District Descriptive Statistics
sum super1adj lwheatyield lwheat_hect fabriques_25kbuffer elevation_range wheatsuit ln_ma_1789_ba_own_dist_default ALTprairies1852 ALTjacheres1852 sharemetayer1852 avg_farm_size_1862 fr_bishop_dist  if sample==1 & super1adj~=., separator(0)

*Table A2: Balance of Samples With vs. Without Data on Confiscations
eststo: quietly: reg sample wheatsuit , robust
eststo: quietly: reg sample wheatsuit  i.FE13, robust
esttab, replace se ar2 k(wheatsuit)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
eststo: quietly: reg sample potatosuit , robust
eststo: quietly: reg sample potatosuit  i.FE13, robust
esttab, replace se ar2 k(potatosuit)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
eststo: quietly: reg sample elevation_range , robust
eststo: quietly: reg sample elevation_range i.FE13, robust
esttab, replace se ar2 k(elevation_range)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
eststo: quietly: reg sample  ln_ma_1789_ba_own_dist_default  , robust
eststo: quietly: reg sample  ln_ma_1789_ba_own_dist_default  i.FE13, robust
esttab, replace se ar2 k(ln_ma_1789_ba_own_dist_default)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
eststo: quietly: reg sample wheatsuit elevation_range potatosuit ln_ma_1789_ba_own_dist_default  , robust
eststo: quietly: reg sample wheatsuit elevation_range potatosuit ln_ma_1789_ba_own_dist_default i.FE13, robust
esttab, replace se ar2 k(wheatsuit  potatosuit  elevation_range  ln_ma_1789_ba_own_dist_default )  star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*Table A3: Percent Land Confiscated and District Revenues in 1880, 1900.
*Regression 1: bivariate, FE13
eststo: quietly: reg revenusannuels1880 super1adj i.FE13 if sample==1, robust
*Regression 2: control for wheat suit, FE13
eststo: quietly: reg revenusannuels1880 super1adj wheatsuit i.FE13 if sample==1, robust
*Regression 3: control for wheat suit and market access, FE13
eststo: quietly: reg revenusannuels1880 super1adj wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear
* Revenues Annules 1900
*Regression 4: bivariate, FE13
eststo: quietly: reg revenusannuels1900 super1adj i.FE13 if sample==1, robust
*Regression 5: control for wheat suit, FE13
eststo: quietly: reg revenusannuels1900 super1adj wheatsuit i.FE13 if sample==1, robust
*Regression 6: control for wheat suit and market access, FE13
eststo: quietly: reg revenusannuels1900 super1adj wheatsuit ln_ma_1789_ba_own_dist_default i.FE13 if sample==1, robust
esttab, replace se ar2 k(super1adj)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*Figure A4: Correlation between distance to 1600 bishopric and Revolutionary confiscations.
lpoly super1adj fr_bishop_dist if sample==1, noscat ci bw(5000)pw(1472.21)

*Figure A5: Distribution of average farm sizes above and below mean confiscations in 1862.
kdensity avg_farm_size_1862, nograph generate(x fx)
kdensity avg_farm_size_1862 if super1adj>=5.9, nograph generate(fx0) at(x)
kdensity avg_farm_size_1862 if super1adj<5.9, nograph generate(fx1) at(x)
label var fx0 "confiscations>mean"
label var fx1 "confiscations<mean"
line fx0 fx1 x, sort ytitle(Density)
drop fx x fx0 fx1



log close












* End Code