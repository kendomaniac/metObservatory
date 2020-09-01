#!/usr/bin/bash
IDCORE=extract_
IDTISSUE=bladder_
IDTYPE=bam
ID=$IDCORE$IDTISSUE$IDTYPE
WORKING_DIR=/scratch/adrenal_gland_bam_ok
SCRATCH_DIR=/home/rcaloger/data

FILE=$SCRATCH_DIR/extract.sh
/bin/cat <<EOM >$FILE
cd /scratch
/scripts/shrinkBam.py WORKING_DIR
EOM


docker run --cidfile=$SCRATCH_DIR/$ID -v $SCRATCH_DIR:/scratch  -d docker.io/repbioinfo/metobservatory_2020.04 /usr/bin/bash /scratch/extract.sh
