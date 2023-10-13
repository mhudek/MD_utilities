# Calculation of electrostatic potential 

The electric potential of the can be obtained by integrating the Poisson-Boltzman equation. One dimensional PB equation is given by: 

$$\nabla^2 \psi(z)=\frac{d^2 \psi(z)}{dz^2}=-\frac{\rho(z)}{\varepsilon_0}$$
where $\varepsilon_0=8.85\times10^{-12} ~ C ~ V^{-1} ~ m^{-1}$

where $\psi$ is the electric potential is the function of distance, z. $\rho$ is the volumetric charge density function.

https://doi.org/10.1063/1.3148885

Two possible solutions for symmetrical slabs:
1. Classical soultions $\psi(0)=0$ & $E_{el}(0)=0$ 
2. Assuming PBC so $\psi_S(0)=\psi_S(L)$

Classical solution integral:

$$\psi_{cl}(z) = -\frac{1}{\varepsilon_0} \int_0^z dz' \int_0^{z'} \rho(z'') dz''$$

Under assumption number 2:

$$\psi_s(z)=\psi_{cl}(z)-\Delta(z)$$

$$\Delta(z)=\frac{z}{L}\psi_{cl}(L)$$

Both soultions should give same result for symmetrical membranes and materials centered at 0, provided good enough sampling and $\pm$ some constant C 

Do not use PBC solution for asymetrical membranes

Another relevant paper: https://doi.org/10.1039/C8NR00776D 

## Guoy-Chapman

Electric double layer (EDL) is a well-known phenomenon occurring at the interface of a charged surface with a liquid containing ions. The ions form a layer at the surface of the charged surface to screen the charges.

For liquids contatining ions 

$$\rho(z)=F\sum_j ~ z_j c_j(x)$$

Boltzman 
Fundementals of Interface and Colloid Science, Volume II: Solid-Liquid Interfaces, J Lykema

Normalised dimensionless potential:
$$y(x)= \frac{F}{RT} \psi(x)$$
Reciprocal Debye lenght $\kappa$
$$\kappa^2=\frac{F^2\Sigma_j c_j z_j^2}{\varepsilon_0 \varepsilon R T}$$
From Possion equation:
$$y^d=\frac{2}{z}ln[-p\sigma^d + \sqrt{(p\sigma^d)^2+1}]$$
where $\sigma^d$ is surface charge (C/m^2), and $p=8\varepsilon_0\varepsilon c R T$
Potential distribution obtained analytically:
$$tanh(\frac{zy(x)}{4})=[tanh(\frac{zy^d}{4})] e^{-\kappa x}$$
For low potentials and z=1 ...
$$\psi(x)=\psi^d e^{-\kappa x}$$
