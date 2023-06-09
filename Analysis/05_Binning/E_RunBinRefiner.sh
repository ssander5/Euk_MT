#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 7_Bin_Refining

#make output folder

if [ -d bin_refinement ]; then
    echo "directory exists"
else
    mkdir bin_refinement
    mkdir ./bin_refinement/input
    mkdir ./bin_refinement/input/maxbin
    mkdir ./bin_refinement/input/metabat
    mkdir ./bin_refinement/binrefiner_output
fi

if [ -d checkM ]; then
    echo "directory exists"
else
    mkdir checkM
    mkdir checkM/maxbin
    mkdir checkM/metabat
    mkdir checkM/refined
fi


#cp ./binning/maxbin/*.fasta ./bin_refinement/input/maxbin
cp ./binning/metabat/*.fa ./bin_refinement/input/metabat

#Binning_refiner
Binning_refiner \
   -i ./bin_refinement/input \
   -p all.BR

mv *BR* ./bin_refinement/binrefiner_output

export PATH=$PATH:../../Software/hmmer-3.3.2/bin/

#running checkM for maxbin
checkm lineage_wf \
   -t 8 \
   -x fasta \
   ./binning/maxbin/ \
   ./checkM/maxbin/

checkm taxonomy_wf \
   domain \
   Bacteria \
   ./binning/maxbin/ \
   ./checkM/maxbin/ \
   -x fasta

#running checkM for metabat

checkm lineage_wf \
   -t 8 \
   -x fa \
   ./binning/metabat \
   ./checkM/metabat

checkm taxonomy_wf \
    domain \
    Bacteria \
    ./binning/metabat \
    ./checkM/metabat/ \
    -x fa

#running checkM for refined bins

checkm lineage_wf \
   -t 8 \
   -x fasta \
   ./bin_refinement/binrefiner_output/all.BR_Binning_refiner_outputs/all.BR_refined_bins/ \
   ./checkM/refined

checkm taxonomy_wf \
    domain \
    Bacteria \
    ./bin_refinement/binrefiner_output/all.BR_Binning_refiner_outputs/all.BR_refined_bins \
    ./checkM/refined \
    -x fasta


echo "DONE running Binrefiner!"
