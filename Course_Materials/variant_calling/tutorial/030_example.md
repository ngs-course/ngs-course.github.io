% [NGS data analysis course](http://ngscourse.github.io/)
% __Variant calling__
% _(updated 21-10-2015)_

<!-- COMMON LINKS HERE -->

[SAMTools]: http://samtools.sourceforge.net/ "samtools"
[Picard]: http://picard.sourceforge.net/ "Picard"
[MuTect]: http://www.broadinstitute.org/cancer/cga/mutect_download "MuTect"

Preliminaries
================================================================================

Software used in this practical:
--------------------------------

- [SAMTools] : SAM Tools provide various utilities for manipulating alignments in the SAM format, including sorting, merging, indexing and generating alignments in a per-position format.
- [Picard] : Picard comprises Java-based command-line utilities that manipulate SAM files, and a Java API (SAM-JDK) for creating new programs that read and write SAM files.
- [MuTect] : method developed at the Broad Institute for the reliable and accurate identification of somatic point mutations in next generation sequencing data of cancer genomes.


File formats explored:
----------------------

- [SAM](http://samtools.sourceforge.net/SAMv1.pdf)
- [BAM](http://www.broadinstitute.org/igv/bam)
- VCF Variant Call Format: see [1000 Genomes](http://www.1000genomes.org/wiki/analysis/variant-call-format/vcf-variant-call-format-version-42) and [Wikipedia](http://en.wikipedia.org/wiki/Variant_Call_Format) specifications.

Exercise 3: Somatic calling
================================================================================

1. Prepare reference genome
--------------------------------------------------------------------------------
Use ``SAMTools`` to generate the fasta file index:

    samtools faidx TP53.hg19.fa

Generate the sequence dictionary using ``Picard``:

    java -jar ~/soft/picard-tools/picard.jar CreateSequenceDictionary \
				REFERENCE=TP53.hg19.fa \
				OUTPUT=TP53.hg19.dict

2. Prepare BAM file
--------------------------------------------------------------------------------

Go to the somatic calling example folder:

    cd /home/training/ngs_course/calling/example_3/somatic_calling

Sort:

    samtools sort 000-normal.bam 001-normal_sorted
    samtools sort 000-tumor.bam 001-tumor_sorted

Index the BAM file:

    samtools index 001-normal_sorted.bam
    samtools index 001-tumor_sorted.bam


2. Somatic calling
--------------------------------------------------------------------------------

For brevity, we are not including BAM preprocessing steps. However, in real analysis it is recommended to include them.

    ~/soft/java7/bin/java -jar ~/soft/muTect/muTect-1.1.5.jar \
		--analysis_type MuTect \
		--reference_sequence TP53.hg19.fa \
		--dbsnp 000-dbsnp_132_b37.leftAligned.vcf.gz \
		--cosmic 000-b37_cosmic_v54_120711.vcf.gz \
		--input_file:normal 001-normal_sorted.bam \
		--input_file:tumor 001-tumor_sorted.bam \
		--out 002-call_stats.out \
		--coverage_file 002-coverage.wig \
		--vcf 003-somatic_variants.vcf

Extract high quality somatic variants.

	grep -v REJECT 003-somatic_variants.vcf
