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


Exercise 2: Visualising RNA-Seq data
================================================================================

In the following **folder** you will find mapped RNA-Seq data from Illumina’s Human BodyMap 2.0 project. This two datasets in particular contain reads from brain and heart tissues.

    cd /home/participant/Desktop/Course_Materials/visualization/example_2


Steps
--------------------------------------------------------------------------------

##### 1. Use ``samtools`` to index the bam file:  

<input class="spoilerbutton" type="button" value="Show answer" onclick="this.value=this.value=='Show answer'?'Hide answer':'Show answer';">
<div class="spoiler"><div>
    samtools index heart.bodyMap.bam
    samtools index brain.bodyMap.bam
</div></div>

##### 2. Open IGV and load the bam file heart.bodyMap.bam.  

<input class="spoilerbutton" type="button" value="Show answer" onclick="this.value=this.value=='Show answer'?'Hide answer':'Show answer';">
<div class="spoiler"><div>
    igv
- Go to ``File`` --> ``Load from file...``
Select heart.bodyMap.bam and brain.bodyMap.bam
</div></div>

##### 3. Navigate a little and get familiar with the software.  
Reads are only on **chromosome 12 from 98Mbp to 100Mbp**.
Remember that 1Mbp = 1000000bp.

So, reads will be around ``12:98000000-100000000``.


##### 4. Look for ***IKBIP*** gene and try to answer the following questions:

 - How many different isoforms does the gene have? Which exon combinations form every isoform?
 **TIP:** Right-click on the Features panel --> Select ``Expanded``
<input class="spoilerbutton" type="button" value="Show answer" onclick="this.value=this.value=='Show answer'?'Hide answer':'Show answer';">
<div class="spoiler"><div>
The gene __IKBIP__ contains 4 exons that generate **3 different isoforms** (note that the gene is located in the reverse strand):<br>- Isoform 1: exon 1 + exon 4<br>- Isoform 2: exon 1 + exon 2 + exon 4<br>- Isoform 3: exon 1 + exon 2 + exon 3
</div></div>

 - Is __IKBIP__ gene expressed in heart and brain tissues? 

 - Create a **Sashimi plot** of the gene.
 **TIP:** center the gene IKBIP on the Track panel, right-click on the Panel, select ``Sashimi Plot`` and tick both tissues.  
 What kind of information can you obtain from this plot?
 <input class="spoilerbutton" type="button" value="Show answer" onclick="this.value=this.value=='Show answer'?'Hide answer':'Show answer';">
<div class="spoiler"><div>
The Sashimi Plot shows raw RNA-Seq densities along exons and junctions. Lines indicate junctions and the number corresponds to the number of reads that support this junction.
</div></div>

 - Load SNP data from **dbSNP 1.3.7** and go to position **chr12:99019058**.
 Is the heart sample homozygous or heterozygous for this position?
 Would you trust this variant?
 Is this variant a known SNP?
<input class="spoilerbutton" type="button" value="Show answer" onclick="this.value=this.value=='Show answer'?'Hide answer':'Show answer';">
<div class="spoiler"><div>
`-` Load and look at the SNP track:
  ``File`` –> ``Load from server`` –> ``Annotations`` –> ``Variants and Repeats`` –> ``dbSNP 1.3.7``<br>- This individual is heterozygous for this position with alleles A/G.<br> - Yes. There are 17 high quality reads (47%) supporting this variant and the base quality is, in general, high.<br> - Yes, rs7310804.
</div></div>

-----
