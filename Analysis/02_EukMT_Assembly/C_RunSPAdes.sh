#!/bin/bash

#SBATCH -J RunAssembly_C
#SBATCH -p RM-shared
#SBATCH -o %j.txt
#SBATCH -e %j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=05:00:00

mem=800
threads=20
out=spades/
out2=spades-meta/
left=Trinity/left.norm.fq
right=Trinity/right.norm.fq

PATH=$PATH:../Software/SPAdes-3.15.4-Linux/bin

spades.py --rna -1 $left -2 $right -m $mem -t $threads -o $out 2>&1 > spades.log
spades.py --meta -1 $left -2 $right -m $mem -t $threads -o $out2 2>&1 > metaspades.log
