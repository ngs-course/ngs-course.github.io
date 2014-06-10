##explore_plink_pvalues.r
##2013-12-17 dmontaner@cipf.es
##2014-06-10 dmontaner@cipf.es
##explore p-value adjustment form plink in the association test results

##' See
##' http://pngu.mgh.harvard.edu/~purcell/plink/anal.shtml#cc
##' for details on the statistical analysis performed by PLINK.

datos <- read.table (file = "f060_res_plink.assoc.adjusted", header = TRUE, as.is = TRUE)
dim (datos)
datos[1:3,]
summary (datos)  ## Notice that there are no missing data.

colnames (datos)

##' Some plots
par (mfrow = c(2,3))
for (co in c ("BONF", "HOLM", "SIDAK_SS", "SIDAK_SD", "FDR_BH", "FDR_BY")) {
    print (co)
    plot (datos[,"UNADJ"], datos[,co], xlim = c(0,1), ylim = c(0,1), xlab = "unadjusted p-value", ylab = "adjusted p-value", main = co)
}
