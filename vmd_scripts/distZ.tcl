set out [open "distanceZ.dat" w]
puts $out "Timestep distance"

# select atoms for distance 
# C4 in fragment 36
set sel1 [atomselect top "index 9739"]
set sel2 [atomselect top "name C2 and fragment 0 to 5"]

set all [atomselect top all]

for {set i 0} {$i < [molinfo top get numframes]} {incr i 1} {

   $sel1 frame $i
   $sel2 frame $i
   $all frame $i

   set c1 [measure center $sel1]
   set c2 [measure center $sel2]

   set distZ [lindex [vecsub $c1 $c2] 2]
   puts $out "$i,$distZ "

   }

quit
