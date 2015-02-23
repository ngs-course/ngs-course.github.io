---
title: NGS Data Analysis Course
subtitle: Quality Control and Data Preprocessing
author: Marta Bleda, Javier Lopez, Ignacio Medina, David Montaner
date: 2015-02-23
footer-left: Quality Control and Data Preprocessing
footer-right: NGS Data Analysis Course
url: 'http://www.ngscourse.org'
...


FastQ Format
================================================================================

- Standard Format for NGS data
- Conversion can be done from _sff_, _fasta + qual_, ... 
- Extension of the Fasta format
- Text-based formats (easy to use!)
- If not compressed, it can be huge

\  

<http://en.wikipedia.org/wiki/FASTQ_format>


Quality measurements
================================================================================

Base-calling __error probabilities__ are reported by sequencers.

Usually in __Phred__ (quality) score.

Usually coded by ASCII characters


Phred score
------------

$$Q = -10 log_{10} P$$

$$P = 10^{\frac{-Q}{10}}$$

\  

[http://en.wikipedia.org/wiki/Phred_quality_score](http://en.wikipedia.org/wiki/Phred_quality_score#Definition)




NGS Data Preprocessing Steps
================================================================================

- File parsing: convert to __fastq__ format form __sff__, __fasta__ + __qual__ ...
- Split [multiplex](http://www.illumina.com/technology/multiplexing_sequencing_assay.ilmn "Multiplex Sequencing Assay") samples.

- Quality Control of the raw data.

- Filtering and trimming reads by quality.
- Adapter trimming

- Quality Control of the trimmed and filtered reads



Software
================================================================================


- __FastQC__:
    - quality control
    - some filtering ...

[www.bioinformatics.babraham.ac.uk/projects/fastqc](http://www.bioinformatics.babraham.ac.uk/projects/fastqc)

\ 

- __Cutadapt__: 
    - adapter trimming 
	- filter reads by length (short, long)
	- filter reads by quality

<http://code.google.com/p/cutadapt>



<!-- FastQC Images -->

Per Base Sequence Quality
================================================================================
![](images/per_base_quality)

Per Sequence Quality
================================================================================
![](images/per_sequence_quality)

Per Base Sequence Content
================================================================================
![](images/per_base_sequence_content)

Per Base GC Content
================================================================================
![](images/per_base_gc_content)

Per Sequence Nucleotide Content
================================================================================
![](images/per_sequence_gc_content)

Per Base N Content
===============================================================================
![](images/per_base_n_content)

Sequence Length Distribution
===============================================================================
![](images/sequence_length_distribution)

Duplicate Sequences Distribution
================================================================================
![](images/duplication_levels)

Overrepresenteda Kmers
================================================================================
![](images/kmer_profiles)



More FastQ examples and documentation
================================================================================

... may be found at [FastQ home page](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/)

- Example Reports



Sequencing process: PCR primers 
================================================================================

![](images/pcr_adaptors.png)

Sequencing process: PCR primers 
================================================================================

![](images/illumina_cluster_generation.png)

NGS adaptors and Cutadapt
================================================================================
![](images/adaptors.png)
