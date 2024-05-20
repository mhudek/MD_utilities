
set out [open "names.txt" w]
puts $out "ID, name, resname, resid, segname"
set all [atomselect top "segname CHT NM"]

foreach atom [$all get {index name resname resid segname}] {
              foreach {index name resname resid segname} $atom { break }
              puts $out "$index, $name, $resname, $resid, $segname "
        }

close $out
                
