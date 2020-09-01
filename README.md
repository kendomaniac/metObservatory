# metObservatory
Infrastructure to acquire information on Met gene

To build the image, stay in metObservatory folder and execute:

```
docker build --tag docker.io/repbioinfo/metobservatory_2020.03 .

```

## software

### primary.R

It creates two folders for each tumor primary site in the TCGA, one for bam files and another for vcf files. The above folders are created in /scratch folder, which is the mounting point to a disk where you wish to download TCAG data. In each folder there is a manifest file to retrieve respectively RNAseq STAR 2 steps bam files or MuTect2 vcf for each sample in the manifest files.

```
ID=$(docker run -i -t -d -v /somewhere/in/your/computer:/scratch \ 
docker.io/repbioinfo/metobservatory_2020.02 /bin/bash)
docker attach $ID
R CMD BATCH /scripts/primary.R
```

Check primary.Rout to be sue that all folders manifests were correctly crerated.


### gdc-client

TCGA application to download data from TCGA, it requires a manifest and a user token.

- start a docker istance:

```
ID=$(docker run -i -t -d -v /somewhere/in/your/computer:/scratch \ 
docker.io/repbioinfo/metobservatory_2020.04 /bin/bash)
docker attach $ID
```

- locate your working directory in the folder where the manifest of interest is present:
    
 ``` 
 cd /scratch/adrenal_gland_bam/
/usr/local/bin/gdc-client download -m ./manifest.txt -t ../gdc-user-token.2020-08-17XXX_YY_ZZ.NNNN.txt -n 16
```

- as other option you can run the gdc-client outside docker editing and running the script executing_docker_gdc_download.sh

		+ copy executing_docker_gdc_download.sh in the local folder mounted as /scratch e.g. /home/rcaloger/data/
		
		+ edit the script changing IDTISSUE, IDTYPE, WORKING_DIR and SCRATCH_DIR

 ``` 
 #!/usr/bin/bash
 IDCORE=docker_
 IDTISSUE=bronchus_
 IDTYPE=bam
 ID=$IDCORE$IDTISSUE$IDTYPE
 WORKING_DIR=/scratch/bronchus_and_lung_bam
 SCRATCH_DIR=/home/rcaloger/data/
 
 ID is the dockerid that is saved in the upper folder with respect to the working dir the default is /home/rcaloger/data/
 /home/rcaloger/data/ is mounted as /scratch in the docker
 
 WORKING_DIR is one folder created by primary.R
  
```

### extract Met and all chimeric reads

This is a python script that extract reads at the Met locus using samtools, then uses a specific c++ program to extract all reads which are not mapped or chimeric.

- start a docker istance:

```
ID=$(docker run -i -t -d -v /home/rcaloger/data:/scratch  \ 
docker.io/repbioinfo/metobservatory_2020.04 /bin/bash)
docker attach $ID
```

- locate your working directory upstream the folder where the bam downloaded with the manifest of interest are present, e.g. adrenal_gland_bam_ok:
    
 ``` 
 cd /scratch/
/scripts/shrinkBam.py /scratch/adrenal_gland_bam_ok
```

- as other option you can run the gdc-client outside docker editing and running the script executing_docker_met_others.sh

		+ copy executing_docker_met_others.sh in the local folder mounted as /scratch e.g. /home/rcaloger/data/
		
		+ edit the script changing IDTISSUE, IDTYPE, WORKING_DIR and SCRATCH_DIR

 ``` 
 #!/usr/bin/bash
 IDCORE=extract_
 IDTISSUE=adrenal_
 IDTYPE=bam
 ID=$IDCORE$IDTISSUE$IDTYPE
 WORKING_DIR=/scratch/adrenal_gland_bam_ok
 SCRATCH_DIR=/home/rcaloger/data/
 
 ID is the dockerid that is saved in the upper folder with respect to the working dir the default is /home/rcaloger/data/
 /home/rcaloger/data/ is mounted as /scratch in the docker
 
 WORKING_DIR is one folder created by primary.R
  
```

- execute locally executing_docker_met_others.sh e.g. /home/rcaloger/data/