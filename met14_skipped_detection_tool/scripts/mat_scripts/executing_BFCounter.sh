#!/bin/bash

# the script executes the concatenation of the two reads for each sample and runs BFCounter on it, providing a single table as output

IDCORE=count_
IDTISSUE=met_
IDTYPE=kmers
ID=$IDCORE$IDTISSUE$IDTYPE
KMER_NUM=10000000
SCRATCH_DIR=$1
WORKING_DIR=$2

FILE=$SCRATCH_DIR$WORKING_DIR/BFCounter_script.sh
/bin/cat <<EOM >$FILE
cd /scratch$WORKING_DIR
for i in */
do
echo "Starting to extract MET kmers for \$i."
cd /scratch$WORKING_DIR/\$i/met_fastq
cat *.fastq > temp
rm *.fastq
mv temp temp.fastq
BFCounter count -k 16 -n $KMER_NUM --verbose -o temp.hash temp.fastq &> /scratch$WORKING_DIR/\$i/BFCounter_stats_16.txt
BFCounter dump -k 16 -i temp.hash -o /scratch$WORKING_DIR/\$i/kmer_table_16.txt
cd /scratch$WORKING_DIR/\$i
rm -r met_fastq
echo "Extraction of MET kmers for \$i done."
done
EOM

# change the name of the image to the tag you selected on build
docker run --cidfile=$SCRATCH_DIR$WORKING_DIR/$ID -v $SCRATCH_DIR:/scratch docker.io/repbioinfo/metobservatory.2021.01 /usr/bin/bash /scratch$WORKING_DIR/BFCounter_script.sh
