mkdir -p /home/participant/cambridge_mda/
cp -r /home/participant/Desktop/Open_Share/annotation /home/participant/cambridge_mda/
cd /home/participant/cambridge_mda/annotation/annovar
perl convert2annovar.pl -format vcf4 example/example1.vcf > example/example1.annovar
perl convert2annovar.pl -format vcf4 -allsample -withfreq example/example1.vcf > example/example1.annovar
perl annotate_variation.pl -buildver hg19 -downdb refGene humandb/
perl annotate_variation.pl -buildver hg19 -downdb cytoBand humandb/
perl annotate_variation.pl -buildver hg19 -downdb 1000g2012apr humandb/
perl annotate_variation.pl -buildver hg19 -downdb snp135 humandb/
perl annotate_variation.pl -buildver hg19 -downdb phastConsElements46way humandb/
perl annotate_variation.pl -buildver hg19 -downdb genomicSuperDups humandb/
perl annotate_variation.pl -buildver hg19 -downdb ljb2_all humandb/
perl annotate_variation.pl -buildver hg19 -downdb esp6500si_all humandb/
mkdir results
perl annotate_variation.pl --geneanno example/example1.annovar humandb/ -build hg19 --outfile results/0-geneanno
perl annotate_variation.pl -regionanno -dbtype cytoBand example/example1.annovar humandb/ -build hg19 --outfile results/1-regionanno
perl annotate_variation.pl -filter -dbtype 1000g2012apr_all -maf 0.01 example/example1.annovar humandb/ -build hg19 --outfile results/2-filter
perl annotate_variation.pl -filter -dbtype snp135 example/example1.annovar humandb/ -build hg19 --outfile results/2-filter
