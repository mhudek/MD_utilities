#Gnuplot script
#Usage: gnuplot -p plot_rmsd.gp
  
set xlabel "Time (ns)"
set ylabel "RMSD (angstrom)"

#scaling factor from timestep to ns: dcdfreq * 10^-6 = 400*10^-6 = 0.0004

plot 'rmsd.dat' u ($1*0.0004):2 t "rmsd"
