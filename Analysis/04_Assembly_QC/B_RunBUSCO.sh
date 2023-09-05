#!/bin/bash

#SBATCH -J RunAsmblyQC_B
#SBATCH -p RM-shared
#SBATCH -o %j.txt
#SBATCH -e %j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=05:00:00

busco \
   -m transcriptome \
   -i ../03_Process_MT_Assembly/Assembly.clean.fa \
   -o test \
   -l eukaryota
