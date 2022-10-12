import parmed as pmd

psf = pmd.load_file('step3_input.psf')
psf.coordinates = pmd.load_file('step3_input.pdb').coordinates
params = pmd.charmm.CharmmParameterSet('par_interface.prm','water.prm')
psf.load_parameters(params)
psf.save('out.top') # .top is recognized as a GROMACS topology file
psf.save('out.gro')
