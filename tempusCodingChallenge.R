rm(list=ls(all=TRUE))
###
library("vcfR")

#make sure challenge_data-2.vcf and R code are in the same folder.
#read vcf data using in-built function in R
data <- read.vcfR("Challenge_data-2.vcf")
data.tidy <- vcfR2tidy(data)
names(data.tidy)

#The data(variant information, meta and gt) is retrieved in separate variables. 
data.fix <- data.tidy$fix
meta <- data.tidy$meta
gt <- data.tidy$gt
 
#extract necessary variant information and store in annotate variable.
annotate <- data.fix[ ,c(1:6)]
annotate <- cbind(annotate, data.fix[,c('TYPE', 'DP', 'AF')])

#gt has normal and vaf5 Indiv. I am not sure which one should be considered for retrieving gt_DP.
gt_DP <- gt[gt[,'Indiv'] == 'normal',]
annotate <- cbind(annotate, gt_DP[,'gt_DP'])

#compute % of reads supporting the variant vs reads supporting reference reads.
annotate <- cbind(annotate, 'Percent gt_DP/DP')
annotate[,11] <- (annotate[, 'gt_DP']/annotate[,'DP'])*100

colnames(annotate) <- c("ChromKey", "CHROM", "POS","ID" , "REF", "ALT", "TYPE", "Depth Seq Coverage(DP)", 
                        "Allele Frequency(AF)", "Reads supporting the variant(gt_DP)", "Percent gt_DP vs DP")

#print 'annotate' to view the annoated information for each variant 
print(annotate)
