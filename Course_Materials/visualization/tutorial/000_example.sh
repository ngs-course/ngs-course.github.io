cd /home/training/ngs_course/visualization
cd example_0
samtools index igv1.bam
igv.sh &
  - point to the left --> map reverse strand
  - point to the right --> map forward strand
  - Colour representation of the sequence
  - Zoom in --> Bases are shown
  - Amminoacids corresponding to each base
  - See all possible translation reading frames
  
  - High/low coverage
  - No coverage
  - RNA alignment against DNA, not cDNA
  - Complete grey reads --> no mismatches
  - Coloured bases --> Change
  - Reads are shadowed according to quality
  - Bases are also shadowed according to quality
  - Inspecting a SNP (``chr11:1,018,335-1,018,412``)
  - Inspecting a homozygous variant (``chr11:1,019,336-1,019,413``)
        - All reads support the variant but 1
        - The reference read quality is 0
  - File > Load from server > Annotations > Variation and repeats > dbSNP 1.3.7
