#!/usr/bin/bash
IDCORE=count_
IDTISSUE=bronchus_
IDTYPE=kmers
ID=$IDCORE$IDTISSUE$IDTYPE
KMER_SIZE=31 # K-mer size can go up to a maximum of 31, to get bigger k-mers we have to make BFCounter again
KMER_NUM=1000000 # estimated number of k-mers as an upper bound, required by BFCounter to work
SCRATCH_DIR=/home/user/data # local path to the files
WORKING_DIR=/bronchus_and_lung/met_benchmarks/delta14 # path from the location we use as scratch directory to the folder containing the fastq.gz files

FILE=$SCRATCH_DIR$WORKING_DIR/BFCounter_script.sh
/bin/cat <<EOM >$FILE
cd /scratch$WORKING_DIR
for i in *.fastq.gz # cycles through all the fastq.gz files in the folder (to account for the 2 reads)
do
BFCounter count -k $KMER_SIZE -n $KMER_NUM -o \$i.hash \$i # need to select the k-mer size (-k) and the estimated maximum number of k-mers (-n)
BFCounter dump -k $KMER_SIZE -i \$i.hash -o \$i.txt # input the same -k used for the previous step. This step converts output of count into a tab-separated file
rm \$i.hash # optional step to remove the output of count. Comment it out to keep the count output
done
EOM

# change the name of the image to the tag you selected on build
docker run --cidfile=$SCRATCH_DIR$WORKING_DIR/$ID -v $SCRATCH_DIR:/scratch  -d docker.io/repbioinfo/metobservatory_2020.05 /usr/bin/bash /scratch$WORKING_DIR/BFCounter_script.sh
