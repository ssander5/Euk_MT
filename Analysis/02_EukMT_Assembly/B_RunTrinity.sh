#make output folder
if [ -d "trinity" ]; then
    echo "./trinity exists"
else
    mkdir trinity
fi

cd trinity

for f in ../01_Clean_Data/final_QC_output/*.1.final.clean.fq; do
    R1s="$R1s,${f}"
    R2s="$R2s,${f%1*}2.final.clean.fq"
    Rs="$Rs,${f%1*}u.final.clean.fq"
done

~/local/trin*/Trinity \
    --max_memory 200G \
    --seqType fq  \
    --left ${R1s#,} \
    --right ${R2s#,} \
    --CPU 16 \
    --full_cleanup \
    --output Trinity

cd -
