#!/bin/bash
IDCORE=generate_
IDTISSUE=hg38_
IDTYPE=genome
ID=$IDCORE$IDTISSUE$IDTYPE
SCRATCH_DIR=$1
WORKING_DIR=/genome
NTHREAD=$2

FILE=$SCRATCH_DIR$WORKING_DIR/genomeGenerate.sh
/bin/cat <<EOM >$FILE
cd /scratch/$WORKING_DIR
wget http://ftp.ensembl.org/pub/release-103/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
gunzip Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
/STAR/source/STAR --runThreadN $NTHREAD --runMode genomeGenerate --genomeDir hg38_full_103 --genomeFastaFiles Homo_sapiens.GRCh38.dna.primary_assembly.fa
rm Homo_sapiens.GRCh38.dna.primary_assembly.fa
EOM

# change the name of the image to the tag you selected on build
docker run --cidfile=$SCRATCH_DIR$WORKING_DIR/$ID -v $SCRATCH_DIR:/scratch docker.io/repbioinfo/metobservatory.2021.01 /usr/bin/bash /scratch$WORKING_DIR/genomeGenerate.sh
