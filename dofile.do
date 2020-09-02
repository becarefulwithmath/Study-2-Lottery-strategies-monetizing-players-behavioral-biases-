/*
clear all
import excel "G:\.shortcut-targets-by-id\1olWFU9o-f1EdvVqLZOwAQ9WHOepixcS3\LOTTO-bez literatury OK\systems\2 Final submission to IGS - work on reviewers comments\Study II - online survey\data\IP_to_country.xlsx", sheet("data2") firstrow allstring clear
saveold "G:\.shortcut-targets-by-id\1olWFU9o-f1EdvVqLZOwAQ9WHOepixcS3\LOTTO-bez literatury OK\systems\2 Final submission to IGS - work on reviewers comments\Study II - online survey\data\IP_to_country.dta", version(13) replace
set more off
clear all
import excel "G:\.shortcut-targets-by-id\1olWFU9o-f1EdvVqLZOwAQ9WHOepixcS3\LOTTO-bez literatury OK\systems\2 Final submission to IGS - work on reviewers comments\Study II - online survey\data\results-survey314699.xlsx", sheet("Lottery - Mturk") firstrow allstring clear
gen source ="mturk" 
append using "G:\.shortcut-targets-by-id\1olWFU9o-f1EdvVqLZOwAQ9WHOepixcS3\LOTTO-bez literatury OK\systems\2 Final submission to IGS - work on reviewers comments\Study II - online survey\data\forum results-survey566466.dta"
replace source="forum" if source==""
append using "G:\.shortcut-targets-by-id\1olWFU9o-f1EdvVqLZOwAQ9WHOepixcS3\LOTTO-bez literatury OK\systems\2 Final submission to IGS - work on reviewers comments\Study II - online survey\data\orsee results-survey566466.dta"
replace source="orsee" if source==""
append using "G:\.shortcut-targets-by-id\1olWFU9o-f1EdvVqLZOwAQ9WHOepixcS3\LOTTO-bez literatury OK\systems\2 Final submission to IGS - work on reviewers comments\Study II - online survey\data\ads results-survey566466.dta"
replace source="ads" if source==""
//add countries obtained from IP. Code for IP-country decoding - https://github.com/becarefulwithmath/IP_to_country
merge 1:1 idResponse_ID submitdateDate_submitted using "G:\.shortcut-targets-by-id\1olWFU9o-f1EdvVqLZOwAQ9WHOepixcS3\LOTTO-bez literatury OK\systems\2 Final submission to IGS - work on reviewers comments\Study II - online survey\data\IP_to_country.dta"
//removal of IP and emails
drop ipaddrIP_address IP end1Thank_you_for_y_ end2winThank_you_for_y_
*/
clear all
use "G:\.shortcut-targets-by-id\1olWFU9o-f1EdvVqLZOwAQ9WHOepixcS3\LOTTO-bez literatury OK\systems\2 Final submission to IGS - work on reviewers comments\Study II - online survey\Study II - online survey FOR SHARING\anonymized_data.dta", clear
//use "G:\Mój dysk\LOTTO-bez literatury OK\systems\2 Final submission to IGS - work on reviewers comments\Study II - online survey\Study II - online survey FOR SHARING\anonymized_data.dta", clear
set more off
drop if q5Do_you_particip_=="N/A"
drop if q5Do_you_particip_=="" 

