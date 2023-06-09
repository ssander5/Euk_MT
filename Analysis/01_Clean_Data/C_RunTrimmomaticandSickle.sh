#!/bin/bash

#SBATCH -J RunQC_C
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

if [ -d trimmomatic ]; then
    echo "directory exists"
else
    mkdir trimmomatic
fi

if [ -d sickle ]; then
    echo "directory exists"
else
    mkdir sickle
fi

echo "Trimming with Trimmomatic and Sickle"

for g in ../00_Input_Data/*_1*; do    #######IF YOUR READS ARE *R1*, please change this to *R1* instead of *_1*
    i1=$g
    i2=${g%_1*}"_2*"          #######IF YOUR READS ARE *R1*, please change this to "_R2*"
    o=${g#../00_Input_Data/}
    base=${o%_1*}            #######IF YOUR READS ARE *R1*, please change this to o%R1 instead of *_1*

    #trimmomatic pe
    trimmomatic PE $i1 $i2 \
    -threads 16 \
    -trimlog ./trimmomatic/$base.trimlog.txt \
    ./trimmomatic/$base.1.trimclean.fq \
    ./trimmomatic/$base.1.u.trimclean.fq \
    ./trimmomatic/$base.2.trimclean.fq \
    ./trimmomatic/$base.2.u.trimclean.fq \
    ILLUMINACLIP:../Reference/adaptors.fa:1:50:30 \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:60

    #sickle pe
    sickle pe \
    -n \
    -f ./trimmomatic/$base.1.trimclean.fq \
    -r ./trimmomatic/$base.2.trimclean.fq \
    -o ./sickle/$base.1.trimclean.sickleclean.fq \
    -p ./sickle/$base.2.trimclean.sickleclean.fq \
    -t sanger \
    -q 20 \
    -l 60 \
    -s ./sickle/$base.u.trimclean.sickleclean.fq


    #sickle se
    sickle se \
    -n \
    -f ./trimmomatic/$base.1.u.trimclean.fq \
    -o ./sickle/$base.1.u.trimclean.sickleclean.fq \
    -t sanger \
    -q 20 \
    -l 60 \

    sickle se \
    -n \
    -f ./trimmomatic/$base.2.u.trimclean.fq \
    -o ./sickle/$base.2.u.trimclean.sickleclean.fq \
    -t sanger \
    -q 20 \
    -l 60 \

    #combining unpaired
    cat ./sickle/$base.1.u.trimclean.sickleclean.fq \
    ./sickle/$base.2.u.trimclean.sickleclean.fq \
    ./sickle/$base.u.trimclean.sickleclean.fq > \
    ./sickle/$base.unpaired.trimclean.sickleclean.fq

    rm ./sickle/$base.1.u.trimclean.sickleclean.fq ./sickle/$base.2.u.trimclean.sickleclean.fq ./sickle/$base.u.trimclean.sickleclean.fq
done

echo "DONE Trimming with Trimmomatic and Sickle!"
