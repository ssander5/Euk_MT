#!/bin/bash

#SBATCH -J RunQC_A
#SBATCH -p RM-shared
#SBATCH -o %j.txt
#SBATCH -e %j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=05:00:00

echo "Checking for software used in this step"

READY=1

echo "Checking for Trinity"

if [[ $(which Trinity) ]]; then
   echo ".....Trinity is FOUND"
else
   echo ".....Trinity is missing"
   READY=0
fi

echo "Checking for Megahit"
if [[ $(which megahit) ]]; then
   echo ".....Megahit is FOUND"
else
   echo ".....Megahit is missing"
   READY=0
fi

echo "Checking for SPAdes"
if [[ $(which spades.py) ]]; then
   echo ".....SPAdes is FOUND"
else
   echo ".....SPAdes is missing"
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
