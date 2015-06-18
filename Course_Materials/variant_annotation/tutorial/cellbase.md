% [NGS data analysis course](http://ngscourse.github.io/)
% __Variant annotation__
% _(updated 15-06-2015)_

<!-- COMMON LINKS HERE -->

[CellBase]: https://github.com/opencb/cellbase "CellBase"


Preliminaries
================================================================================


Software used in this practical:
--------------------------------

- [CellBase][CellBase] : is a database that integrates the most relevant biological information. A command line is provided which enables efficient access to all these data for variant annotation purposes.


File formats explored:
----------------------

- VCF Variant Call Format

Variant annotation with CellBase
================================================================================

Copy the necessary data in your working directory:

    mkdir -p /home/participant/cambridge_mda/
    cp -r /home/participant/Course_Materials/annotation /home/participant/cambridge_mda/
    cd /home/participant/cambridge_mda/annotation/cellbase
    export PATH=$PATH:/home/participant/cambridge_mda/annotation/cellbase/cellbasedevelop/bin

Exercise 1: Working with CellBase annotator
================================================================================

Showing CellBase options
--------------------------------------------------------------------------------

    cellbase.sh -h
    
Getting the annotation of variants
--------------------------------------------------------------------------------

Have a look at variant-annotation parameters:

    cellbase.sh variant-annotation -h
    
You only have to execute this command line to fetch annotations:

    mkdir results    
    cellbase.sh variant-annotation -i /home/participant/cambridge_mda/annotation/cellbase/examples/CEU.exon.2010_03.genotypes.vcf \
    -o /home/participant/cambridge_mda/annotation/cellbase/results/CEU.exon.2010_03.annotated.vep -s hsapiens -u bioinfodev.hpc.cam.ac.uk -L debug

There are almost 4K variants in the input file, it may take few seconds to finish. A new file `/home/participant/cambridge_mda/annotation/cellbase/results/CEU.exon.2010_03.annotated.vep` will be created containing the list of annotations in VEP format.

Have a look at the results:

    less /home/participant/cambridge_mda/annotation/cellbase/results/CEU.exon.2010_03.annotated.vep
    
Run now almost the same command, just changing the suffix of the output file:

    cellbase.sh variant-annotation -i /home/participant/cambridge_mda/annotation/cellbase/examples/CEU.exon.2010_03.genotypes.vcf \
    -o /home/participant/cambridge_mda/annotation/cellbase/results/CEU.exon.2010_03.annotated.json -s hsapiens -u bioinfodev.hpc.cam.ac.uk -L debug
    
A new file `/home/participant/cambridge_mda/annotation/cellbase/results/CEU.exon.2010_03.annotated.json` will be created. This file has JSON format, which is a quite popular format in Bioinformatics. Have a look at the file:

    less /home/participant/cambridge_mda/annotation/cellbase/results/CEU.exon.2010_03.annotated.json
    
Quite an ugly text. Nevertheless, it is a really useful format for bioinformaticians since parsing this file format is trivial from a programming point of view. Python, R, Java provide programming libraries which make this files to be extremely easy to use.

Get variants with clinical information:

    grep -v "Clinvar\"\:null" /home/participant/cambridge_mda/annotation/cellbase/results/CEU.exon.2010_03.annotated.json | head
    
Select and copy (right mouse button->Copy) one line from the above result. Go to http://jsoneditoronline.org/, paste into the left text-box and click on the ">" arrow. Parsed text should appear on the right box.

Try to annotate the file `/home/participant/cambridge_mda/annotation/cellbase/results/CHB.exon.2010_03.sites.vcf`.

