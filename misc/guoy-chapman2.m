clear all;

dens=readmatrix("dens-sod.dat");
dens=flipud(dens);
dens(:,1)=-dens(:,1);
f=dens(1,1);
dens(:,1)=dens(:,1)-f;
dens(:,2)=dens(:,2)*(10^3/22.9); %molar conc. in mol/m^3
dens(:,1)=dens(:,1)*10^(-9); %nm to m
cx = dens;

c=0.21; % bulk ion conc. (mol L^-1)
T=300; % Temperature (K)
z=1;   % valance of the electrolyte (/)    


eps_0=8.85e-12;  %permittivity of free space (C V^-1 m^-1)
eps_r=80;        % relative permittivity of water (/)
F=9.649e4;       % Faraday constant (C mol^-1)
R=8.314;         %gas constant (J mol^-1 K^-1)
el= 1.602e-19;    %el. charge (C)

%unit conversion to SI
c=c*10^3; % mol/L to mol/m^3


rho = z*F*cx;  %(C m^-2)
d2psidx=-rho./(eps_0*eps_r);

%%%%% Debye length %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k2 = (2*F^2*c*z^2)/(eps_0*eps_r*T*R)  ;  %square of inverse debye length (m^-2)
k = sqrt(k2);  % inverse Debye length (m^-1)
lambd = 10^9/k;  %Debye length (nm)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Potential Boltzman law

y=zeros(size(cx,1),1);
y(:)=-(1/z)*log(cx(:,2)/c);
psi = y.*((R*T)/F);

plot(cx(:,1),y);
xline(lambd)

xlabel("distance (nm)");
ylabel("potantial (V)");
