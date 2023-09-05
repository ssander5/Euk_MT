#!/bin/bash

#SBATCH -J RunAssembly_B
#SBATCH -p RM-shared
#SBATCH -o %j.txt
#SBATCH -e %j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=05:00:00

echo "Running megahit"

    R1s=""
    R2s=""
    Rs=""


    i=1

    for f in ../01_*/final_QC_output/*.1.final.clean.fq; do
        R1s="$R1s,${f}"
        R2s="$R2s,${f%1*}2.final.clean.fq"
        Rs="$Rs,${f%1*}u.final.clean.fq"
    done

   megahit \
   -1 ${R1s:1} \
   -2 ${R2s:1} \
   -t 16 \
   --presets meta-large \
   --mem-flag 2 \
   -o ./megahit/
