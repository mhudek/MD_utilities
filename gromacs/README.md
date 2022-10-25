# Gromacs simulation steps
*This is specific to my system ... adjust appropriately*

1. Create .pdb/.psf files with Charmm-gui and NAMD/psfgen
2. Convert to .gro/.top files using namd2gro.py 
    *(Note: need [ParmEd](https://github.com/ParmEd/ParmEd) for that)*
3. Edit box size
  ```
  gmx_mpi editconf -f input.gro -o output.gro -c -d 0.0 -bt triclinic
  ```
4. Create index file
  ```
  gmx_mpi make_ndx -f input.gro -o index.ndx
  ```
5. Create restraints
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
8. First NPT (semi-isotropic pressure) 
  ```
  gmx_mpi grompp -f npt.mdp -c em.gro -r em.gro -p topol.top -o npt.tpr -n index.ndx
  ```
9. First MD run with correct thermostat
  ```
  gmx_mpi grompp -f md.mdp -c npt.gro -r npt.gro -p topol.top -o md.tpr -n index.ndx
  ```
