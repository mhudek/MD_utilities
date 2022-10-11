#Author: Magdalena Hudek (magdalena.hudek@strath.ac.uk)
# get pbc box size during simulation 

proc get_box_size {} {
    set outfile1 [open "box_size.csv" w+] 
    puts $outfile1 "#step, x, y, z"

    set box [pbc get -all]
    set nf [llength $box]
    

    set n 0 
    while {$n<$nf} {
        set b [lindex $box $n] 
        set bl [split $b  ]

        set x [lindex $bl 0]
        set y [lindex $bl 1]
        set z [lindex $bl 2]

        puts $outfile1 "$n, $x, $y, $z  "
    
        incr n
    }   
    puts $n
    foreach {$box} [puts $outfile1 "$box \n"]
    
    puts $outfile1 $box(2)
    close $outfile1
}

get_box_size
