*! version 1.0.0   February 13, 2014 @ 14:17:05

program define solar_calculator

version 10.0
   syntax varlist [if] [in]

   gen time_solcalc = 0.00
   gen ed = date - td(30dec1899)
   gen double jd = ed + 2415018.5 + time_solcalc - tz_offset/24 
   gen double jc = (jd - 2451545)/36525
   gen double gml_sun = mod(280.46646+jc*(36000.76983 + jc*0.0003032),360) 
   gen double gma_sun = 357.52911+jc*(35999.05029 - 0.0001537*jc)
   gen double eeo = 0.016708634 - jc*(0.000042037+0.0000001267*jc)
   gen double sun_eoc = sin((gma_sun*_pi/180))*(1.914602-jc*(0.004817+0.000014*jc))+sin((_pi/180)*(2*gma_sun))*(0.019993-0.000101*jc)+sin((_pi/180)*(3*gma_sun))*0.000289
   gen double sun_tl = sun_eoc + gml_sun
   gen double sun_ta = gma_sun + sun_eoc
   gen double sun_rv = (1.000001018*(1-eeo*eeo))/(1+eeo*cos((_pi/180)*(sun_ta)))
   gen double sun_al = sun_tl - 0.00569 - 0.00478*sin((_pi/180)*(125.04-1934.136*jc))
   gen double mobe = 23 + (26 + ((21.448 - jc*(46.815 + jc*(0.00059 - jc*0.001813))))/60)/60
   gen double obc = mobe + 0.00256*cos((_pi/180)*(125.04-1934.136*jc))
   gen double sun_ra = (180/_pi)*(atan2(cos((_pi/180)*(obc))*sin((_pi/180)*(sun_al)),cos((_pi/180)*(sun_al))))
   gen double sun_dec = (180/_pi)*(asin(sin((_pi/180)*(obc))*sin((_pi/180)*(sun_al))))
   gen double foo_y = tan((_pi/180)*(obc/2))*tan((_pi/180)*(obc/2))
   gen double eot = 4*(180/_pi)*(foo_y*sin(2*(_pi/180)*(gml_sun))-2*eeo*sin((_pi/180)*(gma_sun))+4*eeo*foo_y*sin((_pi/180)*(gma_sun))*cos(2*(_pi/180)*(gml_sun))-0.5*foo_y*foo_y*sin(4*(_pi/180)*(gml_sun))-1.25*eeo*eeo*sin(2*(_pi/180)*(gma_sun)))
   gen double ha_sunrise = (180/_pi)*(acos(cos((_pi/180)*(90.833))/(cos((_pi/180)*(latitude))*cos((_pi/180)*(sun_dec)))-tan((_pi/180)*(latitude))*tan((_pi/180)*(sun_dec))))
   gen double solar_noon = (720-4*longitude-eot+tz_offset*60)/1440
   gen double sunrise_time = solar_noon - ha_sunrise*4/1440
   gen double sunset_time = solar_noon + ha_sunrise*4/1440
   gen double sunlight_duration = 8*ha_sunrise

   replace sunrise_time = sunrise_time*24
   replace sunset_time = sunset_time*24

   label var sunrise_time "Local sunrise time in decimal hours"
   label var sunset_time "Local sunset time in decimal hours"
   label var sunlight_duration "Hours of sunlight"
   label var sun_ra "Right ascension of the sun"
   label var sun_dec "Declination of the sun"
   
   // Clean up 
   drop time_solcalc jd jc ed gml_sun gma_sun eeo sun_eoc sun_tl sun_ta sun_rv sun_al mobe obc foo_y eot ha_sunrise

end
