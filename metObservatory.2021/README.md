# metObservatory.2021
Pipeline to predict if a sample presents skipping of Exon 14 in MET, starting from FASTQ files.

To build the image, stay in the metObservatory.2021 folder and execute:

```
docker build --tag docker.io/repbioinfo/metobservatory.2021.01 .

```

## software

### run_metObs.R

This script handles the entirety of the operations of metObservatory.2021.

To operate it, the user has to procure the script itself and the related dependencies. To do so start an instance of the metObservatory.2021 container taking care to add a local folder as a mounted volume to move the scripts to using the following command:

```
docker run -ti -v /path/to/local/folder:/scratch docker.io/repbioinfo/metobservatory.2021 /bin/bash
```

Then navigate to the /scripts folder in the container and copy the scripts_package.tar file into /scratch in this manner:

```
cd /scripts
cp scripts_package /scratch
```

At this point the container can be exited and the tar file should be decompressed.

The script can be launched using the following command:

```
cd /path/to/script
Rscript run_metObs.R
```

Before launching it, the user should open the file and define the five parameters that describe its behaviour.

- Path

```
define the scratch and data folders
scratch ="/path/to/scratch/folder"
data ="/path/from/scratch/to/data"
```

This block described the paths that the script will operate on.
"Scratch" is the folder that will contain all the elements needed for the analysis, it will contain the genome generate during it, the temporary files for the neural network analysis and the results of the anlysis itself.

Before running the script, the user should place inside of the "scratch" directory another directory containing the data they want to analyse. The name of this directory should be declared in the "data" field. 

If the "scratch" directory is "/home/user/metObs" and the name of the "data" directory is "data_folder", the block should look like this:

```
define the scratch and data folders
scratch = "/home/user/metObs"
data ="data_folder"
```

Inside of the "data" directory, each sample should be located in its own folder. The only sub-directories of "data" should be sample folders.

- Mode

```
define the mode of operations of the application between "setup" and "predict"
run_mode = "setup" or "predict"
```

This block defines the mode in which run_metObs.R will run.

"Setup" should be used once, the first time the script is ran.
It will generate in the scratch folder the genome and other necessary folders.

"Predict" is the mode of operation used for the analysis.

- From

```
define the type of file to start the pipeline from, between "fastq", "bam", "sam" or "matrix"
start_from = "fastq" or "bam" or "sam" or "matrix"
```

This block describes the step from which the anylsis will start.

If using the "fastq" option, the FASTQ files should be paired ends and both the files for each sample should be located in their own folder inside of the "data" directory, ending in R1.fastq and R2.fastq.

If using the "bam" option, each sample should still have its own folder and the BAM should be sorted, indexed and named Aligned.sorted.bam.

The "sam" option should be used only when starting from met.sam files extracted in the previous step by the workflow. Similarly the "matrix" option needs the matrix produced during the pipeline.

- Threads

```
define the amount of cores to dedicate to the genome generation and alignment steps
thread_n = 8
```

This block sets the number of threads that the script can use for the genome generation and alignment steps.

## example

An example can be found by starting an instance of the container with a mounted folder:

```
docker run -ti -v /path/to/local/folder:/scratch docker.io/repbioinfo/metobservatory.2021 /bin/bash
```

After that, two compressed fastqs (example.R1.fastq.gz and example.R2.fastq.gz) can be obtained by navigating to the /example folder and copying them into /scratch:

```
cd /example
cp example.R1.fastq.gz /scratch
cp example.R2.fastq.gz /scratch
```

The examples should be decompressed and placed inside in a folder, and this folder should be put inside the "data" directory.