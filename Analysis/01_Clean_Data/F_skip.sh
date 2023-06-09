#!/bin/bash

#SBATCH -J RunQC_F
#SBATCH -p RM-shared
#SBATCH -o %j.txt
#SBATCH -e %j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sheri.anne.sanders@gmail.com
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

#Get Database

echo "SKIPPING Removing rRNA contamination using SortMeRNA database in bbduk"

for g in ./bbmap/*1.trimclean.sickleclean.spikeclean.hostclean.fq; do

    cp ${g%1.trim*}1.trimclean.sickleclean.spikeclean.hostclean.fq ${g%1.trim*}1.final.clean.fq
    cp ${g%1.trim*}2.trimclean.sickleclean.spikeclean.hostclean.fq ${g%1.trim*}2.final.clean.fq
    cp ${g%1.trim*}unpaired.trimclean.sickleclean.spikeclean.hostclean.fq ${g%1.trim*}u.final.clean.fq

    echo "SKIPPING rRNA CONTAMINATION REMOVAL" >> ./bbmap/$(basename ${g%1.trim*}stats.txt)
done
