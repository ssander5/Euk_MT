#!/bin/bash

#SBATCH -J RunQC_A
#SBATCH -p RM-shared
#SBATCH -o %j.txt
#SBATCH -e %j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=05:00:00

merged=final.100cluster.fasta

TransDecoder.LongOrfs -t $merged.fasta -m $orfSize 2>&1 > longorfs.log
TransDecoder.Predict -t $merged.fasta --no_refine_starts 2>&1 >> longorfs.log
