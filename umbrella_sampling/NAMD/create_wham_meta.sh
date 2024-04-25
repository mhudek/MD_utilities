#!bin/bash

#use to create WHAM metadata 

echo "#Metadata for Wham" > metadata.dat
for (( i=0 ; i <= 22 ; i++ ))
do
	if [ $i == 0 ]
	then
	
		echo "window${i}.colavr.traj"    ${i}    2.5  >> metadata.dat
		
	fi
done
