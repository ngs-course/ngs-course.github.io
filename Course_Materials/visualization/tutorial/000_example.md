% [NGS data analysis course](http://ngscourse.github.io/)
% __Visualization of mapped reads__
% _(updated 22-02-2015)_

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


Guided exercise: IGV introduction
================================================================================

Directory used for the tutorials:

<!--
mkdir -p /home/participant/cambridge_mda15/
cp -r /home/participant/Desktop/Open_Share/visualization /home/participant/cambridge_mda15/
cd /home/participant/cambridge_mda15/visualization
-->

    cd /home/participant/Desktop/Course_Materials/visualization

Enter in the example folder:

    cd example_0

This BAM file contains reads only for **chromosome 11**.

Creating indexed files
--------------------------------------------------------------------------------

Use ``samtools`` to index the bam files:

    samtools index igv1.bam


Run IGV
--------------------------------------------------------------------------------

You can run this command from the terminal:
    igv

or you can also use the link in your Desktop.


Download a reference genome
--------------------------------------------------------------------------------

By default, IGV loads Human hg18 and hg19 assemblies. Bear in mind that we must work with the **same assembly used to mapped our reads**, in this case Human hg19.  
Genome assemblies for several species can be downloaded using IGV. To explore the list of available genomes:

- Go to ``Genomes`` --> ``Load Genome From Server...``

In this practical we are using **Human hg19**


Loading and browsing files
--------------------------------------------------------------------------------

- Go to ``File`` --> ``Load from file...``
Select ``igv1.bam``

**Steps:**

1. Go to the location box and insert ''chr11:996096-1036047'' in the search box and hit ``Go``.
2. Move across the alignment
3. Zoom in
4. Grey boxes are reads:
      - point to the left --> map reverse strand
      - point to the right --> map forward strand
5. At the top --> histogram of coverage
6. Zoom further
      - Colour representation of the sequence
      - Zoom in --> Bases are shown
      - Amminoacids corresponding to each base
      - See all possible translation reading frames
7. Change read information panels
      
What we want to do with IGV?
--------------------------------------------------------------------------------
1. Examine coverage
      - High/low coverage
      - No coverage
2. Visualise alternative splicing
      - RNA alignment against DNA, not cDNA
3. Look for base changes -- > SNPs
      - Complete grey reads --> no mismatches
      - Coloured bases --> Change
	    - Coverage track os only coloured if >20% of the reads support the variant
      - Reads are shadowed according to quality
	    - Darker --> good quality
	    - Lighter --> bad quality
      - Bases are also shadowed according to quality
	    - Darker --> good quality
	    - Lighter --> bad quality
      - Inspecting a SNP (``chr11:1,018,335-1,018,412``)
	    - Look at the coverage bar --> percentage and counts
	    - Sort alignment by base
      - Inspecting a homozygous variant (``chr11:1,019,336-1,019,413``)
            - All reads support the variant but 1
            - The reference read quality is 0
4. Load SNP data
      - File > Load from server > Annotations > Variation and repeats > dbSNP 1.3.7




