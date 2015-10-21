% [NGS data analysis course](http://ngscourse.github.io/)
% __De novo mutations__
% _(updated 21-10-2015)_

<!-- COMMON LINKS HERE -->

[DeNovoGear]: http://denovogear.sourceforge.net/ "DeNovoGear"


Preliminaries
================================================================================

Software used in this practical:
--------------------------------

- [DeNovoGear] : A program to detect de novo variants using next-generation sequencing data.


File formats explored:
----------------------

- VCF Variant Call Format: see [1000 Genomes](http://www.1000genomes.org/wiki/analysis/variant-call-format/vcf-variant-call-format-version-42) and [Wikipedia](http://en.wikipedia.org/wiki/Variant_Call_Format) specifications.


Exercise 4: Identification of _de novo_ mutations
================================================================================

1. Discovery of _de novo_ mutations
--------------------------------------------------------------------------------

When working with families we might be interested in identifying variants that appeared for the first time in one family member as a result of a mutation in a germ cell (egg or sperm) of one of the parents or in the fertilised egg itself.

For this analysis we need to specify the family structure in a pedigree. The requested pedigree must be in [PED format] (http://pngu.mgh.harvard.edu/~purcell/plink/data.shtml#ped).

    less trio.ped

Run DeNovoGear:

	~/soft/denovogear/bin/denovogear dnm auto \
		--vcf trio.vcf \
		--ped trio.ped \
		--output_vcf trio_denovo.vcf

2. Exercise
--------------------------------------------------------------------------------

Open the BAM files corresponding to the 3 related individuals in IGV.
Include also the original VCF and the VCF containing the _de novo_ mutations.

