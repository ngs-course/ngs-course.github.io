% [NGS data analysis course](http://ngscourse.github.io/)
% __Variant calling__
% _(updated 21-10-2015)_

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


Exercise 1: Variant calling with paired-end data
================================================================================

Directory used for the tutorials:

<!--    cd /home/participant/Desktop/Course_Materials/calling -->

    cd /home/training/ngs_course/calling


1. Prepare reference genome: generate the fasta file index
--------------------------------------------------------------------------------
Enter in the genome directory:

    cd /home/training/ngs_course/reference_genome

Use ``SAMTools`` to generate the fasta file index:

    samtools faidx f000_chr21_ref_genome_sequence.fa

This creates a file called samtools faidx f000_chr21_ref_genome_sequence.fa.fai, with one record per line for each of the contigs in the FASTA reference file.


Generate the sequence dictionary using ``Picard``:

<!--    java -jar $PICARD CreateSequenceDictionary REFERENCE=f000_chr21_ref_genome_sequence.fa OUTPUT=f000_chr21_ref_genome_sequence.dict -->

    java -jar ~/soft/picard-tools/picard.jar CreateSequenceDictionary \
				REFERENCE=f000_chr21_ref_genome_sequence.fa \
				OUTPUT=f000_chr21_ref_genome_sequence.dict


2. Prepare BAM file
--------------------------------------------------------------------------------

Go to the example1 folder:

    cd /home/training/ngs_course/calling/example_0

<!-- The **read group** information is key for downstream GATK functionality. The GATK will not work without a read group tag. Make sure to enter as much metadata as you know about your data in the read group fields provided. For more information about all the possible fields in the @RG tag, take a look at the SAM specification.

    AddOrReplaceReadGroups.jar I=f000-dna_100_high_pe.bam O=f010-dna_100_high_pe_fixRG.bam RGID=group1 RGLB=lib1 RGPL=illumina RGSM=sample1 RGPU=unit1

-->

We must sort and index the BAM file before processing it with Picard and GATK. To sort the bam file we use ``samtools``

    samtools sort 000-dna_chr21_100_hq_pe.bam 001-dna_chr21_100_hq_pe_sorted

Index the BAM file:

    samtools index 001-dna_chr21_100_hq_pe_sorted.bam


3. Mark duplicates (using Picard)
--------------------------------------------------------------------------------

Run the following **Picard** command to mark duplicates:

    java -jar ~/soft/picard-tools/picard.jar MarkDuplicates \
			INPUT=001-dna_chr21_100_hq_pe_sorted.bam \
			OUTPUT=002-dna_chr21_100_hq_pe_sorted_noDup.bam \
			METRICS_FILE=002-metrics.txt

This creates a sorted BAM file called ``002-dna_chr21_100_hq_pe_sorted_noDup.bam`` with the same content as the input file, except that any duplicate reads are marked as such. It also produces a metrics file called ``metrics.txt``.

**QUESTION:** How many reads are removed as duplicates from the files (hint view the on-screen output from the two commands)?

Run the following **Picard** command to index the new BAM file:

    java -jar ~/soft/picard-tools/picard.jar BuildBamIndex \
			INPUT=002-dna_chr21_100_hq_pe_sorted_noDup.bam

4. Local realignment around INDELS (using GATK)
--------------------------------------------------------------------------------

There are 2 steps to the realignment process:

**First**, create a target list of intervals which need to be realigned

    java -jar ~/soft/GATK/GenomeAnalysisTK.jar \
		-T RealignerTargetCreator \
		-R ../../reference_genome/f000_chr21_ref_genome_sequence.fa \
		-I 002-dna_chr21_100_hq_pe_sorted_noDup.bam \
		-o 003-indelRealigner.intervals

**Second**, perform realignment of the target intervals

    java -jar ~/soft/GATK/GenomeAnalysisTK.jar \
		-T IndelRealigner \
		-R ../../reference_genome/f000_chr21_ref_genome_sequence.fa \
		-I 002-dna_chr21_100_hq_pe_sorted_noDup.bam \
		-targetIntervals 003-indelRealigner.intervals \
		-o 003-dna_chr21_100_hq_pe_sorted_noDup_realigned.bam

This creates a file called ``003-dna_chr21_100_hq_pe_sorted_noDup_realigned.bam`` containing all the original reads, but with better local alignments in the regions that were realigned.


5. Base quality score recalibration (using GATK)
--------------------------------------------------------------------------------

Two steps:

**First**, analyse patterns of covariation in the sequence dataset

    java -jar ~/soft/GATK/GenomeAnalysisTK.jar \
		-T BaseRecalibrator \
		-R ../../reference_genome/f000_chr21_ref_genome_sequence.fa \
		-I 003-dna_chr21_100_hq_pe_sorted_noDup_realigned.bam \
		-knownSites ../000-dbSNP_chr21.vcf \
		-o 004-recalibration_data.table

This creates a GATKReport file called ``004-recalibration_data.table`` containing several tables. These tables contain the covariation data that will be used in a later step to recalibrate the base qualities of your sequence data.

It is important that you provide the program with a set of **known sites**, otherwise it will refuse to run. The known sites are used to build the covariation model and estimate empirical base qualities. For details on what to do if there are no known sites available for your organism of study, please see the online GATK documentation.

**Second**, apply the recalibration to your sequence data

    java -jar ~/soft/GATK/GenomeAnalysisTK.jar \
		-T PrintReads \
		-R ../../reference_genome/f000_chr21_ref_genome_sequence.fa \
		-I 003-dna_chr21_100_hq_pe_sorted_noDup_realigned.bam \
		-BQSR 004-recalibration_data.table \
		-o 004-dna_chr21_100_hq_pe_sorted_noDup_realigned_recalibrated.bam

This creates a file called ``004-dna_chr21_100_hq_pe_sorted_noDup_realigned_recalibrated.bam`` containing all the original reads, but now with exquisitely accurate base substitution, insertion and deletion quality scores. By default, the original quality scores are discarded in order to keep the file size down. However, you have the option to retain them by adding the flag ``–emit_original_quals`` to the ``PrintReads`` command, in which case the original qualities will also be written in the file, tagged OQ.


6. Variant calling (using GATK - **HaplotypeCaller**)
--------------------------------------------------------------------------------

SNPs and INDELS are called using a single instruction.

    java -jar ~/soft/GATK/GenomeAnalysisTK.jar \
		-T HaplotypeCaller \
		-R ../../reference_genome/f000_chr21_ref_genome_sequence.fa \
		-I 004-dna_chr21_100_hq_pe_sorted_noDup_realigned_recalibrated.bam \
		-o 005-dna_chr21_100_he_pe.vcf

<!--
Code using UnifiedGenotyper
		
SNPs and INDELS are called using separate instructions.

**SNP calling**

    java -jar ../gatk/GenomeAnalysisTK.jar -T UnifiedGenotyper -R ../genome/f000_chr21_ref_genome_sequence.fa -I 004-dna_chr21_100_hq_pe_sorted_noDup_realigned_recalibrated.bam -glm SNP -o 005-dna_chr21_100_he_pe_snps.vcf

**INDEL calling**

    java -jar ../gatk/GenomeAnalysisTK.jar -T UnifiedGenotyper -R ../genome/f000_chr21_ref_genome_sequence.fa -I 004-dna_chr21_100_hq_pe_sorted_noDup_realigned_recalibrated.bam -glm INDEL -o 005-dna_chr21_100_hq_pe_indel.vcf
-->

7. Introduce filters in the VCF file
--------------------------------------------------------------------------------

Once we have called the variants, we might be interested in filtering out some according to our confidence in them. Some of the most basic filters consist of identifying variants with low calling quality or a low number of reads supporting the variant.
There are many programs that can be used to filter VCFs. Here we are going to use bcftools from Samtools to preform a basic filtering.

    bcftools filter -s LowQual -e 'QUAL<20 | DP<3' 005-dna_chr21_100_he_pe.vcf > 006-dna_chr21_100_he_pe_filtered.vcf

Let's see how many variants fail to pass our filters:

    grep LowQual 006-dna_chr21_100_he_pe_filtered.vcf | wc -l

And how many passed:

    grep PASS 006-dna_chr21_100_he_pe_filtered.vcf | wc -l

<!-- Example: filter SNPs with low confidence calling (QD < 12.0) and flag them as "LowConf".

    java -jar $GATK -T VariantFiltration -R ../genome/f000_chr21_ref_genome_sequence.fa -V 005-dna_chr21_100_he_pe.vcf --filterExpression "QD < 12.0" --filterName "LowConf" -o 006-dna_chr21_100_he_pe_filtered.vcf

The command ``--filterExpression`` will read the INFO field and check whether variants satisfy the requirement. If a variant does not satisfy your filter expression, the field FILTER will be filled with the indicated ``--filterName``. These commands can be called several times indicating different filtering expression (i.e: --filterName One --filterExpression "X < 1" --filterName Two --filterExpression "X > 2").

**QUESTION:** How many "LowConf" variants have we obtained?

    grep LowConf 006-dna_chr21_100_he_pe_filtered.vcf | wc -l

-->


8. Visualization
--------------------------------------------------------------------------------

- Exercise 1:
  1. Open the BAMs before and after INDEL Realignment (``002-dna_chr21_100_hq_pe_sorted_noDup.bam`` and ``003-dna_chr21_100_hq_pe_sorted_noDup_realigned.bam``)
  2. Select a region that has been selected for realignment from ``003-indelRealigner.intervals`` and locate IGV in this region
  3. Observe the changes applied by GATK after INDEL realignment

