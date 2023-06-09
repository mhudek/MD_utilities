# Tutorial for lipid bilayer analysis

***Original author: Ben Mitchell, modified by Magda Hudek***

### General notes

Before attempting to use any Gromacs tools on Archie you need to load the Gromacs module. 
```
module load gromacs/intel-2022.2/2022.1-single
```

If there is no .xtc file convert from .trr first

```
gmx_mpi -f step7.trr -s step7.tpr -o step7.xtc -pbc whole
```
Choose option `0` (System) when prompted
*The .trr trajectory is full precision and therefore very bulky. Working with .xtc is faster and more convinient*

Gromacs has many command line tools that help with analysis, these can be found [here](https://manual.gromacs.org/current/onlinehelp/gmx.html).

## Create a new index file
Index files helps Gromacs identify different groups within the membrane. Index file provided by Charmm-gui is very basic, so we need to expand it using `gmx make_ndx`

```
gmx_mpi make_ndx -f step7_production.tpr -o membrane_index.ndx
```
![image](https://github.com/mhudek/MD_utilities/assets/43149008/01c92e2c-c733-4d3a-bc9d-60397386936c)

Once at this window do the following:
Create an index group of the POPE phosphorus atoms (paste line below)
```
2 & a P
```
Rename the group (paste line below)
```
name 7 PE_FAMILY_P
```
Create an index group of the POPG phosphorus atoms (paste line below)
```
3 & a P
```
Rename the group (paste line below)
```
name 8 PG_FAMILY_P
```
Exit out the selector (paste line below)
```
Q
```
**Note** ensure that the number at the start of a prompt is the same as the group you want it to take from (e.g. 2 POPE, 0 System).

## Partial density

Partial density across the membrane allows analysis of the electronic structure of a system. This can be calculated by GROMACS using the following command:
```
gmx_mpi density -s step7_production.tpr -f production.xtc -n index.ndx -o density.xvg -d Z -center -sl 1200 
```
`-s` is the portable binary run input file (`.tpr`). `-f` is the trajectory file. `-n` is the index file. `-o` is the output file name. `-d` is the direction measured (you want across the Z axis).
`-sl` is the number of slices the box is divided into. 
Entering this command will bring up another prompt asking for group selections. 
First it asks you to choose what to center the system around and then what to calculate partial density for. In this example select membrane for both.  

**Note:** -sl option needs to be dependent on the box size. Easy way to check the box size is to open `step7.gro` in VMD, open TkConsole and type `pbc -get`. In this case we are calculating
density in Z direction, so we are only intrested in Z dimension of the box. We want the spacing of about 1 angstrom or larger (depending on vdw) radius. Divide the size of the box in z direction 
by the spacing to get number of slices. Repeat a few times with smaller and larger `-sl` to check for convergence. 

![image](https://github.com/mhudek/MD_utilities/assets/43149008/80fdb29d-9513-48e4-8d97-f11b9905f762)

To plot results use xmgrace

```
xmgrace density.xvg
```

![image](https://github.com/mhudek/MD_utilities/assets/43149008/83e2d463-9ecd-4e57-bdd3-e31e079291c4)

You may also want to calculate partial densities for specific groups. This allows us to see the position of each group withim the membrane.

## 
