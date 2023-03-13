import sys

try:
    import MDAnalysis as mda
    from MDAnalysis.lib.log import ProgressBar
    from MDAnalysis.analysis import rdf
except:
    print("MDAnalysis not found. Exiting.")
    sys.exit(1)

try:
    import numpy as np
except:
    print("Numpy not found. Exiting.")
    sys.exit(1)

#shouldm't be necessary with updated MDAnalysis
#import warnings
#warnings.filterwarnings("ignore", category=DeprecationWarning)

if len(sys.argv) !=3:
    print("Syntax: $ python get_windows.py topology.psf trajectory")
    sys.exit(1)

gro = sys.argv[1]
xtc = sys.argv[2]

u = mda.Universe(gro, xtc)

all_a  = u.select_atoms("all")

#select chitosan
chain1 = u.select_atoms("segid CHT")
chain1_amino = u.select_atoms("segid CHT and name N")

#select siloxide oxygens on silica surface
b_surf = u.select_atoms("type IOC24 and resid 0:135")
t_surf = u.select_atoms("type IOC24 and resid 136:270")

crdf = rdf.InterRDF(chain1_amino,b_surf)
crdf.run()

#for 2.0.0+ ver
r = np.column_stack((crdf.results.bins, crdf.results.rdf))
#for 1.0.0 ver
#r = np.column_stack((crdf.bins, crdf.rdf))

np.savetxt("amino_siloxide_rdf.txt", r, delimiter=' ')
