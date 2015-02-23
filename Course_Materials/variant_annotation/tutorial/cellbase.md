% [NGS data analysis course](http://ngscourse.github.io/)
% __Variant annotation__
% _(updated 29-09-2014)_

<!-- COMMON LINKS HERE -->

[CellBase]: https://github.com/opencb/cellbase "CellBase"


Preliminaries
================================================================================


Software used in this practical:
--------------------------------

- [CellBase][CellBase] : a complete suite of tools to work with genomic variation data, from VCF tools to variant profiling or genomic statistics.


File formats explored:
----------------------

- VCF Variant Call Format

Variant annotation with HPG-Variant
================================================================================

Copy the necessary data in your working directory:

    mkdir -p /home/participant/cambridge_mda/
    cp -r /home/participant/Desktop/Open_Share/annotation /home/participant/cambridge_mda/
    cd /home/participant/cambridge_mda/annotation/
    
Download CellbaseCode:

    git clone https://github.com/opencb/cellbase.git

Exercise 1: Working with HPG-Variant
================================================================================

Getting the effect of variants
--------------------------------------------------------------------------------

To run the variant effect annotation tool you need the CellBase commandline. You only have to execute this command line to fetch annotations:

    mkdir cellbase_results
    cellbase-app/build/bin/cellbase.sh query --variant-annot --input-file /home/participant/cambridge_mda/annotation/hpg-variant/examples/CEU.exon.2010_03.genotypes.vcf --output-file /home/participant/cambridge_mda/annotation/cellbase_results/CEU.exon.2010_03.annotated.vep --host-url wwwdev.ebi.ac.uk --species "Homo sapiens"

A new file `/home/participant/cambridge_mda/annotation/cellbase_results/CEU.exon.2010_03.annotated.vep` has been created containing the list of annotations in VEP format.