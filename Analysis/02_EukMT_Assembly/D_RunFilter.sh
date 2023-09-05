#!/bin/bash

#SBATCH -J RunAssembly_D
#SBATCH -p RM-shared
#SBATCH -o %j.txt
#SBATCH -e %j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=05:00:00


echo "Running assembly length filter"

      #spades
      ./reformat.sh \
      in=./spades/contigs.fasta \
      out=./spades/rna_contigs_1000_filtered.fasta \
      minlength=1000

      #spades
      ./reformat.sh \
      in=./spades-meta/contigs.fasta \
      out=./spades-meta/meta_contigs_1000_filtered.fasta \
      minlength=1000

      #megahit
      reformat.sh \
      in=./megahit/final.contigs.fa \
      out=./megahit/megahit_final_1000_filtered.fasta \
      minlength=1000

      #trinity
      reformat.sh \
      in=./trinity/Trinity.Trinity.fasta \
      out=./trinity/Trinity_1000_filtered.fasta \
      minlength=1000

echo "DONE running assembly length filter!"
