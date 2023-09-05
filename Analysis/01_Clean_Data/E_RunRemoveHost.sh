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

echo "Removing host contamination and generating stats using BBMAP"

for g in ./bbmap/*1.trimclean.sickleclean.spikeclean.fq; do
    o=${g#./bbmap/}
    base=${o%_R1*}

    bbwrap.sh \
    threads=16 \
    minid=0.95 \
    maxindel=3 \
    bwr=0.16 \
    bw=12 \
    quickmatch \
    fast \
    minhits=2 \
    qtrim=rl \
    trimq=20 \
    minlength=60 \
    in=$g,${g%1*}unpaired.trimclean.sickleclean.spikeclean.fq \
    in2=${g%1*}2.trimclean.sickleclean.spikeclean.fq,NULL \
    outu1=${g%1*}1.trimclean.sickleclean.spikeclean.hostclean.fq \
    outu2=${g%1*}2.trimclean.sickleclean.spikeclean.hostclean.fq \
    outu=${g%1*}unpaired.trimclean.sickleclean.spikeclean.hostclean.fq \
    path=../Reference/human/ 2>&1 >/dev/null | \
    awk '{print "HOST CONTAMINATION SEQUENCES "$0}' | \
    tee -a ${g%1.*}stats.txt

done

echo "DONE Removing host contamination and generating stats using BBMAP!"
