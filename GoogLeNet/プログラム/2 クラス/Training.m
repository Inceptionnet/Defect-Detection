clc;
clear ;
close all;

%--------------------------------          Configuration           ------------------------------------%
TrainingDatasetPath = fullfile('D:','欠陥検出','画像データ','2種類の分類','訓練データ');
ModelPath = 'D:\欠陥検出\GoogLeNet\モデル\2種類の分類\';
FileExtensions = '.tif';
ensembleNum = 7;

%-------------------------------                End             -------------------------------------%
Optimizer = 'sgdm';
LearnRate = 1e-3;
LearnRateDropFactor = 0.5;
LearnRateDropPeriod = 3;
miniBatchSize = 10;
Epochs = 12;

for ii=1:ensembleNum
    net = googlenet;
    digitData=imageDatastore(TrainingDatasetPath, 'IncludeSubFolders', true, 'FileExtensions', FileExtensions , 'LabelSource', 'foldernames');
    [trainDB,checkDB] = splitEachLabel(digitData,0.7,'randomize');
    numImages = numel(trainDB.Files);
    lgraph = layerGraph(net);
    lgraph = removeLayers(lgraph, {'loss3-classifier','prob','output'});
    numClasses = numel(categories(trainDB.Labels));
    newLayers = [
        fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
        softmaxLayer('Name','softmax')
        classificationLayer('Name','classoutput')];
    lgraph = addLayers(lgraph,newLayers);
    lgraph = connectLayers(lgraph,'pool5-drop_7x7_s1','fc');
    inputSize = net.Layers(1).InputSize;
    augimdsTrain = augmentedImageDatastore(inputSize(1:2),trainDB);
    augimdsValidation = augmentedImageDatastore(inputSize(1:2),checkDB);
    numIterationsPerEpoch = floor(numel(trainDB.Labels)/miniBatchSize);
    options = trainingOptions(Optimizer, ...
        'LearnRateSchedule','piecewise',...
        'LearnRateDropFactor',LearnRateDropFactor,...
        'LearnRateDropPeriod',LearnRateDropPeriod,...
        'MiniBatchSize',miniBatchSize, ...
        'MaxEpochs',Epochs, ...
        'InitialLearnRate',LearnRate, ...
        'ValidationData',augimdsValidation, ...
        'ValidationFrequency',numIterationsPerEpoch, ...
        'ValidationPatience',Inf, ...
        'Verbose',false ,...
        'Plots','training-progress');
    netTransfer(ii) = trainNetwork(augimdsTrain,lgraph,options);   %#ok
    [Ypred,scores]=classify(netTransfer(ii),checkDB);
%     confMat = confusionmat(checkDB.Labels, Ypred) %#ok
%     conf = bsxfun(@rdivide,confMat,sum(confMat,2)) %#ok
%     ValidationAccuracy = sum(Ypred==checkDB.Labels)/numel(checkDB.Labels) %#ok
   
end

ModelName = sprintf('GModel_%s',datestr(now, 'mmm_dd_yyyy_HH_MM'));
save([ModelPath,ModelName],'netTransfer');
