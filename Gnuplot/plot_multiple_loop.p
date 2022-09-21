#Author: Magdalena Hudek (magdalena.hudek@strath.ac.uk)

set encoding iso_8859_1   #allows the use code of angstrom symbol

#list1=system('ls k2.5/hst*.dat')  #one way to plot with loop ... this way no need for number order in filenames

set format y "%2.1f"     #all yticks have one decimal place
set tics font "Halvetica ,12"  #set tick font and size
 
set yrange [0 : 1.0]
set xrange [4:26]
set xlabel 'Distance ({/Helverica=12 \305})' font "Halvetica ,12"   # \305 inserts angstrom symbol
set ylabel 'Scaled frequency' font "Halvetica ,12"

set key font "Halvetica ,12" at 23,0.8  #position legend at x=23, y=0.8

#plot for [file in list1] file u 1:($2/338695) w l lc rgb  "#774CDC" notitle, \  #loop plotting with list


#loop with filenames named in sequence, only first plot in the list gets a name for a neat looking legend.
plot for [i=1:20] 'k2.5/hstwin'.i.'.colvars.traj.dat' u 1:($2/338695) w l lc rgb  "#774CDC" lw 2 t (i==1 ? "k=2.5 kcal mol^{*1} ({/Helverica=12 \305})^{-2}" : ""), \
for [j=1:20] 'k5/hstwin'.j.'.colvars.traj.dat' u 1:($2/338695) w l lc rgb "#E21515" lw 2 t (j==1 ? "k=5.0 kcal mol^{*1} ({/Helverica=12 \305})^{-2}" : ""), \
'k6/hstwin3.colvars.traj.dat' u 1:($2/338695) w l lc rgb "#61CA11" lw 2 t "k=6.0 kcal mol^{*1} ({/Helverica=12 \305})^{-2}"
