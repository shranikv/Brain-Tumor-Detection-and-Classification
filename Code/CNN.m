function [accuracy] = CNN

datasetPath = "C:\Users\Personal\Desktop\BE Project\activeContoursSnakesDemo\activeContoursDemo\Segmented";
imds = imageDatastore(datasetPath, 'IncludeSubfolders',true,'LabelSource','foldernames');
labelCount = countEachLabel(imds);

imds.ReadFcn = @(loc)imresize(imread(loc),[100,100]);

PercentageSplit = 0.75;
[imdsTrain,imdsValidation] = splitEachLabel(imds, PercentageSplit ,'randomize');

layers = [
    imageInputLayer([100 100])
    
    convolution2dLayer(3,16,'Padding',[1 1 1 1])
    batchNormalizationLayer
    reluLayer   
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding',[1 1 1 1])
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding',[1 1 1 1])
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding',[1 1 1 1])
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,64,'Padding',[1 1 1 1])
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,128,'Padding',[1 1 1 1])
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    
    
    fullyConnectedLayer(4)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',60, ...
    'Shuffle','once', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',5, ...
    'Verbose',false, ...
    'Plots','training-progress');

net = trainNetwork(imdsTrain,layers,options);

%imdstest = imread("C:\Users\Personal\Desktop\BE Project\activeContoursSnakesDemo\activeContoursDemo\Segmented\GBM segmented\9.jpg");
%imdstest = imresize(imdstest,[100,100]);
%pred = classify(net,imdstest); 

YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;
accuracy = sum(YPred == YValidation)/numel(YValidation);
accuracy = accuracy * 100;
figure;
plotconfusion(imdsValidation.Labels,YPred);

save('ConvolutionNN');