////////******data preparation**********//////////
//edu and risk cleaning
replace q35What_is_the_hig_ = "University graduate - master's degree" if q35otherWhat_is_the_hig__=="Associate's degree"
replace q35What_is_the_hig_ = "school graduate" if q35otherWhat_is_the_hig__=="Currently in college"
replace q35What_is_the_hig_ = "school graduate" if q35otherWhat_is_the_hig__=="Piano , music"
replace q35What_is_the_hig_ = "school graduate" if q35otherWhat_is_the_hig__=="1 year of college"
replace q35What_is_the_hig_ = "school graduate" if q35otherWhat_is_the_hig__=="Attended trade college classes, & seiminars. I'm a freelance photographer. Freelance Paparazzi photographer."
replace q35What_is_the_hig_ = "school graduate" if q35otherWhat_is_the_hig__=="JD"
replace q35What_is_the_hig_ = "school graduate" if q35otherWhat_is_the_hig__=="school 8th"
replace q30SQ001How_willing_are__ = "10" if q30SQ001How_willing_are__=="<p>Completely willing to take risk</p><p>10</p>"
replace q31SQ001People_might_be__ = "10" if q31SQ001People_might_be__=="<p>Completely willing to take risk</p><p>10</p>"
replace q30SQ001How_willing_are__ = "0" if q30SQ001How_willing_are__=="<p>Completely unwilling to take risk</p><p>0</p>"
replace q31SQ001People_might_be__ = "0" if q31SQ001People_might_be__=="<p>Completely unwilling to take risk</p><p>0</p>"
tab q35What_is_the_hig_
//keep if q35What_is_the_hig_=="Other"

//drop too quick participants
destring interviewtimeTotal_time, replace force 
drop if interviewtimeTotal_time<200
//combine grouptimes from 4 sub-surveys into one 
//in case we want to analyse not overall survey time, but time per survey page.
local var "grouptime_2filtering"
gen `var'=""
replace `var'=groupTime701Group_time if `var'==""
replace `var'=groupTime707Group_time if `var'==""
replace `var'=groupTime714Group_time if `var'==""
replace `var'=groupTime720Group_time if `var'==""
local var "grouptime_4part1"
gen `var'=""
replace `var'=groupTime703Group_time if `var'==""
replace `var'=groupTime709Group_time if `var'==""
replace `var'=groupTime716Group_time if `var'==""
replace `var'=groupTime722Group_time if `var'==""
local var "grouptime_5part2"
gen `var'=""
replace `var'=groupTime704Group_time_The_ if `var'==""
replace `var'=groupTime710Group_time_The_ if `var'==""
replace `var'=groupTime717Group_time_The_ if `var'==""
replace `var'=groupTime723Group_time_The_ if `var'==""

