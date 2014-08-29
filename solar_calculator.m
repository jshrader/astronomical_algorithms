function [ sunset_time, sunrise_time, solar_noon, sunlight_duration, sun_dec ] = solar_calculator( latitude, longitude, date, tz_offset )
%SOLAR_CALCULATOR Summary of this function goes here
%   Detailed explanation goes here

time_solcalc = 0.00;
ed = m2xdate(datenum(date), 0);
jd = ed + 2415018.5 + time_solcalc - tz_offset./24;
jc = (jd - 2451545)./36525;
gml_sun = mod(280.46646+jc.*(36000.76983 + jc.*0.0003032),360);
gma_sun = 357.52911+jc.*(35999.05029 - 0.0001537.*jc);
eeo = 0.016708634 - jc.*(0.000042037+0.0000001267.*jc);
sun_eoc = sin((gma_sun.*pi./180)).*(1.914602-jc.*(0.004817+0.000014.*jc))+sin((pi./180).*(2.*gma_sun)).*(0.019993-0.000101.*jc)+sin((pi./180).*(3.*gma_sun)).*0.000289;
sun_tl = sun_eoc + gml_sun;
sun_al = sun_tl - 0.00569 - 0.00478.*sin((pi./180).*(125.04-1934.136.*jc));
mobe = 23 + (26 + ((21.448 - jc.*(46.815 + jc.*(0.00059 - jc.*0.001813))))./60)./60;
obc = mobe + 0.00256.*cos((pi./180).*(125.04-1934.136.*jc));
sun_dec = (180./pi).*(asin(sin((pi./180).*(obc)).*sin((pi./180).*(sun_al))));
foo_y = tan((pi./180).*(obc./2)).*tan((pi./180).*(obc./2));
eot = 4.*(180./pi).*(foo_y.*sin(2.*(pi./180).*(gml_sun))-2.*eeo.*sin((pi./180).*(gma_sun))+4.*eeo.*foo_y.*sin((pi./180).*(gma_sun)).*cos(2.*(pi./180).*(gml_sun))-0.5.*foo_y.*foo_y.*sin(4.*(pi./180).*(gml_sun))-1.25.*eeo.*eeo.*sin(2.*(pi./180).*(gma_sun)));
ha_sunrise = (180./pi).*(acos(cos((pi./180).*(90.833))./(cos((pi./180).*(latitude)).*cos((pi./180).*(sun_dec)))-tan((pi./180).*(latitude)).*tan((pi./180).*(sun_dec))));
solar_noon = (720-4.*longitude-eot+tz_offset.*60)./1440;
sunrise_time = solar_noon - ha_sunrise.*4./1440;
sunset_time = solar_noon + ha_sunrise.*4./1440;
sunlight_duration = 8.*ha_sunrise;

sunset_time = sunset_time*24;
sunrise_time = sunrise_time*24;


end

