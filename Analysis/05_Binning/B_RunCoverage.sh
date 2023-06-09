#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N D3_Coverage_and_Binning

#make output folder

if [ -d coverage ]; then
    echo "directory exists"
else
    mkdir coverage
    mkdir coverage/bam
fi

    echo "Running Create coverage file"
      echo "Running bbwrap in coverage file"

    for f in ../01_Clean_Data/final_QC_output/*.1.final.clean.fq; do
        R1s="$R1s,${f}"
        R2s="$R2s,${f%1*}2.final.clean.fq"
    done

      bbwrap.sh \
      ref=../03_Process_MT_Assembly/Assembly.clean.fa \
      nodisk \
      in=${R1s#,} \
      in2=${R2s#,} \
      t=4 \
      kfilter=22 \
      subfilter=15 \
      maxindel=80 \
      out=./coverage/bam/all.sam \
      covstats=./coverage/bam/all.coverage

      #converting sam file to bam
      samtools view \
      -S \
      -b \
      -u \
      ./coverage/bam/all.sam \
      > ./coverage/bam/all.bam

      #sorting the bam file
      samtools sort \
      -m 16G \
      -@ 3 \
      ./coverage/bam/all.bam \
      -o ./coverage/bam/all.sorted.bam

      #indexing the sorted bam file
      samtools index \
      ./coverage/bam/all.sorted.bam

      jgi_summarize_bam_contig_depths \
      --outputDepth ./coverage/all.depth.txt \
      --pairedContigs ./coverage/all.paired.txt \
      --minContigLength 1000 \
      --minContigDepth 2 \
      ./coverage/bam/all.sorted.bam

      tail -n+2 ./coverage/all.depth.txt | cut -f 1,3 > ./coverage/all.maxbin.cov

echo "DONE running create coverage file!"

