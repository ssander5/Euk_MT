#!/bin/bash

#SBATCH -J RunQC_H
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

if [ -d final_QC_output ]; then
    echo "directory exists"
else
    mkdir final_QC_output
fi

echo "Copying clean files to the folder"
cp ./bbmap/*final.clean.fq ./final_QC_output/

for f in ./bbmap/*stats.txt; do
  cp $f ./final_QC_output/
done

echo "DONE copying clean files to the folder!"
