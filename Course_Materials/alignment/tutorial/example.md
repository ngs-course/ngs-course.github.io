% [NGS data analysis course](http://ngs-course.github.io/)
% __DNA and RNA-seq NGS alignment__
% _(updated 22-02-2015)_

<!-- COMMON LINKS HERE -->

[BWA]: http://bio-bwa.sourceforge.net/ "BWA"
[HPG Aligner]: https://github.com/opencb/hpg-aligner/wiki/ "HPG Aligner"
[Bowtie2]: http://bowtie-bio.sourceforge.net/bowtie2/index.shtml "Bowtie2"
[TopHat2]: http://ccb.jhu.edu/software/tophat/index.shtml "TopHat2"
[STAR]: https://code.google.com/p/rna-star/ "STAR"
[MapSplice2]: http://www.netlab.uky.edu/p/bioinfo/MapSplice2 "MapSplice2"
[SAMTools]: http://www.htslib.org/ "SAMtools"
[dwgsim]: http://sourceforge.net/apps/mediawiki/dnaa/index.php?title=Whole_Genome_Simulation "dwgsim"
[BEERS]: http://www.cbil.upenn.edu/BEERS/ "BEERS"
[Ensembl]: http://www.ensembl.org/index.html "Ensembl"

# Preliminaries

In this hands-on will learn how to align DNA and RNA-seq data with most widely used software today. Building a whole genome index requires a lot of RAM memory and almost one hour in a typical workstation, for this reason **in this tutorial we will work with chromosome 21** to speed up the exercises. The same steps would be done for a whole genome alignment. Two different datasets, high and low quality have been simulated for DNA, high quality contains 0.1% of mutations and low quality contains 1%. For RNA-seq a 100bp and 150bp datasets have been simulated.


### NGS aligners used:

- [BWA] : BWA is a software package for mapping **DNA** low-divergent sequences against a large reference genome, such as the human genome. The new project repository is available at [GitHub BWA](https://github.com/lh3/bwa)
- [HPG Aligner] : HPG Aligner is a new NGS aligner for mapping both **DNA Genomic** and **RNA-seq** data against a large reference genome. It's has been designed for having a high sensitivity and performance.
- [Bowtie2] : *Bowtie 2* is an ultrafast and memory-efficient tool for aligning **DNA** sequencing reads to long reference sequences.
- [TopHat2] : *TopHat* is a fast splice junction mapper for RNA-Seq reads. It aligns **RNA-Seq** reads to mammalian-sized genomes using the ultra high-throughput short read aligner Bowtie, and then analyzes the mapping results to identify splice junctions between exons.
- [STAR] : *STAR* aligns **RNA-seq** reads to a reference genome using uncompressed suffix arrays.

### Other software used in this hands-on:
- [SAMTools] : SAM Tools **provide various utilities** for manipulating alignments in the SAM format, including sorting, merging, indexing and generating alignments in a per-position format.
- [dwgsim] (optional): dwgsim can perform whole **genome simulation**.
- [BEERS] (optional): BEERS is a **simulation engine** for generating **RNA-Seq** data.

### File formats explored:

- [SAM](http://samtools.sourceforge.net/SAMv1.pdf): Sequence alignment format, plain text.
- [BAM](http://www.broadinstitute.org/igv/bam): Binary and compressed version of SAM


### Data used in this practical

Create a ```data``` folder in your **working directory** and download the **reference genome sequence** to be used (human chromosome 21) and *simulated datasets* from **Dropbox** [data](https://www.dropbox.com/sh/4qkqch7gyt888h7/AABD_i9ShwryfAqGeJ0yqqF3a).
For the rest of this tutorial the **working directory** will be **cambridge_mda15** and all the **paths** will be relative to that working directory:
    
    cd cambridge_mda15
    mkdir data

##### Download reference genome from [Ensembl]

Working with NGS data requires a high-end workstations and time for building the reference genome indexes and alignment. During this tutorial we will work only with chromosome 21 to speed up the runtimes. You can download it from **Dropbox** [data](https://www.dropbox.com/sh/4qkqch7gyt888h7/AABD_i9ShwryfAqGeJ0yqqF3a) or from the *Download* link at the top of [Ensembl] website and then to *Download data via FTP*, you get it in only one step by going to:

[Ensembl GRCh37 http://grch37.ensembl.org/info/data/ftp/index.html](http://grch37.ensembl.org/info/data/ftp/index.html)

[Ensembl GRCh38 http://www.ensembl.org/info/data/ftp/index.html](http://www.ensembl.org/info/data/ftp/index.html)

You should see a species table with a Human (*Homo sapiens*) row and a *DNA (FASTA)* column or click at [ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/](ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/), download the chromosome 21 file (*Homo_sapiens.GRCh37.75.dna.chromosome.21.fa.gz*) and move it from your browser download folder to your ```data``` folder:

    mv Homo_sapiens.GRCh37.75.dna.chromosome.21.fa.gz path_to_local_data

**NOTE:** For working with the whole reference genome the file to be downloaded is *Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz*


##### Copy simulated datasets

For this hands-on we are going to use small DNA and RNA-seq datasets simulated from chromosome 21. Data has been already simulated using _dwgsim_ software from SAMtools for DNA and _BEERS_ for RNA-seq. You can copy from the shared resources from **Dropbox** [data](https://www.dropbox.com/sh/4qkqch7gyt888h7/AABD_i9ShwryfAqGeJ0yqqF3a) into your ``data`` directory for this practical session. Preparing the data directory:

    cp path_to_course_materials/alignment/* your_local_data/

Notice that the name of the folders and files describe the dataset, ie. ```dna_chr21_100_hq``` stands for: _DNA_ type of data from _chromosome 21_ with _100_nt read lengths of _high_ quality. Where _hq_ quality means 0.1% mutations and _lq_ quality 1% mutations. Take a few minutes to understand the different files.

**NOTE:** If you want to learn how to simulate DNA and RNA-seq for other conditions go down to the end of this tutorial.

##### Real datasets

For those with access to high-end nodes clusters you can index and simulated whole genome datasets or download real datasets from this sources:
- [1000genomes project](http://www.1000genomes.org/)
- [European Nucleotide Archive (ENA)](https://www.ebi.ac.uk/ena/)
- [Sequence Read Archive (SRA)](http://www.ncbi.nlm.nih.gov/sra)


### Installing SAMtools (Optional, already installed)

Check that it is not installed by executing

    samtools

A list of commands should be printed. If not then proceed with the installation.

Download [SAMtools] from *SF Download Page* link and move to the working directory, then uncompress it.

    mv samtools-1.2.tar.bz2 working_directory
    cd working_directory
    tar -jxvf samtools-1.2.tar.bz2 
    cd samtools-1.2
    make

Check that is correct by executing it with no arguments, the different commands available should be printed. You can also copy it to your ```bin``` folder in your home directory, if bin folder exist, to make it available to the PATH:

    samtools
    cp samtools ~/bin


# Exercise 1: NGS Genomic DNA aligment

In this exercise we'll learn how to download, install, build the reference genome index and align in single-end and paired-end mode with the two most widely DNA aligners: *BWA* and *Bowtie2*. But first, create an ```aligners``` folder to store the software, and an ```alignments``` folder to store the results, create those folders in your *working directory* next to ```data```, you can create both folders by executing:

    mkdir aligners
    mkdir alignments

Now go to ```aligners``` and  ```alignments``` folders and create subfolders for *bwa* and *bowtie* to store the indexes and alignments results:

    cd aligners
    mkdir bwa hpg-aligner bowtie

and

    cd alignments
    mkdir bwa hpg-aligner bowtie
    
**NOTE:** Now your working directory must contain 3 folders: data (with the reference genome of chrom. 21 and simulated datasets), aligners and alignments. Your working directory should be similar to this (notice that aligners have not been downloaded):

```
.
├── aligners
│   ├── bowtie
│   ├── bwa
│   ├── hpg-aligner
├── alignments
│   ├── bowtie
│   ├── bwa
│   ├── hpg-aligner
├── data
│   ├── dna_chr21_100_hq_read1.fastq
│   ├── dna_chr21_100_hq_read2.fastq
│   ├── dna_chr21_100_lq_read1.fastq
│   ├── dna_chr21_100_lq_read2.fastq
│   ├── Homo_sapiens_cDNAs_chr21.fa
│   ├── Homo_sapiens.GRCh37.75.dna.chromosome.21.fa
│   ├── rna_chr21_100_hq_read1.fastq
│   └── rna_chr21_100_hq_read2.fastq
│   ├── rna_chr21_150_lq_read1.fastq
│   └── rna_chr21_150_lq_read2.fastq


```


### BWA
[BWA] is probably the most used aligner for DNA. AS the documentation states it consists of three different algorithms: *BWA*, *BWA-SW* and *BWA-MEM*. The first algorithm, which is the oldest, is designed for Illumina sequence reads up to 100bp, while the rest two for longer sequences. BWA-MEM and BWA-SW share similar features such as long-read support and split alignment, but BWA-MEM, which is the latest, is generally recommended for high-quality queries as it is faster and more accurate. BWA-MEM also has better performance than BWA for 70-100bp Illumina reads.

All these three algorithms come in the same binary so only one download and installation is needed.

##### Download and install (Optional, already installed)

First check that bwa is not currently installed by executing:

    bwa

A list of commands will be printed if already installed. If not you can continue with the installation.

You can click on ```SF download page``` link in the [BWA] page or click directly to:

[http://sourceforge.net/projects/bio-bwa/files](http://sourceforge.net/projects/bio-bwa/files)

Click in the last version of BWA and wait for a few seconds, as the time of this tutorial last version is **bwa-0.7.10.tar.bz2**, the download will start. When downloaded go to your browser download folder and move it to aligners folder, uncompress it and compile it:

    mv bwa-0.7.12.tar.gz working_directory/aligners/bwa
    tar -jxvf bwa-0.7.12.tar.gz
    cd bwa-0.7.12
    make
    cp bwa ~/bin

You can check that everything is allright by executing:

    bwa

Some information about the software and commands should be listed.


##### Build the index

Create a folder inside ```aligners/bwa``` folder called ```index``` to store the BWA index and copy the reference genome into it:
    
    mkdir index
    cp  data/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa  aligners/bwa/index/   (this path can be different!)
    
Now you can create the index by executing:

    bwa index aligners/bwa/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa

Some files will be created in the ```index``` folder, those files constitute the index that BWA uses.

**NOTE:** The index must created only once, it will be used for all the different alignments with BWA.


##### Aligning with new BWA-MEM in both single-end (SE) and paired-end (PE) modes

BWA-MEM is the recommended algorithm to use now. You can check the options by executing:

    bwa mem

To align **SE** with BWA-MEM execute:

    bwa mem -t 4 -R "@RG\tID:foo\tSM:bar\tPL:Illumina\tPU:unit1\tLB:lib1" aligners/bwa/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa data/dna_chr21_100_hq_read1.fastq > alignments/bwa/dna_chr21_100_hq_se.sam

Now you can use SAMtools to create the BAM file from the *alignment/bwa* folder:
    cd alignments/bwa
    samtools view -b dna_chr21_100_hq_se.sam -o dna_chr21_100_hq_se.bam


To align **PE** with BWA-MEM just execute the same command line with the two FASTQ files:

    bwa mem -t 4 -R "@RG\tID:foo\tSM:bar\tPL:Illumina\tPU:unit1\tLB:lib1" aligners/bwa/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa data/dna_chr21_100_hq_read1.fastq data/dna_chr21_100_hq_read2.fastq > alignments/bwa/dna_chr21_100_hq_pe.sam
    
Now you can use SAMtools to create the BAM file from the *alignment/bwa* folder:

    cd alignments/bwa
    samtools view -b dna_chr21_100_hq_pe.sam -o dna_chr21_100_hq_pe.bam


Now you can do the same for the **low** quality datasets.


##### Aligning with old BWA algorithm, two command lines: ALN and SAMSE/SAMPE in SE and PE modes (Optional exercise)

Now we are going to align SE and PE the **high** quality dataset. Single-end alignment with BWA requires 2 executions. The first uses ```aln``` command and takes the ```fastq``` file and creates a ```sai``` file; the second execution uses ```samse``` and the ```sai``` file and create the ```sam``` file. Results are stored in ```alignments``` folder:

    bwa aln aligners/bwa/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -t 4 data/dna_chr21_100_hq_read1.fastq -f alignments/bwa/dna_chr21_100_hq_se.sai
    bwa samse aligners/bwa/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa alignments/bwa/dna_chr21_100_hq_se.sai data/dna_chr21_100_hq_read1.fastq -f alignments/bwa/dna_chr21_100_hq_se.sam


For paired-end alignments with BWA 3 executions are needed: 2 for ```aln``` command and 1 for ```sampe``` command:

    bwa aln aligners/bwa/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -t 4 data/dna_chr21_100_hq_read1.fastq -f alignments/bwa/dna_chr21_100_hq_pe1.sai
    bwa aln aligners/bwa/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -t 4 data/dna_chr21_100_hq_read2.fastq -f alignments/bwa/dna_chr21_100_hq_pe2.sai
    bwa sampe aligners/bwa/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa alignments/bwa/dna_chr21_100_hq_pe1.sai alignments/bwa/dna_chr21_100_hq_pe2.sai data/dna_chr21_100_hq_read1.fastq data/dna_chr21_100_hq_read2.fastq -f alignments/bwa/dna_chr21_100_hq_pe.sam

Now you can use SAMtools to create the BAM file from the *alignment/bwa* folder:

    cd alignments/bwa
    samtools view -b dna_chr21_100_hq_se.sam -o dna_chr21_100_hq_se.bam
    samtools view -b dna_chr21_100_hq_pe.sam -o dna_chr21_100_hq_pe.bam

Now you can do the same for the **low** quality datasets.


### HPG Aligner
[HPG Aligner] is an ultrafast and high sensitivity tool for aligning sequencing reads to long reference sequences. It is particularly good at aligning reads of any size. HPG Aligner 2.0 indexes the genome using a Suffix Arrays. HPG Aligner 2 supports gapped, local, and paired-end alignment modes, together with INDEL realignment and recalibration.

##### Build the index

Create a folder inside HPG Aligner program called ```index``` to store the HPG Aligner index and copy the reference genome into it:
    
    cd hpg-aligner   (_inside aligners folder_)
    mkdir index
    cp data/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa aligners/bwa/index/
    
Now you can create the index by executing:

    hpg-aligner build-sa-index -g aligners/hpg-aligner/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -i aligners/hpg-aligner/index/

Some files will be created in the ```index``` folder, those files constitute the index that HPG Aligner uses.

**NOTE:** The index must created only once, it will be used for all the different alignments with HPG Aligner.


##### Aligning in SE and PE modes


Mapping **SE** with HPG Aligner requires only 1 execution, for aligning the **high** in SE mode execute:

    hpg-aligner dna --cpu-threads 4 -i aligners/hpg-aligner/index/ -f data/dna_chr21_100_hq_read1.fastq -o alignments/hpg-aligner/ --prefix dna_chr21_100_hq_se

And create the BAM file using SAMtools, you could create the BAM file adding _--bam-format_ to the previous command line:

    cd alignments/hpg-aligner
    samtools view -b dna_chr21_100_hq_se_out.sam -o dna_chr21_100_hq_se.bam


Mapping in **PE** also requires only one execution:

    hpg-aligner dna --cpu-threads 4 -i aligners/hpg-aligner/index/ -f data/dna_chr21_100_hq_read1.fastq -j data/dna_chr21_100_hq_read2.fastq -o alignments/hpg-aligner --prefix dna_chr21_100_hq_pe

And create the BAM file using SAMtools:

    cd alignments/hpg-aligner
    samtools view -b dna_chr21_100_hq_pe_out.sam -o dna_chr21_100_hq_pe.bam
    
Repeat the same steps for the **low** quality dataset.


### Bowtie2

[Bowtie2] as documentation states is an ultrafast and memory-efficient tool for aligning sequencing reads to long reference sequences. It is particularly good at aligning reads of about 50 up to few 100s. Bowtie 2 indexes the genome with an FM Index to keep its memory footprint small: for the human genome, its memory footprint is typically around 3.2 GB. Bowtie 2 supports gapped, local, and paired-end alignment modes.

##### Download and install (Optional, already installed)

First check that bwa is not currently installed by executing:

    bowtie2

A list of commands will be printed if already installed. If not you can continue with the installation.

From [Bowtie2] go to ```Latest Release``` and download the program or go directly to:

[http://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.2.3/](http://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.2.3/)

Click in the Linux version of Bowtie2 and wait for a few seconds, as the time of this tutorial last version is **bowtie2-2.2.3-linux-x86_64.zip**, the download will start. When downloaded go to your browser download folder and move it to aligners folder and uncompress it. No need to compile if you downloaded the Linux version:

    mv bowtie2-2.2.3-linux-x86_64.zip working_directory/aligners/bowtie
    unzip bowtie2-2.2.3-linux-x86_64.zip
    cd bowtie2-2.2.3

You can check that everything is allright by executing:

    bowtie2

Big information about the software and commands should be listed.


##### Build the index

Create a folder inside Bowtie2 program called ```index``` to store the Bowtie2 index and copy the reference genome into it:
    
    cd bowtie   (_inside aligners folder_)
    mkdir index
    cp data/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa aligners/bowtie/index/
    
Now you can create the index by executing:

    bowtie2-build aligners/bowtie/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa aligners/bowtie/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa

Some files will be created in the ```index``` folder, those files constitute the index that Bowtie2 uses.

**NOTE:** The index must created only once, it will be used for all the different alignments with Bowtie2.


##### Aligning in SE and PE modes

Mapping **SE** with Bowtie2 requires only 1 execution, for aligning the **high** in SE mode execute:

    bowtie2 -q -p 4 -x aligners/bowtie/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -U data/dna_chr21_100_hq_read1.fastq -S alignments/bowtie/dna_chr21_100_hq_se.sam

And create the BAM file using SAMtools;

    cd alignments/bowtie
    samtools view -b dna_chr21_100_hq_se.sam -o dna_chr21_100_hq_se.bam


Mapping in **PE** also requires only one execution:

    bowtie2 -q -p 4 -x aligners/bowtie/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -1 data/dna_chr21_100_hq_read1.fastq -2 data/dna_chr21_100_hq_read2.fastq -S alignments/bowtie/dna_chr21_100_hq_pe.sam

And create the BAM file using SAMtools;

    cd alignments/bowtie
    samtools view -b dna_chr21_100_hq_pe.sam -o dna_chr21_100_hq_pe.bam
    
Repeat the same steps for the **low** quality dataset.


### More exercises

- Try to simulate datasets with longer reads and more mutations to study which aligner behaves better
- Test the aligner sensitivity to INDELS
- Try BWA-MEM algorithm and compare sensitivity. The same index is valid, only one execution for the SAM file ```./bwa mem index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa ../../data/dna_chr21_100_low/dna_chr21_100_low.bwa.read1.fastq```


# Exercise 2: NGS RNA-seq aligment

In this exercise we'll learn how to download, install, build the reference genome index and align in single-end and paired-end mode with the two most widely RNA-seq aligner: *TopHat2*. TopHat2 uses Bowtie2 as an aligner.

**NOTE:** Two others commonly used RNA-seq aligners are [STAR] and [MapSplice2], no guided exercises have been documented in this tutorials, but users are encouraged to follow the instructions of their web sites.

Go to ```alignments``` folder and create to folders for *bwa* and *bowtie* to store alignments results:

    cd alignments
    mkdir tophat

**NOTE:** No index is needed for TopHat as it uses Bowtie2 for alignment.
    
### TopHat2

[TopHat2] states to be a *fast* splice junction mapper for RNA-Seq reads, which is not always completrly true. It aligns RNA-Seq reads to mammalian-sized genomes using the ultra high-throughput short read aligner Bowtie, and then analyzes the mapping results to identify splice junctions between exons.

##### Download and install (Optional, already installed)

First check that bwa is not currently installed by executing:

    tophat2

A list of commands will be printed if already installed. If not you can continue with the installation.

From [TopHat2] go to ```Releases``` and download the Linux program by clicking in *Linux x86_64 binary* link.

As the time of this tutorial last version is **tophat-2.0.10.Linux_x86_64.tar.gz**, the download will start. When downloaded go to your browser download folder and move it to aligners folder and uncompress it. No need to compile if you downloaded the Linux version:

    mv tophat-2.0.10.Linux_x86_64.tar.gz working_directory/aligners/tophat
    tar -zxvf tophat-2.0.10.Linux_x86_64.tar.gz
    cd tophat-2.0.10.Linux_x86_64

You can check that everything is allright by executing:

    tophat2

Big information about the software and commands should be listed.

**NOTE:** TopHat uses Bowtie as the read aligner. You can use either Bowtie 2 (the default) or Bowtie (--bowtie1) and you will need the following Bowtie 2 (or Bowtie) programs in your PATH. Index must be created with Bowtie not TopHat. So, copy Bowtie2 into ~/bin:
    
    cd bowtie2   (bowtie 2.2 does not work)
    cp bowtie* ~/bin


##### Aligning in SE and PE modes

To align in SE mode:

    tophat2 -o alignments/tophat/rna_chr21_100_hq_se aligners/bowtie/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa data/rna_chr21_100_hq_read1.fastq

And for PE:

    tophat2 -o alignments/tophat/rna_chr21_100_hq_pe/ aligners/bowtie/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa data/rna_chr21_100_hq_read1.fastq data/rna_chr21_100_hq_read2.fastq

Now align the rna dataset of 150bp with low quality and compare stats.


### STAR and MapSplice2
[STAR] and [MapSplice2] are two others interesting RNA-seq aligners. [STAR] offer a great performance while still have good sensitivity. [MapSplice2] shows usually a better sensitivity but is several times slower.

##### STAR installation (Optional, already installed)
STAR comes compiled for Linux, you only have to download the *tarball*:

    tar -zxvf STAR_2.3.0e.Linux_x86_64_static.tgz

Read the documentation and try to align the simulated dataset.


##### MapSplice2 installation (Optional, already installed)
MapSplice must be unizpped and compiled:

    unzip MapSplice-v2.1.6.zip
    cd MapSplice-v2.1.6
    make

Read the documentation and try to align the simulated dataset.


# Exercise 3: Simulating NGS datasets (Optional)

### DNA
Download [dwgsim] from http://sourceforge.net/projects/dnaa/files/ to the *working_directory* and uncompress it and compile it:

    tar -zxvf dwgsim-0.1.10.tar.gz
    cd dwgsim-0.1.10
    make

Check options by executing:

    ./dwgsim

Then you can simulate 2 million reads of 150bp with a 2% if mutation executing:

    ./dwgsim-0.1.11/dwgsim -1 150 -2 150 -y 0 -N 2000000 -r 0.02 ../data/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa ../data/dna_chr21_100_low/dna_chr21_100_verylow


### RNA-seq
[BEERS] is a perl-based program, no compilation is needed, just download it from here http://www.cbil.upenn.edu/BEERS and uncompress it:

    tar xvf beers.tar

