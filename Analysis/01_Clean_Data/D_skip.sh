#!/bin/bash

#SBATCH -J RunQC_D
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

if [ -d ./bbmap ]; then
    echo "directory exists"
else
    mkdir bbmap
fi

echo "SKIPPING Removing phix adaptors and sequencing artifacts using BBMAP"

for g in ./sickle/*1.trimclean.sickleclean.fq ; do
    o=${g#./sickle/}

    cp ${g%1.trim*}1.trimclean.sickleclean.fq ./bbmap/${o%1.trim*}1.trimclean.sickleclean.spikeclean.fq
    cp ${g%1.trim*}2.trimclean.sickleclean.fq ./bbmap/${o%1.trim*}2.trimclean.sickleclean.spikeclean.fq
    cp ${g%1.trim*}unpaired.trimclean.sickleclean.fq ./bbmap/${o%1.trim*}unpaired.trimclean.sickleclean.spikeclean.fq
done



