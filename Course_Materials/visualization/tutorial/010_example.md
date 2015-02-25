% [NGS data analysis course](http://ngscourse.github.io/)
% __Visualization of mapped reads__
% _(updated 23-02-2015)_

<!-- COMMON LINKS HERE -->

[IGV]: http://www.broadinstitute.org/igv/home "IGV"
[Samtools]: http://samtools.sourceforge.net/ "samtools"


Preliminaries
================================================================================


Software used in this practical:
--------------------------------

- [IGV] : The Integrative Genomics Viewer is a program for reading several types of indexed database information, including mapped reads and variant calls, and displaying them on a reference genome. It is invaluable as a tool for viewing and interpreting the "raw data" of many NGS data analysis pipelines.
- [samtools] : SAM Tools provide various utilities for manipulating alignments in the SAM format, including sorting, merging, indexing and generating alignments in a per-position format.


File formats explored:
----------------------

- [SAM](http://samtools.sourceforge.net/SAMv1.pdf)
- [BAM](http://www.broadinstitute.org/igv/bam)


Exercise 1: Visualising sequencing data
================================================================================

In the following **folder** you will find mapped sequencing data from a CEU trio (father, mother and child) from the 1000 Genomes Project:

    cd /home/participant/Desktop/Course_Materials/visualization/example_1

These datasets contain reads only for the [GABBR1](http://www.ensembl.org/Homo_sapiens/Gene/Summary?db=core;g=ENSG00000204681;r=6:29523406-29601753) gene.

Creating indexed files
--------------------------------------------------------------------------------

Use ``samtools`` to index the bam files:

    samtools index NA12878_child.bam
    samtools index NA12891_dad.bam
    samtools index NA12892_mom.bam


Run IGV
--------------------------------------------------------------------------------

You can run this command from the terminal:
    igv

or you can also use the link in your Desktop.


Download a reference genome
--------------------------------------------------------------------------------

Run just in the case you do not have downloaded Human hg19 genome before:

- Go to ``Genomes`` --> ``Load Genome From Server...``
Select **Human hg19**

    
Loading and browsing files
--------------------------------------------------------------------------------

- Go to ``File`` --> ``Load from file...``
Select NA12878_child.bam, NA12891_dad.bam and NA12892_mom.bam

**Steps:**

1. Enter the name of our gene (_**GABBR1**_) in the search box and hit ``Go``.
2. Zoom in until you find some SNPs - they might be in exons or introns.
3. Identify at least one example of a short insertion variant and deletion around exon 4.
4. Load and look at the SNP track: ``File`` --> ``Load from server`` --> ``Annotations`` --> ``Variants and Repeats`` --> ``dbSNP``


