%Zeta potential calculation using Guoy-Chapman theory
%assuming flat surface and symmetrical electrolytes
%Author: Magdalena Hudek (magdalena.hudek@strath.ac.uk)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  POTENTIALLY NOT QUITE RIGHT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all;

c=0.1; % bulk ion conc. (mol L^-1)
T=300; % Temperature (K)
z=1;   % valance of the electrolyte (/)    


eps_0=8.85e-12;  %permittivity of free space (C V^-1 m^-1)
eps_r=80;        % relative permittivity of water (/)
F=9.649e4;       % Faraday constant (C mol^-1)
R=8.314;         %gas constant (J mol^-1 K^-1)
el= 1.602e-19;    %el. charge (C)


rd = ((5)*el)/2.646e-17 %charge at the slipping plane density (C m^-2) 

%unit conversion to SI
c=0.1*10^3; % mol/L to mol/m^3

k2 = (2*F^2*c*z^2)/(eps_0*eps_r*T*R)  ;  %square of inverse debye length (m^-2)
k = sqrt(k2);  % inverse Debye length (m^-1)

p=sqrt(1/(8*eps_r*eps_0*c*R*T)); %constants group

yd = (2/z)*asinh(-p*rd); %unitless poential
psi_d = (yd *R*T)/F;     %measureble kinetic potential (zeta-pot) V

x = linspace(0,10^(-8),1000);
psi = psi_d .* exp(-k*x);
y = 4/z * atanh( tanh((z*yd)/4)*exp(-k.*x));

plot(x,y);

rho_d_t = -11.73*sqrt(0.1)*sinh(0.0195*(-40))
