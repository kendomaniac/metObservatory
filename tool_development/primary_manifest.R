# creates folders with manifests inside
#R CMD BATCH /scripts/primary_manifest.R

cat("\nThis script works in the folder mounted as /scratch\n")
mypath = "/scratch"

library(GenomicDataCommons)
if(GenomicDataCommons::status()$status!="OK"){
  stopifnot(GenomicDataCommons::status()$status=="OK")
  cat("\nGenomicDataCommons did not start!\n")
}

primary.site = cases() %>% facet('primary_site') %>% aggregations()
primary.site <- primary.site[[1]]
cat("\nOnly primary sites with at least 50 samples are considered\n")
primary.site <- primary.site[which(primary.site$doc_count >= 50),]
primary.site <- primary.site[which(primary.site$key != "other and ill-defined digestive organs"),]

setwd(mypath)
for(i in primary.site$key){
  mysite = i
  myfolderbam = paste(gsub(" ", "_", mysite), "bam", sep="_")
  myfoldervcf = paste(gsub(" ", "_", mysite), "vcf", sep="_")
  myfolderbam = paste(mypath, myfolderbam, sep="/")
  myfoldervcf = paste(mypath, myfoldervcf, sep="/")
  dir.create(myfolderbam)
  dir.create(myfoldervcf)
  
  cat("\ncreating vcf manifest in ", myfoldervcf,"\n")
  setwd(myfoldervcf)
  vcf_manifest = files() %>% 
    filter(cases.primary_site == mysite
           & data_format == 'vcf'
           & data_category == 'simple nucleotide variation'
           & experimental_strategy == 'WXS'
           & analysis.workflow_type == 'MuTect2')  %>%
    manifest()
  write.table(vcf_manifest, "manifest.txt", sep="\t", row.names = F, quote=F)

  cat("\ncreating bam manifest in ", myfolderbam,"\n")
  setwd(myfolderbam)
  bam_manifest = files() %>%
    filter(cases.primary_site == mysite
           & data_format == 'bam'
           & data_category == 'sequencing reads'
           & experimental_strategy == 'RNA-Seq')  %>%
    manifest()
  #head(bam_manifest)
  bam_manifest <- bam_manifest[grep("_gdc_realn_rehead.bam$", bam_manifest$filename),]
  #bam.names <- sub(".rna_seq.genomic.gdc_realn.bam", "", bam_manifest$filename)
  write.table(bam_manifest, "manifest.txt", sep="\t", row.names = F, quote=F)
  
  setwd(mypath)
}
cat("\nCheck the primary_manifest.Rout to see that all folders were created without errors\n")