# Example exponential function fit
# Author: Magdalena Hudek

reset

set terminal pngcairo size 1024,768
set output 'average50.png'
set xlabel "Timestep(s)"
set ylabel "x(µm)"

# Function to be fitted
f(x) = a + b*exp(-x/c) 

#Initial guesses for the fit
a=0.031
b=17.531
c=0.000859

#Fit function f(x) over the [0.006:0.018] (specifying the range is optional)
fit [0.006:0.018]f(x) '6m_avg.txt' using 1:3 via a,b,c
#fit f(x) '6m_avg.txt' using 1:3 via a,b,c

#Legend titles
t_f = sprintf("f(x) = %.3f +%.3f exp(-x/%.6f)", a, b, c)
t_d = "Computed data"

set yrange [0.03:0.040]
set xrange [0.0065:0.017]
#set logscale y 10


plot '6m_avg.txt' u 1:3 w lp linewidth 0.5 linecolor rgb '#0060ad' t "polymer extensions",\
f(x) title t_f 
