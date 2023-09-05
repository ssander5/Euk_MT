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

echo "Removing phix adaptors and sequencing artifacts using BBMAP"


for f in ./sickle/*1.trimclean.sickleclean.fq ; do
    name=${f#./sickle/}

    #bbduk for paired
    bbduk.sh \
    threads=8 \
    in=${f%1.trimclean*}1.trimclean.sickleclean.fq \
    in2=${f%1.trimclean*}2.trimclean.sickleclean.fq \
    k=31 \
    ref=../Reference/phix_adapters.fa.gz \
    out1=./bbmap/${name%1*}1.trimclean.sickleclean.spikeclean.fq \
    out2=./bbmap/${name%1*}2.trimclean.sickleclean.spikeclean.fq \
    minlength=60 \
    2>&1 > /dev/null | awk '{print "PHIX REMOVAL PAIRED "$0}' | tee -a ./bbmap/${name%1*}stats.txt

    #bbduk for unpaired
    bbduk.sh \
    threads=8 \
    in=${f%1.trim*}unpaired.trimclean.sickleclean.fq \
    k=31 \
    out1=./bbmap/${name%1*}unpaired.trimclean.sickleclean.spikeclean.fq \
    minlength=60 \
    2>&1 > /dev/null | awk '{print "PHIX REMOVAL UNPAIRED "$0}' | tee -a ./bbmap/${name%1*}stats.txt

done

echo "DONE Removing phix adaptors and sequencing artifacts using BBMAP!"


