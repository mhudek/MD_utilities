#!bin/bash

for (( i=0 ; i <= 22 ; i++ ))
do
	if [ $i == 0 ]
	then
		cp ../output/$i/umbrella${i}_pullx.xvg .
		cp ../output/$i/umbrella${i}_pullf.xvg .
		cp ../output/$i/umbrella${i}.tpr .
		
		echo "umbrella${i}_pullx.xvg" > pullx-files.dat
		echo "umbrella${i}_pullf.xvg" > pullf-files.dat
		echo "umbrella${i}.tpr" > tpr-files.dat
	else
		cp ../output/$i/umbrella${i}_pullx.xvg .
    		cp ../output/$i/umbrella${i}_pullf.xvg .
    		cp ../output/$i/umbrella${i}.tpr .

		echo "umbrella${i}_pullx.xvg" >> pullx-files.dat
    		echo "umbrella${i}_pullf.xvg" >> pullf-files.dat
    		echo "umbrella${i}.tpr" >> tpr-files.dat
	fi
done
