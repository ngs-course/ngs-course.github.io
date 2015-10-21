samtools faidx TP53.hg19.fa
java -jar ~/soft/picard-tools/picard.jar CreateSequenceDictionary \
cd /home/training/ngs_course/calling/example_3/somatic_calling
samtools sort 000-normal.bam 001-normal_sorted
samtools sort 000-tumor.bam 001-tumor_sorted
samtools index 001-normal_sorted.bam
samtools index 001-tumor_sorted.bam
~/soft/java7/bin/java -jar ~/soft/muTect/muTect-1.1.5.jar \
