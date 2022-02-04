#!/bin/bash

#======================================================
#
# Job script for running on a single node
#
#======================================================

#======================================================
#SBATCH --mail-type=ALL
#SBATCH --mail-user=somethin@something
#
# Propogate environment variables to the compute node
#SBATCH --export=ALL
#
# Run in the standard partition (queue)
#SBATCH --partition=standard
#
# Specify project account
#SBATCH --account=
#
# No. of tasks required 
#SBATCH --ntasks=20 --nodes=1   
#
# Distribute processes in round-robin fashion for load balancing
#SBATCH --distribution=cyclic
#
#
# Specify (hard) runtime (HH:MM:SS)
#SBATCH --time=40:00:00
#
# Job name
#SBATCH --job-name=window
#
# Output file
#SBATCH --output=slurm-%j.out
#======================================================

module purge
module load namd/intel-2016.4/2.12_mpi

#======================================================
# Prologue script to record job details
# Do not change the line below
#======================================================
/opt/software/scripts/job_prologue.sh  
#------------------------------------------------------

mpirun -np $SLURM_NTASKS namd2 win.conf > win.out.$SLURM_JOB_ID

#======================================================
# Epilogue script to record job endtime and runtime
# Do not change the line below
#======================================================
/opt/software/scripts/job_epilogue.sh 
#------------------------------------------------------
