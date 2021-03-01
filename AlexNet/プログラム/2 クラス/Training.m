clc;
clear ;
close all;

%--------------------------------          Configuration           ------------------------------------%
TrainingDatasetPath = fullfile('D:','欠陥検出','画像データ','2種類の分類','訓練データ');
ModelPath = 'D:\欠陥検出\AlexNet\モデル\2種類の分類\';
FileExtensions = '.tif';
ensembleNum = 7;
%-------------------------------                End             -------------------------------------%

Optimizer = 'sgdm';
LearnRate = 1e-4;
LearnRateDropFactor = 0.5;
LearnRateDropPeriod = 3;
miniBatchSize = 10;
Epochs = 12;

for ii=1:ensembleNum
    net = alexnet;
    digitData=imageDatastore(TrainingDatasetPath, 'IncludeSubFolders', true, 'FileExtensions', FileExtensions , 'LabelSource', 'foldernames');
    [trainDB,checkDB] = splitEachLabel(digitData,0.7,'randomize');
    numImages = numel(trainDB.Files);
    layersTransfer = net.Layers(1:end-3);
    numClasses = numel(categories(trainDB.Labels));
    layers = [ ...
        layersTransfer
        fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
        softmaxLayer
        classificationLayer];
    miniBatchSize = 10;
    inputSize = net.Layers(1).InputSize;
    pixelRange = [-30 30];
    imageAugmenter = imageDataAugmenter( ...
        'RandXReflection',true, ...
        'RandXTranslation',pixelRange, ...
        'RandYTranslation',pixelRange);
    augimdsTrain = augmentedImageDatastore(inputSize(1:2),trainDB, ...
        'DataAugmentation',imageAugmenter);
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
    netTransfer(ii) = trainNetwork(augimdsTrain,layers,options);   %#ok
%     [Ypred,scores]=classify(netTransfer(ii),augimdsValidation);
%     confMat = confusionmat(checkDB.Labels, Ypred) %#ok
%     conf = bsxfun(@rdivide,confMat,sum(confMat,2)) %#ok
%     ValidationAccuracy = sum(Ypred==checkDB.Labels)/numel(checkDB.Labels) %#ok
   
end

ModelName = sprintf('AModel_%s',datestr(now, 'mmm_dd_yyyy_HH_MM'));
save([ModelPath,ModelName],'netTransfer');
