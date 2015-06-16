mkdir -p /home/participant/cambridge_mda/
cp -r /home/participant/Desktop/Open_Share/annotation /home/participant/cambridge_mda/
cd /home/participant/cambridge_mda/annotation/cellbase

./cellbase.sh -h

./cellbase.sh variant-annotation -h

mkdir cellbase_results    
./cellbase.sh variant-annotation -i /home/participant/cambridge_mda/annotation/cellbase/examples/CEU.exon.2010_03.genotypes.vcf -o /home/participant/cambridge_mda/annotation/cellbase_results/CEU.exon.2010_03.annotated.vep -s hsapiens
less /home/participant/cambridge_mda/annotation/cellbase_results/CEU.exon.2010_03.annotated.vep

./cellbase.sh variant-annotation -i /home/participant/cambridge_mda/annotation/cellbase/examples/CEU.exon.2010_03.genotypes.vcf -o /home/participant/cambridge_mda/annotation/cellbase_results/CEU.exon.2010_03.annotated.json -s hsapiens

less /home/participant/cambridge_mda/annotation/cellbase_results/CEU.exon.2010_03.annotated.json

grep -v "Clinvar\"\:null" /home/participant/cambridge_mda/annotation/cellbase_results/CEU.exon.2010_03.annotated.json   

