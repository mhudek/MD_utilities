# Umbrella sampling procedure for Gromacs
1. SMD 
2. Obtain coordinate files (.gro) from SMD using [get_windows.py](get_windows.py) 
3. Prepare [input](inputs) files 
4. Copy resultd into single directory and prepare wham files using [create_wham_files.sh](input/create_wham_files.sh)
5. Run wham
   ```
   gmx_mpi wham -it tpr-files.dat -ix pullx-files.dat -o -hist -unit kCal
   ```
6. Check histograms for overlap
   ```
   xmgrace -nxy histo.xvg
   ```
7. Check Free energy profile  
