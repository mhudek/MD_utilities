%Deby length for a polymer in a water solution with monovalent ions
%author: Magdalena Hudek (magdalena.hudek@strath.ac.uk)

clear all;
close all;

%constants
eps_r = 80;              %permittivity of water
eps_0 = 8.854e-12;       %permittivity of vacuum (F/m)
k_b   = 1.38e-23;        %Boltzmans const (J/K)
N_A   = 6.022e23;        %Avogadro num (/mol)
e     = 1.602e-19;       %el. charge (C)

%variables
T = 300;                  %temperature (K)
I = linspace(0,0.2,1000); %salt conc from 0 to 0.2 mol/L
I = I .* 10^3;            %convert to  mol/m^3

%calculate Debye length
l_D= sqrt((eps_r * eps_0 * k_b*T) ./ (2.* N_A .* e^2.*I));

%unit conversions for plotting
l_D = l_D * 10^10;  % m to ang
I = I .* 10^(-3);   % mol/m^3 to mol/L

%plot
plot( I, l_D);
set(gca,'FontSize',14)
xlabel( " c (mol/L)")
ylabel("\lambda_D (A^{\circ})")
