import pandas as pd
import numpy as np

import matplotlib.pyplot as plt
import matplotlib as mpl
import matplotlib.colors as colors

try:
    from IPython import get_ipython
    get_ipython().magic('clear')
    get_ipython().magic('reset -f')
except:
    pass


deprot = [10, 16, 22, 41, 41, 43, 54, 60, 69, 76, 87, 115, 117, 118, 119, 121,\
          124, 126, 137, 141, 149, 155, 159, 165, 166, 183, 184, 191, 206,\
              209, 218, 229, 249, 252, 256, 267] 

#H-bonds array produced by measure_h_bonds.tcl script in VMD
df = pd.read_csv("./h_bonds_custom.txt")
#array with index, atom_name, resname and resid of all donors and acceptors
names = pd.read_csv("./names.txt")

#identify unique hydrogen bonds
hbond_types = df.drop_duplicates([' DONOR', ' ACCEPTOR'], keep='first')

#get the number of frames for the simulation
num_frames = df['FRAME'].max()+1

#make dictionary so we can lookup nanes, resnames ... 
id2types = names[['ID',' resname']].set_index('ID').T.to_dict('list')
id2name = names[['ID',' name']].set_index('ID').T.to_dict('list')
id2resid = names[['ID',' resid']].set_index('ID').T.to_dict('list')
id2segname = names[['ID',' segname']].set_index('ID').T.to_dict('list')

#identify bonds between silica & chitosan, and create a name for each bond
d = []
for idx, row in hbond_types.iterrows():
    d_index = row[' DONOR']
    a_index = row[' ACCEPTOR']
    d_type = id2types[d_index]
    a_type = id2types[a_index]
    a_segname = id2segname[a_index][0]
    d_segname = id2segname[d_index][0]
    if ( (str(a_type[0]) != str(d_type[0])) and (a_segname == " CHF " or d_segname == " CHF ")  ):
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
    if p.shape[0] > 700:  # show only bonds with more than x number of frames
        temp = np.zeros(num_frames)
        n.append(row['NAME'])
        for idx, row in p.iterrows():
            temp[row['FRAME']] = 1
        m.append(temp)
m = np.array(m)


frame = m 
#plotting part

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
