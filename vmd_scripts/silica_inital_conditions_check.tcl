#Script to check inital condtions of a system containing silica slab in water box
#Author: Magdalena Hudek

set ions [atomselect top "ions"]
set sod [atomselect top "resname SOD"]
set cla [atomselect top "resname CLA"]
set silica [atomselect top "resname 'CR20-'"]
set all [atomselect top "all"]

set all_n [$all num]
set sod_n [$sod num]
set cla_n [$cla num]
set silica_n [$silica num]

#volume of the box
set box [pbc get]
set bl [lindex $box 0]
set x [lindex $bl 0]
set y [lindex $bl 1]
set z [lindex $bl 2]

set box_volume [expr $x*$y*$z] 

#calculate volume of silica slab
set silica_minmax [measure minmax $silica]
foreach {min max} $silica_minmax { break }
foreach {xmin ymin zmin} $min { break }
foreach {xmax ymax zmax} $max { break }
set xs [expr abs($xmax-$xmin)]
set ys [expr abs($ymax-$ymin)]
set zs [expr abs($zmax-$zmin)]
set volume_silica [expr $xs*$ys*$zs]
set silica_surface [expr $xs*$ys]

#volume of water box
set water_volume [expr $box_volume-$volume_silica]

#calculate ion concentration
set NA double(6.022e23)

set sod_mol [expr $sod_n/$NA]
set cla_mol [expr $cla_n/$NA]
#in mol/L
set sod_conc [expr $sod_mol/($water_volume*1e-27)] 
set cla_conc [expr $cla_mol/($water_volume*1e-27)]

#calculate surface properties
set siloxide_o [atomselect top "charge '-0.9' '-0.675'"]
set deprot_o [atomselect top "charge '-0.9'"]

set siloxide_o_n [$siloxide_o num]
set deprot_o_n [$deprot_o num]
set deg_ion [expr double($deprot_o_n*100)/$siloxide_o_n]

#calculate siloxade concentration per surface area
set silox_conc [expr (0.5*$siloxide_o_n)/($silica_surface*0.01)]

#Create output

set out [open "System_info.txt" w]

puts $out "This file was generated from .gro (or pdb) and .psf files using TCL script."
puts $out ""
puts $out "System name: "
puts $out "Total number of atoms: $all_n "
puts $out "Number of silica atoms: $silica_n"
puts $out "Number of sodium ions: $sod_n"
puts $out "Number of cloride ions: $cla_n"
puts $out ""
puts $out "Initial box dimensions: ([format "%.2f" $x], [format "%.2f" $y], [format "%.2f" $z]) (ang)"
puts $out "Initial box volume: [format "%.2f" $box_volume] ang^3"
puts $out "Initial water volume: [format "%.2f" $water_volume] ang^3"
puts $out ""
puts $out "Sodium concentration: [format "%.2f" $sod_conc] mol/L"
puts $out "Chloride concentration [format "%.2f" $cla_conc] mol/L"
puts $out ""
puts $out "Silica surface area (one side) : [format "%.2f" $silica_surface] ang^2"
puts $out "Number of siloxide groups on both surfaces: $siloxide_o_n"
puts $out "Concentration of siloxide groups on the surface [format "%.2f" $silox_conc] /nm^2"
puts $out "Number of deprotonated siloxide groups: $deprot_o_n "
puts $out "Degree of ionisation: [format "%3.4s%%" $deg_ion] "

close $out
