#Author: magdalena.hudek@strath.ac.uk

# Define a function to update the label with the current frame number
proc update_label {args} {
  
  global label_id  

  set frame [molinfo 0 get frame]     	
  #puts "Frame: $frame "
  #Chage from frame to time ... in this case timestep was 2 ps 
  set t [format "%.2f" [expr $frame * 0.002]]  
  graphics 0 delete all
  draw color black
  draw text {5 0 -10} "Time $t ns" size 1 thickness 3

}

# Draw new label every time frame changes
trace add variable vmd_frame(0) write "update_label"

