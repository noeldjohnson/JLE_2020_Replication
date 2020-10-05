* Replication File for Table 1 in Finley, Frank, and Johnson, ``The Effects of Land Redistribution: Evidence from the French Revolution'' published in the Journal of Law and Economics.
* Author: Noel Johnson
* Last Edited: 9/9/20

use "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Data Sets/DAuctionProperties.dta"

log using "/Users/noeljohnson/Dropbox/Research/Revolutionary Expropriation/Replication Files/Table 1.log", replace

gen lpricehect=ln(price_per_)
gen temp=DBishopric/1000
drop DBishopric
rename temp DBishopric

sum lpricehect DBishopric if (ferme==1 | vignes==1 | metayer==1)

sum lpricehect if (ferme==1 | vignes==1 | metayer==1), detail

eststo: quietly: reg lpricehect DBishopric if  (vignes==1 | ferme==1 | metayer==1), cluster(dept_id)
eststo: quietly: reg lpricehect DBishopric ln_ma_1789_ba_own_dist_default wheatsuit  if  (vignes==1 | ferme==1 | metayer==1), cluster(dept_id)
eststo: quietly: reg lpricehect DBishopric ln_ma_1789_ba_own_dist_default wheatsuit  if  (vignes==1 | ferme==1 | metayer==1) & lpricehect<8.149335, cluster(dept_id)
eststo: quietly: reg lpricehect DBishopric ln_ma_1789_ba_own_dist_default wheatsuit  if  (vignes==1 | ferme==1 | metayer==1) & lpricehect<7.096465, cluster(dept_id)
esttab, replace se ar2 k(DBishopric)  star(* 0.10 ** 0.05 *** 0.01)
eststo clear

log close