//vars renaming, vars removal, cleaning
local var_initial "Country idResponse_ID q2How_often_do_yo_ q3In_which_year_w_ q4Which_lottery_d_ q5Do_you_particip_ q6Do_you_use_soc_ q7Could_you_pleas_ q8Could_you_pleas_ q9SQ001When_you_play_t__P q9SQ002When_you_play_t__U q9SQ003When_you_play_t__U q9SQ004When_you_play_t__P q9SQ005When_you_play_t__U q9SQ006When_you_play_t__B q9SQ007When_you_play_t__U q9SQ008When_you_play_t__U q9SQ009When_you_play_t__U q9SQ010When_you_play_t__R q10Some_books_and__ q11Could_you_provi_ q11otherCould_you_provi__ q12Could_you_very__ q13Are_you_followi_ q14Why_are_you_or_ q15Is_there_anothe_ q16Could_you_provi_ q16otherCould_you_provi__ q17Could_you_very__ q18Are_you_followi_ q19Why_are_you_or_ q20Do_you_use_any__ q21How_is_the_soft_ q22Could_you_pleas_ q23Why_do_you_use__ q24Could_you_pleas_ q25SQ001If_you_play_the__ q25SQ002If_you_play_the__ q25SQ003If_you_play_the__ q26Are_there_peopl_ q27How_often_do_yo_ q28SQ001Please_choose_a__ q28SQ002Please_choose_a__ q30SQ001How_willing_are__ q31SQ001People_might_be__ q32SQ001Here_are_severa__ q32SQ002Here_are_severa__ q32SQ003Here_are_severa__ q32SQ004Here_are_severa__ q32SQ005Here_are_severa__ q32SQ006Here_are_severa__ q32SQ007Here_are_severa__ q32SQ008Here_are_severa__ q32SQ009Here_are_severa__ q32SQ010Here_are_severa__ q33SQ001Please_choose_a__ q33SQ002Please_choose_a__ q33SQ003Please_choose_a__ q33SQ004Please_choose_a__ q33SQ005Please_choose_a__ q33SQ006Please_choose_a__ q33SQ009Please_choose_a__ q33SQ010Please_choose_a__ q33SQ007Please_choose_a__ q33SQ008Please_choose_a__ q34Gender q35What_is_the_hig_ q35otherWhat_is_the_hig__ q36Field_of_study q37Which_of_the_fo_ interviewtimeTotal_time grouptime_2filtering grouptime_4part1 grouptime_5part2 "
/*renaming stops if new varname is the same as old varname. This why we need this intermediate step in renaming*/ 
local var_temp "country1 idResponse_ID1 q2How_often_do_yo_11 q3In_which_year_w_12 q4Which_lottery_d_15 q5Do_you_particip_16 quickpicks17 q7Could_you_pleas_18 q8Could_you_pleas_19 analysis20 numerology21 wheeling22 play23 loa24 samenumbers25 randsoftware26 softwareprob27 softwarehelp28 randself29 knowstrategies31 q11Could_you_provi_32 q11otherCould_you_provi__33 q12Could_you_very__34 q13Are_you_followi_35 q14Why_are_you_or_36 q15Is_there_anothe_37 q16Could_you_provi_38 q16otherCould_you_provi__39 q17Could_you_very__40 q18Are_you_followi_41 q19Why_are_you_or_42 software43 q21How_is_the_soft_44 q22Could_you_pleas_45 q23Why_do_you_use__46 q24Could_you_pleas_47 peerplaybuy48 peerplaychoice49 peerplayresults50 peerplaypeople51 religiosityprivate52 religiositydivine53 religiositycarry54 riskgeneral56 riskfinancial57 extraversion58 q32big5_159 q32big5_260 q32big5_361 q32big5_462 q32big5_563 q32big5_664 q32big5_765 q32big5_866 q32big5_967 bhigher68 blower69 bthesame70 blotteryfair71 blotteryskill72 bluckycoin73 brituals74 bgamblfallacy75 blotteryunfair76 bjackpot77 woman78 education79 q35otherWhat_is_the_hig__80 q36Field_of_study81 income82 interviewtimeTotal_time86 grouptime_2filtering87 grouptime_4part188 grouptime_5part289 "
local var_final "country idResponse_ID frequency age q4Which_lottery_d_ syndicate quickpicks q7Could_you_pleas_ q8Could_you_pleas_ analysis numerology wheeling prey loa samenumbers randsoftware softwareprob softwarehelp randself knowstrategies q11Could_you_provi_ q11otherCould_you_provi__ q12Could_you_very__ followstrategy q14Why_are_you_or_ q15Is_there_anothe_ q16Could_you_provi_ q16otherCould_you_provi__ q17Could_you_very__ q18Are_you_followi_ q19Why_are_you_or_ software q21How_is_the_soft_ q22Could_you_pleas_ q23Why_do_you_use__ q24Could_you_pleas_ peerplaybuy peerplaychoice peerplayresults peerplaypeople religiosityprivate religiositydivine religiositycarry riskgeneral riskfinancial personality1 personality2 personality3 personality4 personality5 personality6 personality7 personality8 personality9 personality10 bhigher blower bthesame blotteryfair blotteryskill bluckycoin brituals bgamblfallacy blotteryunfair bjackpot woman education q35otherWhat_is_the_hig__ q36Field_of_study income interviewtimeTotal_time grouptime_2filtering grouptime_4part1 grouptime_5part2 "
rename (`var_initial') (`var_temp')
rename (`var_temp') (`var_final')
// renvars `var_initial' \ `var_temp'
// renvars `var_temp' \ `var_final'
keep `var_final' source
foreach var of varlist _all {
	label var `var' ""
}

//replacing answers with numbers
local var "quickpicks"
replace `var'="" if `var'=="As far as I know, there are no quick-picks in the lottery I usually play"
replace `var'="4" if `var'=="I always use quick-picks "
replace `var'="3" if `var'=="I usually use quick-pick, but occasionally choose numbers by myself"
replace `var'="2" if `var'=="I usually choose numbers by myself, but occasionally use quick-picks"
replace `var'="1" if `var'=="I always choose numbers by myself"
destring `var', replace  
gen  `var'1=.
replace `var'1=1 if `var'==4
replace `var'1=1 if `var'==3
replace `var'1=0 if `var'==2
replace `var'1=0 if `var'==1

local var "frequency"
replace `var'="5" if `var'=="Daily"
replace `var'="4" if `var'=="A few times per week"
replace `var'="3" if `var'=="A few times per month"
replace `var'="2" if `var'=="A few times per year"
replace `var'="1" if `var'=="Less than a few times per year"
destring `var', replace 

foreach var in religiositydivine religiositycarry personality1 personality2 personality3 personality4 personality5 personality6 personality7 personality8 personality9 personality10 bhigher blower bthesame blotteryfair blotteryskill bluckycoin brituals bgamblfallacy blotteryunfair bjackpot  {
replace `var'="1" if `var'=="Disagree strongly"
replace `var'="2" if `var'=="Disagree moderately"
replace `var'="3" if `var'=="Disagree a little"
replace `var'="3" if `var'==" Disagree a little"
replace `var'="4" if `var'=="Neither agree nor disagree"
replace `var'="5" if `var'=="Agree a little"
replace `var'="6" if `var'=="Agree moderately"
replace `var'="7" if `var'==" Agree  strongly" //two spaces!
replace `var'="7" if `var'=="Agree  strongly" //two spaces!
destring `var', replace 
}


replace woman="1" if woman=="Female"
replace woman="0" if woman=="Male"


foreach var in analysis numerology wheeling prey loa samenumbers randsoftware softwareprob softwarehelp randself peerplaybuy peerplaychoice peerplayresults {
replace `var'="1" if `var'=="never"
replace `var'="2" if `var'=="occasionally"
replace `var'="3" if `var'=="sometimes"
replace `var'="4" if `var'=="often"
replace `var'="5" if `var'=="very often"
replace `var'="6" if `var'=="always"
destring `var', replace
}

local var "education"
replace `var'="1" if `var'=="no formal schooling - never attended / kindergarten only"
replace `var'="2" if `var'=="school graduate"
replace `var'="3" if `var'=="University graduate - bachelor's degree"
replace `var'="4" if `var'=="University graduate - master's degree"
destring `var', replace force
tab education
local var1 "university"
gen `var1'=.
replace `var1'=0 if `var'==1
replace `var1'=0 if `var'==2
replace `var1'=1 if `var'==3
replace `var1'=1 if `var'==4

local var "followstrategy"
replace `var'="1" if `var'=="Not at all"
replace `var'="2" if `var'=="Only to a minor extent"
replace `var'="3" if `var'=="To a large extent"
replace `var'="4" if `var'=="Fully"
destring `var', replace force
local var "followstrategy"
gen  `var'1=.
replace `var'1=0 if `var'==1
replace `var'1=0 if `var'==2
replace `var'1=1 if `var'==3
replace `var'1=1 if `var'==4


local var "religiosityprivate"
replace `var'="1" if `var'=="Rarely or never"
replace `var'="2" if `var'=="A few times a month"
replace `var'="3" if `var'=="Once a week"
replace `var'="4" if `var'=="Two or more times/week"
replace `var'="5" if `var'=="Daily"
replace `var'="6" if `var'=="More than once a day"
destring `var', replace 

local var "peerplaypeople"
replace `var'="1" if `var'=="There are no such people"
replace `var'="2" if `var'=="There is one such person"
replace `var'="3" if `var'=="There are a few such people"
replace `var'="4" if `var'=="There are many such people  "
destring `var', replace 

local var "income"
replace `var'="1" if `var'=="We live very poorly – we don’t have enough for our basic needs"
replace `var'="2" if `var'=="We live modestly – we have to manage economically every day"
replace `var'="3" if `var'=="We live on average – we have enough money for everyday living, but we have to save for major purchases"
replace `var'="4" if `var'=="We live well – we can afford much without saving"
replace `var'="5" if `var'=="We live very well – we can afford some luxury"
destring `var', replace 

gen USA = 0
gen India = 0
gen Poland = 0
gen other_country = 1
replace USA=1 if country=="US"
replace India=1 if country=="IN"
replace Poland=1 if country=="PL"
replace other_country=0 if country=="US"
replace other_country=0 if country=="IN"
replace other_country=0 if country=="PL"

tabm USA India Poland other_country

foreach var in syndicate knowstrategies software  {
replace `var'="1" if `var'=="Yes"
replace `var'="0" if `var'=="No"
destring `var', replace 
}

foreach var in riskgeneral riskfinancial {
destring `var', replace force
}

