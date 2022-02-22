## Project Title: U.S. Banking Data

### Motivation
The banking data in the U.S. are difficult to navigate, and there are limited systemic resources outlining key steps to access such data. In this project, I describe approaches to access two main types of banking data: Y-9C, or FR Y-9C Consolidated Financial Statements for Bank Holding Companies, and "call report", or Report of Condition and Income.

### Key Results
- **Spatial analysis of banking** 
   - The map below shows bank branch closures (during 2017-2021) near the Orleans Parish, Louisiana, due to factors such as Covid-19 (*Source: FDIC*)
![](https://github.com/tengtedliu/us_banking_data/blob/main/graphics/branch.jpg)


### Key Documents
* `bank_data.pdf` describes the key steps in accessing such data, both for individual and bulk download
* `call_report_download.ipynb` accompanied by `y9c_links.txt` offers one way to bulk download call reports
* `call_dataclean.do` and `y9c_dataclean.do` are Stata do files describing ways to clean the downloaded data
