%Plot h-bonds obtained from VMD's hbonds plugin

clear all;

filename1 = "./hbonds.dat";
data = readmatrix(filename1);

ts=data(:,1);
hbonds=data(:,2);

%convert ts into nanosecond
time = ts(:) * 10^(-4); % fs to ns 

hbonds_ave = movmean(hbonds,250);

plot(time,hbonds);
hold on;
plot(time,hbonds_ave,'Linewidth', 2 )
xline(0.17);

xlabel('time (ns)')
ylabel("H-bonds")
