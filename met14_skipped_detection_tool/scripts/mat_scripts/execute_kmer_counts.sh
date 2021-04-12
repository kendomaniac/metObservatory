#!/bin/bash
IDCORE=extract_
IDTISSUE=kmer_
IDTYPE=counts
ID=$IDCORE$IDTISSUE$IDTYPE
SCRATCH_DIR=$1
WORKING_DIR=$2


FILE=$SCRATCH_DIR$WORKING_DIR/kmerCounts.R
/bin/cat <<EOM >$FILE
setwd("/scratch$WORKING_DIR")

relation=read.table("kmer_relMat.txt",header=TRUE,sep="\t",stringsAsFactors=FALSE)
kmers=unique(relation[,2])

folders=list.dirs(recursive=FALSE)
folders=sub("./", "", folders)

mat=matrix(nrow=length(kmers), ncol=length(folders), 0)
rownames(mat)=kmers
colnames(mat)=folders

for (i in folders) {
  cat("Starting work on ",i, "\n", sep="")
  file=as.matrix(read.table(paste(i, "kmer_table_16.txt", sep="/"),header=FALSE,row.names=1,sep="\t"))
  mat[names(file[which(row.names(file) %in% row.names(mat)),]),i]=as.numeric(file[which(row.names(file) %in% row.names(mat))])
  cat("Done work on ",i, ".\n", sep="")
}
write.table(mat, "kmer_count_matrix.txt", sep="\t", col.names=NA, row.names=TRUE)

mat2=t(t(mat)/colSums(mat)*100)
mat2=mat2[c(relation[grep("13",relation[,1]),2],relation[grep("14",relation[,1]),2],relation[grep("15",relation[,1]),2]),]

write.table(mat2, "kmer_freq_matrix.txt", sep="\t", col.names=NA, row.names=TRUE)

cat("Kmer matrix creation completed",sep="")
EOM

# change the name of the image to the tag you selected on build
docker run --cidfile=$SCRATCH_DIR$WORKING_DIR/$ID -v $SCRATCH_DIR:/scratch docker.io/repbioinfo/metobservatory.2021.01 Rscript /scratch$WORKING_DIR/kmerCounts.R
