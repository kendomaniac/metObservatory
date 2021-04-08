#!/usr/bin/bash
IDCORE=docker_
IDTISSUE=bronchus_
IDTYPE=bam
ID=$IDCORE$IDTISSUE$IDTYPE
WORKING_DIR=/scratch/bronchus_and_lung_bam
SCRATCH_DIR=/home/rcaloger/data

FILE="/home/rcaloger/data/script.sh"
/bin/cat <<EOM >$FILE
cd $WORKING_DIR
/usr/local/bin/gdc-client download -m $WORKING_DIR/manifest.txt -t /scratch/gdc-user-token.2020-08-23065902.824Z.txt -n 16
cd /scratch
EOM


docker run --cidfile=$SCRATCH_DIR/$ID -v $SCRATCH_DIR:/scratch  -d docker.io/repbioinfo/metobservatory_2020.03 /usr/bin/bash /scratch/script.sh
