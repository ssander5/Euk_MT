#!/bin/bash

#SBATCH -J RunQC_G
#SBATCH -p RM-shared
#SBATCH -o %j.txt
#SBATCH -e %j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=05:00:00

echo "Creating stats"

for f in ./bbmap/*1.final.clean.fq; do

     base=${f%1.final*}

     grep 'RAWREADS' ${base}stats.txt  | grep 'Input:' | awk '{print "RAWREADS COUNT""\t"$3/2}' | tee ${base}finalstats.txt
     grep 'RAWREADS' ${base}stats.txt  | grep 'Input:' | awk '{print "BASES RAWREADS "$5}' | tee -a ${base}finalstats.txt
     grep 'HOST CONTAMINATION SEQUENCES' ${base}stats.txt | grep "Reads Used:"  | awk '{printf $4" "}' | awk '{print "READS BIO "$1/2 + $2}' | tee -a ${base}finalstats.txt
     egrep ^UNPAIRED ${base}stats.txt  | grep 'Input:' | awk '{print $3}' | awk '{print "READS CLEAN_UNPAIRED "$1}' | tee -a ${base}finalstats.txt
     egrep ^UNPAIRED ${base}stats.txt  | grep 'Input:' | awk '{print "BASES CLEAN_UNPAIRED "$5}' | tee -a ${base}finalstats.txt
     egrep ^PAIRED ${base}stats.txt  | grep 'Input:' | awk '{print $3}' | awk '{print "READS CLEAN_PAIRED "$1}' | tee -a ${base}finalstats.txt
     egrep ^PAIRED ${base}stats.txt  | grep 'Input:' | awk '{print "BASES CLEAN_PAIRED "$5}' | tee -a ${base}finalstats.txt

done

echo "DONE creating stats!"
