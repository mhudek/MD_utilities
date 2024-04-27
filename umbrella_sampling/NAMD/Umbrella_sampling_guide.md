# Practical umbrella smpling guide in NAMD

This is a brief step-by-step guide for doing umbrella sampling in NAMD, when collective variable is Distance (or distance based)
Treat this as a reminder, not a learning tool!

1. Run SMD with pull group and reference goup, set-up the same as they will be for the collective variable
2. Create directory tree
   ```bash
   └── umbrella
    ├── input
    ├── output
    └── windows
   ```
3. Run [make-output-dirs.sh](make-output-dirs.sh) from `umbrella` directory to cretate numbered directories in the output directory
4. Copy the common input files to the input directory - system pdb & psf, parameter files
5. Copy [US-win.in](US-win.in), [win-base.conf](win-base.conf) and [namd-slurm.sh](namd-slurm.sh) into `umbrella` directory.
6. Modify the base files for your system and then modify and use [setup-windows.tcl](setup-windows.tcl) to create window specific files in each subdirectoy
7. Use [setup-windows.tcl](setup-windows.tcl) to obtain start coordinates for each window from the SMD run.
8. Run each umbrella sampling window TODO automate this process
9. Create a new directory in the umbrella tree e.g. analysis and copy all the collective variable outpurs here
   ```bash
   cp ../output/*/win*.colvar.traj .
   ```
10. Download and insatll WHAM from [Grossfield lab](http://membrane.urmc.rochester.edu/?page_id=126)
11. Create metadata file using [create_wham_meta.sh](create_wham_meta.sh)
12. Check for the histogram overlap using [histogram.sh](histogram.sh)
