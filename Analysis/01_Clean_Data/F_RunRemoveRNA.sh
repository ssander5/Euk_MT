#!/bin/bash

#SBATCH -J RunQC_F
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

#Get Database
if [ -f ../Reference/smr_v4.3_default_db.fasta ]; then
    echo "rRNA database exists"
else
    wget https://github.com/sortmerna/sortmerna/releases/download/v4.3.3/database.tar.gz
    mv database.tar.gz ../Reference/
    tar -xvf ../Reference/database.tar.gz
fi

echo "Removing rRNA contamination using SortMeRNA database in bbduk"

for f in ./bbmap/*1.trimclean.sickleclean.spikeclean.hostclean.fq; do
    #bbduk is easier to install, faster to run, and has similar output to sortmerna

    base=${f%1.trim*}

    #bbduk for paired
    bbduk.sh \
    in=${base}1.trimclean.sickleclean.spikeclean.hostclean.fq \
    in2=${base}2.trimclean.sickleclean.spikeclean.hostclean.fq \
    ref=../Reference/smr_v4.3_default_db.fasta \
    out=${base}1.final.clean.fq \
    out2=${base}2.final.clean.fq \
    outm=${base}reads_that_match_rRNA.fq 2>&1 >/dev/null | \
    awk '{print "RNA CONTAMINATION SEQUENCES PAIRED "$0}' | \
    tee -a ./${base}stats.txt

    #bbduk for unpaired
    bbduk.sh \
    threads=8 \
    in=${base}unpaired.trimclean.sickleclean.spikeclean.hostclean.fq \
    k=31 \
    out1=${base}u.clean.fq \
    minlength=60
    outm=${base}reads_that_match_rRNA_unpaired.fq 2>&1 >/dev/null | \
    awk '{print "RNA CONTAMINATION SEQUENCES UNPAIRED "$0}' | \
    tee -a ./${base}stats.txt

   echo "Merging files"
   echo "Running bbmerge"
   /home/sheri/local/miniconda3/envs/champion/bin/bbmerge.sh \
       threads=16 \
       in1=${base}1.final.clean.fq \
       in2=${base}2.final.clean.fq \
       out=${base}merged.final.clean.fq \
       outu1=${base}1.unmerged.final.clean.fq \
       outu2=${base}2.unmerged.final.clean.fq \
       mininsert=60 2>&1 >/dev/null | \
       awk '{print "MERGED "$0}' | \
       tee -a ./${base}stats.txt

    echo "Reformating for diamond"

    /home/sheri/local/miniconda3/envs/champion/bin/reformat.sh \
    in1=${base}1.unmerged.final.clean.fq \
    in2=${base}2.unmerged.final.clean.fq \
    out=${base}12.interleaved.final.clean.fa

    cat ${base}merged.final.clean.fq ${base}u.clean.fq > ${base}u.final.clean.fq
    rm ${base}merged.final.clean.fq ${base}u.clean.fq

    /home/sheri/local/miniconda3/envs/champion/bin/reformat.sh \
    threads=16 \
    in=${base}u.final.clean.fq 2>&1 >/dev/null | \
    awk '{print "UNPAIRED "$0}' | \
    tee -a ./${base}stats.txt

    /home/sheri/local/miniconda3/envs/champion/bin/reformat.sh \
    threads=16 \
    in1=${base}1.unmerged.final.clean.fq \
    in2=${base}2.unmerged.final.clean.fq 2>&1 >/dev/null | \
    awk '{print "PAIRED "$0}' | \
    tee -a ./${base}stats.txt

done

echo "DONE Removing rRNA contamination using SortMeRNA database in bbduk!"

