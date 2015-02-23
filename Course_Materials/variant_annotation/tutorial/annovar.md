% [NGS data analysis course](http://ngscourse.github.io/)
% __Variant annotation__
% _(updated 29-09-2014)_

<!-- COMMON LINKS HERE -->

[AnnoVar]: http://www.openbioinformatics.org/annovar/ "AnnoVar"

Variant annotation with Annovar
================================================================================

Copy the necessary data in your working directory:

    mkdir -p /home/participant/cambridge_mda/
    cp -r /home/participant/Desktop/Open_Share/annotation /home/participant/cambridge_mda/
    cd /home/participant/cambridge_mda/annotation/annovar


1. VCF to Annovar format
--------------------------------------------------------------------------------

    perl convert2annovar.pl -format vcf4 example/example1.vcf > example/example1.annovar
	perl convert2annovar.pl -format vcf4 -allsample -withfreq example/example1.vcf > example/example1.annovar

The above command takes example1.vcf as input file, and generate the example1.annovar as output file. The 3 extra columns are zygosity status, genotype quality and read depth.


1. Download gene annotation database (for hg18 build) and save to humandb/ directory
--------------------------------------------------------------------------------

    perl annotate_variation.pl -buildver hg19 -downdb refGene humandb/

	perl annotate_variation.pl -buildver hg19 -downdb cytoBand humandb/

    perl annotate_variation.pl -buildver hg19 -downdb 1000g2012apr humandb/

    perl annotate_variation.pl -buildver hg19 -downdb snp135 humandb/

Other possible downloads for hg19 (more can be found at http://www.openbioinformatics.org/annovar/annovar_download.html):


    perl annotate_variation.pl -buildver hg19 -downdb phastConsElements46way humandb/
    perl annotate_variation.pl -buildver hg19 -downdb genomicSuperDups humandb/
    perl annotate_variation.pl -buildver hg19 -downdb ljb2_all humandb/
    perl annotate_variation.pl -buildver hg19 -downdb esp6500si_all humandb/


2. Gene-based annotation of variants in the varlist file (by default --geneanno is ON)
--------------------------------------------------------------------------------

    mkdir results
	perl annotate_variation.pl --geneanno example/example1.annovar humandb/ -build hg19 --outfile results/0-geneanno

3. Region-based annotate variants
--------------------------------------------------------------------------------

    perl annotate_variation.pl -regionanno -dbtype cytoBand example/example1.annovar humandb/ -build hg19 --outfile results/1-regionanno


4. Filter rare or unreported variants (in 1000G/dbSNP) or predicted deleterious variants
--------------------------------------------------------------------------------

    perl annotate_variation.pl -filter -dbtype 1000g2012apr_all -maf 0.01 example/example1.annovar humandb/ -build hg19 --outfile results/2-filter

    perl annotate_variation.pl -filter -dbtype snp135 example/example1.annovar humandb/ -build hg19 --outfile results/2-filter