foreach var in knowstrategies software woman age {
destring `var', replace force
}

// labeling groups of variables practices when playing
global practices "syndicate software analysis numerology wheeling prey loa samenumbers randself randsoftware softwareprob softwarehelp" //practicies_when_playing 1-6; "syndicate software" 0-1
//global xxx1 "frequency" //2-5
gen followstrategy_all = followstrategy
replace followstrategy_all = 1 if knowstrategies == 0
global stratexperience "knowstrategies followstrategy_all" //0-1; 1-4;
//browse $stratexperience
global peerplay "peerplaybuy peerplaychoice peerplayresults peerplaypeople" //1-6
global relig "religiosityprivate religiositydivine religiositycarry" //1-7
global risk "riskgeneral riskfinancial" //0-10
global beliefs "bhigher blower bthesame blotteryfair blotteryskill bluckycoin brituals bgamblfallacy blotteryunfair bjackpot" //1-7
// big5
gen extraversion=personality1+8-personality6 // MK12: added 8. no difference really
gen agreeableness=personality2+8-personality7
gen conscientiousness=personality3+8-personality8
gen emotional_stability=personality4+8-personality9
gen openness_to_experience=personality5+8-personality10
global big5 "extraversion agreeableness conscientiousness emotional_stability openness_to_experience"
//demographics
replace age=2020-age
gen age2=age^2
global demogr "age age2 woman university income USA India Poland other_country" //; age2 is age squared; university is boolean, equal to one if university is completed

///*************summary**************////
sum _all
//ssc inst tab_chi
//this tabm is a pain, why not to use simple sum _all? anyway I've done it:
/* 0-1 */ tabm syndicate software 
/* 0-1 */ tab knowstrategies
/* 1-4 */ tab followstrategy
/* 1-6 */ tabm analysis numerology wheeling prey loa samenumbers randself randsoftware softwareprob softwarehelp 
/* 2-5 */ tab frequency
/* 1-6 */ tabm $peerplay 
/* 1-7 */ tabm $relig
/* 1-10 */ tabm $risk
/* 1-7 */ tabm $beliefs
/* 1-7 */ tabm $big5
tab age 
replace age=. if age>100

/* 0-1 */ tabm woman university
tab income

//drop suspicios comments, probably the same person
gen string_present =  strpos(q7Could_you_pleas_, "a greater percentage of lot") > 0
tab string_present
drop if string_present==1
//looking at duplicated comments
foreach var in q11Could_you_provi_ q11otherCould_you_provi__ q12Could_you_very__ q14Why_are_you_or_ q15Is_there_anothe_ q16Could_you_provi_ q16otherCould_you_provi__ q17Could_you_very__ q18Are_you_followi_ q19Why_are_you_or_ q21How_is_the_soft_ q22Could_you_pleas_ q23Why_do_you_use__ q24Could_you_pleas_ q8Could_you_pleas_ q7Could_you_pleas_ q4Which_lottery_d_ {
table `var', stubwidth(40)
} 
// for  q12Could_you_very__  this is useless -- it's cut. couldn't we include more chars in the dta file?
// this is only to look at duplicated comments. Max number of characters is 40, so full comments avaliable if you click on Data Explorer.


