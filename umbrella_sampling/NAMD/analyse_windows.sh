#!bin/bash
  

for f in {1..36};
do
        var0=$(grep 'set win' ./measure_dist.tcl)
        var1="set win $f"
        sed -i "s/$var0/$var1/" measure_dist.tcl
        cd $f
        vglrun vmd -dispdev text -e ../measure_dist.tcl
        cd ..
done
