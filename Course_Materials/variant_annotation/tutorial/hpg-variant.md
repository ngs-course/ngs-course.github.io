% [NGS data analysis course](http://ngscourse.github.io/)
% __Variant annotation__
% _(updated 29-09-2014)_

<!-- COMMON LINKS HERE -->

[HPG-Variant]: http://wiki.opencb.org/projects/hpg/doku.php?id=variant:overview "HPG Variant"


Preliminaries
================================================================================


Software used in this practical:
--------------------------------

- [HPG-Variant][HPG-Variant] : a complete suite of tools to work with genomic variation data, from VCF tools to variant profiling or genomic statistics.


File formats explored:
----------------------

- VCF Variant Call Format

Variant annotation with HPG-Variant
================================================================================

Copy the necessary data in your working directory:

    mkdir -p /home/participant/cambridge_mda/
    cp -r /home/participant/Desktop/Open_Share/annotation /home/participant/cambridge_mda/
    cd /home/participant/cambridge_mda/annotation/hpg-variant

Exercise 1: Working with HPG-Variant
================================================================================

Getting the effect of variants
--------------------------------------------------------------------------------

To run the variant effect annotation tool you need the hpg-var-effect binary file. You only have to execute this command line to fetch annotations:

    ./hpg-var-effect -v examples/CHB.exon.2010_03.sites.vcf --outdir hpg-variant_results

If you don't set the outdir option, the default output folder is /tmp/variant/ .

Inside the output folder, you will get a collection of .txt files. Each of them contains a list of variation effects classified by type, such as non-synonymous codon, a DNAseI hypersensitive site, and so on.

There is also an all_variants.txt file which stores all the effects of all types. The summary.txt file shows the number of times a specific effect has been retrieved.

For more information about the contents of the output files, please read the Result report section.

VCF tools
--------------------------------------------------------------------------------

#### Splitting

When analyzing a VCF file, you may be interested only in a part of it. If you want to split it, for example by chromosome, you must run:

    ./hpg-var-vcf split -v examples/CEU.exon.2010_03.genotypes.vcf --criterion chromosome --outdir filter

As a result, the /tmp/variant/ folder will contain a list of files named chromosome_N_CEU.exon.2010_03.genotypes.vcf, each of them containing the variants in chromosome N.

#### Filtering

Maybe part of the variants in a dataset do not meet your requirements for a future analysis, so you want to remove them from the dataset. For example, if you want to filter by coverage (the sum in all samples), you should run:

    ./hpg-var-vcf filter -v examples/CEU.exon.2010_03.genotypes.vcf --coverage 9000 --save-rejected --outdir filter_coverage

This way, the file CEU.exon.2010_03.genotypes.vcf.filtered will contain all variants with DP over 9000!! The save-rejected option saves the variants with less DP in the file /tmp/variant/CEU.exon.2010_03.genotypes.vcf.rejected. You can omit it if you prefer to save space.

#### Statistics

If you want to know more about the structure and fitness of your dataset, you can retrieve some statistics for variants, samples and the whole file.

By default, variants and file statistics are retrieved. Just run:

    ./hpg-var-vcf stats -v examples/CEU.exon.2010_03.genotypes.vcf --outdir stats

As a result, the folder will contain a pair of files named summary-stats and stats-variants.

If you prefer to retrieve statistics per sample, run:

    ./hpg-var-vcf stats -v examples/CEU.exon.2010_03.genotypes.vcf --samples --outdir stats_by_sample

In this case, the output file will be named stats-samples.

GWAS
--------------------------------------------------------------------------------

To run genomic-wide association studies, you need a pair of VCF and PED related files. The former contains the list of variants and the genotypes of the samples, whereas the latter contains familial information, as well as the sex and phenotypes of those samples.

You can run family-based tests using the TDT tool:

    ./hpg-var-gwas tdt -v examples/4Kvariants_147samples.vcf -p examples/4Kvariants_147samples.ped --outdir tdt

As a result, you will find a hpg-variant.tdt file containing the number of times the reference allel is transmitted or not, as well as some statistical values.

There is also the possibility of conducting population association studies using chi-square of Fisher's exact test:

    ./hpg-var-gwas assoc --chisq -v examples/4Kvariants_147samples.vcf -p examples/4Kvariants_147samples.ped --outdir assoc-chisq
    ./hpg-var-gwas assoc --fisher -v examples/4Kvariants_147samples.vcf -p examples/4Kvariants_147samples.ped --outdir assoc-fisher

The results of these tasks are a hpg-variant.chisq and a hpg-variant.fisher files, containing the number of times each allele appears in affected and unaffected groups, the related frequencies, and some more statistical values.