//////***********analysis*******/////

//if Mturk matters? yes
gen source_mturk=(source=="mturk") // indicator of the source
// you used five different tests instead of just one that would perfectly do:
tab source_m quickpicks1, exact
tabstat $practices $demogr $risk $beliefs $big5 followstrategy, statistics( mean) by(source_mturk) 
//asdoc tabstat $practices $demogr $risk $beliefs $big5 followstrategy, statistics( mean) by(source_mturk) fs(6) save(Asdoc command results.doc) append

format $practices $demogr $risk $beliefs $big5 followstrategy %9.2f
asdoc tabstat $practices $demogr $risk $beliefs $big5 followstrategy, statistics( mean min max) columns(statistics) f  save(Asdoc command results.doc) replace


// correlations
pwcorr $stratexperience $demogr $big5   $practices, star(.01)

pwcorr  $practices, star(.01)

//pairwase correlation for all with Bonferoni adj
asdoc pwcorr quickpicks  $practices, label star(.01) fs(6) dec(2) bonferroni save(Asdoc command results.doc) append
asdoc pwcorr $stratexperience quickpicks  $practices, label star(.01) fs(6) dec(2) bonferroni save(Asdoc command results.doc) append

// ok, i'd say that these practices variables are generally highly correlated... basically just one factor:
factor $practices
fapara //Horn's "parallel analysis" test of principal components/factors. Look at factors that solid line (eigenvalue of factor n) is higher or equal to dashed line (average eighenvalue for the factor n)
asdoc rotate, varimax label dec(3) save(Asdoc command results.doc) append //Rotated factor loadings (pattern matrix) and unique variances for factors
//for paper:
//We use the analysis of eigenvalues to determine how many factors should be kept. The parallel analysis (Fig. 1, Appendix B) indicates that as many as five factors have higher eigenvalues than would be obtained had the data been generated randomly. 
//Entries above .3 are printed in bold to facilitate their quick identification. 


