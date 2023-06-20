#!bin/bash

## plot colective variables histograms to check for the umbrellas overlap

#define input names
filename="win*.colvars.traj"

#loop through all the files
for f in ${filename}
do
    # awk script which creates the histogram 
    awk '
    BEGIN{
        bin_width=0.1;
    }
    {
        bin=int(($2-0.0001)/bin_width);
        if( bin in hist){
            hist[bin]+=1
        }else{
            hist[bin]=1
        }
    }
    END{
        for (h in hist)
            printf " %2.2f  %i \n", h*bin_width, hist[h]
    }'  ${f} > tmp_${f}  
    
    # sort bins in numerical order
    sort -gk 1 tmp_${f} > hst${f}.dat
    rm tmp_${f}
done

# plot the histograms on a single plot
gnuplot -p << EOF
    set terminal pdf
    set output 'histogram.pdf' 
    list=system('ls  hst*.dat')
    set xlabel 'Distance (angstrom)'
    set ylabel 'count'
    set nokey
    plot for [file in list] file w l t file
EOF

rm hst*.dat
