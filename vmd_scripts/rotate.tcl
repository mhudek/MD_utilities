# rotates all atoms around y-axis by 90 deg

proc rotate {in_psf in_pdb out_pfx } { 

    resetpsf
    readpsf $in_psf
    coordpdb $in_pdb

    mol load psf $in_psf pdb $in_pdb


    set all [atomselect top all ]
    set matrix [transaxis y 90] 

    $all move $matrix

    foreach atom [$all get {segid resid name x y z}] {
            foreach {segid resid name x y z} $atom { break }
            coord $segid $resid $name [list $x $y $z] 
    }   


    writepsf $out_pfx.psf
    writepdb $out_pfx.pdb

    mol delete top 
}

proc move_by {in_psf in_pdb out_pfx } {
    resetpsf
    readpsf $in_psf
    coordpdb $in_pdb

    mol load psf $in_psf pdb $in_pdb


    set all [atomselect top all ]


    foreach atom [$all get {segid resid name x y z}] {
            foreach {segid resid name x y z} $atom { break }
            coord $segid $resid $name [list $x $y [expr $z+29.0] ]
    }
    
    writepsf $out_pfx.psf
    writepdb $out_pfx.pdb

    mol delete top 

}
