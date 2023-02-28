#!/bin/sh
  
if (( $# != 2 )); then {
  echo "usage: $0 <output_dir> <num_replicas>"
  exit -1
}; fi

mkdir $1

for (( i=0; i<$2; ++i )); do
        mkdir $1/$i
        cp input/topol.top $1/$i
        cp input/index.ndx $1/$i
        cp input/ionized.psf $1/$i
        cp input/umbrella.mdp $1/$i
        cp input/umbrella_equil.mdp $1/$i
done
