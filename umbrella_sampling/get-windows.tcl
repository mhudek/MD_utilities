#Originally from NAMD umbrella sampling tutorial

#Usage: vmd -dispdev text -e get-windows.tcl

proc writeXSC { j fr } {
  #correct index number for file name
  set l [expr $j- 4]
  set outXSC [open "./windows/win${l}.restart.xsc" w]
  animate goto $fr
  puts $outXSC "\# NAMD extended system configuration output file"
  puts $outXSC "\#\$LABELS step a_x a_y a_z b_x b_y b_z c_x c_y c_z o_x o_y o_z s_x s_y s_z s_u s_v s_w"
  puts $outXSC "0 [molinfo top get a] 0 0 0 [molinfo top get b] 0 0 0 [molinfo top get c] [lindex [molinfo top get center] 0 0] [lindex [molinfo top get center] 0 1] [lindex [molinfo top get center] 0 2] 0 0 0 0 0 0"
  close $outXSC
}

set skip 5

## load files here

mol new ../SMD/cht_sc.psf
mol addfile ../SMD3/CHT_PME_D3.dcd step $skip waitfor all

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
   ## from 0 to number_of_umbrellas
   for {set j 0} {$j < 21} {incr j} {
        ## note that this tolerance may need to be changed to capture all windows
        # set so the colvar goes from 4 to 24
        set n [expr $j + 4 ]
        if {[expr abs($distZ - $n)] < 0.25} {
         $all writenamdbin ./windows/win${j}.restart.coor
         writeXSC $n $i

      }
   }

}

quit
