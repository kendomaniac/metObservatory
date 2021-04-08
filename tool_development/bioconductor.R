update.packages(ask = FALSE)

if (!require("BiocManager"))
  install.packages("BiocManager")
BiocManager::install('GenomicDataCommons')
