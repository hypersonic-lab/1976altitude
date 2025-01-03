close all
clf
clear

% Create hypersonic flight condtions that overlap with wind tunnels

min_alt = 10; % km
max_alt = 25; % km
d_alt = 15; % km

Atmo = StandardAtmos([min_alt:d_alt:max_alt],'HeightUnit','km');

D = 0.105; % m

altitude = Atmo.(1);
T = Atmo.(3);
p = Atmo.(5);
rho = Atmo.(6);
mu = Atmo.(10);

Mach = [2,3,5,7,9];
Angle = [0, 10, 15, 20];

% Assume constant R
R = 287; % J/kg*K

% Assume constant gamma
gamma = 1.4;

i = 1;


for alt = 1:length(min_alt:d_alt:max_alt)
    for M = 1:length(Mach)
        for A = 1:length(Angle)

            % Speed of sound and resulting speed
            a = sqrt(gamma * R * T(alt));
            u = Mach(M) * a;

            % Unit Reynold's number
            Re1 = rho(alt) * u / mu(alt);

            ReD = rho(alt) * u * D / mu(alt); 


             % Generate a test name based on altitude, Mach, and angle
           test_name = sprintf('Alt%d_M%d_A%d', altitude(alt), Mach(M), Angle(A));
            
            %grid(i,1) = test_name;
            grid(i,1) = altitude(alt);
            grid(i,2) = Mach(M);
            grid(i,3) = Angle(A);
            grid(i,4) = round(T(alt),3,'significant');
            grid(i,5) = round(p(alt),0,'decimals');
            %grid(i,6) = rho(alt);
            grid(i,6) = round(rho(alt),3,'significant');
            grid(i,7) = Re1;
            grid(i,8) = ReD;

            test_names{i,1} = test_name;

            i = i + 1; 
        end
    end
end

% Combine grid data and test names into a cell array for writing
grid_with_names = [test_names,num2cell(grid)];

filename = 'UCAH_CFD_flight.xlsx';

% Define header for the grid
header = {'Test Name', 'Altitude (km)', 'Mach', 'Angle (degrees)', 'Temperature (K)', ...
          'Pressure (Pa)', 'Density (kg/m^3)', 'Unit Reynolds Number', 'ReD'};

% Write the header first
writecell(header, filename, 'Sheet', 1, 'Range', 'A1');

% Write the grid data with test names starting from the second row
writecell(grid_with_names, filename, 'Sheet', 1, 'Range', 'A2');

min(grid(:,8))
max(grid(:,8))