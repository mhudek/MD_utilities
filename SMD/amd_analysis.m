clear all;

in=readmatrix("smd_info_d3.txt");

t=in(:,1);
x=in(:,2);
y=in(:,3);
z=in(:,4);
fz=in(:,7);

%calculate displacement
d=sqrt(  (x-x(1) ).^2 + (y-y(1) ).^2 + (z-z(1) ).^2);

%set time in nanoseconds
t=t.*10^-6;

%plot dispacemetn with running average
%{
%constant velocity displacement function
f = @(x) 10.*x; 

d_mean = movmean(d,500);
plot(t,d);
hold on;
plot(t,d_mean);
fplot(f, [0,3.5])
%}

%plot fz
%
f_mean = movmean(fz,100);
plot(t,fz, LineWidth=0.1, Color=[0.5 0.5 0.5]);
hold on;
plot(t,f_mean, LineWidth=1.5, Color='b');
%bond breaking
%monomer 1
xline(0.4124); %N-O5
xline(0.8426); %O3-O
xline(0.8640); %N-O
%monomer 2
xline(0.4692, 'r-')  %O6-N (N-on crystal)
%monomer 3
xline(1.153,'g--' ); %N-O5
xline(1.2240,'g--' ); %N-O4
xline(0.8026,'g--' ); %N-O
xline(0.9340,'g--' ); %N-O

%monomer 4
xline(1.233, 'r--'); %O6-N (N-on crystal)

%monomer 5
xline(1.7962);
xline(1.8046);
xline(2.4776);
xline(0.4814);
xline(1.4366);


%monomer6
xline(2.2768,'b--')
xline(2.8526,'b--')

xlabel("Time(ns)");
ylabel("Force in +z dir (pN)");
%}
