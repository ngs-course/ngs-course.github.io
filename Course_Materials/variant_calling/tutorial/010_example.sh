cd /home/training/ngs_course/calling
cd /home/training/ngs_course/reference_genome
samtools faidx f000_chr21_ref_genome_sequence.fa
java -jar ~/soft/picard-tools/picard.jar CreateSequenceDictionary \
cd /home/training/ngs_course/calling/example_0
AddOrReplaceReadGroups.jar I=f000-dna_100_high_pe.bam O=f010-dna_100_high_pe_fixRG.bam RGID=group1 RGLB=lib1 RGPL=illumina RGSM=sample1 RGPU=unit1
samtools sort 000-dna_chr21_100_hq_pe.bam 001-dna_chr21_100_hq_pe_sorted
samtools index 001-dna_chr21_100_hq_pe_sorted.bam
java -jar ~/soft/picard-tools/picard.jar MarkDuplicates \
java -jar ~/soft/picard-tools/picard.jar BuildBamIndex \
java -jar ~/soft/GATK/GenomeAnalysisTK.jar \
java -jar ~/soft/GATK/GenomeAnalysisTK.jar \
java -jar ~/soft/GATK/GenomeAnalysisTK.jar \
java -jar ~/soft/GATK/GenomeAnalysisTK.jar \
java -jar ~/soft/GATK/GenomeAnalysisTK.jar \
java -jar ../gatk/GenomeAnalysisTK.jar -T UnifiedGenotyper -R ../genome/f000_chr21_ref_genome_sequence.fa -I 004-dna_chr21_100_hq_pe_sorted_noDup_realigned_recalibrated.bam -glm SNP -o 005-dna_chr21_100_he_pe_snps.vcf
java -jar ../gatk/GenomeAnalysisTK.jar -T UnifiedGenotyper -R ../genome/f000_chr21_ref_genome_sequence.fa -I 004-dna_chr21_100_hq_pe_sorted_noDup_realigned_recalibrated.bam -glm INDEL -o 005-dna_chr21_100_hq_pe_indel.vcf
bcftools filter -s LowQual -e 'QUAL<20 | DP<3' 005-dna_chr21_100_he_pe.vcf > 006-dna_chr21_100_he_pe_filtered.vcf
grep LowQual 006-dna_chr21_100_he_pe_filtered.vcf | wc -l
grep PASS 006-dna_chr21_100_he_pe_filtered.vcf | wc -l
java -jar $GATK -T VariantFiltration -R ../genome/f000_chr21_ref_genome_sequence.fa -V 005-dna_chr21_100_he_pe.vcf --filterExpression "QD < 12.0" --filterName "LowConf" -o 006-dna_chr21_100_he_pe_filtered.vcf
grep LowConf 006-dna_chr21_100_he_pe_filtered.vcf | wc -l
