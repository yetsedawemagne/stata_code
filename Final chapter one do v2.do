*** Yetsedaw Emagne PhD Thesis main DO file***
*cd "C:\Users\thomas\Downloads\dataanddo"
*cd "C:\Users\user\Desktop\analysis\raw"
*cd "C:\Users\emagn\Dropbox\analysis\raw"
*cd  "C:\Users\emagn\Desktop\analysis\raw"
cd D:\Dropbox\analysis\raw
gl output_v2 "D:\Dropbox\analysis\output_v2\"

use sect5a_hh_w4, clear
keep if  individual_id ==  1
*keeping members who are 18 or older 
keep if s5aq00 == 1 
drop if s5aq01 == 2
gen num = 1 if s5aq00
sort household_id
by household_id: egen Num_fi = sum(num) if s5aq05 == 1 
replace Num_fi = 0 if Num_fi == .
replace Num_fi = 4 if Num_fi == 5 | Num_fi == 6|Num_fi == 7|Num_fi ==  8
label var Num_fi "number of households more than 18 years old"
ren saq14 rural
global id saq01 saq02 saq03 saq04 saq05 saq06 rural ea_id2 household_id2 individual_id2

* generating access to financial institiutions 

*gen access = hh_s4bq02 
*replace access = 0 if access == 2

* sources of financial acces - Public private ++

foreach x of varlist s5aq03__1 s5aq03__2  s5aq03__3 ///
s5aq03__4 s5aq03__5 s5aq03__6 s5aq03__7 s5aq03__8 s5aq03__9 ///
s5aq04__1 s5aq04__2 s5aq04__3 s5aq04__4{
replace `x' = 0 if `x' == 2
}



gen finaccess = 1 if s5aq03__1 == 1| s5aq03__2 == 1| s5aq03__3 ==1 | s5aq03__4 == 1| s5aq03__5 == 1| ///
s5aq03__6 ==1 | s5aq03__7 == 1| s5aq03__8 == 1 | s5aq03__9 ==1 

replace finaccess = 0 if finaccess == .



gen finknowledge = 1 if s5aq03__1 == 1 | s5aq03__2 == 1| s5aq03__3 ==1 | s5aq03__4 == 1| s5aq03__5 == 1| ///
s5aq03__6 ==1 | s5aq03__7 == 1| s5aq03__8 == 1 | s5aq03__9 ==1 

replace finknowledge = 0 if finknowledge == .

lab def finknowledge 1 "Has knowledge" 0 "No knowledge"

lab values finknowledge finknowledge 
lab variable finknowledge "finacial knowledge (s5q03-09)"
sort household_id
*gen financeaccesstotal = rowtotal(finaccess)

*renaming variables of awarness of financial services 

ren s5aq03__1 Public 
ren s5aq03__2 Private
ren s5aq03__3 insurance 
ren s5aq03__4 MT
ren s5aq03__5 MMAgent
ren s5aq03__6 SACCO 
ren s5aq03__7 Bagent 
ren s5aq03__8 AT
ren s5aq03__9 interestfree
ren s5aq04__1 Coll 
ren s5aq04__2 interest
ren s5aq04__3 credit  
ren s5aq04__4 inflation


global awarness Private Public insurance MT MMAgent SACCO Bagent AT interestfree ///
Coll interest credit inflation 

tabstat $awarness, by(saq01)

*gg
*--------------
****** account ownership 
*--------------
ren s5aq05 ownsaccount
ren s5aq06__1 pri
ren s5aq06__2 pub 
ren s5aq06__3 mf
ren s5aq06__4 sac
foreach x of varlist  ownsaccount $awarness pri pub mf sac  {
replace `x' = 0 if `x' == 2
}

global account ownsaccount pri pub mf sac  
lab def ownsaccount 1 "Owns account" 0 "No account"
lab values ownsaccount ownsaccount

tabstat $account , by(saq01)


*knowledge - financial services use 




foreach x of varlist s5aq07__1 s5aq07__2 s5aq07__3 s5aq07__4 s5aq07__5{
replace `x' = 0 if `x' == 2
}


ren (s5aq07__1 s5aq07__2 s5aq07__3 s5aq07__4 s5aq07__5) (atmbanking onlinebanking mobilebanking agentbanking intfreebanking )
global serviceuse atmbanking onlinebanking mobilebanking agentbanking intfreebanking


tabstat $serviceuse  , by(saq01)


/*renaming knowledge variables 

ren hh_s5bq19a agent_knowledge 
ren hh_s5bq19b atm_knowledge
ren hh_s4bq19c mobilebanking_knowledge
ren hh_s4bq19d collateral_knowledge
ren hh_s4bq19e interest_knowledge

global knowledge agent_knowledge atm_knowledge mobilebanking_knowledge collateral_knowledge interest_knowledge
*/

*--------------------------------------------
   *formal financial instutiuons saving*
