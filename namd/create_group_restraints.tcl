#Create harmonic group restraints for NAMD membrane simulations
#This only works for use on NAMD3
#
#Before running this code create restraints directory
#Run from TkConsole in VMD after uploading the molecule

#Define upper and lower leaflet & whole membrane
set u_leaf [atomselect top "resname ECLIPA and name P P1 P3 P4 PA PB"]
set l_leaf [atomselect top "segname MEMB and name P P1 P3 P4 PA PB"]
set memb [atomselect top "resname ECLIPA or segname MEMB"]

#caculate com positions
set u_com [measure center $u_leaf]
set l_com [measure center $l_leaf]
set com [measure center $memb]

#create output files
set out [open "group_restraints" w] ;# include this file into your NAMD input using source comand

#Files containing indices of restrained atoms
set out1 [open "restraints/upp_leaf.txt" w]
set out2 [open "restraints/low_leaf.txt" w]


foreach i1 [$u_leaf get index] {
        puts $out1 "$i1"
}

foreach i2 [$l_leaf get index] {
        puts $out2 "$i2"
}

puts $out "groupRestraints  on"
puts $out "groupResK A 5"
puts $out "groupResX A off"
puts $out "groupResY A off"
puts $out "groupResZ A on"

puts $out "group1File A restraints/upp_leaf.txt"
puts $out "group2File A restraints/low_leaf.txt"

puts $out "#group1RefPos A $u_com"
puts $out "#group2RefPos A $l_com"
puts $out "groupResCenter A [vecsub $l_com $u_com]"

close $out
close $out1
close $out2
