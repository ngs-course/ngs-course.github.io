% [NGS data analysis course](http://ngscourse.github.io/)
% __Association__
% _(updated 21-10-2015)_

<!-- COMMON LINKS HERE -->

[RvTests]: http://zhanxw.github.io/rvtests/ "RvTests"

Preliminaries
================================================================================

Software used in this practical:
--------------------------------

- [RvTests] : package for genetic association studies. It is designed to support unrelated individual or related (family-based) individuals. Both quantitative trait and binary trait are supported.


File formats explored:
----------------------

- VCF Variant Call Format: see [1000 Genomes](http://www.1000genomes.org/wiki/analysis/variant-call-format/vcf-variant-call-format-version-42) and [Wikipedia](http://en.wikipedia.org/wiki/Variant_Call_Format) specifications.
- PED File


Exercise: Analysis of rare variant
================================================================================

Directory used for the tutorials:

<!--    cd /home/participant/Desktop/Course_Materials/calling -->

    cd /home/training/ngs_course/association

In this practical we are going to use a tool called RvTests. Let's see how to run it:

	~/soft/rvtests/rvtest --help


# Single Variant tests
Test every variant individually for association with the disease/trait. The phenotype can be binary (case/control) or quantitative.

|Single variant | Model | Traits(\*) | Covariates | Related / unrelated | Description |
|:::|:::|:::|:::|:::|
|Score test | score | B, Q | Y | U | Only null model is used to performed the test | 
|Wald test | wald | B, Q | Y | U | Only fit alternative model, and effect size will be estimated | 
|Exact test | exact | B | N | U | Fisher's test | 
|Fam LRT | famLRT | Q | Y | R, U | Fast-LMM model | 
|Fam Score | famScore | Q | Y | R, U | Fast-LMM model style likelihood ratio test | 
|Grammar-gamma | famGrammarGamma | Q | Y | R, U | Grammar-gamma method |
|Firth regression | firth | B | Y | U | Logistic regression with Firth correction by David Firth, discussed by Clement Ma. |

(\*) In trait column, B and Q stand for binary, quantitate trait.

## Related individual test
To test related individuals, you will need to first create a kinship matrix. The tool to do it is called `vcf2kinship`.

	~/soft/rvtests/vcf2kinship --help

Let's compute the kinship matrix:

	~/soft/rvtests/vcf2kinship \
	    --inVcf 4Kvariants_147samples.vcf.gz \
	    --ped 4Kvariants_147samples.ped \
	    --ibs \
	    --out 4Kvariants_147samples

	head -n 10 4Kvariants_147samples.kinship | cut -f 1-10

Then we can use linear mixed model based association tests such as Fast-LMM score test, Fast-LMM LRT test and Grammar-gamma tests. **These models only work when the studied phenotype is quantitative**.

	~/soft/rvtests/rvtest \
    	--inVcf 4Kvariants_147samples.vcf.gz \
    	--pheno 4Kvariants_147samples.ped \
    	--out 4Kvariants_147samples \
    	--kinship 4Kvariants_147samples.kinship \
    	--single famScore,famLRT,famGrammarGamma

	head 4Kvariants_147samples.FamScore.assoc


## Unrelated single variant test

	~/tools/rvtests/rvtest \
	    --inVcf 4Kvariants_147samples.vcf.gz \
	    --pheno 4Kvariants_147samples.ped \
	    --out 4Kvariants_147samples \
	    --single score,wald,exact

	head 4Kvariants_147samples.SingleWald.assoc

Do we have any significant variants?

	awk -F'\t' '{if ($9 <= 0.05) print $0}' 4Kvariants_147samples.SingleWald.assoc | sort -k 9
	
	! awk -F'\t' '{if ($9 <= 0.05) print $0}' 4Kvariants_147samples.SingleScore.assoc | sort -k 9

# Groupwise tests
Groupwise tests includes three major kinds of tests.

* **Burden tests**: group variants, which are usually less than 1% or 5% rare variants, for association tests. The category includes: CMC test, Zeggini test, Madsen-Browning test, CMAT test, and rare-cover test.
* **Variable threshold tests**: group variants under different frequency thresholds.
* **Kernel methods**: suitable to tests rare variants having different directions of effects. These includes SKAT test and KBAC test.

**Burden tests**

| Burden tests | Model | Traits | Covariates | Related / unrelated | Description |
|---|---|---|---|---|---|
| CMC | cmc | B, Q | N | U | Collapsing and combine rare variants by Bingshan Li. |
| Zeggini | zeggini | B, Q | N | U | Aggregate counts of rare variants by Morris Zeggini. |
| Madsen-Browning | mb | B | N | U | Up-weight rare variant using inverse frequency from controls by Madsen. |
| Fp | fp | B | N | U | Up-weight rare variant using inverse frequency from controls by Danyu Lin. |
| Exact CMC | exactCMC | B | N | U | Collapsing and combine rare variants, then perform Fisher's exact test. |
| RareCover | rarecover | B | N | U | Find optimal grouping unit for rare variant tests by Thomas Hoffman. |
| CMAT | cmat | B | N | U | Test non-coding variants by Matt Z. |
| CMC Wald | cmcWald | B, Q | N | U | Collapsing and combine rare variants, then perform Wald test. |


**Variable threshold models**

| Single variant | Model | Traits | Covariates | Related / unrelated | Description |
|---|---|---|---|---|---|
| Variable threshold model | vt | B, Q | N | U | Every rare-variant frequency cutoffs are tests by Alkes Price. |
| Variable threshold CMC | cmc | B, Q | N | U | This models is native so that it output CMC test statistics under all possible frequency cutoffs. |


**Kernel models**

| Kernel | Model | Traits | Covariates | Related / unrelated | Description |
|---|---|---|---|---|---|
| SKAT | skat | B, Q | Y | U | Sequencing kernel association test by Shawn Lee. |
| KBAC | kbac | B | N | U | Kernel-based adaptive clustering model by Dajiang Liu. |

All above tests requires to group variants into a unit. The simplest case is to use gene as grouping unit. 

RvTests expects a [refFlat](http://genome.ucsc.edu/goldenpath/gbdDescriptionsOld.html#RefFlat) file when using gene grouping units. These are the fields included in a refFlat format:

* Name of gene as it appears in Genome Browser
* Name of gene
* Chromosome name
* "+" or "-" for strand
* Transcription start position
* Transcription end position
* Coding region start
* Coding region end
* Number of exons
* Exon start positions
* Exon end positions


    zcat refFlat_hg19.txt.gz | head
	
	~/soft/rvtests/rvtest \
	    --inVcf 4Kvariants_147samples.vcf.gz \
	    --pheno 4Kvariants_147samples.ped \
	    --out burden_out \
	    --geneFile refFlat_hg19.txt.gz \
	    --burden cmc \
		