*--------------------------------------------

foreach x of varlist s5aq11__1 s5aq11__2 s5aq11__3 s5aq11__4{
replace `x' = 0 if `x' == 2
}
ren s5aq11__1 privatesaving
ren s5aq11__2 publicsaving 
ren s5aq11__3 microsaving 
ren s5aq11__4 saccosaving 
gen saving600 = s5aq16  
gen anysaving = s5aq09

global saving  privatesaving publicsaving microsaving saccosaving  anysaving




*** formal financial instituon saving ( Yes No)

foreach x of varlist $saving{
tabstat `x', by(rural)
}
******
*** any saving and saving 600Bir formal financial 
replace anysaving =  0 if anysaving == 2
tab anysaving  rural, row col

tab saving600 rural, row col


/*------------------------*
* saving frequency *----*
'------------------------*/


ren (s5aq12a s5aq12b s5aq12c s5aq12d) (privatefreq publicfreq microfreq saccofreq)


global ffsavingfrequency privatefreq publicfreq microfreq saccofreq 
*formal financial instituions saving frequcny 

foreach x of varlist $ffsavingfrequency{
tab `x' rural, row col
}










*-----------------------------
     *informal saving 
*-----------------------------

*renaming informal financial savings 


*frequncy in informal saving 
foreach x of varlist s5aq13__1 s5aq13__2 s5aq13__3 s5aq13__4 s5aq13__5{
replace `x' = 0 if `x' == 2
}

ren (s5aq13__1 s5aq13__2 s5aq13__3 s5aq13__4 s5aq13__5) (homesaving frfamsaving assocationsaving equbsaving othersaving)


ren ( s5aq14a s5aq14b s5aq14c s5aq14d s5aq14e ) (fhomesaving ffrfamsaving fassocationsaving fequbsaving fothersaving)

*global ids 
global informalsaving homesaving frfamsaving assocationsaving equbsaving othersaving
global informalsavingfreq fhomesaving ffrfamsaving fassocationsaving fequbsaving fothersaving

*iformal finanicial instituions saving (Yes no)
foreach x of varlist $informalsaving{
tabstat `x' , by(rural)
}

* informal financial saving freqycny 

foreach x of varlist $informalsavingfreq{
tab `x' rural, row col
}


*generating access to finance comprising finance instituions and services 


egen Finaccess = rowtotal( $account $serviceuse)
sort household_id individual_id
ren s5aq09 saving 
*ren s5aq18 insurance 
recode saving (2 = 0)
recode insurance ( 2 = 0)

collapse (max)$account $serviceuse $saving saving insurance finknowledge, by(household_id ea_id)

save financial_inclusion, replace 

*Remittance 
use sect13_hh_w4_v2, clear 
drop if source_cd == 102 | source_cd == 103 
gen remittance = 1 if s13q01 == 1
replace remittance =  0 if remittance == .
tab remittance
collapse (max)remittance, by(household_id)
save remitance, replace 
merge 1:1 household_id using financial_inclusion

keep if _merge == 3 
drop _merge 
save remitance_fi, replace 

*Credit 
use sect15a_hh_w4, clear 
gen creditaccess =  s15q01
collapse (max)creditaccess, by(saq01 household_id)
save credit, replace 
merge 1:1 household_id using remitance_fi 

keep if _merge == 3 
drop _merge 
replace creditaccess = 0 if creditaccess ==  2

*global serviceuse atmbanking onlinebanking mobilebanking intfreebanking

foreach x of varlist $serviceuse pri pub mf sac remittance creditaccess saving insurance{
replace `x' = 0 if `x' == .
}


*ownsaccount
*Multiple corrospondence analysis limited it to public and private banks only, better index values 

*NOTE - attempted to use individual cases, 
mca $serviceuse ownsaccount creditaccess remittance saving insurance
predict findex, rowscore dim(2) normalize(principal)
sum findex 

*Reference - https://www.stata.com/manuals/mvmca.pdf
mca $serviceuse pri pub creditaccess remittance

*stata by default maintains two dimensions ( in our case dim 1 and dim 2 combine to explain 74% )
predict FI_index, rowscore dim(2) normalize(principal)

label var FI_index "Financial index predicted using the Burt approach of MCA"
sort household_id 

*mean FI score from all possible FI dimensions 
*bysort household_id: egen FI_summary = sum(FI_index)
*label var FI_summary "Average financial inclusion of a household"

