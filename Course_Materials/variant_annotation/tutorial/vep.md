% [NGS data analysis course](http://ngscourse.github.io/)
% __Variant annotation__
% _(updated 21-10-2015)_

<!-- COMMON LINKS HERE -->

[VEP]: http://www.ensembl.org/info/docs/tools/vep/index.html "VEP"

Variant annotation with VEP
================================================================================

In this part of the course we will focus on filtering, annotating and prioritisation of the variants we have called with GATK.


1. Compressing and indexing VCF files
--------------------------------------------------------------------------------

In order to further process the variants in the VCF file we created with GATK we first need to compress and index it.

	

The with bgzip compressed files end with .vcf.gz and the corresponding tabix index files have the extension .vcf.gz.tbi.

2. Quality control of variants
--------------------------------------------------------------------------------

Summary statistics can be generated with bcftools stats. Run the command below to generate the summary statistics and the corresponding report and take a look the results.

	

3. Variant effect prediction and filtering
--------------------------------------------------------------------------------

In order to predict the functional consequences of the variants on genes and to gain additional useful annotation/information about their deleteriousness we can run Ensembl's Variant Effect Predictor (VEP). The consequence types that are predicted by VEP are illustrated here. VEP can be run on the command line (see below) or directly via [Ensembl's web page] (http://www.ensembl.org/info/docs/tools/vep/index.html).

## VEP command line tool
There is a limit to the size of the files that can be uploaded to the web page. If the files are getting very big it is advised to use VEP Perl scrip variant_effect_predictor.pl from the command line.

Let's predict the effect of the variants detected in our VCF.

	variant_effect_predictor.pl --offline --fork 8 \
	    --input_file $inprefix.vcf.gz \
	    --output_file STDOUT --vcf --no_escape \
	    --stats_file ${outprefix}_summary.html \
	    --assembly GRCh37 --fasta GRCh37_chr19.fa \
	    --everything --force_overwrite \
	    | bgzip -c > $outprefix.vcf.gz

While VEP is annotating the variants (it will take a couple of minutes), take a look at the documentation and make yourself familiar with the command line parameters we are using here.

	variant_effect_predictor.pl

When it finishes, take a look at the output files.

The overall results are summarised in a neat HTML file ending with ``_summary.html`` that can be viewed in your browser.

### Exercise:
Work out what command line options are needed to filter out rare coding variants with a MAF<0.01 in central european (CEU) population and run the command.
Show how to filter with ``filter_vep.pl`` and ``bcftools``.





