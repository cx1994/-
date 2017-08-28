%����һ�������������������������ֶ�λ�����򣬽�ȡһ����֮�󣨴�С�Ͳ�������������imresize��36x36x3��ͼƬ
%������cifar10Net�ж�Ϊ���ּ�,�ƶ�һ�������������жϣ��������ж�һ�£��Ƚ����ߵ�IOU����IOU<0.5,����Ϊ��һ��������
%ͼƬѵ��Ϊ��ȡÿ�����֣���Ӳ�ͬ�������Լ������䡣

load('rcnnStopSigns.mat','cifar10Net')

addpath F:\ѧϰ����\���ѧϰ\R-CNN\data2\traindata\
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