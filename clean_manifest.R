setwd("/home/rcaloger/data/bronchus_and_lung_bam")
tmp <- read.table("manifest.txt", sep="\t", header=T, stringsAsFactors = F)
dim(tmp)
downloaded <- dir(".")
`%!in%` = Negate(`%in%`)
tmp1 <- tmp[which(tmp$id %!in% downloaded),]
dim(tmp1)
write.table(tmp1, "manifest_bis.txt", sep="\t", row.names = F, quote=F)
