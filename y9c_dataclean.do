
***During the construction process, Y9C datafiles have to be divided into three groups, 
***as variable names differ

****for 2018Q2 to 2020****
set more off
local files : dir "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Y9C/2018_2020" files "*.dta"

cd "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Y9C/2018_2020"
foreach file in `files' {
    use `file', clear
keep RSSD9001 RSSD9999 RSSD9007 RSSD9008 RSSD9043 RSSD9132 RSSD9040 RSSD9032 RSSD9146 ///
BHCK2170	BHCK0211	BHCK0213	BHCK1286	BHCK1287	BHCKHT50	BHCKHT51	BHCKHT52	BHCKHT53	BHDM1766	BHDM2122	BHCK2122 ///
BHDM1975	BHCKK207	BHCK2948 	BHFN6636	BHFN6631
save "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Y9C/append/`file'_append.dta", replace
}


****for 2011 to 2018Q1****
set more off
local files : dir "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Y9C/2011_2018" files "*.dta"

cd "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Y9C/2011_2018"
foreach file in `files' {
    use `file', clear
keep RSSD9001 RSSD9999 RSSD9007 RSSD9008 RSSD9043 RSSD9132 RSSD9040 RSSD9032 RSSD9146 ///
BHCK2170	BHCK0211	BHCKK207 BHCK0213	BHCK1286	BHCK1287	BHCK1289	BHCK1294	BHCK1290	BHCK1295	BHCK1291	BHCK1297	///
BHCK1293	BHCK1298	BHDM1766	BHDM2122	BHCK2122 ///
BHDM1975	BHCK2948 	BHFN6636	BHFN6631
save "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Y9C/append/`file'_append.dta", replace
}

****for 1994 to 2010 ****
set more off
local files : dir "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Y9C/1994_2010" files "*.dta"

cd "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Y9C/1994_2010"
foreach file in `files' {
    use `file', clear
  foreach v of varlist _all {
      capture rename `v' `= upper("`v'")'
   }
keep RSSD9001 RSSD9999 RSSD9007 RSSD9008 RSSD9043 RSSD9132 RSSD9040 RSSD9032 RSSD9146 ///
BHCK2170	BHCK0211  BHCK2011 BHCK0213	BHCK1286	BHCK1287	BHCK1289	BHCK1294	BHCK1290	BHCK1295	BHCK1291	BHCK1297	///
BHCK1293	BHCK1298	BHDM1766	BHDM2122	BHCK2122 ///
BHDM1975	BHCK2948 	BHFN6636	BHFN6631
save "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Y9C/append/`file'_append.dta", replace
}


****append 1994 to 2020 data ****
clear all 
cd "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Y9C/append"
! ls *.dta >filelist.txt


file open myfile using "/Users/ted/Dropbox/RA_Ted/Call_reports_Y9C/Bulk/Y9C/append/filelist.txt", read

file read myfile line
use `line'
save y9c_data, replace

file read myfile line
while r(eof)==0 { /* while you're not at the end of the file */
	append using `line'
	file read myfile line
}
file close myfile
save y9c_data, replace
