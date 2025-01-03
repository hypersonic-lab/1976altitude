% 1976 Altitude Calculator
% Original tool created here: https://www.mathworks.com/matlabcentral/fileexchange/92653-u-s-standard-atmosphere-1976-model
% See above website for more details on it

% Modified by K. Hanquist - 3 Jan 2025

% The following commands creates a vector of altitudes. You can modify as
% needed to include as many or as little altitudes as you want

min_alt = 5; % km
max_alt = 80; % km
d_alt = 1; % km

addpath('Toolbox') 

Atmo = StandardAtmos([min_alt:d_alt:max_alt],'HeightUnit','km');

altitude = Atmo.(1); % km
T = Atmo.(3); % K
p = Atmo.(5); % Pa
rho = Atmo.(6); % kg/m^3
mu = Atmo.(10);

% The following commands are extra and calculate the Reynolds number and
% unit Reynolds number for certain flight and geometry conditions

Mach = 4.9;
D = 1; % Characteristic length or diameter [m]

% Assume constant R
R = 287; % J/kg*K

% Assume constant gamma
gamma = 1.4;

for i = 1:length(altitude)
    a = sqrt(gamma * R * T(i)); % Speed of sound (m/s)
    u = Mach * a; % Velocity (m/s)
    Re_1alt(i) = rho(i) * u / mu(i); % unit Reynolds number (1/m)
    Re_Dalt(i) = rho(i) * u * D / mu(i); % Reynolds number
end