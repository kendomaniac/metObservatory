Using file test.R you can train and use the neural network simply downloading the neuralNetwork folder and starting R using that as working directory. There are two functions : 
1) nnMetTraining . This function generate the BW file, that contain all the weights in order to get the neural network ready to predict. <br/>
#' @param group, a character string. Two options: sudo or docker, depending to which group the user belongs<br/>
#' @param scratch.folder, a character string indicating the path of the scratch folder<br/>
#' @param file, a character string indicating the path of the file, with file name and extension included. This file is the one used for training. Need to have sample on the column and the raw kmers on the row. <br/>
#' @param nEpochs, number of Epochs for neural network training. Usually 1000 is a good value.<br/>
#' @param projectName, is an arbitrary name for the analysis. <br/>
#' @param patiencePercentage, number of Epochs percentage of not training before to stop. Usually 5 is a good value. <br/>
#' @param separator, separator used in count file, e.g. '\\t', ','<br/>
#' @param bN, Vector state, mandatory for training. The order of this matrix has to be the same as the matrix provided in "file" and this file is used to set the rule, associating to each sample if is 1 or 0, so the state. The prediction generated in nnMetPredict will follow this rule.  <br/>

2) nnMetPredic . This function generate the predict file, based on the state vector gave in the previous function. E.G. using test.R predicted value close to one are related to wild type, predicted value close to 0 are related to delta skypped. 
WARNING. Before to use the BW file generated from nnMetTraining is very important to check the training pdf generated. In this file is very important that the learning curve is not flat
#' @param scratch.folder, a character string indicating the path of the scratch folder<br/>
#' @param file, a character string indicating the path of the file, with file name and extension included. This file is the one used for training. Need to have sample on the column and the raw kmers on the row. Even if this function is for prediction and not for training you need to provide the same file used for training. <br/>
#' @param projectName, is an arbitrary name for the analysis. <br/>
#' @param patiencePercentage, number of Epochs percentage of not training before to stop. Usually 5 is a good value. <br/>
#' @param separator, separator used in count file, e.g. '\\t', ','<br/>
#' @param bN, Vector state, mandatory for training. The order of this matrix has to be the same as the matrix provided in "file" and this file is used to set the rule, associating to each sample if is 1 or 0, so the state. The prediction generated in nnMetPredict will follow this rule.  <br/>
#' @param eV, matrix for prediction. Need to have the same structure as the file provided for the training. <br/>
#' @param BW, file path with weight saved from nnMetTraining.R usually in BW folder. <br/>


![flat](https://github.com/kendomaniac/metObservatory/tree/master/NeuralNetwork/Pictures/learningWrong.png).
If is so, regenerate the BW running again nnMetTraining until you generate a proper learning 
![curve](https://github.com/kendomaniac/metObservatory/tree/master/NeuralNetwork/Pictures/learningCorrect.png?raw=true).
Seed value will be provided in order to generate the same weight given the same seed. 
DockerFile is a work in progress. The temporary docker used is repbioinfo/neuralnetworkmet. 
