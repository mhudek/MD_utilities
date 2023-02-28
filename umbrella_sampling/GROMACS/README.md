# Umbrella sampling procedure for Gromacs
1. SMD 
2. Obtain coordinate files (.gro) from SMD using [get_windows.py](get_windows.py) 
3. Prepare input files
4. Copy files into single folder and prepare wham files
5. Run wham
   ```
   gmx_mpi wham -it tpr-files.dat -ix pullx-files.dat -o -hist -unit kCal
   ```
6. Check histograms for overlap
  ```
  xmgrace -nxy histo.xvg
  ```
7. Check Free energy profile  
