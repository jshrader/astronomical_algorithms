clear
program drop solar_calculator
set obs 2
* Test the case of New Zealand
gen tz_offset = 13
gen latitude = -41.288
gen longitude = 174.7772
replace tz_offset = 12 in 2
gen date = d(16dec2015)
* With no arguments
solar_calculator
su sunset_time 
assert r(mean) > 20.33029
assert r(mean) < 20.3303

keep date latitude longitude tz_offset
* With arguments
solar_calculator, date(date) tz_offset(tz_offset) latitude(latitude) longitude(longitude)
su sunset_time 
assert r(mean) > 20.33029
assert r(mean) < 20.3303

* The old way
keep date latitude longitude tz_offset
solar_calculator

* With differently named arguments
keep date latitude longitude tz_offset
rename date v1
rename tz_offset v2
rename latitude v3
rename longitude v4
solar_calculator, date(v1) tz_offset(v2) latitude(v3) longitude(v4)
su sunset_time 
assert r(mean) > 20.33029
assert r(mean) < 20.3303

* Generate balanced panel of sun related variables
clear
set obs 36500
gen day = floor(_n/100)*100
replace day = 0 if day == 36500
bysort day: gen id = _n
gen latitude = id - 11
bysort id: gen doy = _n
drop day
gen date = .
replace date = d(31dec2000) + doy
gen tz_offset = 1
gen longitude = 0
solar_calculator

gen year = year(date)
collapse (mean) sunlight_duration, by(year latitude)
* You can clearly see that the calculator breaks down near the arctic
* (or antarctic) circle.
twoway line sunlight_duration latitude
