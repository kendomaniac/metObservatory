#!/bin/bash
IDCORE=extract_
IDTISSUE=Met_
IDTYPE=SAM
ID=$IDCORE$IDTISSUE$IDTYPE
SCRATCH_DIR=$1
WORKING_DIR=$2

FILE=$SCRATCH_DIR$WORKING_DIR/metExtract.sh
/bin/cat <<EOM >$FILE
cd /scratch$WORKING_DIR
for i in */
do
echo "Starting met.sam extraction on sample \$i."
cd /scratch$WORKING_DIR/\$i
samtools view Aligned.sorted.bam 7:116672196-116798377 > met.sam
samtools idxstats Aligned.sorted.bam > stats.txt
echo "Sample \$i done."
done
EOM

# change the name of the image to the tag you selected on build
docker run --cidfile=$SCRATCH_DIR$WORKING_DIR/$ID -v $SCRATCH_DIR:/scratch docker.io/repbioinfo/metobservatory.2021.01 /usr/bin/bash /scratch$WORKING_DIR/metExtract.sh
