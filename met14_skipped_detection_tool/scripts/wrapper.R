metObs=function(mode=c("setup","NN","CNN"),from,scratch.dir,projName,threads) {
  
  path=getwd()  
  
  if (!dir.exists(scratch.dir)) {
    cat("The provided scratch directory doesn't exist.")
    return()
  }
  if (nchar(projName)<1) {
    cat("The project name must be declared.")
    return()
  }
  if (!is.numeric(threads)) {
    cat("No amount of threads provided.")
    return()
  }

  if (mode=="setup") {
    dir.create(paste(scratch.dir,projName,sep="/"))
    dir.create(paste(scratch.dir,"/genome",sep=""))
    dir.create(paste(scratch.dir,"/nn_temp",sep=""))
    dir.create(paste(scratch.dir,"/cnn_temp",sep=""))
    system(paste(path,"/scripts/setup_scripts/execute_genomeGenerate.sh ",scratch.dir," ",threads,sep=""))
  } else if (mode=="NN") {
    from.allowed=c("fastq","bam","sam","matrix")
    start.point=which(from.allowed==from)
    if (from %in% from.allowed) {
      if (start.point<2) {
        system(paste(path,"/scripts/mat_scripts/execute_STARalign.sh ",scratch.dir," /",projName," ",threads,sep=""))
      }
      if (start.point<3) {
        system(paste(path,"/scripts/mat_scripts/execute_metExtract.sh ",scratch.dir," /",projName,sep=""))
      }
      if (start.point<4) {
        system(paste(path,"/scripts/mat_scripts/execute_all_pos_counts.sh ",scratch.dir," /",projName,sep=""))
      }
      source(paste(path,"/scripts/nn_scripts/nnMetPredict.R",sep=""))
      source(paste(path,"/scripts/nn_scripts/runDocker.R",sep=""))
      
      nnMetPredict(group=c("docker"), scratch.folder=paste(scratch.dir,"/nn_temp",sep=""), file=paste(path,"/scripts/nn_scripts/trainingMat.txt",sep=""),separator="\t",patiencePercentage=5,projectName="results",bN=paste(path,"/scripts/nn_scripts/vectorTraining.txt",sep=""),eV=paste(scratch.dir,"/",projName,"/pos_count_matrix.txt",sep=""),BW=paste(path,"/scripts/nn_scripts/BW/BW.hdf5",sep=""),alreadyFreq=FALSE)
      if (dir.exists(paste(scratch.dir,"/",basename(projName),"_NNresults",sep=""))) {
        unlink(paste(scratch.dir,"/",basename(projName),"_NNresults",sep=""), recursive=TRUE)
      }
      system(paste("mv ", path,"/scripts/nn_scripts/results/ ",scratch.dir,"/",basename(projName),"_NNresults",sep=""))
      
    } else {
      cat("The value defined for From is not fastq, bam, sam or matrix.")
    }
    
  } else if (mode=="CNN") {
    from.allowed=c("fastq","bam","sam","matrix")
    start.point=which(from.allowed==from)
    if (from %in% from.allowed) {
      if (start.point<2) {
        system(paste(path,"/scripts/mat_scripts/execute_STARalign.sh ",scratch.dir," /",projName," ",threads,sep=""))
      }
      if (start.point<3) {
        system(paste(path,"/scripts/mat_scripts/execute_metExtract.sh ",scratch.dir," /",projName,sep=""))
      }
      if (start.point<4) {
        system(paste("cp ", path,"/scripts/mat_scripts/kmer_relMat.txt ",scratch.dir,"/",projName,sep=""))
        system(paste(path,"/scripts/mat_scripts/executing_Sam2Fastq.sh ",scratch.dir," /",projName,sep=""))
        system(paste(path,"/scripts/mat_scripts/executing_BFCounter.sh ",scratch.dir," /",projName,sep=""))
        system(paste(path,"/scripts/mat_scripts/execute_kmer_counts.sh ",scratch.dir," /",projName,sep=""))
        system(paste("rm ",scratch.dir,"/",projName,"/kmer_relMat.txt",sep=""))
      }
      source(paste(path,"/scripts/cnn_scripts/nnMetPredictConv.R",sep=""))
      source(paste(path,"/scripts/cnn_scripts/runDocker.R",sep=""))
      
      nnMetPredictConv(group=c("docker"), scratch.folder=paste(scratch.dir,"/cnn_temp",sep=""), file=paste(path,"/scripts/cnn_scripts/trainingMat.txt",sep=""),separator="\t",patiencePercentage=5,projectName="results",bN=paste(path,"/scripts/cnn_scripts/vectorTraining.txt",sep=""),eV=paste(scratch.dir,"/",projName,"/kmer_freq_matrix.txt",sep=""),BW=paste(path,"/scripts/cnn_scripts/BW/BW.hdf5",sep=""),alreadyFreq=TRUE,ks=100)
      if (dir.exists(paste(scratch.dir,"/",basename(projName),"_CNNresults",sep=""))) {
        unlink(paste(scratch.dir,"/",basename(projName),"_CNNresults",sep=""), recursive=TRUE)
      }
      system(paste("mv ", path,"/scripts/cnn_scripts/results/ ",scratch.dir,"/",basename(projName),"_CNNresults",sep=""))
      
    } else {
      cat("The value defined for From is not fastq, bam, sam or matrix.")
    }
      
  } else {
    cat("No valid mode of operation for the script was selected.")
  }
}
