#Usage: vmd -dispdev text -e measure_rmsd.tcl 

set win 1
set in "win$win.dcd"

## load files here

mol new ../../input/cht_sc.psf
mol addfile ../../input/cht_sc.pdb
mol addfile $in waitfor all


## define output

set out [open "rmsd_win$win.dat" w]
puts $out "#Frame       rmsd"

## define selections and measure rmsd
set ref [atomselect top "fragment 36" frame 0]
set sel [atomselect top "fragment 36"]

for {set i 0} {$i < [molinfo top get numframes]} {incr i 1} {

   $sel frame $i

   set rmsd [measure rmsd $sel $ref]
   puts $out "$i        $rmsd"
}

close $out

quit
