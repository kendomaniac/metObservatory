source(paste(getwd(),"/scripts/wrapper.R",sep=""))

#define the scratch and data folders
scratch ="/path/to/scratch/folder"
data ="/path/from/scratch/to/data"

#define the mode of operations of the application between "setup" and "predict"
run_mode = "setup" or "predict"

#define the type of file to start the pipeline from, between "fastq", "bam", "sam" or "matrix"
start_from = "fastq" or "bam" or "sam" or "matrix"

#define the amount of cores to dedicate to the genome generation and alignment steps
thread_n = 8

metObs(mode=run_mode,from=start_from,scratch.dir=scratch,data.dir=data,threads=thread_n)