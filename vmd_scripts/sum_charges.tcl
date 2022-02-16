set out [open "charge_sum.dat" w]

proc sum_c {sel} {
        set c 0
        foreach charge [$sel get charge] {
                set c [expr $c + $charge]
}
return $c
}

set i 0
set resn 198

while {$i < $resn} {
        set sel [atomselect top "segname NM and resid $i"]
        set ch [sum_c $sel]
        puts $out  "$i  $ch"
        incr i
}
