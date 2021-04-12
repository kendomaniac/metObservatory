source(paste(getwd(),"/scripts/wrapper.R",sep=""))

#define the scratch folder
scratch = "/path/to/scratch/folder"

#define a project name
project = "project_name"

#define the mode of operations of the application between "setup", "NN" or "CNN"
run_mode = "setup" or "NN" or "CNN"

#define the type of file to start the pipeline from, between "fastq", "bam", "sam" or "matrix"
start_from = "fastq" or "bam" or "sam" or "matrix"

#define the amount of cores to dedicate to the genome generation and alignment steps
thread_n = 8

metObs(mode=run_mode,from=start_from,scratch.dir=scratch,projName=project,threads=thread_n)
