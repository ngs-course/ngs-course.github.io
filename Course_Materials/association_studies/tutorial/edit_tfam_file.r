##edit_tfam_file.r
##2013-12-17 dmontaner@cipf.es
##2014-06-10 dmontaner@cipf.es
## This script formats the Phenotype column of a tfam file.
## The script assigns values 1 and 2 consecutively to the individuals of the sample.
## This assignment is arbitrary and thus biologically meaningless. 
## It is just intended to be used as an example for the practical.

##' Remember: Phenotype (1=unaffected; 2=affected; 0 missing; -9=missing)
##' See http://pngu.mgh.harvard.edu/~purcell/plink/data.shtml#tr for details

##' Read the data
datos <- read.table (file = "f020_plink_format.tfam")
class (datos)
dim (datos)
datos[1:10,]

##' Assigning an _arbitrary_ Phenotype for the example
datos[,6] <- 1:2 ## NOTICE that the 1:2 vector gets "recycled" here

##' See the _imputed_ data frame
datos[1:10,]


##' Save a new file with the imputed column
write.table (datos, file = "f040_plink_format.tfam", quote = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE)
