##edgeR_example.r
##2014-12-09 dmontaner@cipf.es
##We use edgeR to perform a differential gene expression analysis

##' clean the working space
rm (list = ls ())

##' load the library
library (edgeR)

##' prepare some variables
myfiles <- c ("g041_case.count", "g042_case.count", "g043_case.count", "g044_cont.count", "g045_cont.count", "g046_cont.count")
myclass <- c ("case", "case", "case", "cont", "cont", "cont")
mylabel <- c ("case1", "case2", "case3", "cont1", "cont2", "cont3")

cbind (myfiles, myclass, mylabel)

datos <- readDGE (files = myfiles, group = myclass, labels = mylabel)
class (datos)
datos
dim (datos)

##' Check that the counts are read properly:
##' from the shell:
##'    grep ENSG00000141959 g04*
system ("grep ENSG00000141959 g04*")

##' You can access to the full data matrix doing
datos$counts

##'As you can see their are some undesirable rows at the end.
tail (datos$counts)

##' We can exclude them
malos <- grepl ("_", rownames (datos$counts), )
table (malos)
datos[malos,]

datos <- datos[!malos,]
dim (datos)

##' now the last rows have been removed
tail (datos$counts)


##' We can compute counts per million
cpms <- cpm (datos)
summary (cpms)

##' cpms are very small in this example dataset.
##' We will not do it but generally,
##' features with less than 1 read per million are excluded form the analysis.

##' When gene lengths are available RPKMs can be computed using the function "rpkm"


##' Now we can start computing differential expression.
##' Fists we create a "DGEList" object:
dgeL <- DGEList (counts = datos, group = datos$samples$group)
dgeL
class (dgeL)

##' and compute normalization factors
dgeN <-  calcNormFactors (dgeL)
dgeN


##' We can explore the "relationship" between the samples
##' in a PCA wise plot
plotMDS (dgeN)

##' Now we will estimate dispersion 
dgeD <- estimateCommonDisp (object = dgeN)
dgeD
dgeD <- estimateTagwiseDisp (object = dgeN)
dgeD


##' And finally we perform the statistical test
res <- exactTest (dgeD)
class (res)
res

##' You can find the most significant genes 
topTags (res)


##'Find out all significant genes
padj <- p.adjust (res$table$PValue, "BH")
touse <- padj < 0.05
table (touse)
res[touse,]$table

## What does it mean the sign of the logFC?
