cd /home/training/ngs_course/calling
cd /home/training/ngs_course/reference_genome
samtools faidx f000_chr21_ref_genome_sequence.fa
java -jar ~/soft/picard-tools/picard.jar CreateSequenceDictionary \
cd /home/participant/Desktop/Course_Materials/calling/example1
AddOrReplaceReadGroups.jar I=f000-dna_100_high_pe.bam O=f010-dna_100_high_pe_fixRG.bam RGID=group1 RGLB=lib1 RGPL=illumina RGSM=sample1 RGPU=unit1
samtools sort 000-dna_chr21_100_hq_pe.bam 001-dna_chr21_100_hq_pe_sorted
samtools index 001-dna_chr21_100_hq_pe_sorted.bam
java -jar $PICARD MarkDuplicates INPUT=001-dna_chr21_100_hq_pe_sorted.bam OUTPUT=002-dna_chr21_100_hq_pe_sorted_noDup.bam METRICS_FILE=002-metrics.txt
java -jar $PICARD BuildBamIndex INPUT=002-dna_chr21_100_hq_pe_sorted_noDup.bam
java -jar $GATK -T RealignerTargetCreator -R ../genome/f000_chr21_ref_genome_sequence.fa -I 002-dna_chr21_100_hq_pe_sorted_noDup.bam -o 003-indelRealigner.intervals
java -jar $GATK -T IndelRealigner -R ../genome/f000_chr21_ref_genome_sequence.fa -I 002-dna_chr21_100_hq_pe_sorted_noDup.bam -targetIntervals 003-indelRealigner.intervals -o 003-dna_chr21_100_hq_pe_sorted_noDup_realigned.bam
java -jar $GATK -T BaseRecalibrator -R ../genome/f000_chr21_ref_genome_sequence.fa -I 003-dna_chr21_100_hq_pe_sorted_noDup_realigned.bam -knownSites ../000-dbSNP_chr21.vcf -o 004-recalibration_data.table
java -jar $GATK -T PrintReads -R ../genome/f000_chr21_ref_genome_sequence.fa -I 003-dna_chr21_100_hq_pe_sorted_noDup_realigned.bam -BQSR 004-recalibration_data.table -o 004-dna_chr21_100_hq_pe_sorted_noDup_realigned_recalibrated.bam
java -jar $GATK -T HaplotypeCaller -R ../genome/f000_chr21_ref_genome_sequence.fa -I 004-dna_chr21_100_hq_pe_sorted_noDup_realigned_recalibrated.bam -o 005-dna_chr21_100_he_pe.vcf
java -jar ../gatk/GenomeAnalysisTK.jar -T UnifiedGenotyper -R ../genome/f000_chr21_ref_genome_sequence.fa -I 004-dna_chr21_100_hq_pe_sorted_noDup_realigned_recalibrated.bam -glm SNP -o 005-dna_chr21_100_he_pe_snps.vcf
java -jar ../gatk/GenomeAnalysisTK.jar -T UnifiedGenotyper -R ../genome/f000_chr21_ref_genome_sequence.fa -I 004-dna_chr21_100_hq_pe_sorted_noDup_realigned_recalibrated.bam -glm INDEL -o 005-dna_chr21_100_hq_pe_indel.vcf
java -jar $GATK -T VariantFiltration -R ../genome/f000_chr21_ref_genome_sequence.fa -V 005-dna_chr21_100_he_pe.vcf --filterExpression "QD < 12.0" --filterName "LowConf" -o 006-dna_chr21_100_he_pe_filtered.vcf
grep LowConf 006-dna_chr21_100_he_pe_filtered.vcf | wc -l
