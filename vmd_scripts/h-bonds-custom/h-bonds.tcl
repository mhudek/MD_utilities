#get h-bonds for each frame of the simulation

set outfile [open h_bonds_custom.txt w]
set n [molinfo top get numframes]

set sel1 [atomselect top {fragment 0 1 2 3 4 5 36 and name "[O.*]" "[N.*]" O1 O2 O3 O4 O5 O6}]
#set sel2 [atomselect top "fragment 36"]


puts $outfile "FRAME, DONOR, HYDROGEN, ACCEPTOR"
for {set i 1} {$i < $n} {inc i} {
	puts "current frame: $i"
	#set sel1 [atomselect top "fragment 2" frame $i]
	#set sel2 [atomselect top "fragment 36" frame $i]
	$sel1 frame $i
	$sel1 update
	#$sel2 frame $i
	#$sel1 update
	set hb [measure hbonds 3.5 30 $sel1]
	foreach {donor acceptor hydrogen} $hb { break }
	set n_bonds [llength $donor]
	for {set j 1} {$j < $n_bonds} {inc j} {
		set line "$i, [lindex $donor $j], [lindex $hydrogen $j], [lindex $acceptor $j]"   
		puts $outfile $line
	}
}

close $outfile
