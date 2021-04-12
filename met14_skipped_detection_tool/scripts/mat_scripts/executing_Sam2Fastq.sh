#!/bin/bash
IDCORE=extraction_
IDTISSUE=met_
IDTYPE=fastq
ID=$IDCORE$IDTISSUE$IDTYPE
SCRATCH_DIR=$1
WORKING_DIR=$2

FILE=$SCRATCH_DIR$WORKING_DIR/Sam2Fastq.sh
/bin/cat <<EOM >$FILE
cd /scratch$WORKING_DIR
for i in */
do
echo "Starting extraction of MET fastqs in \$i."
cd /scratch$WORKING_DIR/\$i
mkdir met_fastq
cat /scratch$WORKING_DIR/\$i/met.sam | grep -v ^@ | awk 'NR%2==1 {print "@"\$1"\\n"\$10"\\n+\\n"\$11}' > /scratch$WORKING_DIR/\$i/met_fastq/met.R1.fastq
cat /scratch$WORKING_DIR/\$i/met.sam | grep -v ^@ | awk 'NR%2==0 {print "@"\$1"\\n"\$10"\\n+\\n"\$11}' > /scratch$WORKING_DIR/\$i/met_fastq/met.R2.fastq
echo "Extraction of MET fastqs in \$i done."
done
EOM

# change the name of the image to the tag you selected on build
docker run --cidfile=$SCRATCH_DIR$WORKING_DIR/$ID -v $SCRATCH_DIR:/scratch docker.io/repbioinfo/metobservatory.2021.01 /usr/bin/bash /scratch$WORKING_DIR/Sam2Fastq.sh
