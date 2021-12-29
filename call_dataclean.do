******************create the dta files and create date variable from file names
******this requires processing different call report schedules, as they are separate files

set more off
local files : dir "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Call_complete" files "*.txt"

cd "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Call_dta"
foreach file in `files' {
import delimited "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Call_complete/`file'", varnames(1) stripquote(yes) case(upper) encoding(ISO-8859-1)clear
  gen date = substr("`file'",27,9)
save "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Call_dta/`file'.dta", replace
}



set more off
local files : dir "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Call_complete/RCB" files "*.txt"

cd "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Call_dta"
foreach file in `files' {
import delimited "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Call_complete/RCB/`file'", varnames(1) stripquote(yes) case(upper) encoding(ISO-8859-1)clear
  gen date = substr("`file'",28,9)
save "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Call_dta/`file'.dta", replace
}


set more off
local files : dir "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Call_complete/RCC" files "*.txt"

cd "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Call_dta"
foreach file in `files' {
import delimited "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Call_complete/RCC/`file'", varnames(1) stripquote(yes) case(upper) encoding(ISO-8859-1)clear
  gen date = substr("`file'",29,9)
save "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Call_dta/`file'.dta", replace
}



*******************need to change the file names manually; Stata won't read file names with space and parentheses (in Mac you can 'find and replace" file names in bulk)

******************append files
clear all 
cd "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Call_dta"
! ls *.dta >filelist.txt


file open myfile using "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Call_dta/filelist.txt", read

file read myfile line
use `line'
save call_data, replace

file read myfile line
while r(eof)==0 { /* while you're not at the end of the file */
	append using `line', force
	file read myfile line
}
file close myfile
save call_data, replace
 
**********
cd "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Call_dta"
use call_data, clear
keep IDRSSD RCFD2170 RCFD0211 RCFD0213 RCFD1286 RCFD1287 RCFDHT50 RCFDHT51 RCFDHT52 RCFDHT53 ///
RCON1763 RCON2122 RCFD2122 RCONB538 RCONB539 RCONK137 RCFDK207 RCFD2948 RCFN6636 RCFN6631 date
drop if IDRSSD==.
destring RCFD2170, replace
ren IDRSSD RSSD9001

****format date variable
gen quarter = substr(date, 2, 2)
gen year = substr(date, 6, 4)
gen day = substr(date, 4, 2)
destring quarter year day, replace
drop date
gen date2=mdy(quarter,day,year)
gen date = qofd(date2)
format date %tq
drop date2

egen id = group (RSSD9001 date)
global destring RCFD2948 RCFN6631 RCFN6636 RCFD0211 RCFD0213 RCFD1286 RCFD1287 RCFDHT50 ///
RCFDHT51 RCFDHT52 RCFDHT53 RCFD2122 RCON1763 RCON2122 RCONB538 RCONB539 RCFDK207 RCONK137

set more off
foreach x of varlist $destring {
destring `x', replace
}

collapse RSSD9001 RCFD2170 RCFD2948 RCFN6631 RCFN6636 date RCFD0211 RCFD0213 RCFD1286 RCFD1287 RCFDHT50 ///
RCFDHT51 RCFDHT52 RCFDHT53 RCFD2122 RCON1763 RCON2122 RCONB538 RCONB539 RCFDK207 RCONK137, by(id)

save "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Call_dta/call_data_variables.dta", replace

