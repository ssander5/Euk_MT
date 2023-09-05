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
mem=100
threads=24
out=final_assembly



cat megahit/megahit_final_1000_filtered.fasta | sed 's/>/>megahit_filtered_' > final.assembly.fasta


cat trinity/Trinity_1000_filtered.fasta | sed 's/>/trinity_filtered_/g' >> final.assembly.fasta


cat spades/rna_contigs_1000_filtred.fasta | sed 's/>/>rnaspades_filtered_/g' >> final.assembly.fasta


cat spades-meta/meta-contigs_filtered.fasta | sed 's/>/>metaspades_filtered_/g' >> final.assembly.fasta
