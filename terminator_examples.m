%% Calculating values related to the passage of the terminator: sunrise, 
% sunset, transit, and perhaps the angle of the terminator. 
% Adapted from "Astronomical Algorithms" by Jean Meeus
% 
% Jeff Shrader
% Created on: 2014-02-03

%% Sunrise, sunset, and transit
% Inputs
lat = 32.715; % N is positive
lon = 117.1625; % W is positive
date = [2014 2 6];
time = [0 0 0];
tz = -8;

% Constants
d2r = pi/180;
r2d = 1/d2r;

% Derivations
date_num = 
time_num = 
JD = date_num + 2415018.5 + time_num - tz/24;


if month < 3
    month = month + 12;
    year = year - 1;
end;
A = floor(year/100);
B = 2 - A + floor(A/year);
JD = floor(365.25*(year + 4716)) + floor(30.6001*(month + 1)) + day + B - 1524.5;
T = (JD - 2451545)/36525;

theta_0 = mod(100.46061837 + 3600.770053608*T + 0.000387933*T.^2 - (T.^3)/38710000, 360);
alpha_hour = [21, 21, 21];
alpha_min = [1, 5, 9];
alpha_sec = [17.61213, 21.49772, 24.55342];
alpha = ((alpha_hour + alpha_min./60 + alpha_sec./3600)./24).*360;
delta_sign = -1;
delta_deg = [16, 16, 16];
delta_min = [57, 39, 22];
delta_sec = [5.5573, 43.2163, 3.5104];
delta = delta_sign.*(delta_deg + delta_min./60 + delta_sec./3600);
h_0 = -0.833333; %The value for the sun

N = day + 31;
dec = sin(23.45)*sin(360*(N + 284)/365);

cosH_0 = (sin(h_0) - sin(lat)*sin(delta(2)))/(cos(lat)*cos(delta(2)));
H_0 = acos(cosH_0)*r2d; % Should be in degrees

m(1) = alpha(2) + lon - theta_0;
m(2) = m(1) - H_0/360;
m(3) = m(1) + H_0/360;

%DT


%%
clear
lat = 32.715; % N is positive
lon = 117.1625; % W is positive
year = 2014;
month = 2;
day = 3;



rs = [];
z  = [];
r  = [];
t  = [];
d  = [];

%********************************************************

Nin = nargin;

if Nin < 3
   date = clock;
   date = date(1:3);
elseif isempty(date)
   return
elseif size(date,2) == 1
   date = datevec(date);
elseif ~( size(date,2) >= 3 )
   date = cat(2,date,ones(size(date,1),3));
end

if Nin < 4
   int = 30;  % Intervall [sec]
    n  = ceil( 24*3600 / int );
end

%********************************************************

lon = lon - 360 * floor( ( lon + 180 ) / 360 );  % [ -180 .. 180 )

t = datenum(date(:,1),date(:,2),date(:,3)) - datenum(date(:,1),01,01);

m = size(t,1);

dt = 1/n;

t = t(:,ones(1,n)) + dt * ones(m,1) * ( 0 : n-1 ) - lon/360;

  SC  = 1368.0;   % Solar Constant
  d2r = pi/180;   % deg --> rad

[m,n] = size(JD);

y = datenum(y,01,01);

JD = JD + y(:,ones(1,n));

JD = datevec(JD(:));

% compute Universal Time in hours
   UT = JD(:,4) + JD(:,5) / 60 + JD(:,6) / 3600;

% compute Julian ephemeris date in days (Day 1 is 1 Jan 4713 B.C.=-4712 Jan 1)
  JD = 367 * JD(:,1) - fix( 7 * ( JD(:,1) + fix( (JD(:,2)+9) / 12 ) ) / 4 ) + ...
        fix( 275 * JD(:,2) / 9 ) + JD(:,3) + 1721013 + UT/24;

% compute interval in Julian centuries since 1900
  JD = ( JD - 2415020 ) / 36525;

% compute mean anomaly of the sun
   G = 358.475833 + 35999.049750 * JD - 0.000150 * JD.^2;

% compute mean longitude of sun
   L = 279.696678 + 36000.768920 * JD + 0.000303 * JD.^2;

% compute mean anomaly of Jupiter: 225.444651 + 2880 * JD + 154.906654 * JD;
  JP = 225.444651 + 3034.906654 * JD;

% compute mean anomaly of Venus
  VN = 212.603219 + 58517.803875 * JD + 0.001286 * JD.^2;

% compute longitude of the ascending node of the moon's orbit
  NM = 259.183275 - 1934.142008 * JD + 0.002078 * JD.^2;

   G = (  G - 360 * fix(  G / 360 ) ) * d2r;
   L = (  L - 360 * fix(  L / 360 ) ) * d2r;
  JP = ( JP - 360 * fix( JP / 360 ) ) * d2r;
  VN = ( VN - 360 * fix( VN / 360 ) ) * d2r;
  NM = ( NM - 360 * fix( NM / 360 ) + 360 ) * d2r;

% compute sun theta (THETA)
  DEC = +0.397930 * sin(L)       - 0.000040 * cos(L)       ...
        +0.009999 * sin(G-L)     + 0.003334 * sin(G+L)     ...
        +0.000042 * sin(2*G+L)  - 0.000014 * sin(2*G-L)   ...
        -0.000030 * JD.*sin(G-L) - 0.000010 * JD.*sin(G+L) ...
        -0.000208 * JD.*sin(L)   - 0.000039 * sin(NM-L)    ...
        -0.000010 * cos(G-L-JP);

% compute sun rho
  RHO = 1.000421 - 0.033503 * cos(G) - 0.000140 * cos(2*G) + ...
        0.000084 * JD.*cos(G) - 0.000033 * sin(G-JP) + 0.000027 * sin(2*G-2*VN);

%%% RHO = 1 - 0.0335*sin( 2 * pi * (DayOfYear - 94)/365 )

% compute declination: DEC = asin( THETA ./ sqrt(RHO) );
   DEC = DEC ./ sqrt(RHO);