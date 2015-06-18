mkdir -p /home/participant/cambridge_mda/
cp -r /home/participant/Course_Materials/annotation /home/participant/cambridge_mda/
cd /home/participant/cambridge_mda/annotation/cellbase
./cellbasedevelop/bin/cellbase.sh -h

./cellbasedevelop/bin/cellbase.sh variant-annotation -h

mkdir results    
./cellbasedevelop/bin/cellbase.sh variant-annotation -i /home/participant/cambridge_mda/annotation/cellbase/examples/CEU.exon.2010_03.genotypes.vcf \
-o /home/participant/cambridge_mda/annotation/cellbase/results/CEU.exon.2010_03.annotated.vep -s hsapiens -u bioinfodev.hpc.cam.ac.uk -L debug
less /home/participant/cambridge_mda/annotation/cellbase/results/CEU.exon.2010_03.annotated.vep

./cellbasedevelop/bin/cellbase.sh variant-annotation -i /home/participant/cambridge_mda/annotation/cellbase/examples/CEU.exon.2010_03.genotypes.vcf \
-o /home/participant/cambridge_mda/annotation/cellbase/results/CEU.exon.2010_03.annotated.json -s hsapiens -u bioinfodev.hpc.cam.ac.uk -L debug

less /home/participant/cambridge_mda/annotation/cellbase/results/CEU.exon.2010_03.annotated.json

grep -v "Clinvar\"\:null" /home/participant/cambridge_mda/annotation/cellbase/results/CEU.exon.2010_03.annotated.json | head

tail /home/participant/cambridge_mda/annotation/cellbase/results/CEU.exon.2010_03.annotated.json
