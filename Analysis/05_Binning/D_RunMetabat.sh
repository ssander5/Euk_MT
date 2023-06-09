#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 6_MetaBat

#make output folder

if [ -d binning ]; then
    echo "directory exists"
else
    mkdir binning
fi

if [ -d binning/metabat ]; then
    echo "directory exists"
else
   mkdir ./binning/metabat
fi

echo "Running Binning Metabat"
for f in ../1_*/final_QC_output/*1.final.clean.fq; do
      metabat2 \
      -i ../03_Process_MT_Assembly/Assembly.clean.fa \
      -a ./coverage/all.depth.txt \
      -o ./binning/metabat/all_metabat \
      -t 16 \
      -m 1500 \
      -v \
      --unbinned
done

#In order to check which contigs were grouped together into separate bins by MetaBat example
#grep ">" E01452_L001_to_L004_metabat.1.fa | sed 's/>//g' > E01452_L001_to_L004_metabat.1.contigNames

echo "DONE running Binning Metabat!"
