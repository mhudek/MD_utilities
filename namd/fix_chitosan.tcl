# Create .pdb file to fix molecule

set all [ atomselect top all ]
set fix [ atomselect top "fragment 12 to 17" ]
all set occupancy 0
fix set occupancy 1
all writepdb fix_cht_middle.pdb
