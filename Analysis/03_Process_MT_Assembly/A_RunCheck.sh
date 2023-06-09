#!/bin/bash

#SBATCH -J RunQC_A
#SBATCH -p RM-shared
#SBATCH -o %j.txt
#SBATCH -e %j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sheri.anne.sanders@gmail.com
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=05:00:00

echo "Checking for software used in this step"

READY=1

echo "Checking for Transdecoder"

if [[ $(which Transdecoder.LongOrfs) ]]; then
   echo ".....Transdecoder is FOUND"
else
   echo ".....Trandecoder is missing"
   READY=0
fi

echo "Checking for cd-hit"
if [[ $(which cd-hit) ]]; then
   echo ".....cd-hit is FOUND"
else
   echo ".....cd-hit is missing"
   READY=0
fi

echo "Checking for cd-hit-est"
if [[ $(which cd-hit-est) ]]; then
   echo ".....cd-hit-est is FOUND"
else
   echo ".....cd-hit-est is missing"
   READY=0
fi

echo "Checking for subset_fasta.pl"
if [[ $(which cd-hit-est) ]]; then
   echo ".....subset_fasta.pl is FOUND"
else
   echo ".....subset_fasta.pl is missing"
   READY=0
fi

echo "DONE Checking software"

###########################################################

echo "Checking for databases"
echo "No databases for this step"

if [ $READY == 0 ]; then
    echo "Software or Databases are still missing, please address this before running workflow"
    echo ""
else
    echo "Software and Databases are all found, you can run the workflow now"
    echo ""
fi
