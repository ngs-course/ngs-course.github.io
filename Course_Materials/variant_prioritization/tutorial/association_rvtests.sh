cd /home/training/ngs_course/association
	--inVcf 4Kvariants_147samples.vcf.gz \
	--pheno 4Kvariants_147samples.ped \
	--out 4Kvariants_147samples \
	--kinship 4Kvariants_147samples.kinship \
	--single famScore,famLRT,famGrammarGamma
zcat refFlat_hg19.txt.gz | head
