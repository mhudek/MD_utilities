import pandas as pd
import numpy as np

import matplotlib.pyplot as plt
import matplotlib as mpl
import matplotlib.colors as colors

#try:
#    from IPython import get_ipython
#    get_ipython().magic('clear')
#    get_ipython().magic('reset -f')
#except:
#    pass

#H-bonds array produced by measure_h_bonds.tcl script in VMD
df = pd.read_csv("./h_bonds_custom.txt")
#array with index, atom_name, resname and resid of all donors and acceptors
names = pd.read_csv("./names.txt")

#identify unique hydrogen bonds
hbond_types = df.drop_duplicates([' DONOR', ' ACCEPTOR'], keep='first')

#get the number of frames for the simulation
num_frames = df['FRAME'].max()

#make dictionary so we can lookup nanes, resnames ... 
id2types = names[['ID',' resname']].set_index('ID').T.to_dict('list')
id2name = names[['ID',' name']].set_index('ID').T.to_dict('list')
id2resid = names[['ID',' resid']].set_index('ID').T.to_dict('list')

#identify bonds between silica & chitosan, and create a name for each bond
d = []
for idx, row in hbond_types.iterrows():
    d_index = row[' DONOR']
    a_index = row[' ACCEPTOR']
    d_type = id2types[d_index]
    a_type = id2types[a_index]
    if str(a_type[0]) != str(d_type[0]):
        an = id2name[row[' ACCEPTOR']]
        dn = id2name[row[' DONOR']]
        arid = id2resid[row[' ACCEPTOR']]
        drid = id2resid[row[' DONOR']]
        name = str(str(dn[0])+str("(")+str(drid[0])+str(")")+str(an[0]) + str("(")+str(arid[0])+str(")"))     
        d.append(( d_index, a_index, name ))
  
hbonds_cht_si = pd.DataFrame(d, columns=(' DONOR', ' ACCEPTOR', 'NAME'))

# Create the array for plotting. 

#place holder list for map
m = []  
#place holder list for bond names
n = []
for idx, row in hbonds_cht_si.iterrows():
    p = df.loc[(df[' DONOR'] == row[' DONOR'])]
    p = p.loc[(df[' ACCEPTOR'] == row[ ' ACCEPTOR'])]
    if p.shape[0] > 1:  # show only bonds with more than x number of frames
        temp = np.zeros(num_frames)
        n.append(row['NAME'])
        for idx, row in p.iterrows():
            temp[row['FRAME']] = 1
        m.append(temp)
m = np.array(m)


frame = m 
#plotting part
#########################################################################

fig, ax = plt.subplots()
cmap = colors.ListedColormap(['white', 'black'])

plt.yticks(np.arange(0,len(n)), n)

#x = [0, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000]
#xticks = [0, 1, 2, 3,  4, 5, 6, 7, 8]
#plt.xticks(x, xticks)
#plt.xlabel("Time (ns)")

cax=plt.imshow(frame,origin='lower',filternorm=False,aspect='auto', cmap=cmap, interpolation='nearest')

#plot xlines where h-bonds break
#for k in range(len(frame)):
#    x = np.max( np.nonzero(frame[k,:]))
#    plt.plot([ x, x], [-0.5, 9.5], color='red', linewidth=1)
#    print(x*2)

cbar = fig.colorbar(cax, ticks=[0.25, 0.75],shrink=1,aspect=20)
boundaries = [ 0, 1]
norm = colors.BoundaryNorm(boundaries, cmap.N, clip=True)
cbar.ax.set_yticklabels(['no bond', 'bond'])

#####################################################################

#fig, (ax1, ax2, ax3) = plt.subplots(3, 1)


'''

#Plot 1 - force
d1 = np.loadtxt("force.txt")
t1 = d1[:,0]
force = d1[:,1]
f0 = np.zeros(len(t1))

x1 = [-100, -50, 0, 50, 100, 150]
ax1.set_yticks(x1)
ax1.set_yticklabels(x1, fontsize='x-small')

ax1.plot(t1, force, linewidth=0.1)
ax1.plot(t1, f0, linewidth=0.5, color='black')

ax1.set_ylabel("Force(pN)", fontsize='x-small')
ax1.set_xticklabels("")

ax1.set_ylim(-100,150)


#Plot 2 - displacement

d2 = np.loadtxt("displacement.txt")
t2 = d2[:,0]
z = d2[:,1]

x2 = [0, 2, 4, 6, 8]
ax2.set_yticks(x2)
ax2.set_yticklabels(x2, fontsize='x-small')

ax2.plot(t2,z, linewidth=0.1)
ax2.set_ylabel("Displacement (nm)", fontsize='x-small')
ax2.set_xticklabels("")

ax2.set_ylim(0,10)


#Plot 3

cmap = colors.ListedColormap(['white', 'black'])



x = np.arange(0,4287,500)
xticks = x*20*0.001
plt.xticks(x, xticks)
plt.xlabel("Time (ns)")

cax=ax3.imshow(frame,origin='lower',filternorm=False,aspect='auto', cmap=cmap, interpolation='nearest')
plt.yticks(np.arange(0,len(n)), n, fontsize='xx-small')



#plot xlines where h-bonds break
for k in range(len(frame)):
    x = np.max( np.nonzero(frame[k,:]))
    ax1.plot([ x*20, x*20], [-100, 300], color='red', linewidth=0.5, alpha=0.5)
    ax2.plot([ x*20, x*20], [-1, 10], color='red', linewidth=0.5, alpha=0.5)
    ax3.plot([ x, x], [-0.5, 15.5], color='red', linewidth=0.5, alpha=0.5)
    
    print(x*2)

#Adjust spaces and limits 
plt.subplots_adjust(left =0.2, hspace = 0.1)


#xlimits
xmax =42 #max time in ns

ax1.set_xlim(t1[0],xmax*1000)
ax2.set_xlim(t2[0],xmax*1000 )
ax3.set_xlim(0,xmax*50)


#Add labels
#ax1.text(0.95 *xmax*1000, 110, "A")
#ax2.text(0.95 *xmax*1000, 3.2, "B")
#ax3.text(0.95 *xmax*500, 10, "C")


plt.savefig('plot-zoomed-in.png', dpi=1200)
'''