*median FI score from all possible FI dimensions 
*bysort household_id: egen FI_median = median(FI_index)
*label var FI_median "Median financial inclusion of a household"
*'''''' limited financial index '''

mca $serviceuse pri pub saving insurance

*stata by default maintains two dimensions ( in our case dim 1 and dim 2 combine to explain 74% )
predict FI_index2, rowscore dim(2) normalize(principal)

label var FI_index2 "Financial index limited predicted using the Burt approach of MCA"
sort household_id 

mca $serviceuse pri pub saving insurance

*stata by default maintains two dimensions ( in our case dim 1 and dim 2 combine to explain 74% )
predict FI_index3, rowscore dim(2) normalize(principal)

label var FI_index2 "Financial index limited predicted using the Burt approach of MCA"
sort household_id 

mca $serviceuse ownsaccount saving insurance , normalize(principal)

*stata by default maintains two dimensions ( in our case dim 1 and dim 2 combine to explain 74% )
predict FI_index4

*mean FI score from all possible FI dimensions 
*bysort household_id: egen FI_summary2 = mean(FI_index2)
*label var FI_summary2 "Average financial inclusion2 of a household"

*median FI score from all possible FI dimensions 
*bysort household_id: egen FI_median2 = median(FI_index2)
*label var FI_median2  "Median financial inclusion of a household"

*burt approach 
mca $serviceuse ownsaccount, method(burt) noadjust
predict findexb 

*collapse (max)creditaccess remittance  (mean)Num_fi findex findex1 FI_summary FI_summary2 (median)FI_median FI_median2, by(household_id) 
collapse (max)$account $serviceuse $saving saving insurance creditaccess remittance finknowledge (mean)findexb findex FI_index FI_index2, by(saq01 household_id ea_id) 

save FI_inclusionall, replace 



/****** value of fin asset*****

use sect5b2_hh_w4, clear
ren saq14 rural
ren s5bq09 finasset_value
replace finasset_value = 0 if finasset_value < 0
sort household_id individual_id
gen checking  = 1 if asset_type == 1
gen saving  = 1 if asset_type == 2
gen mifina  = 1 if asset_type == 3
gen informal  = 1 if asset_type == 4
egen total = rowtotal(checking saving mifina informal)
gen checking_value = finasset_value if checking == 1
gen saving_value = finasset_value if saving == 1
gen mifin_value = finasset_value if mifina == 1
gen info_value = finasset_value if informal == 1
collapse (max)checking saving mifina informal (mean)checking_value mifin_value info_value, by( household_id individual_id)
save value, replace
merge 1:m household_id individual_id using financial_inclusion 
drop _merge
sort ea_id
save fininclusionsaving, replace
*/


**********************************************
*community
**********************************************
use sect04_com_w4.dta, clear 
ren cs4q11 Center 
label var Center cs4q11
rename cs4q52 SACCO_acc 
replace SACCO_acc = 0 if SACCO_acc==2
ren cs4q53 SACCO_dis
replace SACCO_dis = 0 if SACCO_acc == .
replace cs4q14 = 0 if cs4q14 == 2
rename cs4q14 weekly_market
ren cs4q15 mkt_dist 
rename cs4q43 CB_access
g CB_distance = cs4q44
rename cs4q45 microfinance_access
g MF_distance  = cs4q46
replace MF_distance =  0 if MF_distance == .

g bankagent_access  = cs4q54

g bankagent_distance  = cs4q55
replace bankagent_distance =  0 if bankagent_distance == .



rename cs4q50 ATM_access 
rename cs4q51 ATM_distance 
replace ATM_distance =  0 if ATM_distance == .
replace mkt_dis = 0 if mkt_dis == . 
*sort saq01 saq02 saq03 saq06 
sort ea_id
 
collapse (mean) mkt_dis bankagent_distance ATM_distance SACCO_dis CB_distance MF_distance (max)Center bankagent_access ATM_access SACCO_acc CB_access weekly_market  , by(ea_id)  

ren CB_distance distance_toCommercialbank
ren SACCO_dis distance_toSavingandcreditasso
ren ATM_distance distance_toATM
*replace MF_distance = 1 if MF_distance > 0
sort ea_id
save round4_comm, replace
merge 1:m ea_id using FI_inclusionall
*FI_inclusionall
*keep if _merge==3
*drop _merge

save financial_inclusion4_all, replace 

**

*-------------CONS aggregate data-------*

use cons_agg_w4, clear 
*we took the 2015/16 poverty line and adjusted to 2018/19 using annual CPI
**see the excel file
* Adjusted povety line for Food for 2018/19: 5515 and total 10471



/* Note that the above computation of poverty line was changed due to Tadeles's suggestion

Tadeles suggestion:

poverty line at (t) = poverty line (t-1)*(cpi(t)/cpi(t-1))
poverty line at (t=2015) = 7184
cpi at (t=2015) =207.29
cpi at (t=2018) = 278.49
Therefore, using the above formula,
poverty line at (t=2015) = 7184 

poverty line at (t=2018) = 7184*(278.49/207.29) =9660.88

*/
gen pov = (nom_totcons_aeq>9660.88)
lab def pov 0 "Poor" 1 "Non Poor"
lab val pov pov
tab pov 

/*
Original poverty estimate
pov	Freq.	Percent	Cum.
			
0	1,983	29.29	29.29
1	4,787	70.71	100.00
			
Total	6,770	100.00

Revised poverty estimate
       pov |      Freq.     Percent        Cum.
------------+-----------------------------------
       Poor |      1,756       25.94       25.94
   Non Poor |      5,014       74.06      100.00
------------+-----------------------------------
      Total |      6,770      100.00

*/

gen hh_sizesq = hh_size*hh_size

save final_08_poverty , replace

*head information 

use sect1_hh_w4, clear

keep if s1q01==1 // keep if relationship is head
gen headage =  s1q03a 
label var headage "Household head age in years"
*age of household age
replace s1q03b=0 if s1q03b==.
gen age=s1q03a+s1q03b/12
gen age_sq=age*age
label var age "Age of the household head"
label var age_sq "Square of age of the household head"
*education lebled as a years taken for education that means, we tried to catagorize the years of education from 1 to 16.
gen edu_years=.
*Can't read or write=0
replace edu_year=0  if s1q16==96 | s1q16==98 |s1q16==0
replace edu_year=1  if s1q16==93 | s1q16==94 |s1q16==95 |s1q16==1
replace edu_year=2  if s1q16==2
replace edu_year=3  if s1q16==3
replace edu_year=4  if s1q16==4
replace edu_year=5  if s1q16==5
replace edu_year=6  if s1q16==6
replace edu_year=7  if s1q16==7
replace edu_year=8  if s1q16==8
replace edu_year=9  if s1q16==9   | s1q16==21
replace edu_year=10 if s1q16==10 |s1q16==22
replace edu_year=11 if s1q16==11 |s1q16==23 |s1q16==25
replace edu_year=12 if s1q16==12 |s1q16==24 |s1q16==26 |s1q16==27
replace edu_year=13 if s1q16==13 |s1q16==28 |s1q16==29 |s1q16==30 |s1q16==31
replace edu_year=14 if s1q16==14 | s1q16==34 |s1q16==32 |s1q16==16 |s1q16==17

replace edu_year=15 if s1q16==35 |s1q16==33 |s1q16==18 |s1q16==19
replace edu_year=16 if s1q16==20
replace edu_year=.  if s1q16==99
label var edu_year "years of education completed by household head"

rename s1q01 head 
rename s1q02 gender 

gen malehead =  1 if gender == 1
replace malehead = 0 if gender == 2 
label var malehead "Household head is male"
label define hh 1"Male head" 0"Female head"
label values malehead hh 

gen headeduc = 0 if s1q16 == 98 & (malehead == 1 | malehead == 0)
replace headeduc = 1 if headeduc == .  
label var headeduc "Household head education status"
label define hh1 1"head is illitrate" 2"head is atleast primary or informally educatted"
label values headeduc hh1 


gen sector  = 1 if s1q21 == 1 
replace sector = 0 if sector == . 
label var sector "main enterprise is agriculture"
label define hh2 1"Agriculture" 2"Others"
label values sector hh2 

gen married = 1 if s1q09 == 2 
replace married = 0 if married == . 
label var married "Household head is married"
label define hh3 1"Yes" 0"No"
label values married hh3 


lab def saq01   1 TIGRAY 2 AFAR /*
 */ 3 AMHARA 4 OROMIA  5 SOMALI /*
 */ 6 BENISHANGUL 7 SNNP 12 GAMBELA /*
 */ 13 HARAR 14 "ADDIS ABABA" /*
 */ 15 "DIRE DAWA" 8 "Other regions", modify

gen region = saq01
replace region = 8 if region == 2 | region == 5 | region == 6 | region == 12 | region == 13 | region == 14 | region == 15 
 label define rig 1"Tigray" 3"Amhara" 4"Oromia" 7"SNNPR" 8"Others"
 label values region rig 
*drop if saq01 == 15 
ren saq14 rural
replace rural=0 if rural==2
lab def saq14 1 "Rural" 0 "Urban", modify

*replace s1q02=0 if s1q02==2
*lab def s1q02 1 "Male" 0 "Female", modify
*rename s1q02 gender


save final_09_hh_char, replace

merge 1:1 household_id using final_08_poverty 
keep if _merge == 3 
drop _merge 
save final_10_poverty_hh_char, replace 

merge m:1 ea_id using round4_comm 
keep if _merge == 3 
drop _merge 
save final_11_poverty_hh_char_comm, replace

merge 1:m household_id using FI_inclusionall 

*keep if _merge == 3 
drop _merge 
save HH_FI_inclusionall, replace 


*---------
use sect10b_hh_w4, clear 
rename s10bq08a area 
rename s10bq08b unit 
replace area = 0 if area == . 
gen area_ha =  area if unit == 1 

replace area_ha = area/10000 if unit == 2 
replace area_ha = area/0.25 if unit == 3 | unit == 6 | unit == 7 | unit == 5 
label var area_ha "land owned in Hecatre"

collapse (sum)area_ha, by(household_id)
*drop if area_ha > 10
save land, replace 
*-----------
use  sect10d2_hh_w4, clear
ren s10dq02 livestock 
collapse (sum)livestock, by(household_id)
sort household_id 
save livestock, replace 

merge 1:1 household_id using land  
*keep if _merge == 3 
drop _merge 
replace livestock = 0 if livestock == . 
*replace livestock= 1 if livestock > 0
save land_live, replace 

*asset 
use sect11_hh_w4, clear 
drop if s11q00 == 2
ren s11q01 asset 
gen Rad_T  = 1 if (asset_cd == 8 | asset_cd ==9 ) & asset > 0 
replace Rad_T = 0 if Rad_T == .
tab asset_cd, gen(ass)
global ass ass1 ass2 ass3 ass4 ass5 ass6 ass7 ass8 ass9 ass10 ass11 ass12 ass13 ass14 ass15 ass16 ass17 ass18 ass19 ass20 ass21 ass22 ass23 ass24 ass25 ass26 ass27 ass28 ass29 ass30 ass31 ass32 ass33 ass34 ass35
collapse (sum)asset  (max)$ass Rad_T, by(household_id)
label var Rad_T "Household has Radio or Television"

pca $ass

*stata by default maintains two dimensions ( in our case dim 1 and dim 2 combine to explain 74% )
predict assetindex

save asset, replace 
merge 1:1 household_id using land_live
keep if _merge == 3 
drop _merge 
save land_live_asset, replace 

use HH_FI_inclusionall, clear 
merge 1:1 household_id using land_live_asset  

*keep if _merge == 3 
*drop _merge 

replace distance_toCommercialbank = 0 if distance_toCommercialbank == .
replace area_ha = ln(area_ha +1)
replace livestock = ln(livestock+1)
replace distance_toSavingandcreditasso =  0 if distance_toSavingandcreditasso==.

gen ldistancecbe = ln(distance_toCommercialbank+1)

*redefinig - poverty now 1 is poor  
recode pov (1 = 2) 
recode pov (0 = 1) 
recode pov (2 = 0)
recode Center ( 2 = 0)

label define ss 0"Non poor" 1"Poor"
label values pov ss

gen lMF_distance = ln( MF_distance + 1)
gen lbankagent_distance = ln( bankagent_distance +1 )
gen ldistance_toCommercialbank = ln(distance_toCommercialbank+1)
gen ldistance_toSavingandcreditasso = ln(1+distance_toSavingandcreditasso)
*save final_12_poverty_hh_char_dist_access, replace
tab region, gen(reg)
*replace area_ha = 1 if area_ha > 1 
gen age2 = age*age

*gg
*-----------------------------------------------------------------*

*log using emagneresult, replace 

*generate the number of financial products and services used by the household)
egen ind = rowtotal($serviceuse ownsaccount creditaccess remittance saving insurance)

label var ind "Finanacial Inclusion index" 




*simple logit Financial inclusion 
*Model 1 - logit 
logit ownsaccount finknowledge gender age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock i.saq01

predict ownsaccount_hat


margins, dydx(*)
est sto logitfi 

*save "D:\Dropbox\analysis\final\data_ready_for_modelling.dta", replace

save "C:\Users\emagn\Desktop\analysis\final\data_ready_for_modelling.dta", replace

*this output goes to ETH_adm1_wt_data for mapping
 collapse (mean)  finknowledge pov ind, by(saq01)



 


*Total Sample
* Model 2 - iv probit 
*use "C:\Users\emagn\Desktop\analysis\final\data_ready_for_modelling.dta", clear
use "C:\Users\Admin\Downloads\analysis\final\data_ready_for_modelling.dta", clear
ivprobit pov gender age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01 (ind=finknowledge), first


outreg2 using "$output_v2/ivreg_v2.txt", replace cttop(full)
outreg2 using "$output_v2/ivreg_v2.xls", replace cttop(full)
outreg2 using "$output_v2/ivreg_v2.doc", replace cttop(full)


probit pov ind gender age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01

outreg2 using "$output_v2/probit_v2.txt", replace cttop(full)
outreg2 using "$output_v2/probit_v2.xls", replace cttop(full)
outreg2 using "$output_v2/probit_v2.doc", replace cttop(full)





*Area of residence
* Model 2 - iv probit 
ivprobit pov gender age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01 (ind=finknowledge) if rural==0, first

outreg2 using "$output_v2/regression_v2_rural.txt", replace cttop(full)
outreg2 using "$output_v2/regression_v2_rural.xls", replace cttop(full)
outreg2 using "$output_v2/regression_v2_rural.doc", replace cttop(full)
//////////////////////////////////////


* Model 2 - iv probit 
ivprobit pov gender age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01 (ind=finknowledge) if rural==1, first

outreg2 using "$output_v2/regression_v2_urban.txt", replace cttop(full)
outreg2 using "$output_v2/regression_v2_urban.xls", replace cttop(full)
outreg2 using "$output_v2/regression_v2_urban.doc", replace cttop(full)
//////////////////////////////////////






*GENDER
* Model 2 - iv probit 
ivprobit pov age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01 (ind=finknowledge) if gender==2, first

outreg2 using "$output_v2/regression_v2_female.txt", replace cttop(full)
outreg2 using "$output_v2/regression_v2_female.xls", replace cttop(full)
outreg2 using "$output_v2/regression_v2_female.doc", replace cttop(full)
//////////////////////////////////////


///////////////Male modle estimation taken to text/////////////
* Model 2 - iv probit 
ivprobit pov age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01 (ind=finknowledge) if gender==1, first

outreg2 using "$output_v2/regression_v2_male.txt", replace cttop(full)
outreg2 using "$output_v2/regression_v2_male.xls", replace cttop(full)
outreg2 using "$output_v2/regression_v2_male.doc", replace cttop(full)
//////////////////////////////////////














*joing signifiance of instrumental variablescan applied 
*if the instrumental variables are more than one. but in this case the instrumental variable is only finknowledge= financial service and product use knowledge.

test ldistance_toCommercialbank distance_toSavingandcreditasso
g double used=e(sample)

margins, dydx(*)
est sto logitiv 

***Ownsaccount
*Two stage
logit ownsaccount gender age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01 ldistance_toCommercialbank

predict Fowns, residual 

*second stage 
probit pov gender age  edu_year married hh_size  sector rural weekly_market area_ha livestock assetindex  i.region ownsaccount Fowns

est sto modelone

*****   mobilebanking 
logit mobilebanking  gender age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01 ldistance_toCommercialbank

predict Fmobank, residual 

*second stage 
probit pov gender age  edu_year married hh_size  sector rural weekly_market area_ha livestock assetindex  i.region mobilebanking  Fmobank
est sto modeltwo
*** intfreebanking
 logit intfreebanking gender age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01 ldistance_toCommercialbank

predict Finternet, residual 

*second stage 
probit pov gender age  edu_year married hh_size  sector rural weekly_market area_ha livestock assetindex  i.region intfreebanking Finternet
  
  *****atmbanking 
 logit atmbanking gender age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01 ldistance_toCommercialbank

predict Fatmbank, residual 

*second stage 
probit pov gender age  edu_year married hh_size  sector rural weekly_market area_ha livestock assetindex  i.region atmbanking Fatmbank
est sto modelthree

esttab modelone modeltwo modelthree using emagnerobust.doc, mtitles("Own account" "Mobile" "ATM") b(2) se(2) starlevels (* 0.1 ** 0.05 *** 0.01) stats(N) wide addnote ("Source: own calculation using 2018/19 LSMS-ISA ESS data")
 

ivprobit pov gender age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01 (ind= ldistance_toCommercialbank), first


*tabulating index values 
tab ind if used == 1
*summary of the estimated sample
*sum poverty 
sum pov  if used == 1 
*sum variables used for index calculation 
sum $serviceuse ownsaccount creditaccess remittance saving insurance  if used == 1 
*independent varibables 
sum gender age edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01    ldistance_toCommercialbank if used == 1 






****** CHOKE******
*****to change the values of male ane female variables
 gen sex = gender
 replace sex=0 if gender==2
 tab pov if sex==1
 tab pov if sex==0
 tab sex if pov==1
 tab sex if pov==0

mean edu_years headeduc married headage gender ownsaccount creditaccess remittance rural hh_size pov, over( rural )
***OR*** just to calculate the mean and standard deviation 
sort gender
by gender: su edu_years headeduc married headage gender ownsaccount creditaccess remittance rural hh_size pov
******************


esttab logitfi logitiv using emagne21.doc, mtitles("Logit" "IV Probit" ) b(2) se(2) starlevels (* 0.1 ** 0.05 *** 0.01) stats(N) wide addnote ("Source: own calculation using 2018/19 LSMS-ISA ESS data")


log close 


**** male against female ****
recode gender (2=0)
*male
logit pov ind age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01 if gender==1 
margins, dydx(*)
est sto logitfim
 
***Female

logit pov ind age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01 if gender==0
margins, dydx(*)
est sto logitfif

* Model 2 - iv probit male 
ivprobit pov age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01 (ind=   ldistance_toCommercialbank) if gender==1, first

margins, dydx(*)
est sto logitivm
* Model 2 - iv probit female 
ivprobit pov age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01 (ind=   ldistance_toCommercialbank) if gender==0, first

margins, dydx(*)
est sto logitivf

*** all results in a table format
esttab logitfim logitfif logitivm logitivf using emagne23.doc, mtitles("Logitm" "Logitf" "IV Probitm" "IV Probitf") b(2) se(2) starlevels (* 0.1 ** 0.05 *** 0.01) stats(N) wide addnote ("Source: own calculation using 2018/19 LSMS-ISA ESS data")


**/////// probit and iv probit models by gender and rural urban catagories. 

*Model 1 - logit urban
logit pov ind gender age age2 edu_year married hh_size Rad_T sector weekly_market area_ha livestock   i.saq01 if rural==0
margins, dydx(*)
est sto logitfiu 

*Rural
logit pov ind gender age age2 edu_year married hh_size Rad_T sector weekly_market area_ha livestock   i.saq01 if rural==1
margins, dydx(*)
est sto logitfir 
* Model 2 - iv probit 
ivprobit pov gender age age2 edu_year married hh_size Rad_T sector weekly_market area_ha livestock   i.saq01 (ind=   ldistance_toCommercialbank) if rural==0, first

margins, dydx(*)
est sto logitivu 
*urban 
ivprobit pov gender age age2 edu_year married hh_size Rad_T sector weekly_market area_ha livestock   i.saq01 (ind=   ldistance_toCommercialbank) if rural==1, first

margins, dydx(*)
est sto logitivr 

esttab logitfiu logitfir logitivu logitivr using emagne24.doc, mtitles("Logitu" "Logitr" "IV Probitu" "IV Probitr") b(2) se(2) starlevels (* 0.1 ** 0.05 *** 0.01) stats(N) wide addnote ("Source: own calculation using 2018/19 LSMS-ISA ESS data")

***** we used the follwoing command if we want to investigate therelationship b/n FI indicators and poverty***
logit pov mobilebanking ownsaccount creditaccess remittance headage hh_size hh_sizesq gender rural edu_years married i.saq01    ldistance_toCommercialbank
margins, dydx(*)
**?????????????????????????????????


***In order to see the regional destrbution of FI by poverty status, we  use the following commad. 
sort saq01 
bysort saq01: tabstat ind, by (pov)






*** Commands from GIULIO
 tabstat distance_toCommercialbank , by(saq01) stat(mean)
 tabstat finknowledge , by(saq01) stat(mean)

 estpost tabstat distance_toCommercialbank pov ind , by(saq01) stat(mean)
 estpost tabstat finknowledge pov ind , by(saq01) stat(mean)

 esttab . using "C:\Users\emagn\Desktop\analysis\outputs\descriptives\stat by region.csv",cells("Mean(f(3))") replace label

 * Load the map
 shp2dta using "D:\Dropbox\analysis\raw\maps\ETH_adm1.shp", database(eth_regions) coordinates(ethcoord) genid(region_id) replace
 
 * Load the data for the map
import delimited D:\Dropbox\analysis\raw\maps\ETH_adm1_wt_data.csv, varnames(1) clear
 
spmap fii using ethcoord, id(id_1) legend(on) fcolor(Greens2) // plots the variable on the map



graph export "D:\Dropbox\analysis\outputs\descriptives\fii_by_region.png", replace // exports the map onto a png file

*import data for the second veriino
import delimited D:\Dropbox\analysis\raw\maps\ETH_adm1_wt_data_v2.csv, varnames(1) clear

spmap pov using ethcoord, id(id_1) legend(on) fcolor(Greens2) 

spmap finknowledge using ethcoord, id(id_1) legend(on) fcolor(Greens2) 

*clbreaks(0.75 1 1.25 1.5 1.75 2 2.25 2.5 2.75 3) clmethod(custom) 

*legend(label(2 "0 to 1000") label(3 "1001 to 2000") label(4 "2001 to 3000" ) label(5 "3001 to 5000" ) label(6 "5001 to 10000" ) label(7 "10000+" )) //


****Scaterplot to see the corolation betewen indicators(FII, Pov and Distance to the nearest bnk) by regoion. 
twoway scatter fii pov
twoway scatter fii pov, mlab(name_0)
twoway scatter fii pov, mlab(name_1)
twoway scatter fii pov || lfit fii pov, mlab(name_1)
twoway scatter fii pov, mlab(name_1) || lfit fii pov
graph save Graph "C:\Users\user\Desktop\analysis\January 2023 Article one\orrolation beteween Fii and Pov by region .gph"
 
 
****To work on some graph and tables 
tabstat $serviceuse ownsaccount creditaccess remittance saving insurance if used==1, by(pov)
tabstat $serviceuse ownsaccount creditaccess remittance saving insurance if used==1 & saq01 == 1, by(pov)
twoway bar $serviceuse ownsaccount creditaccess remittance saving insurance if used==1 , by(pov)
twoway bar $serviceuse ownsaccount creditaccess remittance saving insurance if used==1 & saq01 == 3, by(pov
graph bar $serviceuse ownsaccount creditaccess remittance saving insurance if used==1 & saq01 == 3, by(pov)
---------------------

//////////////////////////////////////
****Full Summary statistics to be used as an appendix****


***Full summary statistics
tabstat pov mobilebanking ownsaccount creditaccess remittance headage hh_size hh_sizesq gender rural edu_years married Rad_T sector rural weekly_market area_ha livestock i.saq01 
 asdoc sum pov ownsaccount creditaccess remittance saving insurance gender age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock ind i.saq01

 **** Summary statistcs for rural /urban

 sort rural 
by rural : su pov ownsaccount creditaccess remittance saving insurance gender age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock ind i.saq01

 
*asdoc sum pov ownsaccount creditaccess remittance saving insurance gender age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock ind i.saq01


**** Summary statistics for male Female***
sort malehead
by malehead: su pov ownsaccount creditaccess remittance saving insurance gender age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock ind i.saq01


 *asdoc sum pov ownsaccount creditaccess remittance saving insurance gender age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock ind i.saq01

 /////////////////////////////
 
 
*findexb and FI_index2 give negative assocation 
ivprobit pov gender age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01 (findex=   Center), first

ivprobit pov gender age age2 edu_year married hh_size Rad_T sector rural weekly_market area_ha livestock   i.saq01 (FI_index2=   Center), first


* Instrumental variable regression 

ivprobit pov (FI_summary =  distance_toCommercialbank distance_toSavingandcreditasso ), first  
est sto basic 
ivprobit pov gender age  head_edu married hh_size  sector (FI_summary =  distance_toCommercialbank  ), first  
est sto hh
ivprobit pov gender age  head_edu married hh_size  sector rural weekly_market area_ha livestock (FI_summary = distance_toCommercialbank  ), first  
est sto hhplus 
ivprobit pov gender age edu_year married hh_size  sector rural weekly_market area_ha livestock   i.region (FI_summary =   ldistance_toCommercialbank distance_toSavingandcreditasso ), first  
est sto full
margins compute 
est out basic hh hhplus full 
ivprobit pov gender age  head_edu married hh_size sector rural weekly_market i.saq01 (FI_median =  SACCO_acc bankagent_access  ), first  


*----------------------------------------------------------------*
*as a two stage regression 
*first stage 
reg FI_summary distance_toCommercialbank  distance_toSavingandcreditasso gender age  edu_year married hh_size  sector rural weekly_market area_ha livestock  assetindex  i.region  

predict FIhat, residual 

*second stage 
probit pov gender age  edu_year married hh_size  sector rural weekly_market area_ha livestock assetindex  i.region FI_summary FIhat
mfx 

reg FI_summary distance_toCommercialbank  distance_toSavingandcreditasso gender headage  headeduc married adulteq  sector  weekly_market area_ha livestock i.region   if rural ==1

predict FIhatr, residual 

*second stage 
probit pov gender headage  headeduc married adulteq  sector weekly_market area_ha livestock i.region FI_summary FIhatr if rural == 1
*-----------------------------------------------------------------

*----------------------------------------------------------------*
*as a two stage regression robustnes check 
*first stage 
logit ownsaccount distance_toCommercialbank  distance_toSavingandcreditasso gender age  edu_year married hh_size  sector rural weekly_market area_ha livestock  assetindex  i.region  

predict Fowns, residual 

*second stage 
probit pov gender age  edu_year married hh_size  sector rural weekly_market area_ha livestock assetindex  i.region ownsaccount Fowns
mfx 

reg FI_summary distance_toCommercialbank  distance_toSavingandcreditasso gender headage  headeduc married adulteq  sector  weekly_market area_ha livestock i.region   if rural ==1

predict FIhatr, residual 

*second stage 
probit pov gender headage  headeduc married adulteq  sector weekly_market area_ha livestock i.region FI_summary FIhatr if rural == 1
*-----------------------------------------------------------------



****************

******************

ivprobit pov hh_size gender headeduc sector rural reg2 reg3 reg4 reg5 reg6 reg7 reg8 reg9 reg10 reg11 (FI_median = MF_distance bankagent_distance ), first


gg 


*** If you want some descriptions 
*knowledge of financial services by region 

tabstat  $account , by( saq01)

*financial products by region
tabstat $serviceuse, by(saq01)


*source of financial services by region
tabstat $saving , by(saq01)
tabstat $informalsaving, by(saq01)

*--------------------
*saving frequency formal and informal financial inst.

tabstat $ffsavingfrequency $informalsavingfreq, by(saq01)


*** If you want some descriptions 
*knowledge of financial services by rural  

tabstat $awarness, by(rural)

*financial products by region
tabstat $serviceuse, by(rural)

*source of financial services by region
tabstat $account, by(rural)

tabstat $informalsaving, by(rural)


*--------------------
*saving frequency formal and informal financial inst.

foreach x of varlist privatefreq publicfreq microfreq saccofreq{
tab `x' rural, row col
}

foreach x of varlist fhomesaving ffrfamsaving fassocationsaving fequbsaving fothersaving{
tab `x' rural, row col
}

