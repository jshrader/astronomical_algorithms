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

