#!/bin/bash
IDCORE=extract_
IDTISSUE=pos_
IDTYPE=counts
ID=$IDCORE$IDTISSUE$IDTYPE
SCRATCH_DIR=$1
WORKING_DIR=$2


FILE=$SCRATCH_DIR$WORKING_DIR/allPosCounts.R
/bin/cat <<EOM >$FILE
setwd("/scratch$WORKING_DIR")

positions=c(116771498:116771654, 116771849:116771989,116774881:116775111)

folders=list.dirs(recursive=FALSE)
folders=sub("./", "", folders)

mat=matrix(nrow=length(positions), ncol=length(folders), 0)
rownames(mat)=positions
colnames(mat)=folders

for (i in folders) {
  file=readLines(paste(i, "met.sam", sep="/"))
  cat("Starting work on ",i, "\n", sep="")
  for (j in file) {
    file=strsplit(j, "\t")
    left_window=as.numeric(file[[1]][8])
    right_window=as.numeric(file[[1]][8])+nchar(file[[1]][10])
    read_window=c(left_window, right_window)
    read_positions=left_window:right_window
    read_positions=read_positions[read_positions %in% positions]
    mat[as.character(read_positions), i]=mat[as.character(read_positions), i] + 1
  }
  cat("Done work on ",i, ".\n", sep="")
}
write.table(mat, "pos_count_matrix.txt", sep="\t", col.names=NA, row.names=TRUE)
EOM

# change the name of the image to the tag you selected on build
docker run --cidfile=$SCRATCH_DIR$WORKING_DIR/$ID -v $SCRATCH_DIR:/scratch docker.io/repbioinfo/metobservatory.2021.01 Rscript /scratch$WORKING_DIR/allPosCounts.R
