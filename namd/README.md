# Random collection of tips for NAMD simulations

- If system crashes repeatedly for no reason at the same timestep, just after LDB it's probably LDB crash. Possible solution:
  ```
  ldBalancer none
  ```
  otherwise change number of cores or system slightly.

- Version 2.15 might crash if `nonBondedFreq 2` is set, remove this, so namd uses default or set to 1
- In new versions of Namd margin should not be set, unless equilibration/minimalization crashes due to instability 
- `wrapAll on` is not recommended with `colvars on`
- VMD creates correct .psf file if writepsf is called from a script (internally calls psfgen), but writes incorrect atom types if command is issued from TkConsole
