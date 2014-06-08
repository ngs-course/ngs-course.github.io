mkdir data
mv Homo_sapiens.GRCh37.75.dna.chromosome.21.fa.gz path_to_local_data
cp path_to_shared_data/* your_local_data/
mv samtools-0.1.19.tar.bz2 working_directory
cd working_directory
tar -jxvf samtools-0.1.19.tar.bz2 
cd samtools-0.1.19
make
./samtools
cp samtools ~/bin
mkdir aligners alignments
cd alignments
mkdir bwa bowtie

├── beers.tar
├── dwgsim-0.1.10
├── dwgsim-0.1.10.tar.gz
└── reads_simulator.pl
mv bwa-0.7.7.tar.bz2 working_directory/aligners/bwa
tar -jxvf bwa-0.7.7.tar.bz2
cd bwa-0.7.7
make
./bwa

cd bwa-0.7.7   (if not in it)
mkdir index
cp ../../data/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa index/

./bwa index index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa
./bwa aln index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -t 4 ../../data/dna_chr21_100_high/dna_chr21_100_high.bwa.read1.fastq -f ../../alignments/bwa/dna_chr21_100_high_se.sai
./bwa samse index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa ../../alignments/bwa/dna_chr21_100_high_se.sai ../../data/dna_chr21_100_high/dna_chr21_100_high.bwa.read1.fastq -f ../../alignments/bwa/dna_chr21_100_high_se.sam
./bwa aln index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -t 4 ../../data/dna_chr21_100_high/dna_chr21_100_high.bwa.read1.fastq -f ../../alignments/bwa/dna_chr21_100_high_pe1.sai
./bwa aln index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -t 4 ../../data/dna_chr21_100_high/dna_chr21_100_high.bwa.read2.fastq -f ../../alignments/bwa/dna_chr21_100_high_pe2.sai
./bwa sampe index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa ../../alignments/bwa/dna_chr21_100_high_pe1.sai ../../alignments/bwa/dna_chr21_100_high_pe2.sai ../../data/dna_chr21_100_high/dna_chr21_100_high.bwa.read1.fastq ../../data/dna_chr21_100_high/dna_chr21_100_high.bwa.read2.fastq -f ../../alignments/bwa/dna_chr21_100_high_pe.sam
cd alignments/bwa
samtools view -S -b dna_chr21_100_high_se.sam -o dna_chr21_100_high_se.bam
samtools view -S -b dna_chr21_100_high_pe.sam -o dna_chr21_100_high_pe.bam
./bwa aln index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -t 4 ../../data/dna_chr21_100_low/dna_chr21_100_low.bwa.read1.fastq -f ../../alignments/bwa/dna_chr21_100_low_se.sai
./bwa samse index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa ../../alignments/bwa/dna_chr21_100_low_se.sai ../../data/dna_chr21_100_low/dna_chr21_100_low.bwa.read1.fastq -f ../../alignments/bwa/dna_chr21_100_low_se.sam
./bwa aln index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -t 4 ../../data/dna_chr21_100_low/dna_chr21_100_low.bwa.read1.fastq -f ../../alignments/bwa/dna_chr21_100_low_pe1.sai
./bwa aln index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -t 4 ../../data/dna_chr21_100_low/dna_chr21_100_low.bwa.read2.fastq -f ../../alignments/bwa/dna_chr21_100_low_pe2.sai
./bwa sampe index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa ../../alignments/bwa/dna_chr21_100_low_pe1.sai ../../alignments/bwa/dna_chr21_100_low_pe2.sai ../../data/dna_chr21_100_low/dna_chr21_100_low.bwa.read1.fastq ../../data/dna_chr21_100_low/dna_chr21_100_low.bwa.read2.fastq -f ../../alignments/bwa/dna_chr21_100_low_pe.sam
cd alignments/bwa
samtools view -S -b dna_chr21_100_low_se.sam -o dna_chr21_100_low_se.bam
samtools view -S -b dna_chr21_100_low_pe.sam -o dna_chr21_100_low_pe.bam
mv bowtie2-2.2.1-linux-x86_64.zip working_directory/aligners/bowtie
unzip bowtie2-2.2.1-linux-x86_64.zip
cd bowtie2-2.2.1
./bowtie2

cd bowtie2-2.2.1   (if not in it)
mkdir index
cp ../../data/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa index/

./bowtie2-build index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa
./bowtie2 -q -p 4 -x index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -U ../../data/dna_chr21_100_high/dna_chr21_100_high.bwa.read1.fastq -S ../../alignments/bowtie/dna_chr21_100_high_se.sam
cd alignments/bowtie
samtools view -S -b dna_chr21_100_high_se.sam -o dna_chr21_100_high_se.bam
./bowtie2 -q -p 4 -x index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -1 ../../data/dna_chr21_100_high/dna_chr21_100_high.bwa.read1.fastq -2 ../../data/dna_chr21_100_high/dna_chr21_100_high.bwa.read2.fastq -S ../../alignments/bowtie/dna_chr21_100_high_pe.sam
cd alignments/bowtie
samtools view -S -b dna_chr21_100_high_pe.sam -o dna_chr21_100_high_pe.bam

cd alignments
mkdir tophat

mv tophat-2.0.10.Linux_x86_64.tar.gz working_directory/aligners/tophat
tar -zxvf tophat-2.0.10.Linux_x86_64.tar.gz
cd tophat-2.0.10.Linux_x86_64
./tophat2

cd bowtie2-2.2.1   (bowtie 2.2 does not work)
cp bowtie* ~/bin
./tophat2 -o ~/courses/cambridge_mda14/alignments/tophat/rna_chr21_100_high_se ~/courses/cambridge_mda14/aligners/bowtie2-2.2.1/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa ~/courses/cambridge_mda14/data/rna_chr21_100_high/rna_chr21_100_high.bwa.read1.fastq
./tophat2 -o ~/courses/cambridge_mda14/alignments/tophat/rna_chr21_100_high_pe/ ~/courses/cambridge_mda14/aligners/bowtie2-2.2.1/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa ~/courses/cambridge_mda14/data/rna_chr21_100_high/rna_chr21_100_high.bwa.read1.fastq ~/courses/cambridge_mda14/data/rna_chr21_100_high/rna_chr21_100_high.bwa.read2.fastq
tar -zxvf STAR_2.3.0e.Linux_x86_64_static.tgz
unzip MapSplice-v2.1.6.zip
cd MapSplice-v2.1.6
make
tar -zxvf dwgsim-0.1.10.tar.gz
cd dwgsim-0.1.10
make
./dwgsim
./dwgsim-0.1.11/dwgsim -1 150 -2 150 -y 0 -N 2000000 -r 0.02 ../data/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa ../data/dna_chr21_100_low/dna_chr21_100_verylow
tar xvf beers.tar
