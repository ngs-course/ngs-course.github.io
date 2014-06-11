rm -r                                           ../../../../sandbox/rna_seq/
cp -r ../../../../ngs_course_materials/rna_seq/ ../../../../sandbox/rna_seq/
cp    ../../../../ngs_course_materials/f000_chr21_ref_genome_sequence.fa ../../../../sandbox/rna_seq/
cp    ../../../../ngs_course_materials/f005_chr21_genome_annotation.gtf  ../../../../sandbox/rna_seq/
cd    ../../../../sandbox/rna_seq/
cd rna_seq_data
bowtie2-build f000_chr21_ref_genome_sequence.fa f001_bowtie_index
tophat2 -r 300 -o f021_case_tophat_out   f001_bowtie_index   f011_case_read1.fastq f011_case_read2.fastq
tophat2 -r 300 -o f022_case_tophat_out   f001_bowtie_index   f012_case_read1.fastq f012_case_read2.fastq
tophat2 -r 300 -o f023_case_tophat_out   f001_bowtie_index   f013_case_read1.fastq f013_case_read2.fastq
tophat2 -r 300 -o f024_cont_tophat_out   f001_bowtie_index   f014_cont_read1.fastq f014_cont_read2.fastq
tophat2 -r 300 -o f025_cont_tophat_out   f001_bowtie_index   f015_cont_read1.fastq f015_cont_read2.fastq
tophat2 -r 300 -o f026_cont_tophat_out   f001_bowtie_index   f016_cont_read1.fastq f016_cont_read2.fastq
samtools view f021_case_tophat_out/accepted_hits.bam > f031_case.sam
samtools view f022_case_tophat_out/accepted_hits.bam > f032_case.sam
samtools view f023_case_tophat_out/accepted_hits.bam > f033_case.sam
samtools view f024_cont_tophat_out/accepted_hits.bam > f034_cont.sam
samtools view f025_cont_tophat_out/accepted_hits.bam > f035_cont.sam
samtools view f026_cont_tophat_out/accepted_hits.bam > f036_cont.sam
wc -l *.sam
wc -l *.fastq

cuffdiff -o f040_dif_exp_two f005_chr21_genome_annotation.gtf   f031_case.sam   f034_cont.sam
cuffdiff -o f040_dif_exp_several f005_chr21_genome_annotation.gtf   f031_case.sam,f032_case.sam,f033_case.sam   f034_cont.sam,f035_cont.sam,f036_cont.sam

