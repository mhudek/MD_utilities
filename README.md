# MD_utillities

- Code for pre- and post-processing in Molecular Dynamics, mainly for [NAMD](/namd/) - including [umbrella sampling](/umbrella_sampling) and [smd](/SMD/); [GROMACS](/gromacs/) & [VMD](/vmd_scripts/).
- There are some more complex [Gnuplot](/Gnuplot/) scripts available; for basics refer to Gnuplot manual or [one-liners](ONE_LINERS.md).
- [Miscaleneous](/misc) is a collection of scripts that don't fit anywhere else.

## Useful Bash commands
Collection of one-line bash commands that might come in handy is available [here](ONE_LINERS.md).

### Umbrella_sampling

Files were originally obtained from NAMD umbrella sampling tutorial

##Indexing accross different codes:

| Software   | starts at 0 | starts at 1 | 
| ---------- | ---------- | ----------- | 
| VMD        | index      | serial      |
| MDAnalysis | index      | id          |
| Gromacs    |            | .ndx files  |

## Charmm-GUI tips
- add `EXT XPLOR` to first line of psf file
- water segments should be called `TIP3`
 
## List of resources for MD
- [CHARMM-GUI](https://charmm-gui.org/) - create inputs for NAMD, LAMMPS, GROMACS
- [PyMOL](https://github.com/schrodinger/pymol-open-source) - VMD alternative for visualisation and post-precessing; open-source and educational versions are free
- [Ovito](https://www.ovito.org/) - nice for visualisation for LAMMPS; free version limited for post-processing
- [MDAnalysis](https://www.mdanalysis.org/) - Python MD pre- & post-processing library  
- [SwissParam](https://swissparam.ch/) - CHARMM ff small molecule parametrisation
- [Tupa](https://mdpoleto.github.io/tupa/) - visualise electric field in PyMol
- [Calculate entropy](https://codeentropy.readthedocs.io/en/latest/index.html)
- [FixBox](https://pubs.acs.org/doi/10.1021/acs.jcim.2c00823) - To fix broken PBCs (.gro format)

## General software/code resources
- [Software carpentry](https://software-carpentry.org/lessons/) - free lessons in bash, python, R ...
