#!/usr/bin/env python3

"""
Calculate chitosan chain distance from silica surface during simulation. 
Required inputs: Topology (.psf) and SMD trajectory (.xtc - other formats should work too)
"""

__author__="Magdalena Hudek"
__email__="magdalena.hudek@strath.ac.uk"

import sys

try:
    import MDAnalysis as mda
    from MDAnalysis.lib.log import ProgressBar
    from MDAnalysis.analysis import distances
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

def main():

    gro = sys.argv[1]
    xtc = sys.argv[2]

    u = mda.Universe(gro, xtc)
    
    all_a  = u.select_atoms("all")

    #define selections here
    chain1 = u.select_atoms("segid CHT")                 
    chain2 = u.select_atoms("segid CHP") 
    chain3 = u.select_atoms("segid CHD")
    chain4 = u.select_atoms("segid CHE")
    chain5 = u.select_atoms("segid CHF")
    
    b_surf = u.select_atoms("type IOC24 and resid 0:135")
    t_surf = u.select_atoms("type IOC24 and resid 136:270")

    dist = []
        
    for ts in ProgressBar(u.trajectory):
        #surface 1
        dist_arr_1 = distances.distance_array(chain1.positions, b_surf.positions, box=u.dimensions)
        dist_arr_3 = distances.distance_array(chain3.positions, b_surf.positions, box=u.dimensions)
        dist_arr_4 = distances.distance_array(chain4.positions, b_surf.positions, box=u.dimensions)
        
        d1 = np.min(dist_arr_1) 
        d3 = np.min(dist_arr_3)
        d4 = np.min(dist_arr_4)
        
        #surface 2
        dist_arr_2 = distances.distance_array(chain2.positions, t_surf.positions, box=u.dimensions)
        dist_arr_5 = distances.distance_array(chain5.positions, t_surf.positions, box=u.dimensions)
        
        d2 = np.min(dist_arr_2)
        d5 = np.min(dist_arr_5)

        dist.append([ts.frame, d1, d2, d3, d4, d5])
        
    dist = np.array(dist)

    np.savetxt("dist_from_surf.txt", dist, delimiter=' ')

    #add comment to the beginning of the file
    f = open('dist_from_surf.txt', 'r+')
    lines = f.readlines()
    f.seek(0)
    f.write("#Time 1 2 3 4 5 \n")
    for line in lines:
        f.write(line)
    f.close()

#execute the above function
main()
