# metObservatory.2021
Pipeline to predict if a sample presents skipping of Exon 14 in MET, starting from FASTQ files.

All the files relevant for the pipeline are included in the met14\_skipped\_detection\_tool folder.

To build the image, stay in the met14\_skipped\_detection\_tool folder and execute:

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

- Path and project name

```
#define the scratch folder
scratch = "/path/to/scratch/folder"
```

This block describes the path that the script will operate on.
"Scratch" is the folder that will contain all the elements needed for the analysis, it will contain the genome generate during it, the temporary files for the neural network analysis and the results of the anlysis itself.

```
#define a project name
project = "project_name"
```

This block defines the name of the project we will be working on.
After running the setup mode once (see next chapter), a folder with the name of the project will be created inside of the scratch directory we defined. All the data to be analized should be put into this project folder, with each sample having its own subdirectory.

- Mode

```
#define the mode of operations of the application between "setup", "NN" or "CNN"
run_mode = "setup" or "NN" or "CNN"
```

This block defines the mode in which run_metObs.R will run.

"Setup" should be used once, the first time the script is ran.
It will generate in the scratch folder the genome and temporary folders for the networks. It also generates a directory with the name of the project as described in the previous section.

"NN" is the mode of operation used for the analysis using the neural network while "CNN" is the mode used for the analysis with the convolutional neural network.

- From

```
define the type of file to start the pipeline from, between "fastq", "bam", "sam" or "matrix"
start_from = "fastq" or "bam" or "sam" or "matrix"
```

This block describes the step from which the anylsis will start.

If using the "fastq" option, the FASTQ files should be paired ends and both the files for each sample should be located in their own folder inside of the project directory, ending in R1.fastq and R2.fastq.

If using the "bam" option, each sample should still have its own folder and the BAM should be sorted, indexed and named Aligned.sorted.bam.

The "sam" option should be used only when starting from met.sam files extracted in the previous step by the workflow. Similarly the "matrix" option needs the matrix produced during the pipeline. 
The requirements and results of the "fastq" and "bam" steps of the analysis are shared between "NN" and "CNN", so they are only required only once per dataset, however the following steps are different between "NN" and "CNN" mode, so the user should start from the "sam" step when running one after running the other.



- Threads

```
define the amount of cores to dedicate to the genome generation and alignment steps
thread_n = 8
```

This block sets the number of threads that the script can use for the genome generation and alignment steps.

## output

The output of the "NN" mode is saved into "scratch" in a folder named x_NNresults, with x being the same name as the project name.

Inside the folder there are three tables:

- Predicted_pos_count_matrix.txt presents for each sample a value ranging from 0 to 1. The closer to 0 the value is, the closer the sample is to the exon 14 skipped MET condition according to the neural network. The closer to 1, the closer the sample is to the wild-type condition.
- Pval_pos_count_matrix.txt presents for each sample the list of likelihood that the score assigned to the sample by the network at each epoch was correct and not due to randomness.
- PvalSum_pos_count_matrix.txt is a table that takes in consideration the likelihoods presented in Pval_pos_count_matrix.txt to provide a total confidence value for the sample across all epochs, ranging from 0, meaning that the network has no confidence in the score assigned in Predicted_pos_count_matrix.txt to 1, meaning full confidence.

The output of the "CNN" mode is saved in scratch as well, in a folder named x_CNNresults, with x being the same name as the project name.

In this case only a Predicted_kmer_freq_matrix.txt table is present, with the same significance as the Predicted_pos_count_matrix.txt table for the "NN" mode.

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

The examples should be placed inside a folder and then should be decompressed. Then these folders should be put inside the project directory.

The sample should produce a skipped prediction (close to 0) for both the "CNN" and the "NN" modes.
