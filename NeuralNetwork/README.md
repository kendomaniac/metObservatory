Using file test.R you can train and use the neural network simply downloading the neuralNetwork folder and starting R using that as working directory. There are two functions : 
1) nnMetTraining . This function generate the BW file, that contain all the weights in order to get the neural network ready to predict. 
2) nnMetPredic . This function generate the predict file, based on the state vector gave in the previous function. E.G. using test.R predicted value close to one are related to wild type, predicted value close to 0 are related to delta skypped. 
WARNING. Before to use the BW file generated from nnMetTraining is very important to check the training pdf generated. In this file is very important that the learning curve is not flat
![flat](https://github.com/kendomaniac/metObservatory/tree/master/NeuralNetwork/Pictures/learningWrong.png).
If is so, regenerate the BW running again nnMetTraining until you generate a proper learning 
![curve](https://github.com/kendomaniac/metObservatory/tree/master/NeuralNetwork/Pictures/learningCorrect.png?raw=true).
Seed value will be provided in order to generate the same weight given the same seed. 
DockerFile is a work in progress. The temporary docker used is repbioinfo/neuralnetworkmet. 
