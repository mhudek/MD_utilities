#Script to check inital condtions of a system containing silica slab in water box
#Author: Magdalena Hudek

package require pbctools

#silica surface ionisation level to ph
proc ionisation2ph {d} {
	return [expr $d/3.3333333+3]
}

#chitosan number of protonated monomers to pH
proc cht2ph {p n} {
	#avoid division by 0
	if {$p == $n} { 
		set p [expr $p-0.01] }
	return [expr log(double($n)/$p-1)/log(10)+6.3]
}

mol new ionized.psf 
mol addfile si+6cht.gro
	
set ions [atomselect top "ions"]
set sod [atomselect top "resname SOD"]
set cla [atomselect top "resname CLA"]
set silica [atomselect top "resname 'CR20-2'"]
set chtp [atomselect top "resname SDP"]
set chtn [atomselect top "resname SDN"]
set ace [atomselect top "resname BGL"]
set all [atomselect top "all"]
set water [atomselect top "water"]

set all_n [$all num]
set sod_n [$sod num]
set cla_n [$cla num]
set silica_n [$silica num]
set chtp_n [$chtp num]
set chtn_n [$chtn num]
set ace_n [$ace num]
set water_n [$water num]

#number of monomers for chitosan
set pn 22
set pp 23
set ap 27

set n_mon_n [expr $chtn_n/$pn ]
set n_mon_p [expr $chtp_n/$pp ]
set n_mon_a [expr $ace_n/$ap ]

set chain_l [expr $n_mon_n+$n_mon_p+$n_mon_a]

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
puts $out "Number of water molecules: $water_n"
puts $out "Number of silica atoms: $silica_n"
puts $out "Total number of chitin/chitosan atoms: [expr $chtp_n+$chtn_n+$ace_n]"
puts $out "Number of sodium ions: $sod_n"
puts $out "Charge of sodium ions: [lindex [$sod get charge] 0]"
puts $out "Number of chloride ions: $cla_n"
if {$cla_n != 0} {
puts $out "Charge of choride ions: [lindex [$cla get charge] 0]"
}
puts $out ""
puts $out "Initial box dimensions: ([format "%.2f" $x], [format "%.2f" $y], [format "%.2f" $z]) (ang)"
puts $out "Initial box volume: [format "%.2f" $box_volume] ang^3"
puts $out "Initial water volume: [format "%.2f" $water_volume] ang^3"
puts $out "Water column height: [format "%.2f" [expr $z-$zs]] ang"
puts $out ""
puts $out "Sodium concentration: [format "%.2f" $sod_conc] mol/L"
puts $out "Chloride concentration [format "%.2f" $cla_conc] mol/L"
puts $out ""
puts $out "Chitin/chitosan chain length: $chain_l " 
puts $out "Number of protonated chitosan monomers (+1 charge) : $n_mon_p"
puts $out "Number of neutral chitosan monomers (0 charge) : $n_mon_n"
puts $out "Number of chitin monomers (0 charge) : $n_mon_a"
puts $out "Chitosan ph - no very precise due to rounding (cannot have 0.5 monomer protonated!) : [format "%.2f" [cht2ph $n_mon_p $chain_l]]"
puts $out ""
puts $out "Silica surface area (one side): [format "%.2f" $silica_surface] ang^2"
puts $out "Silica slab thickness: [format "%.2f" $zs] ang"
puts $out "Number of siloxide groups on both surfaces (0 charge, unless ionised) : $siloxide_o_n"
puts $out "Concentration of siloxide groups on the surface [format "%.2f" $silox_conc] /nm^2"
puts $out "Number of deprotonated siloxide groups (-1 charge): $deprot_o_n "
puts $out "Degree of ionisation: [format "%3.4s%%" $deg_ion] "
puts $out "Corresponding pH: [format "%.2f" [ionisation2ph $deg_ion]]"


close $out

quit
