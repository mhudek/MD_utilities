% Matlab code for plotting NAMD energies obtained from energy.sh bash script
% Author: Magdalena Hudek

clear all;

filename1 = "./eng0.txt";

data = readmatrix(filename1,'Delimiter','   ');
%data2 = readmatrix(filename2,'Delimiter',',');
%data = data(2000:7000, :);
%data2(:,1) = data2(:,1) + 10000000;

%data = [data1; data2];

%ETITLE:, TS, BOND, ANGLE, DIHED, IMPRP, , ELECT, , VDW, BOUNDARY, MISC, KINETIC, , TOTAL, TEMP, POTENTIAL, TOTAL3, TEMPAVG

ts        = data(:,1);
bond      = data(:,2);
angle     = data(:,3);
dihed     = data(:,4);
impr      = data(:,5);
elect     = data(:,6);
vdw       = data(:,7);
boundary  = data(:,8);
misc      = data(:,9);
kinetic   = data(:,10);
total     = data(:,11);
temp      = data(:,12);
potential = data(:,13);
total3    = data(:,14);
tempavg   = data(:,15);
pressure  = data(:,16);
gpressure = data(:,17);
volume    = data(:,18);
pressavg  = data(:,19);
gpressavg = data(:,20);

%conver ts into nanosecond
time = ts(:) * 10^(-6); % fs to ns 
ave_tot = movmean(total3, 1000);
%ave_tot = movmean(total3, [0 1000]);
koh = vdw + elect;
koh_av = movmean(koh, 100);

plot(time, koh);
hold on;
plot(time,koh_av, 'Linewidth', 2),
%}
xlabel('time (ns)')
ylabel("vdw+elect - energy (kcal/mol)")
