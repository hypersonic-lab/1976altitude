% 1976 Altitude Calculator
% Original tool created here: https://www.mathworks.com/matlabcentral/fileexchange/92653-u-s-standard-atmosphere-1976-model
% See above website for more details on it

% Modified by K. Hanquist - 3 Jan 2025

close all

% Make sure you update the characteristic dimensions (L) and Mach number if
% you want accurate Reynolds and Knudsen numbers

% The following commands creates a vector of altitudes. You can modify as
% needed to include as many or as little altitudes as you want

min_alt = 5; % km
max_alt = 80; % km
d_alt = 5; % km

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
L = 1; % Characteristic length or diameter [m]

% Assume constant R
R = 287; % J/kg*K

% Assume constant gamma
gamma = 1.4;

% Calcualte Reynolds numbers
for i = 1:length(altitude)
    a = sqrt(gamma * R * T(i)); % Speed of sound (m/s)
    u = Mach * a; % Velocity (m/s)
    Re_1alt(i) = rho(i) * u / mu(i); % unit Reynolds number (1/m)
    Re_Dalt(i) = rho(i) * u * L / mu(i); % Reynolds number
end

% Calculate Knudsen number

d = 4.0E-10; % Approximate hard sphere diameter of an "air" particle [m]

k = 1.380649E-23; % Boltzmann constant

n = p ./ (k .* T); % Number density of particles at given altitude

lambda = (sqrt(2) .* n .* pi .* d^2 ).^-1; % Mean free path of particles at given altitude

Kn = lambda ./ L; 

% Plot the results
yyaxis left
semilogy(min_alt:d_alt:max_alt,Kn)
ylabel('Kn')
xlabel('Altitude [km]')

yyaxis right
semilogy(min_alt:d_alt:max_alt,Re_Dalt)
ylabel('Re')
xlabel('Altitude [km]')

% Save data so we can create with Tecplot
data = [(min_alt:d_alt:max_alt)', Kn, Re_Dalt'];

save AltData.dat data -ascii