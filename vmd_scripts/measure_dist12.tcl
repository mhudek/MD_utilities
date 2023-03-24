set win 36
set in "win$win.dcd"

## load files here

mol new ../../input/cht_sc.psf
mol addfile $in waitfor all


set out [open "distZ$win.dat" w]
puts $out "#Timestep distance1 distance2 "



# select atoms for distance 
# C4 in fragment 36
set sel1 [atomselect top "segname CHT and resid 361"]
set sel2 [atomselect top "name C2 and fragment 0 to 5"]
set sel3 [atomselect top "segname CHT and resid 366"]

set all [atomselect top all]

for {set i 0} {$i < [molinfo top get numframes]} {incr i 1} {

   $sel1 frame $i
   $sel2 frame $i
   $sel3 frame $i
   $all frame $i

   set c1 [measure center $sel1]
   set c2 [measure center $sel2]
   set c3 [measure center $sel3]

   set distZ [lindex [vecsub $c1 $c2] 2]
   set distZ2 [lindex [vecsub $c3 $c2] 2]
   puts $out "$i        $distZ   $distZ2 "

   }

quit
