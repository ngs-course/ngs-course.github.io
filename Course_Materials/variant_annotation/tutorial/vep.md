% [NGS data analysis course](http://ngscourse.github.io/)
% __Variant annotation__
% _(updated 21-10-2015)_

<!-- COMMON LINKS HERE -->

[VEP]: http://www.ensembl.org/info/docs/tools/vep/index.html "VEP"

Variant annotation with VEP
================================================================================

In this part of the course we will focus on filtering, annotating and prioritisation of the variants we have called with GATK.

We are going to work in the annotation folder:

	cd /home/training/ngs_course/annotation


1. Compressing and indexing VCF files
--------------------------------------------------------------------------------

In order to further process the variants in the VCF file we created with GATK we first need to compress and index it.

	bgzip -c ~/ngs_course/calling/example_0/006-dna_chr21_100_he_pe_filtered.vcf > dna_chr21_100_he_pe_filtered.vcf.gz
	
	tabix -p vcf dna_chr21_100_he_pe_filtered.vcf.gz

The with bgzip compressed files end with ``.vcf.gz`` and the corresponding tabix index files have the extension ``.vcf.gz.tbi``.

2. Quality control of variants
--------------------------------------------------------------------------------

Summary statistics can be generated with bcftools stats. Run the command below to generate the summary statistics and the corresponding report and take a look the results.

	bcftools stats dna_chr21_100_he_pe_filtered.vcf.gz > vcfstats.txt

3. Variant effect prediction and filtering
--------------------------------------------------------------------------------

In order to predict the functional consequences of the variants on genes and to gain additional useful annotation/information about their deleteriousness we can run Ensembl's Variant Effect Predictor (VEP). The consequence types that are predicted by VEP are illustrated here. VEP can be run on the command line (see below) or directly via [Ensembl's web page](http://www.ensembl.org/info/docs/tools/vep/index.html).

## VEP command line tool
There is a limit to the size of the files that can be uploaded to the web page. If the files are getting very big it is advised to use VEP Perl scrip variant_effect_predictor.pl from the command line.

	~/soft/ensembl-vep-82/scripts/variant_effect_predictor/variant_effect_predictor.pl

Take a look at the documentation and make yourself familiar with the command line parameters we are using here. You can also check the documentation at their website: http://grch37.ensembl.org/info/docs/tools/vep/script/vep_options.html

Let's predict the effect of the variants detected in our VCF.

	~/soft/ensembl-vep-82/scripts/variant_effect_predictor/variant_effect_predictor.pl \
		--offline \
		--input_file dna_chr21_100_he_pe_filtered.vcf.gz \
		--output_file test \
		--vcf \
		--stats_file test_summary.html \
		--assembly GRCh37

When it finishes, take a look at the output files.

The overall results are summarised in a neat HTML file ending with ``_summary.html`` that can be viewed in your browser.

### Exercise:
Work out what command line options are needed to filter out rare coding variants with a MAF<0.01 in central european (CEU) population and run the command.
Show how to filter with ``filter_vep.pl`` and ``bcftools``.

## VEP web application

You can try to run the same from their web tool: [http://grch37.ensembl.org/Tools/VEP](http://grch37.ensembl.org/Tools/VEP).




