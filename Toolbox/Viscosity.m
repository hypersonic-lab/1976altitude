% MATLAB script to compare Chapman-Enskog and Sutherland viscosity for air
clc;
clear;

% Constants for Chapman-Enskog method
M = 28.97; % molecular weight of air (g/mol)
sigma = 3.711e-10; % molecular diameter of air (m)
epsilon_k = 97; % characteristic temperature for air (K)
R = 8314.5; % universal gas constant (J/kmol.K)

% Constants for Sutherland method
mu0 = 1.716e-5; % reference viscosity in Pa.s
T0 = 273.15; % reference temperature in K
S = 110.4; % Sutherland constant in K

% Temperature range
T = linspace(50, 2000, 1000); % temperature from 50 K to 2000 K

% Chapman-Enskog viscosity calculation
% Function for the collision integral (approximation as a function of T)
Omega = @(T) 1.16145 * (T/epsilon_k).^(-0.14874) + 0.52487 * exp(-0.7732 * T/epsilon_k) ...
            + 2.16178 * exp(-2.43787 * T/epsilon_k);

mu_Chapman = 2.669e-8 * sqrt(M * T) ./ (sigma^2 * Omega(T)); % viscosity in Pa.s

% Sutherland viscosity calculation
mu_Sutherland = mu0 * (T / T0).^(3/2) .* (T0 + S) ./ (T + S);

% Plot the results
figure;
plot(T, mu_Chapman, 'r', 'LineWidth', 2);
hold on;
plot(T, mu_Sutherland, 'b--', 'LineWidth', 2);
xlabel('Temperature (K)');
ylabel('Viscosity (Pa.s)');
title('Viscosity of Air: Chapman-Enskog vs Sutherland');
legend('Chapman-Enskog', 'Sutherland');
grid on;

% Display final viscosities for reference at different temperatures
disp('Chapman-Enskog vs Sutherland viscosity comparison:');
fprintf('T (K)   \t Chapman-Enskog (Pa.s)   \t Sutherland (Pa.s)\n');
for i = [50, 300, 1000, 2000]
    fprintf('%4d \t %1.3e \t\t %1.3e\n', i, interp1(T, mu_Chapman, i), interp1(T, mu_Sutherland, i));
end
