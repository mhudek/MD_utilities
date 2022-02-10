"""
Calculate persistence length

Calculate spacial and time average correlation between tangent vectors on a straight DNA chain. Configured to use with a bead wall setup and ignore first and last basepairs.
input: standard lammps dump
"""
import sys, math
import numpy as np
from numba import jit
from timeit import default_timer as timer
import matplotlib.pyplot as plt
import matplotlib as mpl
import matplotlib.colors as colors

#number of beads in the bead wall
N_BEADS = 441

def read_position(line,box_length=0):
    """
    reads in LAMMPS atom output, in the order: id, molecule, type, x, y, z, nx, ny, nz
    returns position of the atom
    """
    
    list1 = line.split()
    x, y, z = float(list1[3]),float( list1[4]),float( list1[5])
    nx, ny, nz = int (list1[6]), int( list1[7]),int( list1[8])
    #x, y, z = x + box_length*nx, y + box_length*ny, z + box_length*nz
          
    return x, y, z

   
def calculate_middle(position,N):
    """
    Stores the positions of the centre of mass in the first strand (strand1) and centre of mass in the seconds strand (strand2) seperately.
    Then calculates and returns middpoints of two centres of mass
    """

    #subtract the numer of beads and the first & last base pairs from the number of atoms 
    N = N - N_BEADS 
    strand1, strand2 = np.zeros((3, N//2)), np.zeros((3, N//2))
    middle = np.zeros((3, N//2))    
    i =  0
    n_basepair = N // 2
    while i < n_basepair:
            
        aux1 = i          
        aux2 = N - 1 - i   
                    
        strand1[:,i] = position[:,aux1]
        strand2[:,i] = position[:,aux2]
                     
        middle[:,i] = (strand1[:,i] + strand2[:,i]) / 2.0
                
        i += 1
        
    return middle
     
@jit
def calculate_correlation(middle):
    """
    The tangen-tangen correlation**/
    
    At each frame (time or snampshot from the simulation) we can compute the tangent-tangent correlation between base-pair i and basepair j (with j>i)
    This is done for all possible i.
    At this fixed time, we can therefore average the tangent-tangent correlation between the tangents that are separated by the same distance j-i.
    
    It is important that the larger the distance between the base-pairs, the less data we obtain. For example:
    if j-i = 0, then we have nbp-1 data: t0*t0, t1*t1, t2*t2, ..., tn-1 * tn-1
    if j-i = 1, then we have nbp-2 data: t0*t1, t1*t2, t2*t3, ...., tn-2* tn-1
    if j-i = nbp-1, then the only data we have is: t0*tn-1.
    """


    #vector joining two consecutive centre of mass points
    tangent = np.zeros((3, middle.size//3))
    n_basepair = middle.size // 3
    i = 0
    while i < n_basepair-1:
        k = i + 1
        tangent[:,i] = middle[:,k] - middle[:,i] 
        dt = length(tangent[:,i])           
        tangent[:,i] = tangent[:,i] / dt    
 
        i += 1

    correlation = np.zeros((n_basepair-1))
    i, j = 0, 0
      
    while i < n_basepair-1:
        j = 0
        while j < n_basepair - 1 - i:
            correlation[j] = correlation[j] + dot_product( tangent[:,i], tangent[:,i+j])
            
            j += 1    
        i += 1 
             
    j = 0
    while j < n_basepair-1:
     
        correlation[j] = correlation[j] / (n_basepair-1-j)
        j += 1

    return correlation

#calculate norm of 3D vector
@jit
def length(a):
    norm = math.sqrt( a[0]*a[0] + a[1]*a[1] + a[2]*a[2] )
    return norm

# calculate scalar product of 2 3D vectors
@jit
def dot_product(a,b):
    r = a[0]*b[0] + a[1]*b[1] + a[2]*b[2]
    return r


#Main part
print('#Started..')
if len(sys.argv) !=2:
    print("Syntax: $ python3 persistance_length.py input_filename")
    sys.exit(1)

start_time = timer()

r = open(sys.argv[1], 'r')
line=r.readline()
corr = []
correlation = []
n_timesteps = 0

while line != '':
    
    if line.find('TIMESTEP') != -1:
        current_timestep = int(r.readline())
        n_timesteps += 1
        line = r.readline()
    if line.find('NUMBER OF ATOMS') != -1:
        #N is the total number of particles in the system
        N = int(r.readline())
        n_basepair = (N-N_BEADS)//2 - 2 
        line = r.readline()
    if line.find('BOX BOUNDS ') != -1:
        line = r.readline()
        l1 = line.split()
        box_length = abs( float(l1[0]) - float(l1[1]) )
        line = r.readline()
    if line.find('ITEM: ATOMS id mol type x y z ix iy iz ') != -1:
        i=0
        positions = np.zeros((3,N))
        while i<N:
            line = r.readline()
            positions[0,i], positions[1,i], positions[2,i] = read_position(line)
            i += 1
        else:
             
            middle = calculate_middle(positions,N)
            correlation = calculate_correlation(middle)
            corr.append(correlation)            
            line = r.readline()
    else:
        line = r.readline()
 
r.close()

ave_corr = np.zeros((n_basepair+1))
corr = np.array(corr)
print('n_timesteps ' + str(n_timesteps) )
print(' ave_corr ' + str( ave_corr.size) + ' shape: ' + str( ave_corr.shape ) )
print( 'corr ' + str(corr.size)+ ' shape  ' + str(corr.shape))

for i in range(n_timesteps):
    ave_corr[:] += corr[i,:]
ave_corr[:] = ave_corr[:] / n_timesteps


ave_corr = np.array(ave_corr)
fig, ax = plt.subplots()
bp = np.arange(0,3434)

ax.set(xlabel='bp',ylabel='correlation')

plt.scatter(bp,ave_corr)

tl = 'Average correlation' 
plt.title(tl)

#filename = './kymograph_f{0}_sig{1}.png'.format(force,sig)
#try:
#    plt.savefig(filename)
#    print(str('Plot saved in this directory as '+ filename))
#except:
#    print("Could not save the plot ... ")

plt.show()

print("Done!")


#end_time = timer()
#runtime = end_time - start_time
#hours = runtime / 3600
#minutes = (runtime-np.rint(hours)*3600) / 60
#seconds = (runtime - np.rint(hours)*3600 -np.rint(minutes)*60) % 60
#print( "## Total runtime %ih:%im:%.2fs" (hours,minutes,seconds))
