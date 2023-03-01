proc vmd_draw_arrow {mol start end} {
    # an arrow is made of a cylinder and a cone
    set middle [vecadd $start [vecscale 0.9 [vecsub $end $start]]]
    set pos [ list [lindex $middle 0] 0.0 [lindex $middle 2] ]
    set dist [lindex [vecsub $end $start] 2]
    set dist_t [format "%.2f" $dist]
    graphics $mol cylinder $start $middle radius 0.3
    graphics $mol cone $middle $end radius 0.4
    graphics $mol text $pos "$dist_t" size 1 thickness 3
}

proc update_frame_number {args} {

  set frame [molinfo 0 get frame]
  puts "Frame: $frame "
  #in this case timestep was 2 ps 
  set t [format "%.2f" [expr $frame * 0.002]]

  set surf [ atomselect top "charge '-0.9' '-0.675' and resid 1 to 135"]
  set c4  [ atomselect top "serial 10510" ]

  set c2com [ measure center $surf]
  foreach {xcom ycom zcom} $c2com { break }

  set xc4 [$c4 get x]
  set yc4 [$c4 get y]
  set zc4 [$c4 get z]

  set p1 [list $xc4 $yc4 $zcom]
  lassign [$c4 get {x y z}] p2

  graphics 0 delete all

  draw color blue
  draw arrow $p1 $p2
  draw color black
  draw text {5 0 -10} "Time $t ns" size 1 thickness 3

}

# Register the update_frame_number function to be called every time the frame changes
trace add variable vmd_frame(0) write "update_frame_number"

