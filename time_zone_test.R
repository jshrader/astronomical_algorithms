## Testing the time zone offset calculator.
##
## Jeff Shrader
## 2017-01-17
## Time-stamp: "2017-01-19 09:58:46 jgs"

## Load the functions
source_dir <- getSrcDirectory(function(dummy) {dummy})
## For debugging
##source_dir <- "~/Dropbox/research/bin/astronomical_algorithms/"
source(paste0(source_dir,"find_time_zone.R"))

## An example of making a stata dataset
library("foreign")
in_data <- read.dta(test.dta)
in_data_tz <- find_tz(in_data)
in_data_tz_offset <- tz_offset(in_data_tz)
write.dta(in_data_tz_offset, file=out_data.dta)

## Run the unit tests for time zone finding
test_tz()
