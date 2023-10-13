%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate Potential along z from charge density
% by double integrating Poisson equation: d2psi/dz^2 = -rho(z)/eps 
%
% Author: magdalena.hudek@strath.ac.uk
% 
% Input needs to be charge density of the system in e/nm^3
% This can easily be obtained from Gromacs density tool,
% -sl option should be sensible 
% > gmx_mpi density -f ... -dens charge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%make sure workspace is clear and additional any plot windows closed
clear all;
close all;

%Input file
% Format: z(nm) charge_dens(e/nm^3)

filename = 'charge_density.xvg';

% relevant physical constansts in SI units
eps_0 = 8.85e-12;    % permittivity of free space (C V^-1 m^-1)
el    = 1.602e-19;   % el. charge (C)

% Load in charge denisity file
matrix=readmatrix(filename, 'FileType', 'text', "CommentStyle", ["#","@"]);

%2 options to enforce PBC:

% Option 1:
% calculate average between first and last point
% Assign the average value as first and last points in charge density.
% This is a bit artificial

%r1 = (matrix(1,2) + matrix(end,2) / 2); 
%density = [ [0,r1]; matrix; [2*matrix(end,1)-matrix(end-1,1), r1 ] ]

%Option 2:
%Set charge density = 0 at z=0
% This should be true (on average) for bulk water with some 
% finite concentration of salt
density = [ [0, 0]; matrix ];

plot(density(:,1),density(:,2));
hold on;
ylabel("Numerical density (e nm^{-3})");
xlabel("Z (nm)")
hold off;

%convert charge density to SI units               
pos = density(:,1).*10^(-9);      % position along z (m)
rho = density(:,2).*el*10^27;     % charge density (C m^-3)

%get number of data points
n=size(density,1);
%define empty arrays
psi  = zeros(n,1);
dpsi = zeros(n,1);

%First integration
%Integrate Poisson equation d2psi/dz^2 = - rho(z)/eps_0 
%first time to obtain electric field (dpsi)
%Initial condition dpsi(z=0) = 0

i = 1;
while i<n
   step = pos(i+1) - pos(i);
   dpsi(i+1) = dpsi(i) - rho(i+1)./eps_0 * step;
   i = i+1;
end

%plot field
figure
plot(pos*10^9,dpsi*10^(-9));
xlabel("Z(nm)");
ylabel("Electric Field (V/nm)");

% second integration
% integral of dpsi to calculate potential
% Intial condition psi(z=0)=0 

j = 1;
while j<n
   step = pos(j+1) - pos(j);
   psi(j+1) = psi(j) + dpsi(j+1)* step; 
   j = j+1;
end

%Plot potential 
figure 
plot(pos*10^9,psi);
xlabel( "Z (nm)"),
ylabel( "Potential (V)");
