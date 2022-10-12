# Gromacs simulation steps

1. Create .pdb/.psf files with Charmm-gui and NAMD/psfgen
2. Convert to .gro/.top files using parmed
3. Edit box size
  ```
  gmx_mpi editconf -f input.gro -o output.gro -c -d 0.0 -bt triclinic
   ```
4. Minimalization
  ```
  gmx_mpi grompp -f minimalization.mdp -c silica.gro -p silica.top -o ed.tpr 
  ```
5.Check energy:
  ```
  gmx_mpi energy -f em.edr -o potential.xvg
  ```
6. Create index file
  ```
  gmx_mpi make_ndx
  ```
7. First NPT (semi-isotropic pressure) 
  ```
  gmx_mpi grompp -f nvt.mdp -c em.gro -r em.gro -p silica.top -o nvt.tpr -n index.ndx
  ```
