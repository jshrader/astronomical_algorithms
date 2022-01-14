# astronomical_algorithms
Algorithms for calculating stuff about how the sun interacts with the earth

The name of the respository comes from the wonderfully titled book "Astronomical Algorithms" by Jean Meeus.

## solar_calculator.ado ##
Stata version of [NOAA's implementation](http://www.esrl.noaa.gov/gmd/grad/solcalc/calcdetails.html) of Meeus' sunset time calculation. 

WARNING: This calculator is accurate to within 1 minute for locations between +/- 72° latitude. For locations outside that area, the result degrade appreciably. For locations outside of +/- 66° latitude (i.e. above the artic circle), the algorithm can break down because of sunlight durations longer than 24 hours. For best results, only use this calculator for locations with absolute latitude less than 66°.

### Syntax ###
    solar_calculator, date([varname]) tz_offset([varname]) latitude([varname]) longitude([varname])

### Inputs ###
Note that all arguments are non-optional. I am violating normal Stata syntax here, but it was easier to parse.

* date: Date for which you want to calculate sunset time in Stata format.
* tz_offset: Timezone offset for the date and location.
* latitude: Latitude of location, positive should be north and negative should be south.
* longitude: Longitude of location, positive should be east and negative should be west.

### Outputs ###
* sunset_time - In decimal hours (see [here](https://www.stata.com/statalist/archive/2009-08/msg00303.html) for how to convert to hours and minutes)
* sunrise_time - In decimal hours (see [here](https://www.stata.com/statalist/archive/2009-08/msg00303.html) for how to convert to hours and minutes)
* solar_noon: [Solar noon](https://en.wikipedia.org/wiki/Noon#Solar_noon)
* sunlight_duration - In minutes (despite what the variable label says)
* sun_dec: [Declination of the sun](https://en.wikipedia.org/wiki/Position_of_the_Sun#Declination_of_the_Sun_as_seen_from_Earth)



## solar_calculator_unit_test.do ##
This file runs some simple checks of the Stata sunset time calculator. There are some edge cases around the dateline and some different possible syntaxes that I want to make sure work.

## find_time_zone.R ##
### Warning ###
WARNING: This code is not yet generalized. You will need to edit paths in the code to get it working on your system. Read all of this help file and follow the instructions. 

### Preliminaries ###
R program to provide the time zone offset for any location and date. 

To run this code, you need or are encouraged to have the following R packages (spatial stuff is package-heavy; sorry):
```
sp, rgeos, stringr, rgdal, raster, foreign, data.table, iotools, maptools, and readr
```

You will also need to download the [tz_world shapefile](http://efele.net/maps/tz/world/) and make it accessible to this code. Then, edit the path to tz_world in `find_time_zone.R`.

One might be able to replace this file with the countytimezones package in R: https://cran.r-project.org/web/packages/countytimezones/countytimezones.pdf

### find_tz ###
#### Syntax ####
`find_tz(<input data>)`

#### Inputs ####
* lat: Latitude of location, where 90 to 0 is above the equator and 0 to -90 is below the equator.
* lon: Longitude of location, where 0 to 180 is east of the prime meridian and 0 to -180 is west.



#### Outputs ####
* lat: Returns input lat
* lon: Returns input lon
* tzid: Time zone ID from tz_world database

### tz_offset ###
#### Inputs ####
* tzid: Time zone ID as returned by `find_tz()`
* date: a string date for the day you want the time zone offest

Note that date is important for appropriately accounting for daylight savings time. The main advantage of this program over simply matching your location to a time zone shapefile is that this code also determines date-specific offsets due to daylight savings time.

#### Outputs ####
* tzid: From inputs
* date: From inputs
* tzoffset: Time zone offset relative to UTC for the given date

### Example ###
Here is an example of creating a file for use by solar_calculator.ado, taking in a dataset of dates and locations from Stata.
```R
library("foreign")
source_dir <- getSrcDirectory(function(dummy) {dummy})
source(paste0(source_dir,"find_time_zone.R"))

in_data <- read.dta(<dataset.dta>)
in_data_tz <- find_tz(in_data)
in_data_tz_offset <- tz_offset(in_data_tz)
write.dta(in_data_tz_offset, file=<output_dataset.dta>)
```

## To do ##
1. Provide sample dataset for example of full workflow starting with dates and locations and ending up with solar times
2. Make both programs use either lat/lon or latitude/longitude as default
3. Write R version of solar_calculator.ado
