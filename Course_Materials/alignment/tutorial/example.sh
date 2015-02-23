
cd cambridge_mda15
mkdir data
mv Homo_sapiens.GRCh37.75.dna.chromosome.21.fa.gz path_to_local_data
cp path_to_course_materials/alignment/* your_local_data/
samtools
mv samtools-1.2.tar.bz2 working_directory
cd working_directory
tar -jxvf samtools-1.2.tar.bz2 
cd samtools-1.2
make
samtools
cp samtools ~/bin
mkdir aligners
mkdir alignments
cd aligners
mkdir bwa hpg-aligner bowtie
cd alignments
mkdir bwa hpg-aligner bowtie

bwa
mv bwa-0.7.12.tar.gz working_directory/aligners/bwa
tar -jxvf bwa-0.7.12.tar.gz
cd bwa-0.7.12
make
cp bwa ~/bin
bwa

mkdir index
cp  data/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa  aligners/bwa/index/   (this path can be different!)

bwa index aligners/bwa/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa
bwa mem
bwa mem -t 4 -R "@RG\tID:foo\tSM:bar\tPL:Illumina\tPU:unit1\tLB:lib1" aligners/bwa/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa data/dna_chr21_100_hq_read1.fastq > alignments/bwa/dna_chr21_100_hq_se.sam
cd alignments/bwa
samtools view -b dna_chr21_100_hq_se.sam -o dna_chr21_100_hq_se.bam
bwa mem -t 4 -R "@RG\tID:foo\tSM:bar\tPL:Illumina\tPU:unit1\tLB:lib1" aligners/bwa/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa data/dna_chr21_100_hq_read1.fastq data/dna_chr21_100_hq_read2.fastq > alignments/bwa/dna_chr21_100_hq_pe.sam

cd alignments/bwa
samtools view -b dna_chr21_100_hq_pe.sam -o dna_chr21_100_hq_pe.bam
bwa aln aligners/bwa/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -t 4 data/dna_chr21_100_hq_read1.fastq -f alignments/bwa/dna_chr21_100_hq_se.sai
bwa samse aligners/bwa/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa alignments/bwa/dna_chr21_100_hq_se.sai data/dna_chr21_100_hq_read1.fastq -f alignments/bwa/dna_chr21_100_hq_se.sam
bwa aln aligners/bwa/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -t 4 data/dna_chr21_100_hq_read1.fastq -f alignments/bwa/dna_chr21_100_hq_pe1.sai
bwa aln aligners/bwa/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -t 4 data/dna_chr21_100_hq_read2.fastq -f alignments/bwa/dna_chr21_100_hq_pe2.sai
bwa sampe aligners/bwa/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa alignments/bwa/dna_chr21_100_hq_pe1.sai alignments/bwa/dna_chr21_100_hq_pe2.sai data/dna_chr21_100_hq_read1.fastq data/dna_chr21_100_hq_read2.fastq -f alignments/bwa/dna_chr21_100_hq_pe.sam
cd alignments/bwa
samtools view -b dna_chr21_100_hq_se.sam -o dna_chr21_100_hq_se.bam
samtools view -b dna_chr21_100_hq_pe.sam -o dna_chr21_100_hq_pe.bam

cd hpg-aligner   (_inside aligners folder_)
mkdir index
cp data/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa aligners/bwa/index/

hpg-aligner build-sa-index -g aligners/hpg-aligner/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -i aligners/hpg-aligner/index/
hpg-aligner dna --cpu-threads 4 -i aligners/hpg-aligner/index/ -f data/dna_chr21_100_hq_read1.fastq -o alignments/hpg-aligner/ --prefix dna_chr21_100_hq_se
cd alignments/hpg-aligner
samtools view -b dna_chr21_100_hq_se_out.sam -o dna_chr21_100_hq_se.bam
hpg-aligner dna --cpu-threads 4 -i aligners/hpg-aligner/index/ -f data/dna_chr21_100_hq_read1.fastq -j data/dna_chr21_100_hq_read2.fastq -o alignments/hpg-aligner --prefix dna_chr21_100_hq_pe
cd alignments/hpg-aligner
samtools view -b dna_chr21_100_hq_pe_out.sam -o dna_chr21_100_hq_pe.bam

bowtie2
mv bowtie2-2.2.3-linux-x86_64.zip working_directory/aligners/bowtie
unzip bowtie2-2.2.3-linux-x86_64.zip
cd bowtie2-2.2.3
bowtie2

cd bowtie   (_inside aligners folder_)
mkdir index
cp data/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa aligners/bowtie/index/

bowtie2-build aligners/bowtie/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa aligners/bowtie/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa
bowtie2 -q -p 4 -x aligners/bowtie/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -U data/dna_chr21_100_hq_read1.fastq -S alignments/bowtie/dna_chr21_100_hq_se.sam
cd alignments/bowtie
samtools view -b dna_chr21_100_hq_se.sam -o dna_chr21_100_hq_se.bam
bowtie2 -q -p 4 -x aligners/bowtie/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa -1 data/dna_chr21_100_hq_read1.fastq -2 data/dna_chr21_100_hq_read2.fastq -S alignments/bowtie/dna_chr21_100_hq_pe.sam
cd alignments/bowtie
samtools view -b dna_chr21_100_hq_pe.sam -o dna_chr21_100_hq_pe.bam

cd alignments
mkdir tophat

tophat2
mv tophat-2.0.10.Linux_x86_64.tar.gz working_directory/aligners/tophat
tar -zxvf tophat-2.0.10.Linux_x86_64.tar.gz
cd tophat-2.0.10.Linux_x86_64
tophat2

cd bowtie2   (bowtie 2.2 does not work)
cp bowtie* ~/bin
tophat2 -o alignments/tophat/rna_chr21_100_hq_se aligners/bowtie/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa data/rna_chr21_100_hq_read1.fastq
tophat2 -o alignments/tophat/rna_chr21_100_hq_pe/ aligners/bowtie/index/Homo_sapiens.GRCh37.75.dna.chromosome.21.fa data/rna_chr21_100_hq_read1.fastq data/rna_chr21_100_hq_read2.fastq
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
