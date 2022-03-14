set win 4
set in "win$win.dcd"

## load files here

mol new ../../input/cht_sc.psf
mol addfile ../../input/cht_sc.pdb
mol addfile $in waitfor all


## define output

set out [open "xy_win.dat" w]
puts $out "#Frame       x       y"

## define selections 
set sel [atomselect top "index 9739"]

set name [$sel get name ]
echo "name check $name "
for {set i 0} {$i < [molinfo top get numframes]} {incr i 1} {

   $sel frame $i

   set x [$sel get x ]
   set y [$sel get y ]
   set z [$sel get z ]
puts $out "$i   $x      $y      $z"
}

close $out

quit
