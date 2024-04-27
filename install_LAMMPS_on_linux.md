# A simple LAMMPS installation guide

[LAMMPS](https://www.lammps.org/) has a detailed installation guide, this is a simplified version. 

1. Download LAMMPS from [https://www.lammps.org/download.html](https://www.lammps.org/download.html)
2. Get system up to date
   ```
   sudo apt-get update
   sudo apt-get upgrade
   ```
3. For the fresh Ubuntu installs
   ```
   sudo apt-get install build-essential
   sudo apt-get install cmake
   ```
4. Extract Lammps directory
   ```
   tar -xvf lammps.tgz
   ```
5. ```
   cd lammps
   mkdir build
   cd build
   ```
6. Add this stage we need to enable the additional packages
   ```
   cmake -C ../cmake/presets/most.cmake ../cmake  # enable most packages
   cmake -D PKG_MC=on .                           # enable MC package, same format for other packaged
   ```
7. Time to compile, this is best done in parallel using -j flag, to find out how many cores you have run `lscpu` command
   ```
   make - j N  #N is the number of cores to comiple with
   ```
8. optional, copy compiled files into installation location
   ```
   make install   
   ```
   The location of the installation tree defaults to `${HOME}/.local.`
   
