#Usage: gnuplot -p plot_msd.p

set datafile commentschars "#@&"  #ignore xmgrace symbols
set encoding iso_8859_1           #allows the use code of angstrom symbol

set format y "%2.1f"               #all yticks have one decimal place
set tics font "Halvetica ,12"      #set tick font and size

set xlabel 'Time (ns)' font "Halvetica ,12"  
set ylabel 'MSD ({/Helverica=12 \305}^2)' font "Halvetica ,12"   # \305 inserts angstrom symbol

plot 'testmsd.xvg' u ($1/1000):($2*100) w lp notitle      #convert x-axis ps to ns & y-axis nm^2 to A^2
