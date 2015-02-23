mkdir -p /home/participant/cambridge_mda/
cp -r /home/participant/Desktop/Open_Share/annotation /home/participant/cambridge_mda/
cd /home/participant/cambridge_mda/annotation/hpg-variant
./hpg-var-effect -v examples/CHB.exon.2010_03.sites.vcf --outdir hpg-variant_results
./hpg-var-vcf split -v examples/CEU.exon.2010_03.genotypes.vcf --criterion chromosome --outdir filter
./hpg-var-vcf filter -v examples/CEU.exon.2010_03.genotypes.vcf --coverage 9000 --save-rejected --outdir filter_coverage
./hpg-var-vcf stats -v examples/CEU.exon.2010_03.genotypes.vcf --outdir stats
./hpg-var-vcf stats -v examples/CEU.exon.2010_03.genotypes.vcf --samples --outdir stats_by_sample
./hpg-var-gwas tdt -v examples/4Kvariants_147samples.vcf -p examples/4Kvariants_147samples.ped --outdir tdt
./hpg-var-gwas assoc --chisq -v examples/4Kvariants_147samples.vcf -p examples/4Kvariants_147samples.ped --outdir assoc-chisq
./hpg-var-gwas assoc --fisher -v examples/4Kvariants_147samples.vcf -p examples/4Kvariants_147samples.ped --outdir assoc-fisher
