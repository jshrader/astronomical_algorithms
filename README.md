# astronomical_algorithms
Algorithms for calculating stuff about how the sun interacts with the earth

The name of the respository comes from the wonderfully titled book "Astronomical Algorithms" by Jean Meeus.

## solar_calculator.ado ##
Stata version of [NOAA's implementation](http://www.esrl.noaa.gov/gmd/grad/solcalc/calcdetails.html) of Meeus' sunset time calculation. 

WARNING: This calculator is accurate to within 1 minute for locations between +/- 72° latitude. For locations outside that area, the result degrade appreciably. 

### Syntax ###
    solar_calculator, date([date_var]) tz_offset([tz_offset_var]) latitude([latitude_var]) longitude([longitude_var])

### Inputs: ###
Note that all arguments are non-optional. I am violating normal Stata syntax here, but it was easier to parse.

* date: Date for which you want to calculate sunset time.
* tz_offset: Timezone offset for the date and location. I have written a helper function for this to be released soon.
* latitude: Latitude of location, positive should be north and negative should be south.
* longitude: Longitude of location, positive should be east and negative should be west.

### Outputs ###
* sunset_time
* sunrise_time
* solar_noon: [Solar noon](https://en.wikipedia.org/wiki/Noon#Solar_noon)
* sunlight_duration
* sun_dec: [Declination of the sun](https://en.wikipedia.org/wiki/Position_of_the_Sun#Declination_of_the_Sun_as_seen_from_Earth)

### To Do ###
1. Automate the calculation of timezone offsets

## solar_calculator_unit_test.do ##
This file runs some simple checks of the Stata sunset time calculator. There are some edge cases around the dateline and some different possible syntaxes that I want to make sure work.

## All other files ##
All of the other files are incomplete. The matlab implementation of solar_calculator.ado works but has a few bugs that were corrected in the Stata version. 
