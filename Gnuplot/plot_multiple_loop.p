#plot multiple files using for loop


#set terminal pdf 
#set output 'histogram.pdf' 
set encoding iso_8859_1

list1=system('ls k2.5/hst*.dat')
list2=system('ls k5/hst*.dat')
list3=system('ls k6/hst*.dat')
set format y "%2.1f"
set xlabel 'Distance ({/Helverica=10 \305})'
set ylabel 'Scaled frequency'
set nokey
plot for [file in list1] file u 1:($2/338695) w l lc rgb  "#774CDC" t "k=2.5kcal/mol/ang", \
for [file in list2] file u 1:($2/338695) w l lc rgb "#E21515", \
for [file in list3] file u 1:($2/338695) w l lc rgb "#61CA11"
                                        
