%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2009-2012, Centre for Advanced Internet Architectures
% Swinburne University of Technology, Melbourne, Australia
% (CRICOS number 00111D).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% plotdaynightterminator.m
% A script for Matlab to draw the Day-Night terminator and the night shadow upon 
% a map created with the following two commands of the Mapping Toolbox:
%
% load coast;
% mapshow(long,lat,'Color','black');
%
% The function will calculate the day-night terminator based on the GMT (UTC) date.
% It will draw the terminator which fits the map created using the mapshow command, 
% and fill the night part of the map with a dark gray colour.
% The effect is similar to http://www.timeanddate.com/worldclock/sunearth.html and
% http://www.daylightmap.com/index.php
%
% The script needs the equinox information for the years it applies. 
% Currently only the 2009 and 2010 equinox information are included.
% more equinox information can be found at: 
% http://www.timeanddate.com/calendar/seasons.html 
% (don't forget to switch to GMT at the bottom of the page)
% 
% This script has been generated by following hints, tips and scripts found at:
% http://www.geoastro.de/elevaz/basics/index.htm
%
% This file is part of the animation_scripts.tar.gz tarball that can be obtained at:
% http://caia.swin.edu.au/sting/tools/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This software was developed by Mattia Rossi <mrossi@swin.edu.au>
%
% This software has been made possible in part by a grant from
% APNIC Pty. Ltd., Canberra, Australia. http://www.apnic.net/
%
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions
% are met:
% 1. Redistributions of source code must retain the above copyright
%    notice, this list of conditions and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright
%    notice, this list of conditions and the following disclaimer in the
%    documentation and/or other materials provided with the distribution.
% 3. The names of the authors, the "Centre for Advanced Internet Architecture"
%    and "Swinburne University of Technology" may not be used to endorse
%    or promote products derived from this software without specific
%    prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS "AS IS" AND
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
% OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
% HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
% LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
% OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
% SUCH DAMAGE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [coords, baseline, delta, dec, UT, K] = plotdaynightterminator(day,month,year,UTChour,UTCmin,UTCsec)

UT=UTChour+UTCmin/60+UTCsec/3600;
if month<=2
    month=month+12;
    year=year-1;
end
juliandate=(365.25*year) + (30.6001*(month+1)) - 15 + 1720996.5 + day + UT/24;
K=pi/180;
T = (juliandate - 2451545.0 ) / 36525;
L = 280.46645 + 36000.76983*T + 0.0003032*T*T;
L = mod(L,360);		
if L<0 
    L = L + 360;
end
M = 357.52910 + 35999.05030*T - 0.0001559*T*T - 0.00000048*T*T*T;
M = mod(M,360);
if M<0 
    M = M + 360;
end
C = (1.914600 - 0.004817*T - 0.000014*T*T)*sin(K*M);
C = C + (0.019993 - 0.000101*T)*sin(K*2*M);
C = C + 0.000290*sin(K*3*M);
theta=L+C;
LS = L;
LM = 218.3165 + 481267.8813*T;	
eps0 =  23.0 + 26.0/60.0 + 21.448/3600.0 - (46.8150*T + 0.00059*T*T - 0.001813*T*T*T)/3600;
omega = 125.04452 - 1934.136261*T + 0.0020708*T*T + T*T*T/450000;		
deltaEps = (9.20*cos(K*omega) + 0.57*cos(K*2*LS) + 0.10*cos(K*2*LM) - 0.09*cos(K*2*omega))/3600;
eps = eps0 + deltaEps + 0.00256*cos(K*(125.04 - 1934.136*T));
lambda = theta - 0.00569 - 0.00478*sin(K*(125.04 - 1934.136*T));
delta = asin(sin(K*eps)*sin(K*lambda));
dec=delta/K;
tau=UT*15;
% coords is (lon, lat)
coords=[[-180:180]',zeros(361,1)];
coords(1:360,2)=atan(cos((coords(1:360)+tau)*K)/tan(dec*K))/K;
coords(361,2)=coords(1,2);

%coords=[[25:50]',zeros(71,1)];
%coords(1:70,2) = atan(cos((coords(1:70)+tau)*K)/tan(dec*K))/K;
%coords(71,2)=coords(1,2);
% plot(coords(:,1),coords(:,2),'-k');

%baseline calculations for 2009 equinox times
%(20/03/2009 21:44 and 23/09/2009 7:18)
%2010 equinox times:
%(21/03/2010 03:32 and 23/09/2010 13:09)
if month<3 || month>9
    baseline=90;
end
if month>3 && month<9
   baseline=-90;
end
if month==3
    if day<21
        baseline=90;
    end
    if day>21
        baseline=-90;
    end
    if day==21
        if UTChour<3
            baseline=90;
        end
        if UTChour>3
            baseline=-90;
        end
        if UTChour==3
            if UTCmin<=32
                baseline=90;
            else
                baseline=-90;
            end
        end
    end
end
if month==9
    if day>23
        baseline=90;
    end
    if day<23
        baseline=-90;
    end
    if day==23
        if UTChour>13
            baseline=90;
        end
        if UTChour<13
            baseline=-90;
        end
        if UTChour==13
            if UTCmin>=9
                baseline=90;
            else
                baseline=-90;
            end
        end
    end
end


