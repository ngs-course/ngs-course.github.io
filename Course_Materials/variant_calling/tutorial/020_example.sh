cd /home/training/ngs_course/calling/example_1
samtools sort 000-dna_chr21_100_hq_se.bam 001-dna_chr21_100_hq_se_sorted
samtools index 001-dna_chr21_100_hq_se_sorted.bam
java -jar ~/soft/picard-tools/picard.jar MarkDuplicates \
java -jar ~/soft/picard-tools/picard.jar BuildBamIndex \
java -jar ~/soft/GATK/GenomeAnalysisTK.jar \
java -jar ~/soft/GATK/GenomeAnalysisTK.jar \
java -jar ~/soft/GATK/GenomeAnalysisTK.jar \
java -jar ~/soft/GATK/GenomeAnalysisTK.jar \
java -jar ~/soft/GATK/GenomeAnalysisTK.jar \
java -jar ../gatk/GenomeAnalysisTK.jar -T UnifiedGenotyper -R ../genome/f000_chr21_ref_genome_sequence.fa -I 004-dna_chr21_100_hq_se_sorted_noDup_realigned_recalibrated.bam -glm SNP -o 005-dna_chr21_100_hq_se_snps.vcf
java -jar ../gatk/GenomeAnalysisTK.jar -T UnifiedGenotyper -R ../genome/f000_chr21_ref_genome_sequence.fa -I 004-dna_chr21_100_hq_se_sorted_noDup_realigned_recalibrated.bam -glm INDEL -o 005-dna_chr21_100_hq_se_indel.vcf
