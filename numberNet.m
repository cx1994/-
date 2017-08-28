%建立一个滑动搜索窗，滑动搜索被粗定位的区域，截取一部分之后（大小和步长待定，），imresize成36x36x3的图片
%，放入cifar10Net判断为数字几,移动一定步长，接着判断，若两者判断一致，比较两者的IOU，若IOU<0.5,则认为是一个新数字
%图片训练为截取每个数字，添加不同的噪声以及做畸变。

load('rcnnStopSigns.mat','cifar10Net')

addpath F:\学习资料\深度学习\R-CNN\data2\traindata\
traindata =load('traindata_rand_back2.mat');
label_rand=load('label_ran_back2.mat');

cifar10Net_reduce = cifar10Net.Layers(1:end-3);
Last3Layers = [
fullyConnectedLayer(11,'Name','fc_1','WeightLearnRateFactor',10, 'BiasLearnRateFactor',20)
softmaxLayer('Name','softmax')
classificationLayer('Name','classification')
];

cifar10Net_new = [
   cifar10Net_reduce
   Last3Layers
];

opts = trainingOptions('sgdm', ...
    'Momentum', 0.9, ...
    'InitialLearnRate',0.01, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 8, ...
    'L2Regularization', 0.004, ...
    'MaxEpochs', 50, ...
    'MiniBatchSize', 50, ...
    'Verbose', true);

label = categorical([label_rand.labelrandback2]);

numNet_back2 = trainNetwork(traindata.traindatarandback2, label, cifar10Net_new, opts);