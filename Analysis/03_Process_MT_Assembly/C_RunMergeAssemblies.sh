#!/bin/bash

#SBATCH -J RunCombine_C
#SBATCH -p RM-shared
#SBATCH -o %j.txt
#SBATCH -e %j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=05:00:00

cat megahit.100cluster.fasta | sed 's/>/>megahit_filtered_' > final.assembly.fasta

cat trinity.100cluster.fasta | sed 's/>/trinity_filtered_/g' >> final.assembly.fasta

cat rna_spades.100cluster.fasta | sed 's/>/>rnaspades_filtered_/g' >> final.assembly.fasta

cat meta_spades.100cluster.fasta | sed 's/>/>metaspades_filtered_/g' >> final.assembly.fasta
