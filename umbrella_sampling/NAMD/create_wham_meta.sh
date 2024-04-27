#!bin/bash

#use to create WHAM metadata 

num_win = 35
k = 2.5

echo "#Metadata for Wham" > metadata.dat
for (( i=0 ; i <= $num_win ; i++ ))
do
		echo "window${i}.colavr.traj"    ${i}    $k  >> metadata.dat
done
