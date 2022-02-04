#!/bin/bash
# extract energies from NAMD log file and prepare for plotting

in_file=$1
out_file=$2

grep -m 1 "ETITLE" $in_file > tmp.txt
grep "ENERGY" $in_file |awk -v OFS=", " '$1=$1' >> tmp.txt
grep -v "Info" tmp.txt > tmp2.txt

sed 's/ENERGY:,//g' tmp2.txt > tmp3.txt
sed 's/ENERGY://g' tmp3.txt > tmp4.txt
sed 's/, /    /g' tmp4.txt > $out_file
# sed 's/      /, /g' tmp2.txt > $out_file


rm tmp.txt
rm tmp2.txt
rm tmp3.txt
rm tmp4.txt


# TS           BOND          ANGLE          DIHED          IMPRP               ELECT            VDW       BOUNDARY           MISC        KINETIC               TOTAL           TEMP      POTENTIAL         TOTAL3        TEMPAVG            PRESSURE      GPRESSURE         VOLUME       PRESSAVG      GPRESSAVG

ts=1
bond=2
angle=3
dihed=4
impr=5
elect=6
vdw=7
boundary=8
misc=9
kinetic=10
total=11
temp=12
potential=13
total3=14
temavg=15
pressure=16
gpressure=17
volume=18
pressavg=19
gpressavg=20

gnuplot -p << EOF
        set terminal pdf
        set output 'energies.pdf'
	set xlabel 'Timestep (fs)'
	set ylabel 'Energy (kcal/mol)'
	stats '${out_file}' using ${vdw} name "vdw" nooutput
	stats '${out_file}' using ${elect} name "elect" nooutput
	stats '${out_file}' using ${total} name "total" nooutput
	stats '${out_file}' using ${bond} name "bond" nooutput
	stats '${out_file}' using ${angle} name "angle" nooutput
	stats '${out_file}' using ${dihed} name "dihed" nooutput
	stats '${out_file}' using ${impr} name "impr" nooutput
	stats '${out_file}' using ${boundary} name "boundary" nooutput
	stats '${out_file}' using ${kinetic} name "kinetic" nooutput
	stats '${out_file}' using ${potential} name "potential" nooutput
	stats '${out_file}' using ${misc} name "misc" nooutput
	print "Vdw+elect = " 
	print vdw_mean+elect_mean 
	print "kcal/mol"
        print "potential - bond - angle - dihedral - impr-boundary_mean"
	print potential_mean-bond_mean-angle_mean-dihed_mean-impr_mean
	print "boundary"
	print boundary_mean
	print "misc"
	print misc_mean
	plot '${out_file}' using ${ts}:${vdw}, '${out_file}' u ${ts}:${elect}, '${out_file}' u ${ts}:${total}
EOF

