setwd("/Volumes/Elements/brain")
tmp <- read.table("gdc_manifest_20200710_091301.txt", sep="\t", header=T, stringsAsFactors = F)
dim(tmp)
downloaded <- dir(".")
`%!in%` = Negate(`%in%`)
tmp1 <- tmp[which(tmp$id %!in% downloaded),]
dim(tmp1)
write.table(tmp1, "gdc_manifest_20200710_091301bis.txt", sep="\t", row.names = F, quote=F)
