## Modified from NAMD umbrella sampling tutorial 

set num_replicas 20
# lower boundary for distance colvar, assume distance between umbrellas 1 
set lower_bound 4

puts "Number of replicas used: $num_replicas "
puts "The distance collective variable set from $lower_bound to [expr $lower_bound + $num_replicas]"


for {set i 1} {$i <= $num_replicas} {incr i} {

## write the config files
  set in1 [open "win-base.conf" r]
  set out [open "output/${i}/win${i}.conf" w]
  puts $out "set num $i"
  while { [gets $in1 line] >= 0} {
    puts $out $line
  }
  close $out

## write the colvars input files      
  set in2 [open "US-base.in" r]
  set out [open "output/${i}/US-win${i}.in" w]
  while { [gets $in2 line] >= 0} {
    if { [string match "*CENTER*" $line]} {
        #want the center from lower colvar bound to higher
      puts $out "        centers        [expr $lower_bound + $i]"
    } else {
      puts $out $line
    }
  }

## setup slurm scripts
  set in3 [open "namd-slurm.sh" r]
  set out [open "output/${i}/namd-slurm.sh" w]
  while { [gets $in3 line] >= 0} {
    if { [string match "#SBATCH --job-name=window" $line]} {
      puts $out "#SBATCH --job-name=window-$i"
    } elseif { [string match "mpirun -np \$SLURM_NTASKS namd2 win.conf > win.out.\$SLURM_JOB_ID" $line]} {
      puts $out "mpirun -np \$SLURM_NTASKS namd2 win${i}.conf > win${i}.out.\$SLURM_JOB_ID"
    } else {
      puts $out $line
    }
  }
}
