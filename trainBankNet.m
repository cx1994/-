addpath F:\ѧϰ����\���ѧϰ\R-CNN\data2\traindata\
addpath F:\ѧϰ����\���ѧϰ\R-CNN\data1\5\

data = load('BoxTablebank.mat');
load('rcnnStopSigns.mat','cifar10Net')

 options = trainingOptions('sgdm', ...
    'Momentum', 0.9, ...
    'InitialLearnRate', 0.001, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod',8, ...
    'L2Regularization',0.01, ...
    'MaxEpochs', 40, ...
    'MiniBatchSize', 100, ...
    'Verbose', true);

cifar10NetRCNN_bank= trainRCNNObjectDetector(data.BoxTable, cifar10Net, options, ...
    'NegativeOverlapRange', [0 0.3], 'PositiveOverlapRange',[0.5 1]);