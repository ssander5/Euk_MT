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

#make output folder
if [ -d "trinity" ]; then
    echo "./trinity exists"
else
    mkdir trinity
fi

for f in ../01_Clean_Data/final_QC_output/*.1.final.clean.fq; do
    R1s="$R1s,${f}"
    R2s="$R2s,${f%1*}2.final.clean.fq"
    Rs="$Rs,${f%1*}u.final.clean.fq"
done

../Software/insilico_read_normalization.pl \
    --JM 200G \
    --seqType fq  \
    --left ${R1s#,} \
    --right ${R2s#,} \
    --max_cov 40 \
    --pairs_together \
    --CPU 2 \
    --full_cleanup \
    --output Trinity

../Software/Trinity \
    --max_memory 200G \
    --seqType fq  \
    --no_normalize_reads \
    --left Trinity/left.norm.fq \
    --right Trinity/right.norm.fq \
    --CPU 16 \
    --full_cleanup \
    --output Trinity
