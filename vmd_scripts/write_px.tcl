#Script for creating .pdb and .psf in VMD containing only selected residues. 
#Author: Magdalena Hudek
#Usage: vmd -dispdev text -e write_px.tcl

#Inpuut names without extension
set input "cht_sc"
set output "cht6"

readpsf ${input}.psf
coordpdb ${input}.pdb

#Define selection here
set sel [atomselect top "fragment 36 and segname CHT"]

$sel writepsf $output.psf
$sel writepdb $output.pdb

quit
