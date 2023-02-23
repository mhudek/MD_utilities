# Gromacs simulation steps
*This is specific to my system ... adjust appropriately*

1. Create .pdb/.psf files with Charmm-gui and NAMD/psfgen
2. Convert to .gro/.top files using namd2gro.py 
    *(Note: need [ParmEd](https://github.com/ParmEd/ParmEd) for that)*
3. Edit box size (very important step!)
  ```
  gmx_mpi editconf -f input.gro -o output.gro -c -d 0.0 -bt triclinic
  ```
4. Create index file
  ```
  gmx_mpi make_ndx -f input.gro -o index.ndx
  ```
5. Create restraints - use genrestr (works only for the first molecule in the .gro file) or use [make_posre.py](./make_posre.py) script.
  ```
  gmx_mpi genrestr -f silica.gro -n index.ndx -o posre.itp
  ```
   
 _Add restraints to the .top file (under appropriate molecule)_
  
  ```
  ; Include Position restraint file
  #ifdef POSRES
  #include "posre.itp"
  #endif
  ```
6. Minimalization
  ```
  gmx_mpi grompp -f em.mdp -c silica.gro -p topol.top -o em.tpr 
  ```
7. Check energy:
  ```
  gmx_mpi energy -f em.edr -o potential.xvg
  ```
8. First NPT (anisotropic pressure - for simulations without surface use isotropic)
   _Max warning 2 is used because of berendsen thermostat & barostat_
  ```
  gmx_mpi grompp -f npt.mdp -c em.gro -r em.gro -p topol.top -o npt.tpr -n index.ndx -maxwarm -2
  ```
9. First MD run with correct thermostat
  ```
  gmx_mpi grompp -f md.mdp -c npt.gro -r npt.gro -p topol.top -o md.tpr -n index.ndx
  ```
10. Extending simulation (time in ps)
   ```
   gmx_mpi convert-tpr -s md.tpr -until 10000 -o md2.tpr

   ```
   Run command in slurm script...
   ```
   gmx mdrun -s md2.tpr -cpi md.cpt -deffnm md

   ```
