#!/bin/bash

# Create index file for silica slab, with group to freeze middle of the slab. Works for slab with two layers of residues only!
# Assumes input is the index file produced by Charmm-gui

gmx_mpi make_ndx -f step3_input.gro -n index.ndx -o index2.ndx << EOF
a SI1 SI2 SI3 SI4 O1 O2 O3 O4 O5 O6 O7 O8 & ri 67-132
a SI9 SI10 SI11 SI12 O18 O19 O20 O21 O23 O24 & ri 1-66
3|4
name 5 fix
q
EOF
