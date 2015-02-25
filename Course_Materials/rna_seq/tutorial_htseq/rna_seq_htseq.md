% [NGS data analysis course](http://www.ngscourse.org)
% __RNA-Seq data analysis with HTSeq and Bioconductor/edgeR__
% _(updated 2015-02-25)_



<!-- COMMON LINKS HERE -->

[bowtie2]:http://bowtie-bio.sourceforge.net/bowtie2/index.shtml "Bowtie2 home page"
[tophat]:http://ccb.jhu.edu/software/tophat/index.shtml "TopHat home page"

[HTSeq]:http://www-huber.embl.de/users/anders/HTSeq/doc/overview.html "HTSeq home page"
[htseq-count]:http://www-huber.embl.de/users/anders/HTSeq/doc/count.html#count "htseq-count manual"

[edgeR]:http://bioconductor.org/packages/release/bioc/html/edgeR.html "edgeR at Bioconductor"
[Bioconductor]:http://bioconductor.org/ "Bioconductor home page"

[gtf]:http://www.ensembl.org/info/website/upload/gff.html "General Feature Format"
[sam]:http://samtools.sourceforge.net/SAMv1.pdf "SAM/BAM formats"

[igv]:http://www.broadinstitute.org/igv/ "Integrative Genomics Viewer"

Preliminaries
================================================================================

Software used in this practical:
--------------------------------

- [Bowtie2] and [TopHat] alignment tools.
- [htseq-count] script based on [HTSeq] devised to compute the number of counts mapped to each genomic feature.
- [edgeR] a [Bioconductor]

File formats explored:
----------------------

- [SAM/BAM][sam]
- [GTF] : General Feature Format.


Overview
================================================================================

1. We use [tophat] to align RNA-Seq reads to the reference genome.
1. We use [htseq-count] to compute read counts for each gene.
1. We use [IGV] to visualize the alignments and to understand how the counts are computed.
1. We use [edgeR] to perform a differential expression analysis.


Exercise
================================================================================

Create an empty directory to work in the exercise and copy or download the raw data to it.
You will need to copy the __reference genome__ the __GTF annotation file__ and the _paired end_ fastq files of the 3 samples (6 files in total).

<!-- new and clean data directory in the sandbox
    rm -r                                           ../../../../sandbox/rna_seq_htseq/
    cp -r ../../../../ngs_course_materials/rna_seq/ ../../../../sandbox/rna_seq_htseq/
    cp    ../../../../ngs_course_materials/f000_chr21_ref_genome_sequence.fa ../../../../sandbox/rna_seq_htseq/
	cp    ../../../../ngs_course_materials/f005_chr21_genome_annotation.gtf  ../../../../sandbox/rna_seq_htseq/
	
    cp edgeR_example.r ../../../../sandbox/rna_seq_htseq/
	
    cd    ../../../../sandbox/rna_seq_htseq/
-->

    cd data


Map against the reference genome using bowtie2
--------------------------------------------------------------------------------

Fist we need to __build an index__ for bowtie:

    bowtie2-build f000_chr21_ref_genome_sequence.fa f001_bowtie_index


And now we can run the __alignments__ for the __paired end__ files:

	tophat2 -r 300 -o f021_case_tophat_out   f001_bowtie_index   f011_case_read1.fastq f011_case_read2.fastq
	tophat2 -r 300 -o f022_case_tophat_out   f001_bowtie_index   f012_case_read1.fastq f012_case_read2.fastq
	tophat2 -r 300 -o f023_case_tophat_out   f001_bowtie_index   f013_case_read1.fastq f013_case_read2.fastq

	tophat2 -r 300 -o f024_cont_tophat_out   f001_bowtie_index   f014_cont_read1.fastq f014_cont_read2.fastq
	tophat2 -r 300 -o f025_cont_tophat_out   f001_bowtie_index   f015_cont_read1.fastq f015_cont_read2.fastq
	tophat2 -r 300 -o f026_cont_tophat_out   f001_bowtie_index   f016_cont_read1.fastq f016_cont_read2.fastq

__REMARK:__ For __paired end__ samples the left and the right files have to be separated using an __space__.  
If separated by a __coma__, tophat understands the two files contain reads form the same sample sequenced in a __single end__ protocol.



Sort BAM files
--------------------------------------------------------------------------------

Use [SAMtools] to sort the BAM files __by read names__ 

    samtools sort -n f021_case_tophat_out/accepted_hits.bam g031_case_sorted_n
    samtools sort -n f022_case_tophat_out/accepted_hits.bam g032_case_sorted_n
    samtools sort -n f023_case_tophat_out/accepted_hits.bam g033_case_sorted_n

    samtools sort -n f024_cont_tophat_out/accepted_hits.bam g034_cont_sorted_n
    samtools sort -n f025_cont_tophat_out/accepted_hits.bam g035_cont_sorted_n
    samtools sort -n f026_cont_tophat_out/accepted_hits.bam g036_cont_sorted_n

This arrangement mode is required by [htseq-count].

You can see how the reads are sorted by name (ie. by pairs) in the BAM file.

    samtools view g031_case_sorted_n.bam | head 

an find the original reads in the fastq file

    grep -A 1 ENST00000270112_43591_43135_1_0_0_0_2:0:0_1:0:0_10 f011_case_read1.fastq
    grep -A 1 ENST00000270112_43591_43135_1_0_0_0_2:0:0_1:0:0_10 f011_case_read2.fastq

- What does the `-A 1` option does?
- Where the two reads named exactly the same in the original files?


This arrangement of the BAM files by names is needed to use [htseq-count] but
is not suitable to use other tools like [IGV] for instance.
Thus sometimes we will need to use two different BAM files per sample, with a different arrangement each.

Use [SAMtools] to sort the BAM files __by chromosome position__ (standard/default sorting)

    samtools sort f021_case_tophat_out/accepted_hits.bam g031_case_sorted
    samtools sort f022_case_tophat_out/accepted_hits.bam g032_case_sorted
    samtools sort f023_case_tophat_out/accepted_hits.bam g033_case_sorted

    samtools sort f024_cont_tophat_out/accepted_hits.bam g034_cont_sorted
    samtools sort f025_cont_tophat_out/accepted_hits.bam g035_cont_sorted
    samtools sort f026_cont_tophat_out/accepted_hits.bam g036_cont_sorted

And index them (this step is needed by the IGV)

    samtools index g031_case_sorted.bam
    samtools index g032_case_sorted.bam
    samtools index g033_case_sorted.bam

    samtools index g034_cont_sorted.bam
    samtools index g035_cont_sorted.bam
    samtools index g036_cont_sorted.bam


Now we can use [htseq-count] to compute read counts for each sample at __gene_ level

    htseq-count --format=bam --stranded=no --type=gene g031_case_sorted_n.bam f005_chr21_genome_annotation.gtf > h041_case.count
	htseq-count --format=bam --stranded=no --type=gene g032_case_sorted_n.bam f005_chr21_genome_annotation.gtf > h042_case.count
    htseq-count --format=bam --stranded=no --type=gene g033_case_sorted_n.bam f005_chr21_genome_annotation.gtf > h043_case.count

    htseq-count --format=bam --stranded=no --type=gene g034_cont_sorted_n.bam f005_chr21_genome_annotation.gtf > h044_cont.count
    htseq-count --format=bam --stranded=no --type=gene g035_cont_sorted_n.bam f005_chr21_genome_annotation.gtf > h045_cont.count
    htseq-count --format=bam --stranded=no --type=gene g036_cont_sorted_n.bam f005_chr21_genome_annotation.gtf > h046_cont.count

or at __exon__ level (the default setting)

    htseq-count --format=bam --stranded=no --type=exon g031_case_sorted_n.bam f005_chr21_genome_annotation.gtf > g041_case.count
	htseq-count --format=bam --stranded=no --type=exon g032_case_sorted_n.bam f005_chr21_genome_annotation.gtf > g042_case.count
    htseq-count --format=bam --stranded=no --type=exon g033_case_sorted_n.bam f005_chr21_genome_annotation.gtf > g043_case.count

    htseq-count --format=bam --stranded=no --type=exon g034_cont_sorted_n.bam f005_chr21_genome_annotation.gtf > g044_cont.count
    htseq-count --format=bam --stranded=no --type=exon g035_cont_sorted_n.bam f005_chr21_genome_annotation.gtf > g045_cont.count
    htseq-count --format=bam --stranded=no --type=exon g036_cont_sorted_n.bam f005_chr21_genome_annotation.gtf > g046_cont.count


Observe the structure of the "count" files. 

    head h041_case.count 
    tail h041_case.count 

Compare the __gene__ and the __exon__ level computations.

    head h041_case.count
    head g041_case.count 

Use [IGV] to visualize the alignments and explore how the the number of counts is computed.
(remember to load the BAM files sorted by chromosome position in the IGV)

Explore the gene "ENSG00000141959" in sample "1_case" for instance.

- Which is the count number assigned to this gene by `htseq-count` at a _gene_ level?
- And at a _exon_ level?
- Why are there this differences? (expand the GTF track to see the different transcripts and exons)
- How are paired reads accounted for?
- in both cases, _gene_ or _exon_ level, counts are reported at __gene__ level.
  Can you find a way to report counts at _exon_ level? (read the help of `htseq-count`)
  <!-- htseq-count --format=bam --stranded=no --type=exon --idattr=exon_id g031_case_sorted_n.bam f005_chr21_genome_annotation.gtf | head -->


Differential expression using Bioconductor edgeR
--------------------------------------------------------------------------------

Now that the alignments are done and counts are computed we can use The [Bioconductor] library [edgeR] to perform a differential expression analysis.

General steps of the analysis are described in the [edgeR_example.r](edgeR_example.r) example.

<!-- execute R
    R CMD BATCH --no-save --no-restore edgeR_example.r 
-->
