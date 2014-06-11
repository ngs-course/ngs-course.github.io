% [NGS data analysis course](http://ngscourse.github.io/)
% __Variant annotation__
% _(updated 08-06-2014)_

<!-- COMMON LINKS HERE -->

[AnnoVar]: http://www.openbioinformatics.org/annovar/ "AnnoVar"

Variant annotation with Annovar
================================================================================

Copy the necessary data in your working directory:

    mkdir -p /home/participant/cambridge_mda14/
    cp -r /home/participant/Desktop/Open_Share/annotation /home/participant/cambridge_mda14/
    cd /home/participant/cambridge_mda14/annotation/annovar


1. VCF to Annovar format
--------------------------------------------------------------------------------

    perl convert2annovar.pl -format vcf4 example/example1.vcf > example/example1.annovar

The above command takes example1.vcf as input file, and generate the example1.annovar as output file. The 3 extra columns are zygosity status, genotype quality and read depth.

If you read the screen message carefully, it tells that only 1 out of 3 samples have been processed in this VCF file. **By default, only the first sample in VCF file will be written to output file**. The input contains five loci, but two of them do not have variation for the first sample, and that is why the output contains only 3 variants.


1. Download gene annotation database (for hg18 build) and save to humandb/ directory
--------------------------------------------------------------------------------

    perl annotate_variation.pl -downdb refGene humandb/

    perl annotate_variation.pl -downdb 1000g2012apr humandb/

Other possible downloads for hg19 (more can be found at http://www.openbioinformatics.org/annovar/annovar_download.html):

    perl annotate_variation.pl -buildver hg19 -downdb refGene humandb/
    perl annotate_variation.pl -buildver hg19 -downdb phastConsElements46way humandb/
    perl annotate_variation.pl -buildver hg19 -downdb genomicSuperDups humandb/
    perl annotate_variation.pl -buildver hg19 -downdb 1000g2012apr humandb/
    perl annotate_variation.pl -buildver hg19 -downdb snp135 humandb/ 
    perl annotate_variation.pl -buildver hg19 -downdb ljb2_all humandb/
    perl annotate_variation.pl -buildver hg19 -downdb esp6500si_all humandb/


2. Gene-based annotation of variants in the varlist file (by default --geneanno is ON)
--------------------------------------------------------------------------------

    mkdir results
    perl annotate_variation.pl --geneanno example/ex1.human humandb/ --outfile results/0-geneanno
          
3. Region-based annotate variants
--------------------------------------------------------------------------------

    perl annotate_variation.pl -regionanno -dbtype cytoBand example/ex1.human humandb/ --outfile results/1-regionanno


4. Filter rare or unreported variants (in 1000G/dbSNP) or predicted deleterious variants
--------------------------------------------------------------------------------

    perl annotate_variation.pl -filter -dbtype 1000g2012apr -maf 0.01 example/ex1.human humandb/ --outfile results/1-filter

    perl annotate_variation.pl -filter -dbtype snp130 example/ex1.human humandb/ --outfile results/1-filter