predict f_practices 


//regression
tab knowstrategies
tab followstrategy //q13. Are_you_following_advice_from_this_book_or_website_when_playing_the_lottery?		number	"Not at all Only to a minor extent To a large extent Fully"
tab q11Could_you_provi_ //q11. Could_you_provide_the_title_of_the_book_or_address_of_the_website_of_this_sort_that_you_remember_best?
tab q11otherCould_you_provi__ //q11[other]. Could_you_provide_the_title_of_the_book_or_address_of_the_website_of_this_sort_that_you_remember_best?_[Other]
tab q12Could_you_very__ //q12. Could_you_very_briefly_summarize_the_most_important_contents_of_this_book/website?


//regression -- practices (own strategies)
quietly reg f_practices source_mturk $demogr 
est store practices_1
quietly reg f_practices source_mturk $demogr frequency knowstrategies 
est store practices_2
quietly reg f_practices source_mturk $demogr frequency knowstrategies  $relig 
est store practices_3
quietly reg f_practices source_mturk $demogr frequency knowstrategies $relig $big5 
est store practices_4
quietly reg f_practices source_mturk $demogr frequency knowstrategies $relig $big5 $beliefs
est store practices_5
quietly reg f_practices source_mturk $demogr frequency knowstrategies $relig $big5 $beliefs $peerplay
est store practices_6
reg f_practices source_mturk $demogr frequency knowstrategies $relig $big5 $beliefs $peerplay $risk
est store practices_7
est table practices_1 practices_2 practices_3 practices_4 practices_5 practices_6 practices_7, b(%12.3f) var(20) star(.01 .05 .10) stats(N r2_a) // PAPER

