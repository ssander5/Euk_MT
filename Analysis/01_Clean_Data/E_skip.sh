#!/bin/bash

#SBATCH -J RunQC_E
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

if [ -d bbmap ]; then
    echo "directory exists"
else
    mkdir bbmap
fi

echo "SKIPPING Removing host contamination and generating stats using BBMAP"

for g in ./bbmap/*1.trimclean.sickleclean.spikeclean.fq; do

    cp ${g} ${g%1.trim*}1.trimclean.sickleclean.spikeclean.hostclean.fq
    cp ${g%1.trim*}2.trimclean.sickleclean.spikeclean.fq ${g%1.trim*}2.trimclean.sickleclean.spikeclean.hostclean.fq
    cp ${g%1.trim*}unpaired.trimclean.sickleclean.spikeclean.fq ${g%1.trim*}unpaired.trimclean.sickleclean.spikeclean.hostclean.fq

    echo "SKIPPING HOST CONTAMINATION SEQUENCE REMOVAL" >> ./bbmap/$(basename ${g%1.trim*}stats.txt)
done
