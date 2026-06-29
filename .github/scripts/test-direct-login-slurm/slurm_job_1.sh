#!/bin/bash
#SBATCH --job-name=downstream-direct-1
#SBATCH --qos=nf
#SBATCH --time=00:05:00
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --output=slurm_job_1.%j.out
set -ex
echo "Hello from SLURM job 1 on $(hostname)"
srun hostname
