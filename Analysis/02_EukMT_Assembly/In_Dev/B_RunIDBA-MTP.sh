#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 2_Runidba

conda activate bioinf

cd /afs/crc/group/huge/Fractionated_Microbiome_Analysis/Analysis/2_Assembly

#make output folder

if [ -d idba_ud ]; then
    echo "directory exists"
else
    mkdir idba_ud
fi

for z in ../0_*/zone.[A]; do
    if [ -d idba_ud/${z#../0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./idba_ud/${z#../0_*/}
    fi

    #first covert paired into single
    #idba_ud -b y /usr/bin/idba_ud -r reads12.fas --num_threads 14 -o ${ANALYSIS_FOLDER}/assembly/idba_ud_out/${i%.1*}
    #1. Merged the paired end data and covert to fasta format.

    echo "Running idba/fq2fa"

    for f in ../1_Quality_Control/final_QC_output/$z/*1.unmerged.final.clean.fq; do
      fq2fa --merge ${f} ${f%1*}2.unmerged.final.clean.fq ${f%1*}12.final.clean.fa

      idba_ud \
      -l ${f%1*}12.final.clean.fa \
      --mink 20 \
      --maxk 124 \
      --num_threads 16 \
      -o ./idba_ud/${f%.1*}
    done
done
