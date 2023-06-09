#cdhit100 → transdecoder → cd-hit98 → salmon quant
#Output: Assembly.clean.fa, gene-to-transcript.tbl

#make output folder
mkdir clustering100
mkdir clustering98

#Translate to pep -> combined.pep
TransDecoder.LongOrfs \
    -t combined.fa

#Cluster cds to remove redundancy (c 100) -> combined.nr.cds (nr = non redundant)
cd-hit-est \
    -i combined.fa.transdecoder_dir/longest_orfs.cds \
    -o clustering100/combined.nr.cds \
    -c 1 \
    -T 5 \
    -g 1 \
    -d 0 \
    -sc \
    -sf

#Subset pep -> combined.nr.pep
grep ">" clustering100/combined.nr.cds | \
    sed -e 's/>//g' | \
    sort | \
    uniq \
    > list.nr.tmp

../Software/subset_fasta.pl \
    -i list.nr.tmp \
    < combined.fa.transdecoder_dir/longest_orfs.pep \
    > clustering100/combined.nr.pep

rm list.nr.tmp

#Cluster pep to form ~isoform groups (c 98) -> combined.nr.98.pep
cd-hit \
    -i clustering100/combined.nr.pep \
    -o clustering98/combined.nr.98.pep \
    -c 0.98 \
    -T 5 \
    -g 1 \
    -d 0 \
    -sc \
    -sf

#Subset combined.fa to non-redundant, one-per-loci fasta
grep ">" clustering98/combined.nr.98.pep | \
    sed -e 's/>//g' -e 's/.p.*//g' | \
    sort | \
    uniq \
    > list.nr.98.tmp

../Software/subset_fasta.pl \
    -i list.nr.98.tmp \
    < combined.fa \
    > Assembly.clean.fa

rm list.nr.98.tmp

#Convert isoform clstr file into Trinity's format
#TDB

#run salmon quantification
#TBD
