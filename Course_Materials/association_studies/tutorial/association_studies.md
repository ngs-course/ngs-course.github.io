% [NGS data analysis course](http://www.ngscourse.org)
% __Association Analysis using PLINK__
% _(updated 2015-02-25)_

<!-- COMMON LINKS HERE -->

[plink]:http://pngu.mgh.harvard.edu/~purcell/plink/ "PLINK: whole genome association analysis"
[vcftools]: http://vcftools.sourceforge.net/ "VCFtools: A package for working with VCF files: merging, comparing, annotating ..."
[tabix]:http://samtools.sourceforge.net/tabix.shtml "tabix: compress and index TAB-delimited files. Useful for handling GFF, GTF, BED and VCF files"
[R]:http://www.r-project.org/ "The Project for Statistical Computing"

[vcf-format-1000ge]:http://www.1000genomes.org/wiki/Analysis/Variant%20Call%20Format/vcf-variant-call-format-version-41
[vcf-format-wikipedia]:http://en.wikipedia.org/wiki/Variant_Call_Format

[1000 genomes]:http://www.1000genomes.org/ "1000 Genomes Home Page"


Preliminaries
================================================================================


Software used in this practical:
--------------------------------

- [PLINK] : whole genome association analysis.
- [VCFtools] : A package for working with VCF files: merging, comparing, annotating ...
- [tabix] : compress and index TAB-delimited files. Useful for handling GFF, GTF, BED and VCF files.
- [R] : a programming language devised for statistical data analysis.

File formats explored:
----------------------

- VCF Variant Call Format: see [1000 Genomes][vcf-format-1000ge] and [Wikipedia][vcf-format-wikipedia] specifications.

See PLINK file formats description [here](http://pngu.mgh.harvard.edu/~purcell/plink/data.shtml#tr).


### Standard PLINK file formats are:

__PED file__ with fields (columns):

1. Family ID
2. Individual ID
3. Paternal ID
4. Maternal ID
5. Sex (1=male; 2=female; other=unknown)
6. Phenotype (1=unaffected; 2=affected; 0 missing; -9=missing)
7. ... genotypes ...


__MAP file__ with fields (columns):

1. chromosome (1-22, X, Y or 0 if unplaced)
2. rs... or SNP identifier
3. Genetic distance (Morgans)
4. Base-pair position (BP units)


### Transposed formats, generally more suitable for genomic data are:

__TPED file with fields (columns):__

1. chromosome (1-22, X, Y or 0 if unplaced)
2. SNP identifier (rs...)
3. Genetic distance (Morgans)
4. Base-pair position (BP units)
5. ...  genotypes ...

__TFAM file with fields (columns):__

1. Family ID
2. Individual ID
3. Paternal ID
4. Maternal ID
5. Sex (1=male; 2=female; other=unknown)
6. Phenotype (1=unaffected; 2=affected; 0 missing; -9=missing)


Overview
================================================================================

1. Use [tabix] to download data from __remote__ VCF files.
1. Use [VCFtools] for converting VCF files to PED and MAP format.
1. Use [PLINK] to perform association studies.

Use [R] for data handling and transformation.


Exercise
================================================================================
	
<!-- new and clean data directory in the sandbox
    rm -r ../../../../sandbox/association_studies/
	mkdir ../../../../sandbox/association_studies/
	cd    ../../../../sandbox/association_studies/
-->

For this practical we will download an example dataset from the [1000 Genomes] web page using [tabix].

Go to the 1000 Genomes FTP site:

<ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/analysis_results/integrated_call_sets>

The files in this directory represent the final variant call set associated with the phase1 analysis.



Use [tabix] to download the first variants in chromosome 20:

    tabix -h ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/analysis_results/integrated_call_sets/ALL.chr20.integrated_phase1_v3.20101123.snps_indels_svs.genotypes.vcf.gz 20:1-1000000 > f010_first_chr20.vcf

- What does it mean the parameter `-h` in the command above? <!-- print / include also the header lines -->  
  (you can find the `tabix` help just by typing the command in in shell)
- What does it mean the parameter `20:1-1000000`? <!-- the range of positions to be downloaded -->
- Why do not we use the option `-o` to create the output file? How do we do it instead?  <!-- the option -o is not implemented; we use the redirection > instead -->


How many lines has it got the downloaded file:

    wc -l f010_first_chr20.vcf 


Convert VCF file to a TPED + TFAM files using [VCFtools]:
   
    vcftools --vcf f010_first_chr20.vcf --out f020_plink_format --plink-tped 

The above command will create the the `.tped` and `.tfam` files. Notice that it will also create an _index_ for the vcf file.

Explore the structure of the files created.

    head f020_plink_format.tfam
    head f020_plink_format.tped


Apply [PLINK] to get a description of the dataset:

    plink --noweb --allow-no-sex --out f030_plink_description --tfile f020_plink_format

- What happens if you do not include the `--allow-no-sex` flag? [^resp]  
  (See the indications in the output or in the `.log` file)


[^resp]:Warning, found 1092 individuals with ambiguous sex codes  
These individuals will be set to missing ( or use --allow-no-sex )  
Writing list of these individuals to [ f030_plink_description2.nosex ]


<!-- What information is in the file `.nosex`? -->

Edit the file `f020_plink_format.tfam` to include some Phenotype information. 
Remember this information is to be coded in __column 6__ as: 1=unaffected; 2=affected; 0 missing.

You could use any software, any spreadsheet for instance, to include this information. 
For this practical we will use [R]

(The file __[edit_tfam_file.r](edit_tfam_file.r)__ shows how to carry out the edition of the file using R)

<!--
    R CMD BATCH --vanilla ../../ngs-course.github.io/Course_Materials/association_studies/tutorial/edit_tfam_file.r
-->


Let's carry out an [association test](http://pngu.mgh.harvard.edu/~purcell/plink/anal.shtml#cc) now using PLINK.

    plink --noweb --allow-no-sex --tped f020_plink_format.tped --tfam f040_plink_format.tfam --out f050_res_plink --assoc

- Why do we use the parameters `--tped` and `--tfam` instead of the `--tfile` used before?.
- What happens if you do not include the `--allow-no-sex` flag?  
  (Run the same command without this parameter and compare the output files)
  <!-- all statistics are returned as missing NA because all individuals are excluded from the analysis as they do not have the sex information -->

<!-- without the --allow-no-sex
    plink --noweb --tped f020_plink_format.tped --tfam f040_plink_format.tfam --out f050_res_plink_NO_NO-SEX --assoc
-->

See PLINK documentation on some other options to [handle Phenotype data](http://pngu.mgh.harvard.edu/~purcell/plink/data.shtml#pheno)

Explore the results file: 

    head f050_res_plink.assoc


We can ask PLINK to perform a [p-value adjustment] using the option `--adjust`

    plink --noweb --allow-no-sex --tped f020_plink_format.tped --tfam f040_plink_format.tfam --out f060_res_plink --assoc --adjust

Explore the results file: 

    head f060_res_plink.assoc.adjusted

and compare with the previous file:

    head f050_res_plink.assoc


You can use the [R] scripts:

- __[explore_plink_results.r](explore_plink_results.r)__
- __[explore_plink_pvalues.r](explore_plink_pvalues.r)__

to do the exploration and the comparison.


<!--
    R CMD BATCH --vanilla ../../ngs-course.github.io/Course_Materials/association_studies/tutorial/explore_plink_results.r
    R CMD BATCH --vanilla ../../ngs-course.github.io/Course_Materials/association_studies/tutorial/explore_plink_pvalues.r
-->
