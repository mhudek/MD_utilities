"""
Create posre_new.itp position restraint file for GROMACS.
Input is either file with atom ids or number of atoms to be restrained
The strength of the potential is set by variable -POSRES_FC_BB in .mdp file 
"""

__author__="Magdalena Hudek"
__email__="magdalena.hudek@strath.ac.uk"

import sys
import re

if len(sys.argv) != 2:
    print("Usage: $python make_posre.py <input>\n")
    print("Input can be either file containing atom_ids to be restrained or number to restrain")
    sys.exit(2)

atom_id = []

if sys.argv[1].isdigit():
    N = int(sys.argv[1]) 
    for m in range(N):
        atom_id.append(m)  
else:
    try:
        infile = open(sys.argv[1],'r')
    except:
        print("Could not open file {:s}. Aborting.".format(sys.argv[1]))
        sys.exit(2)

    lines = infile.readlines()
    nlines = len(lines)

    for line in lines:
        line=line.upper()
        #skip empty lines
        if len(line) == 0:
            continue
        #skip lines with letters
        elif re.search('[a-zA-Z]', line) != None:
            continue
        else:
            n = line.split()
            N = len(n)
            for j in range(N):
                atom_id.append(int(n[j]))

#Create output file
try:
    out = open("posre_new.itp", 'w+')

except:
     print("Could not open file for writing. Aborting.")
     sys.exit(2)


out.write(";Position restraints file for GROMACS \n")
out.write("[ position_restraint ] \n")
out.write(";   i funct   fx              fy              fz \n")

for k in range(N):
    out.write('{:>5d}     1   POSRES_FC_BB    POSRES_FC_BB    POSRES_FC_BB'.format(atom_id[k]))
    out.write('\n')
out.close()

print("Done. Wrote position restraints to posre_new.itp file.")
