#!/bin/bash

#SBATCH -J RunQC_E
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

echo "Removing host contamination and generating stats using BBMAP"

for g in ./bbmap/*1.trimclean.sickleclean.spikeclean.fq; do
    o=${g#./bbmap/}
    base=${o%_R1*}

    echo "Removing host contamination and generating stats using BBMAP"

    touch ./${g%1*}stats.txt

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
    ref=../Reference/human/hsref_GRCh38_p14_clean.fasta \
    in=$g,${g%1*}unpaired.trimclean.sickleclean.bbdukclean.fq \
    in2=${g%1*}2.trimclean.sickleclean.bbdukclean.fq,NULL \
    outu1=${g%1*}1.final.clean.fq \
    outu2=${g%1*}2.final.clean.fq \
    outu=${g%1*}u.clean.fq \
    path=../Reference/human | \

    awk '{print "HOST CONTAMINATION SEQUENCES "$0}' \
    > ./${g%1.*}stats.txt

    echo "Merging files"
    echo "Running bbmerge"
    bbmerge.sh \
       threads=16 \
       in1=${g} \
       in2=${g%1*}2.final.clean.fq \
       out=${g%1*}merged.final.clean.fq \
       outu1=${g%1*}1.unmerged.final.clean.fq \
       outu2=${g%1*}2.unmerged.final.clean.fq \
       mininsert=60 | \
       awk '{print "MERGED "$0}'  \
       > ./${g%1.*}stats.txt
    #done

    echo "Reformating for diamond"

    reformat.sh \
    in1=${g%1*}1.unmerged.final.clean.fq \
    in2=${g%1*}2.unmerged.final.clean.fq \
    out=${g%1*}12.interleaved.final.clean.fa

    cat ${g%1*}merged.final.clean.fq ${g%1*}u.clean.fq > ${g%1*}u.final.clean.fq
    rm ${g%1*}merged.final.clean.fq ${g%1*}u.clean.fq

    reformat.sh \
    threads=16 \
    in=${g%1*}u.final.clean.fq \
    > ./${s%1*}stats.txt

    reformat.sh \
    threads=16 \
    in1=${g%1*}1.unmerged.final.clean.fq \
    in2=${g%1*}2.unmerged.final.clean.fq | \
    awk '{print "PAIRED "$0}' \
    > ./${g%1*}stats.txt

done

echo "DONE Removing host contamination and generating stats using BBMAP!"
