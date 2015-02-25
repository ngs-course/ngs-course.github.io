rm -r                                           ../../../../sandbox/rna_seq_htseq/
cp -r ../../../../ngs_course_materials/rna_seq/ ../../../../sandbox/rna_seq_htseq/
cp    ../../../../ngs_course_materials/f000_chr21_ref_genome_sequence.fa ../../../../sandbox/rna_seq_htseq/
cp    ../../../../ngs_course_materials/f005_chr21_genome_annotation.gtf  ../../../../sandbox/rna_seq_htseq/

cp edgeR_example.r ../../../../sandbox/rna_seq_htseq/

cd    ../../../../sandbox/rna_seq_htseq/
cd data
bowtie2-build f000_chr21_ref_genome_sequence.fa f001_bowtie_index
tophat2 -r 300 -o f021_case_tophat_out   f001_bowtie_index   f011_case_read1.fastq f011_case_read2.fastq
tophat2 -r 300 -o f022_case_tophat_out   f001_bowtie_index   f012_case_read1.fastq f012_case_read2.fastq
tophat2 -r 300 -o f023_case_tophat_out   f001_bowtie_index   f013_case_read1.fastq f013_case_read2.fastq
tophat2 -r 300 -o f024_cont_tophat_out   f001_bowtie_index   f014_cont_read1.fastq f014_cont_read2.fastq
tophat2 -r 300 -o f025_cont_tophat_out   f001_bowtie_index   f015_cont_read1.fastq f015_cont_read2.fastq
tophat2 -r 300 -o f026_cont_tophat_out   f001_bowtie_index   f016_cont_read1.fastq f016_cont_read2.fastq
samtools sort -n f021_case_tophat_out/accepted_hits.bam g031_case_sorted_n
samtools sort -n f022_case_tophat_out/accepted_hits.bam g032_case_sorted_n
samtools sort -n f023_case_tophat_out/accepted_hits.bam g033_case_sorted_n
samtools sort -n f024_cont_tophat_out/accepted_hits.bam g034_cont_sorted_n
samtools sort -n f025_cont_tophat_out/accepted_hits.bam g035_cont_sorted_n
samtools sort -n f026_cont_tophat_out/accepted_hits.bam g036_cont_sorted_n
samtools view g031_case_sorted_n.bam | head 
grep -A 1 ENST00000270112_43591_43135_1_0_0_0_2:0:0_1:0:0_10 f011_case_read1.fastq
grep -A 1 ENST00000270112_43591_43135_1_0_0_0_2:0:0_1:0:0_10 f011_case_read2.fastq
samtools sort f021_case_tophat_out/accepted_hits.bam g031_case_sorted
samtools sort f022_case_tophat_out/accepted_hits.bam g032_case_sorted
samtools sort f023_case_tophat_out/accepted_hits.bam g033_case_sorted
samtools sort f024_cont_tophat_out/accepted_hits.bam g034_cont_sorted
samtools sort f025_cont_tophat_out/accepted_hits.bam g035_cont_sorted
samtools sort f026_cont_tophat_out/accepted_hits.bam g036_cont_sorted
samtools index g031_case_sorted.bam
samtools index g032_case_sorted.bam
samtools index g033_case_sorted.bam
samtools index g034_cont_sorted.bam
samtools index g035_cont_sorted.bam
samtools index g036_cont_sorted.bam
htseq-count --format=bam --stranded=no --type=gene g031_case_sorted_n.bam f005_chr21_genome_annotation.gtf > h041_case.count
htseq-count --format=bam --stranded=no --type=gene g032_case_sorted_n.bam f005_chr21_genome_annotation.gtf > h042_case.count
htseq-count --format=bam --stranded=no --type=gene g033_case_sorted_n.bam f005_chr21_genome_annotation.gtf > h043_case.count
htseq-count --format=bam --stranded=no --type=gene g034_cont_sorted_n.bam f005_chr21_genome_annotation.gtf > h044_cont.count
htseq-count --format=bam --stranded=no --type=gene g035_cont_sorted_n.bam f005_chr21_genome_annotation.gtf > h045_cont.count
htseq-count --format=bam --stranded=no --type=gene g036_cont_sorted_n.bam f005_chr21_genome_annotation.gtf > h046_cont.count
htseq-count --format=bam --stranded=no --type=exon g031_case_sorted_n.bam f005_chr21_genome_annotation.gtf > g041_case.count
htseq-count --format=bam --stranded=no --type=exon g032_case_sorted_n.bam f005_chr21_genome_annotation.gtf > g042_case.count
htseq-count --format=bam --stranded=no --type=exon g033_case_sorted_n.bam f005_chr21_genome_annotation.gtf > g043_case.count
htseq-count --format=bam --stranded=no --type=exon g034_cont_sorted_n.bam f005_chr21_genome_annotation.gtf > g044_cont.count
htseq-count --format=bam --stranded=no --type=exon g035_cont_sorted_n.bam f005_chr21_genome_annotation.gtf > g045_cont.count
htseq-count --format=bam --stranded=no --type=exon g036_cont_sorted_n.bam f005_chr21_genome_annotation.gtf > g046_cont.count
head h041_case.count 
tail h041_case.count 
head h041_case.count
head g041_case.count 
R CMD BATCH --no-save --no-restore edgeR_example.r 
