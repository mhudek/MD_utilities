### Visualisation from TkConsole in VMD
Futher details can be found in [VMD manual](http://www.csb.yale.edu/userguides/graphics/vmd/vmd_help.html), [Axel Koholmayer's website](https://sites.google.com/site/akohlmey/random-hacks/vmd-init-script) might come in handy as well 

1. Update default selection
  ```
  mol selection <selection>
  ```
  e.g. `mol selection "all not water"`, passing variable with selected atoms doesn't work, but passing string selection works as expected.  

2. (optional) - set material/colour/representation
   ```
   mol representation <representation>
   ```
   e.g. `mol selection lines`

2. Create new representation
  ```
  mol addrep top
  ```

  
  