//regression -- strategies from books etc.
foreach depvar in followstrategy_all{
quietly ologit `depvar' source_mturk $demogr 
est store sbook_1
quietly ologit `depvar' source_mturk $demogr frequency  
est store sbook_2
quietly ologit `depvar' source_mturk $demogr frequency   $relig 
est store sbook_3
quietly ologit `depvar' source_mturk $demogr frequency  $relig $big5 
est store sbook_4
quietly ologit `depvar' source_mturk $demogr frequency  $relig $big5 $beliefs
est store sbook_5
quietly ologit `depvar' source_mturk $demogr frequency  $relig $big5 $beliefs $peerplay
est store sbook_6
ologit `depvar' source_mturk $demogr frequency  $relig $big5 $beliefs $peerplay $risk
est store sbook_7a
est table sbook_1 sbook_2 sbook_3 sbook_4 sbook_5 sbook_6 sbook_7a, b(%12.3f) var(20) star(.01 .05 .10) stats(N) // PAPER (JUST FOLLOWSTRATEGY_ALL?)
}
// so the first one (followstrategy) looks at tendency to use a strategy conditional on knowing one. 
// the second (followstrategy_all) looks at using an unconditional tendency of using a strategy  (not knowing one is hte same as not 

tabstat $practices, stat(median, mean)











/* backup code

//descriptive statistics books
asdoc sum systm_year price_paperback_new price_paperback_used price_ebook design_score popularity_paperback_and_ebook_n popularity_paperback_and_ebook_r misleading_score if webpage==0, save(Asdoc command results.doc) append

//descriptive statistics webpages
asdoc sum number_of_products_offered systm_price_min systm_price_max subscription_price_per_month design_score_max4 systm_ppl_Alexa_rank_GLOBAL_25_0 misleading_score if webpage==1, save(Asdoc command results.doc) append


quietly logit mpm_player source_mturk $demogr 
est store spec_1
quietly logit mpm_player source_mturk $demogr frequency $stratexperience 
est store spec_2
quietly logit mpm_player source_mturk $demogr frequency $stratexperience $practices $relig 
est store spec_3
quietly logit mpm_player source_mturk $demogr frequency $stratexperience $practices $relig $big5 
est store spec_4
quietly logit mpm_player source_mturk $demogr frequency $stratexperience $practices $relig $big5 $beliefs
est store spec_5
quietly logit mpm_player source_mturk $demogr frequency $stratexperience $practices $relig $big5 $beliefs $peerplay
est store spec_6
quietly logit mpm_player source_mturk $demogr frequency $stratexperience $practices $relig $big5 $beliefs $peerplay $risk
est store spec_7
est table spec_1 spec_2 spec_3 spec_4 spec_5 spec_6 spec_7, b(%12.3f) var(20) star(.01 .05 .10) stats(N) // noomitted 

//dependent variable
gen mpm_player=. //monetary payoff maximizing player 
replace mpm_player=1 if quickpicks1==1 //quickpicks1 equal to one if quickspicks used most of the time
replace mpm_player=0 if quickpicks1==0


// 2. gen mpm_player=quickpicks1 would do
// 3. because this would do, there is no need to create such a var, just refer to it as quickpicks1

// labeling groups of variables:
global practices1 "analysis numerology wheeling play loa samenumbers randself randsoftware softwareprob softwarehelp" //practicies_when_playing 1-6
global practices2 "syndicate software" //0-1
global xxx1 "frequency" //2-5
global stratexperience1 "knowstrategies" //0-1
global stratexperience2 "followstrategy" //1-4
global peerplay "peerplaybuy peerplaychoice peerplayresults peerplaypeople" //1-6
global relig "religiosityprivate religiositydivine religiositycarry" //1-7
global risk "riskgeneral riskfinancial" //0-10
global beliefs "bhigher blower bthesame blotteryfair blotteryskill bluckycoin brituals bgamblfallacy blotteryunfair bjackpot"//1-7
// big5
gen extraversion=personality1-personality6
gen agreeableness=personality2-personality7
gen conscientiousness=personality3-personality8
gen emotional_stability=personality4-personality9
gen openness_to_experience=personality5-personality10
global big5 "extraversion agreeableness conscientiousness emotional_stability openness_to_experience"
//demographics
replace age=2020-age
gen age2=age^2
global demogr1 "age" //age2 is age squared
global demogr2 "woman university" //university is boolean, equal to one if university is completed
global demogr3 "income" //1-5

//ssc inst tab_chi 
tabm $demogr2
$practices // could you make it display names instead of labels?
sum _all

foreach var in $practices1 {
tabm `var'
}

//dependent variable
gen randsoftware1=. //boolean
replace randsoftware1=1 if randsoftware>=4 //quickpicks1 equal to one if quickspicks used most of the time
replace randsoftware1=0 if randsoftware<=3

gen mpm_player=. //moneraty payoff maximizing player 
replace mpm_player=1 if quickpicks1+randsoftware1==1 //quickpicks1 equal to one if quickspicks used most of the time
replace mpm_player=1 if quickpicks1+randsoftware1==2 //quickpicks1 equal to one if quickspicks used most of the time
replace mpm_player=0 if quickpicks1+randsoftware1==0
