##explore_plink_results.r
##2013-12-17 dmontaner@cipf.es
##2014-06-10 dmontaner@cipf.es
##explore plink results from an association test

##' See
##' http://pngu.mgh.harvard.edu/~purcell/plink/anal.shtml#cc
##' for details on the statistical analysis performed by PLINK.

##' Read the data
datos <- read.table (file = "f060_res_plink.assoc", header = TRUE, as.is = TRUE)
dim (datos)
datos[1:3,]
summary (datos)  ## some field have missing (NA) values


##' Remove SNPs for which the test did not work;
##' those for which the p-value or the OR did not work...
touse <- !is.na (datos[,"OR"])
table (touse)

datos <- datos[touse,]
dim (datos)
summary (datos)


##' What is the Odds Ratio (OR column)
plot (datos[,"F_A"] / datos[,"F_U"], datos[,"OR"])
abline (0, 1, col = "red")


##' How is the p-value distribution
hist (datos[,"P"])
abline (v = 0.05, col = "red")

##' Does it seem UNIFORM?
my.random.p <- runif (nrow (datos))
hist (my.random.p)
abline (v = 0.05, col = "red")


##' What is the p-value relationship with the CHISQ statistic
plot (datos[,"CHISQ"], datos[,"P"])


##' What is the p-value relationship with the OR
plot (datos[,"OR"], datos[,"P"])
abline (v = 1, col = "blue")


##' In the previous plot you can see how the Odds Ratio distribution
##' is [skewed to the right](http://en.wikipedia.org/wiki/Skewness).
##' Usually log Odds Ratio is preferred.
plot (log (datos[,"OR"]), datos[,"P"])
abline (v = 0, col = "blue")

##' And the relationship between the OR and the test statistic
plot (log (datos[,"OR"]), datos[,"CHISQ"])
abline (v = 0, col = "blue")


##' How many SNPs are significant?
##' According to the standard 0.05 threshold:
table (datos[,"P"] < 0.05)

##' In percentage
100 * table (datos[,"P"] < 0.05) / nrow (datos)

##' Compare with randomly generated p-values
100 * table (my.random.p < 0.05) / nrow (datos)


##' Perform a FDR p.value correction for multiple testing
padj <- p.adjust (datos[,"P"], method = "fdr")

##' and explore the corrected p-values
table (padj < 0.05)

par (mfrow = c(1,2))
boxplot (cbind (p = datos[,"P"], padj))
plot (datos[,"P"], padj, xlim = c(0,1), ylim = c(0,1))
