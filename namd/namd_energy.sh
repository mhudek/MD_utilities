#!/bin/bash
# extract energies from NAMD log file and prepare for plotting
#Usage: bash namd_energy.sh in_file out_file

in_file=$1
out_file=$2

grep -m 1 "ETITLE" $in_file > tmp.txt
grep "ENERGY" $in_file |awk -v OFS=", " '$1=$1' >> tmp.txt
grep -v "Info" tmp.txt > tmp2.txt

sed 's/ENERGY:,//g' tmp2.txt > tmp3.txt
sed 's/ENERGY://g' tmp3.txt > $out_file

rm tmp.txt
rm tmp2.txt
rm tmp3.txt
