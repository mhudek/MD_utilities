#!bin/tcl

proc drawline{} {

set f [molinfo top get numframes]

set all [ atomselect top all ]
set c2s [ atomselect top "name C2 and fragment 0 to 5"]
set c4  [ atomselect top "name C4 and resid 361" ]

set c2com [ measure center $c2s]

foreach {xcom ycom zcom} $c2com { break }

set xc4 [$c4 get x]
set yc4 [$c4 get y]
set zc4 [$c4 get z]

set p1 [list $xc4 $yc4 $zcom]
lassign [$c4 get {x y z}] p2

graphics 0 line $p1 $p2

}

proc enabletrace{} {
global vmd_frame
trace variable vmd_frame([molinfo top]) w drawline
}

proc disabletrace{} {
global vmd_frame
trace vdelete vmd_frame([molinfo top]) w drawline
}
