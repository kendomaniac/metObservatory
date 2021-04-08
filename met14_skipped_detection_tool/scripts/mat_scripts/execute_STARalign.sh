#!/bin/bash
IDCORE=align_
IDTISSUE=STAR_
IDTYPE=BAM
ID=$IDCORE$IDTISSUE$IDTYPE
SCRATCH_DIR=$1
WORKING_DIR=$2
NTHREAD=$3

FILE=$SCRATCH_DIR$WORKING_DIR/STARalign.sh
/bin/cat <<EOM >$FILE
cd /scratch$WORKING_DIR
for i in */
do
echo "Starting alignment on sample \$i."
cd /scratch$WORKING_DIR/\$i
/STAR/source/STAR --runThreadN $NTHREAD --genomeDir /scratch/genome/hg38_full_103 --readFilesIn *.R1.fastq *.R2.fastq --outFileNamePrefix /scratch$WORKING_DIR/\$i/ --outSAMtype BAM Unsorted
samtools sort Aligned.out.bam > Aligned.sorted.bam
rm Aligned.out.bam
samtools index Aligned.sorted.bam
echo "Sample \$i done."
done
EOM

# change the name of the image to the tag you selected on build
docker run --cidfile=$SCRATCH_DIR$WORKING_DIR/$ID -v $SCRATCH_DIR:/scratch docker.io/repbioinfo/metobservatory.2021.01 /usr/bin/bash /scratch$WORKING_DIR/STARalign.sh
