#!/bin/bash

#Submit this script with: sbatch thefilename

#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --cpus-per-task=32   # number of CPU per task
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem=200G
#SBATCH -p cq
#SBATCH -J "nextflow_triobinning"   # job name
#SBATCH --mail-user=# email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

module purge
module load go/1.18.3
module load singularity/3.8.7
module load nextflow/25.10.4

nextflow -C nextflow.config run triobinning.nf -resume
