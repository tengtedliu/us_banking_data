rm(list=ls())
setwd('set your working directory here')

get_fry9c_data <- function(year, quarter, max_rows = 5000, verbose = TRUE)
{
  assertthat::assert_that(length(year) == 1 && length(quarter) == 1, msg = "year and quarter must be length 1")
  assertthat::assert_that(year >= 1986, msg = "the year must be >= 1986")
  assertthat::assert_that(quarter >= 1 & quarter <= 4, msg = "the quarter must be on [1,2,3,4]")
  
  file_name <- tempfile(pattern = "bhcdata", tmpdir = tempdir(), fileext = ".zip")
  base_url <- "https://www.chicagofed.org/api/sitecore/BHCHome/GetFile?SelectedQuarter=1&SelectedYear=2018"
  base_url_parsed <- httr::parse_url(base_url)
  base_url_parsed$query$SelectedQuarter <- quarter
  base_url_parsed$query$SelectedYear <- year
  base_url <- httr::build_url(base_url_parsed)
  h <- httr::handle(base_url)
  if (verbose)
  {
    cat("Querying for web data...\n")
    cat(paste0("\t", base_url, "\n"))
  }
  httr::GET(url = base_url, httr::write_disk(file_name, overwrite = TRUE), handle = h)
  if (verbose)
  {
    cat("Unzipping...\n")
    cat(paste0("\t", file_name, "\n"))
  }
  extract_files <- utils::unzip(file_name, overwrite = TRUE, unzip = "internal")
  if (verbose)
  {
    cat("Reading results...\n")
    cat(paste0("\t", extract_files[1], "\n"))
  }
  BHCFYYMM <- utils::read.table(extract_files[1], sep = "^", nrows = max_rows,
                                comment.char = "", header = TRUE, quote = "",
                                na.strings = "--------", as.is = TRUE,
                                stringsAsFactors = FALSE)
  if (nrow(BHCFYYMM) == max_rows)
  {
    warning(paste0("The dataset contains ", max_rows, " rows which is the limit of the read"))
  }
  unlink(file_name)
  unlink(extract_files[1])
  return(BHCFYYMM)
}

yyyy = seq(2000,2020,1)
qq = c(1,2,3,4)
Y = length(yyyy)
Q = length(qq)

complete_dat = NULL
library(haven)

i = 1
j = 1

temp = get_fry9c_data(yyyy[i],qq[j],max_rows = 50000)
name1 = names(temp)

for(i in 1:Y)
{
  print(paste('Year = ',yyyy[i],sep=''))
  for(j in 1:Q)
  {
    if(yyyy[i] < 2020)
    {
      temp = get_fry9c_data(yyyy[i],qq[j],max_rows = 50000)
      file_name = paste('FRY9C',yyyy[i],qq[j],'.dta',sep='')
      write_dta(temp,file_name)
    }
    
    if(yyyy[i]== 2020 & qq[j] <= 2)
    {
      temp = get_fry9c_data(yyyy[i],qq[j])
      file_name = paste('FRY9C',yyyy[i],qq[j],'.dta',sep='')
      write_dta(temp,file_name)
    }
  }
}


