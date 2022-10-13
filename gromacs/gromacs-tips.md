# Tips for Gromacs 
author: Magdalena Hudek

*This file will be expanded with time*

## Minimalization

- Sometimes tolerance needs to be set quite low O(10^2), most tutorials say O(10^3)
- Use h-bonds restraints during the minimalization if you will use them during the production run (e.g. rigid water)

## Equilibration

- Use Berendsen for this stage - it’s more robust than more accurate thermostats
- If it runs in serial, but not parallel it’s likely blowing up
- If vacuum bubbles form with silica slab use semi-isotropic pressure coupling (same pressure for both)
