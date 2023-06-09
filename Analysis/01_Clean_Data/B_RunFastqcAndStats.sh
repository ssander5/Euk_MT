#!/bin/bash

#SBATCH -J RunQC_B
#SBATCH -p RM-shared
#SBATCH -o %j.txt
#SBATCH -e %j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sheri.anne.sanders@gmail.com
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=05:00:00

echo "Running FastQC and Generating Stats"

#make output folder
if [ -d "fastqc" ]; then
    echo "./fastqc exists"
else
    mkdir fastqc
fi

for g in ../00_Input_Data/; do
      fastqc -o ./fastqc $g
done


echo "BBMAP stats"
if [ -d "bbmap" ]; then
    echo "./bbmap exists"
else
    mkdir bbmap
fi

for g in ../../Input_data/*fastq; do
    o=${g#../../Input_data/}
    reformat.sh threads=16 in=$g > ./bbmap/${o%_1*}.stats.txt
done

echo "DONE Running FastQC and Generating Stats!"
