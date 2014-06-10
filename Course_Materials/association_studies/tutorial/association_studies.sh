
rm -r ../../../../sandbox/association_studies/
mkdir ../../../../sandbox/association_studies/
cd    ../../../../sandbox/association_studies/
tabix -h ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/analysis_results/integrated_call_sets/ALL.chr20.integrated_phase1_v3.20101123.snps_indels_svs.genotypes.vcf.gz 20:1-1000000 > f010_first_chr20.vcf
wc -l f010_first_chr20.vcf 
vcftools --vcf f010_first_chr20.vcf --out f020_plink_format --plink-tped 
head f020_plink_format.tfam
head f020_plink_format.tped
plink --noweb --allow-no-sex --out f030_plink_description --tfile f020_plink_format
R CMD BATCH --vanilla ../../ngs-course.github.io/Course_Materials/association_studies/tutorial/edit_tfam_file.r
plink --noweb --allow-no-sex --tped f020_plink_format.tped --tfam f040_plink_format.tfam --out f050_res_plink --assoc
plink --noweb --tped f020_plink_format.tped --tfam f040_plink_format.tfam --out f050_res_plink_NO_NO-SEX --assoc
head f050_res_plink.assoc
plink --noweb --allow-no-sex --tped f020_plink_format.tped --tfam f040_plink_format.tfam --out f060_res_plink --assoc --adjust
head f060_res_plink.assoc.adjusted
head f050_res_plink.assoc
R CMD BATCH --vanilla ../../ngs-course.github.io/Course_Materials/association_studies/tutorial/explore_plink_results.r
R CMD BATCH --vanilla ../../ngs-course.github.io/Course_Materials/association_studies/tutorial/explore_plink_pvalues.r
