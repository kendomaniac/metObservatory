metObs=function(mode=c("setup","predict"),from,scratch.dir,data.dir,threads) {
  
  path=getwd()  
  
  if (!dir.exists(scratch.dir)) {
    cat("The provided scratch directory doesn't exist.")
    return()
  }
  if (!dir.exists(paste(data.dir,sep="/"))) {
    cat("The provided data directory doesn't exist.")
    return()
  }
  if (!is.numeric(threads)) {
    cat("No amount of threads provided.")
    return()
  }

  if (mode=="setup") {
    dir.create(paste(scratch.dir,"/genome",sep=""))
    dir.create(paste(scratch.dir,"/nn_temp",sep=""))
    system(paste(path,"/scripts/setup_scripts/execute_genomeGenerate.sh ",scratch.dir," ",threads,sep=""))
  } else if (mode=="predict") {
    from.allowed=c("fastq","bam","sam","matrix")
    start.point=which(from.allowed==from)
    if (from %in% from.allowed) {
      if (start.point<2) {
        system(paste(path,"/scripts/mat_scripts/execute_STARalign.sh ",scratch.dir," ",data.dir," ",threads,sep=""))
      }
      if (start.point<3) {
        system(paste(path,"/scripts/mat_scripts/execute_metExtract.sh ",scratch.dir," ",data.dir,sep=""))
      }
      if (start.point<4) {
        system(paste(path,"/scripts/mat_scripts/execute_all_pos_counts.sh ",scratch.dir," ",data.dir,sep=""))
      }
      source(paste(path,"/scripts/nn_scripts/nnMetPredict.R",sep=""))
      source(paste(path,"/scripts/nn_scripts/runDocker.R",sep=""))
      
      nnMetPredict(group=c("sudo"), scratch.folder=paste(scratch.dir,"/nn_temp",sep=""), file=paste(path,"/scripts/nn_scripts/trainingMat.txt",sep=""),separator="\t",patiencePercentage=5,projectName="results",bN=paste(path,"/scripts/nn_scripts/vectorTraining.txt",sep=""),eV=paste(scratch.dir,data.dir,"/pos_count_matrix.txt",sep=""),BW=paste(path,"/scripts/nn_scripts/BW/BW.hdf5",sep=""),alreadyFreq=FALSE)
      if (dir.exists(paste(scratch.dir,"/",basename(data.dir),"_results",sep=""))) {
        unlink(paste(scratch.dir,"/",basename(data.dir),"_results",sep=""), recursive=TRUE)
      }
      system(paste("mv ", path,"/scripts/nn_scripts/results/ ",scratch.dir,"/",basename(data.dir),"_results",sep=""))
      
    } else {
      cat("The value defined for From is not fastq, bam, sam or matrix.")
    }
    
  } else {
    cat("No valid mode of operation for the script was selected.")
  }
}
