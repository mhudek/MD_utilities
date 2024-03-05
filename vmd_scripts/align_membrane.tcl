# align_memb.tcl
#
#Usage: vglrun vmd -dispdev text -e align_memb.tcl
#
#Align the lipid bilayer with respect to z=0 positon 
#Warning: always keep original trajectory on tape
#The input trajectory should be wrapped
#i.e. all atoms within unit cell and no bonds accross 
#periodic boundary
#Upper and lower leafler selections need to be input manually!
#
#Author: magalena.hudek@strath.ac.uk

#Load required packages
package require pbctools

#Define input names here

set in_psf "step5_input.psf"
set in_dcd "test_out.dcd"
set out_dcd "test_aligned.dcd"

set memb_sel "segname MEMB"

proc align { sel {refframe 0} } {

  #set over estimate of membrane thickness, used to detect if membrane is split only
  set memb_thickness 75
  #string selection for lower and upper leaflet
  set low_l "segname MEMB and resid 113 to 212"
  set upp_l "segname MEMB and resid 0 to 112"

  set frames [molinfo top get numframes]
  set all [atomselect top all]
  set comsel [atomselect top ($sel) frame $refframe]
  
  ###DEFINE LEAFLETS HERE!
  set lower_leaflet [atomselect top $low_l]
  set upper_leaflet [atomselect top $upp_l] 
  #set reference centre-of-mass 
  set ref_com {0 0 0}
  
  #Loop through all the frames
  for {set i 0} {$i < $frames} {incr i} {
	
	#Get pbc 
	set box [pbc get -first $i -last $i]
        set boxx [split $box]
        set c [lindex $boxx 2]

	$all frame $i
	$all update
	$comsel frame $i
	$comsel update
	
	set com [measure center $all]
        set i_shift [vecsub $ref_com $com]
        $all moveby $i_shift

	$lower_leaflet frame $i
	$lower_leaflet update

	$upper_leaflet frame $i
	$upper_leaflet update
	

	set minmax [measure minmax $comsel]
	foreach {min max} $minmax { break }
        foreach {xmin ymin zmin} $min { break }
        foreach {xmax ymax zmax} $max { break }
	set t [expr $zmax-$zmin]

	if {[expr $t > $memb_thickness]} {
		#puts "Split membrane"
		#check if upper leaflet is split
		set minmax [measure minmax $upper_leaflet]
        	foreach {min max} $minmax { break }
        	foreach {xmin ymin zmin} $min { break }
        	foreach {xmax ymax zmax} $max { break }
        	set t [expr $zmax-$zmin]
		if {[expr abs($t) > $memb_thickness]} {
			#puts "Upper leaflet is split"
			set split_low [atomselect top "same fragment as ($upp_l  and z < [expr -$c/2])" frame $i]
			$split_low moveby [list 0 0 $c]
			}

		#check if lower leaflet is split
		set minmax [measure minmax $lower_leaflet]
                foreach {min max} $minmax { break }
                foreach {xmin ymin zmin} $min { break }
                foreach {xmax ymax zmax} $max { break }
                set t [expr $zmax-$zmin]
		if {[expr abs($t) > $memb_thickness]} {
                        #puts "Lower leaflet is split"
                        set split_low [atomselect top "same fragment as ($low_l and z > [expr $c/2])" frame $i]
                        $split_low moveby [list 0 0 [expr -1* $c]]
                        }

		#check if membrane is still split
		set minmax [measure minmax $comsel]
        	foreach {min max} $minmax { break }
        	foreach {xmin ymin zmin} $min { break }
        	foreach {xmax ymax zmax} $max { break }
        	set t [expr $zmax-$zmin]
		if {[expr abs($t) > $memb_thickness]} {
			#puts "Membrane is still split, but leaflets should be whole"
			set lower_box [atomselect top "same fragment as z < 0" frame $i]
	                $lower_box moveby [list 0 0 $c]
		}
	}
	
	#check for anything thats not water ions or solvent outside of box and put it back if com outside the box
	set etop [atomselect top "same segname as ((resname SDP) and z > [expr $c/2])" frame $i]
        if { [$etop num] > 0} {
                set com_top [measure center $etop]
                if {[lindex $com_top 2] > [expr $c/2-5] } {
                	puts "Found CHITOSAN on the top"
                	$etop moveby [list 0 0 [expr -1*$c]]
                }
        }

	$all update
	$lower_leaflet update
	$upper_leaflet update

	set upper_com [measure center $upper_leaflet ]
        set lower_com [measure center $lower_leaflet ]
        set leaf_distZ [lindex [vecsub $upper_com $lower_com] 2]
	
	if {$leaf_distZ > [expr $c*0.66] } {
		puts "SPLIT MEMBRANE FOUND"
		set lower_box [atomselect top "same fragment as z < 0" frame $i]
		$lower_box moveby [list 0 0 $c]
	}
	
	$comsel update
	set com [measure center $comsel]	

	#align membrane to ref_com
	set shift [vecsub $ref_com $com]
	$all moveby $shift

	$all update
	
	#center solvent around the membrane 
	set over_pbc [atomselect top "same fragment as ((all not $sel) and z > [expr $c/2])" frame $i]
	$over_pbc moveby [list 0 0 [expr -1*$c]]

	set under_pbc [atomselect top "same fragment as ((all not $sel) and z < [expr $c/-2])" frame $i]
        $under_pbc moveby [list 0 0 $c]
	
	#check for anything thats not water ions or solvent outside of box and put it back if com outside the box
        set etop [atomselect top "same segname as (resname SDP) and z > [expr $c/2]" frame $i]
        if { [$etop num] > 0} {
                set com_top [measure center $etop]
                if {[lindex $com_top 2] > [expr $c/2-5] } {
                        puts "Found CHITOSAN on the top"
                        $etop moveby [list 0 0 [expr -1*$c]]
                }
        }


  }
}

#Main part 
mol new $in_psf 
mol addfile $in_dcd waitfor all

align $memb_sel

animate write dcd $out_dcd

quit
