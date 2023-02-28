#!/bin/bash

#======================================================
#
# Job script for running GROMACS on multiple cores on a single node
#
#======================================================
#======================================================
#
#Propogate environment variables to the compute node
#SBATCH --export=ALL
#
#Run in the standard partition (queue)
#SBATCH --partition=gpu
#
# Request any GPU   
#SBATCH --gpus=1
#
#SBATCH --ntasks=1
#
#SBATCH --cpus-per-task=10 
#
# Specify project account
#SBATCH --account=mulheran-cf
#
#
# Specify (hard) runtime (HH:MM:SS)
#SBATCH --time=24:00:00
#
# Job name
#SBATCH --job-name=window
#
# Output file
#SBATCH --output=slurm-%j.out
#======================================================

module purge
module use /opt/software/intel/oneapi/modules/2022.2
module load mkl/2022.1.0
module load nvidia/sdk/22.3
export PATH=/opt/software/gromacs/intel-2022.2/2022.1/Xeon-5218R-gpu/bin:$PATH
export GMX_FORCE_UPDATE_DEFAULT_GPU=TRUE

#======================================================
# Prologue script to record job details
# Do not change the line below
#======================================================
/opt/software/scripts/job_prologue.sh  
#------------------------------------------------------
# Equilibration

gmx grompp -f umbrella_equil.mdp -o npt.tpr -c window.gro -p topol.top -n index.ndx
gmx mdrun -v -deffnm npt

# Production

gmx grompp -f umbrella.mdp -p topol.top -c npt.gro -o umbrella.tpr -n index.ndx
gmx mdrun -v -deffnm umbrella

#======================================================
# Epilogue script to record job endtime and runtim
# Do not change the line below
#======================================================
/opt/software/scripts/job_epilogue.sh 
#------------------------------------------------------
