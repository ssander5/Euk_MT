#!/bin/bash

#SBATCH -J RunCombine_B
#SBATCH -p RM-shared
#SBATCH -o %j.txt
#SBATCH -e %j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=05:00:00

echo "Removing Redundancy within Assembly"

in=../02_*/megahit/megahit_final_1000_filtered.fasta;out=megahit
#in=../02_*/trinity/trinity_1000_filtered.fasta;out=trinity
#in=../02_*/spades/rna_contigs_1000_filtered.fasta;out=rna_spades
#in=../02_*/spades-meta/meta-contigs_filtered.fasta;out=meta_spades

mmseqs createdb $in $in.db
mmseqs linclust $in.db $in.tmp tmp --min-seq-id 1.00 --cov-mode 1 -c 1000 2>1& > $out.mmseqs.log
mmseqs createsubdb $in.tmp $in.db $in.2.db
mmseqs convert2fasta $in.2.db $out.100cluster.fasta
mmseqs createsv $in.db $in.db $in.tmp $out.100cluster.tsv

rm -rf $in.db*
rm -rf $in.tmp*
rm -rf $in.2.db*
rm -rf tmp

echo "Done Removing Redundancy within Assembly
