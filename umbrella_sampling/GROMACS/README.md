# Umbrella sampling procedure for Gromacs
1. SMD 
2. Obtain coordinate files (.gro) from SMD using [get_windows.py](get_windows.py)
   2a Use VMD to double check your selections (use selections.vmd for this)
4. Prepare [input](inputs) files 
5. Copy resultd into single directory and prepare wham files using [create_wham_files.sh](create_wham_files.sh)
6. Run wham
   ```
   gmx_mpi wham -it tpr-files.dat -ix pullx-files.dat -o -hist -unit kCal -temp 300
   ```
7. Check histograms for overlap
   ```
   xmgrace -nxy histo.xvg
   ```
8. Check Free energy profile  

Notes:
- gmx wham sets value of the first point to zero. This can be adjusted using `-zprof0` option
