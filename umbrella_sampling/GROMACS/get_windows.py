#!/usr/bin/env python3

"""
get coordinates files for umbrella sampling with uniform spacing. 
Required inputs: Topology (.psf) and SMD trajectory (.xtc - other formats should work too)
"""

__author__="Magdalena Hudek"
__email__="magdalena.hudek@strath.ac.uk"

import sys

try:
    import MDAnalysis as mda
    from MDAnalysis.lib.log import ProgressBar
except:
    print("MDAnalysis not found. Exiting.")
    sys.exit(1)

try:
    import numpy as np
except:
    print("Numpy not found. Exiting.")
    sys.exit(1)

import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning) 

if len(sys.argv) !=3:
    print("Syntax: $ python get_windows.py topology.psf trajectory")
    sys.exit(1)

gro = sys.argv[1]
xtc = sys.argv[2]

u = mda.Universe(gro, xtc)

all_a  = u.select_atoms("all")

#define selections here
groupA = u.select_atoms("index 10510")                 
groupB = u.select_atoms("type IOC24 and resid 0:135")  

#Umbrella window settings
num_win   = 60
spacing   = 1      # 1 Angstrom spacing between windows
init_dist = 4      # minimum distance in angstom        
tol       = 0.1    # tolerance

distanceZ = []

#for ts in u.trajectory:
for ts in ProgressBar(u.trajectory):
    comB = groupB.center_of_mass()
    dz = groupA.positions[0][2] - comB[2]
    j = 0
    while j < num_win:
        n = j + init_dist
        if np.absolute(dz-n) < tol:
            filename = "window" + str(j) + ".gro"
            all_a.write(filename)
        j=j+1
