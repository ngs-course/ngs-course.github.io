% [NGS data analysis course](http://ngscourse.github.io/)
% __Variant calling__
% _(updated 23-02-2015)_

<!-- COMMON LINKS HERE -->

[SAMTools]: http://samtools.sourceforge.net/ "samtools"
[Picard]: http://picard.sourceforge.net/ "Picard"
[GATK]: http://www.broadinstitute.org/gatk/ "GATK"

Preliminaries
================================================================================

Software used in this practical:
--------------------------------

- [SAMTools] : SAM Tools provide various utilities for manipulating alignments in the SAM format, including sorting, merging, indexing and generating alignments in a per-position format.
- [Picard] : Picard comprises Java-based command-line utilities that manipulate SAM files, and a Java API (SAM-JDK) for creating new programs that read and write SAM files.
- [GATK] : Genome Analysis Toolkit - A package to analyse next-generation re-sequencing data, primary focused on variant discovery and genotyping.


File formats explored:
----------------------

- [SAM](http://samtools.sourceforge.net/SAMv1.pdf)
- [BAM](http://www.broadinstitute.org/igv/bam)
- VCF Variant Call Format: see [1000 Genomes](http://www.1000genomes.org/wiki/analysis/variant-call-format/vcf-variant-call-format-version-42) and [Wikipedia](http://en.wikipedia.org/wiki/Variant_Call_Format) specifications.



Exercise 2: Variant calling with single-end data
================================================================================

Go to the example 2 folder in your course directory: 

    cd /home/participant/Desktop/Course_Materials/calling/example2


1. Prepare reference genome: generate the fasta file index
--------------------------------------------------------------------------------

This step is no longer needed since we have already done it in [example1](http://ngs-course.github.io/Course_Materials/variant_calling/tutorial/010_example.html)

2. Prepare BAM file
--------------------------------------------------------------------------------

We must sort the BAM file using ``samtools``:

    samtools sort 000-dna_chr21_100_hq_se.bam 001-dna_chr21_100_hq_se_sorted

Index the BAM file:

    samtools index 001-dna_chr21_100_hq_se_sorted.bam


3. Mark duplicates (using Picard)
--------------------------------------------------------------------------------

Mark and remove duplicates:

    java -jar ../picard/MarkDuplicates.jar INPUT=001-dna_chr21_100_hq_se_sorted.bam OUTPUT=002-dna_chr21_100_hq_se_sorted_noDup.bam METRICS_FILE=002-metrics.txt

Index the new BAM file:

    java -jar ../picard/BuildBamIndex.jar INPUT=002-dna_chr21_100_hq_se_sorted_noDup.bam


4. Local realignment around INDELS (using GATK)
--------------------------------------------------------------------------------

There are 2 steps to the realignment process:

Create a target list of intervals which need to be realigned
  
    java -jar ../gatk/GenomeAnalysisTK.jar -T RealignerTargetCreator -R ../genome/f000_chr21_ref_genome_sequence.fa -I 002-dna_chr21_100_hq_se_sorted_noDup.bam -o 003-indelRealigner.intervals

Perform realignment of the target intervals:

    java -jar ../gatk/GenomeAnalysisTK.jar -T IndelRealigner -R ../genome/f000_chr21_ref_genome_sequence.fa -I 002-dna_chr21_100_hq_se_sorted_noDup.bam -targetIntervals 003-indelRealigner.intervals -o 003-dna_chr21_100_hq_se_sorted_noDup_realigned.bam


5. Base quality score recalibration (using GATK)
--------------------------------------------------------------------------------

Two steps:

Analyze patterns of covariation in the sequence dataset

    java -jar ../gatk/GenomeAnalysisTK.jar -T BaseRecalibrator -R ../genome/f000_chr21_ref_genome_sequence.fa -I 003-dna_chr21_100_hq_se_sorted_noDup_realigned.bam -knownSites ../000-dbSNP_chr21.vcf -o 004-recalibration_data.table

Apply the recalibration to your sequence data

    java -jar ../gatk/GenomeAnalysisTK.jar -T PrintReads -R ../genome/f000_chr21_ref_genome_sequence.fa -I 003-dna_chr21_100_hq_se_sorted_noDup_realigned.bam -BQSR 004-recalibration_data.table -o 004-dna_chr21_100_hq_se_sorted_noDup_realigned_recalibrated.bam


6. Variant calling (using GATK - **HaplotypeCaller**)
--------------------------------------------------------------------------------

    java -jar ../gatk/GenomeAnalysisTK.jar -T HaplotypeCaller -R ../genome/f000_chr21_ref_genome_sequence.fa -I 004-dna_chr21_100_hq_se_sorted_noDup_realigned_recalibrated.bam -o 005-dna_chr21_100_he_se.vcf
   
<!--
Example with UnifiedGenotyper

**SNP calling**

    java -jar ../gatk/GenomeAnalysisTK.jar -T UnifiedGenotyper -R ../genome/f000_chr21_ref_genome_sequence.fa -I 004-dna_chr21_100_hq_se_sorted_noDup_realigned_recalibrated.bam -glm SNP -o 005-dna_chr21_100_hq_se_snps.vcf

**INDEL calling**

    java -jar ../gatk/GenomeAnalysisTK.jar -T UnifiedGenotyper -R ../genome/f000_chr21_ref_genome_sequence.fa -I 004-dna_chr21_100_hq_se_sorted_noDup_realigned_recalibrated.bam -glm INDEL -o 005-dna_chr21_100_hq_se_indel.vcf
-->

7. Compare VCF and BAM files
--------------------------------------------------------------------------------

Open IGV and load a the paired-end VCF we have generated in the previous tutorial (``005-dna_chr21_100_he_se.vcf``), its corresponding original BAM file (``001-dna_chr21_100_hq_se_sorted.bam``) and the processed BAM (``004-dna_chr21_100_hq_se_sorted_noDup_realigned_recalibrated.bam``).




