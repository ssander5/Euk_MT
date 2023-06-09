#make output folder

for f in ../02_EukMT_Assembly/*/*f*a; do
    cat $f >> combined.fa
done


