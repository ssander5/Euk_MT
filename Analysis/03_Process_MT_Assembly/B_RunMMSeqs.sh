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

in=

mmseqs createdb $in $in.db
mmseqs linclust $in.db $in.tmp tmp --min-seq-id 1.00 --cov-mode 1 -c 1000 2>1& > mmseqs.log
mmseqs createsubdb $in.tmp $in.db $in.2.db
mmseqs convert2fasta $in.2.db 100cluster.fasta
mmseqs createsv $in.db $in.db $in.tmp 100cluster.tsv

rm -rf $in.db*
rm -rf $in.tmp*
rm -rf $in.2.db*
rm -rf tmp
