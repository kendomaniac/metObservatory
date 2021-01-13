 library(rCASC)
 path=getwd()
 source(paste(path,"nnMetPredict.R",sep="/"))
 source(paste(path,"nnMetTraining.R",sep="/"))
 dir.create(paste(path,"scratch",sep="/"))
 scratch=paste(path,"scratch",sep="/")
 nnMetTraining(group=c("sudo"), scratch.folder=scratch, file=paste(path,"Data","mergedAMP16.txt",sep="/"),separator="\t",nEpochs=1000,patiencePercentage=5,projectName="TEST2",bN=paste(path,"Data","vectorDEL_16.txt",sep="/"))
nnMetPredict(group=c("sudo"), scratch.folder=scratch, file=paste(path,"Data","mergedAMP16.txt",sep="/"),separator="\t",patiencePercentage=5,projectName="TEST2",bN=paste(path,"Data","vectorDEL_16.txt",sep="/"),eV=paste(path,"Data","merged5K_16.txt",sep="/"),BW=paste(path,"Data","TEST2","BW","BW.hdf5",sep="/"))
 
