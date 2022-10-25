import parmed as pmd

#Load .psf and .pdb 
psf = pmd.load_file('step3_input.psf')
psf.coordinates = pmd.load_file('step3_input.pdb').coordinates

#Load all necessary parameter files (CHARMM toppar format)
params = pmd.charmm.CharmmParameterSet('par_interface.prm','water.prm')
psf.load_parameters(params)

#Define output
psf.save('out.top') # .top is recognized as a GROMACS topology file
psf.save('out.gro')
