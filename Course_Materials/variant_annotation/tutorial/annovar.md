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

1. Download gene annotation database (for hg18 build) and save to humandb/ directory
--------------------------------------------------------------------------------

    ./annotate_variation.pl -downdb refGene humandb/

    ./annotate_variation.pl -downdb -webfrom annovar 1000g2012apr humandb/

Other possible downloads for hg19:

    annotate_variation.pl -buildver hg19 -downdb -webfrom annovar refGene humandb/
    annotate_variation.pl -buildver hg19 -downdb phastConsElements46way humandb/
    annotate_variation.pl -buildver hg19 -downdb genomicSuperDups humandb/
    annotate_variation.pl -buildver hg19 -downdb -webfrom annovar 1000g2012apr humandb/
    annotate_variation.pl -buildver hg19 -downdb -webfrom annovar snp135 humandb/ 
    annotate_variation.pl -buildver hg19 -downdb -webfrom annovar ljb2_all humandb/
    annotate_variation.pl -buildver hg19 -downdb -webfrom annovar esp6500si_all humandb/
        
2. Gene-based annotation of variants in the varlist file (by default --geneanno is ON)
--------------------------------------------------------------------------------

    ./annotate_variation.pl --geneanno example/ex1.human humandb/ --outfile result
          
3. Region-based annotate variants
--------------------------------------------------------------------------------

    ./annotate_variation.pl -regionanno -dbtype cytoBand example/ex1.human humandb/ --outfile result

    ./annotate_variation.pl -regionanno -dbtype example_db_gff3 example/ex1.human humandb/ --outfile result


4. Filter rare or unreported variants (in 1000G/dbSNP) or predicted deleterious variants
--------------------------------------------------------------------------------

    ./annotate_variation.pl -filter -dbtype 1000g2012apr -maf 0.01 example/ex1.human humandb/ --outfile result

    ./annotate_variation.pl -filter -dbtype snp130 example/ex1.human humandb/ --outfile result


