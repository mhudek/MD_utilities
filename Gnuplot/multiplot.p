#author: Magdalena Hudek (magdalena.hudek@strath.ac.uk)

set encoding iso_8859_1   #allows the use code of angstrom symbol


# Margins for each row resp. column
TMARGIN = "set tmargin at screen 0.95; set bmargin at screen 0.64"
MMARGIN = "set tmargin at screen 0.59; set bmargin at screen 0.32"
BMARGIN = "set tmargin at screen 0.27; set bmargin at screen 0.05"
LMARGIN = "set lmargin at screen 0.2; set rmargin at screen 0.95"
#other macros
NOXTICS = "set xtics 0.1 ; set format x ''; unset xlabel"
NOKEY = "set nokey"
LC1 = "lc "
FONTS = "font 'Halvetica ,12'"

#coordinates for vertical lines
X1 = "0.4112"
X2 = "0.62"
X3 = "1.07"

#label position
POS = "at graph 0.95,0.09 front font 'Halvetica, 12'"


set multiplot layout 3,1 rowsfirst

set style arrow 1 front nohead lw 2 lc 7 dashtype 2 
set tics @FONTS


#graph1
@TMARGIN; @LMARGIN; @NOXTICS; @NOKEY


set label 1 '(a)' @POS
set ylabel "Force (pN)" @FONTS

set arrow 1 from @X1, graph 0 to @X1, graph 1 arrowstyle 1
set arrow 2 from @X2, graph 0 to @X2, graph 1 arrowstyle 1
set arrow 3 from @X3, graph 0 to @X3, graph 1 arrowstyle 1

plot "set1.dat" u 1:2 w l lw 1 lc "steelblue",\
"set1.dat" u 1:3 w l lw 2 lc 16


#graph 2
@MMARGIN; @LMARGIN; @NOXTICS; @NOKEY
set label 1 '(b)' @POS

set ylabel 'Displacement ({/Helverica=12 \305})' @FONTS
plot "set2.dat" u 1:2 w l lw 2 lc "steelblue"
unset ylabel

#graph 3
@BMARGIN; @LMARGIN

set xlabel "Time (ns)" @FONTS
set xrange [0:10000]
unset colorbox
set label 1 '(c)' @POS

set palette defined (1 1 1 1, 1 0 0 0)
set palette defined (0 "white", 1 "steelblue")

set ytics ("O3-HO3:O5" 0,"O6-HO6:O" 1,"O4-HO4:O" 2,"N:O6-HO6" 3,"O:HN-N" 4, "O3-HO3:O6" 5,"O6-HO6:O" 6, "O1:HN-N" 7) 
set xtics ("0.0" 0, "0.2" 1000, "0.4" 2000, "0.6" 3000, "0.8" 4000, "1.0" 5000, "1.2" 6000, "1.4" 7000, "1.6" 8000, "1.8" 9000, "2.0" 10000 )

set arrow 1 from (@X1*5000), graph 0 to (@X1*5000), graph 1 arrowstyle 1
set arrow 2 from (@X2*5000), graph 0 to (@X2*5000), graph 1 arrowstyle 1
set arrow 3 from (@X3*5000), graph 0 to (@X3*5000), graph 1 arrowstyle 1


plot "set3.dat" matrix with image 

unset multiplot
